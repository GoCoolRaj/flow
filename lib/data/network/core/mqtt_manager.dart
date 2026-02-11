import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:quilt_flow_app/app/environment.dart';
import 'package:typed_data/typed_data.dart' as typed;
import 'package:uuid/uuid.dart';

enum MqttConfiguration { quiltBroker, testBroker }

class MQTTManager {
  final String brokerUrl;
  final int port;
  final String? username;
  final String? password;
  //Todo: final String? certificateFilePath;
  final bool useCertificate;
  final String clientId = const Uuid().v4();

  late final MqttServerClient _client;
  final Map<String, StreamController<dynamic>> _topicControllers = {};

  MQTTManager._({
    required this.brokerUrl,
    required this.port,
    this.username,
    this.password,
    //Todo: this.certificateFilePath,
    required this.useCertificate,
  }) {
    _client = MqttServerClient.withPort(brokerUrl, clientId, port)
      ..logging(on: true)
      ..keepAlivePeriod = 60
      ..useWebSocket = true
      ..autoReconnect = false
      ..resubscribeOnAutoReconnect = false
      ..onAutoReconnected = _onAutoReconnected
      ..connectionMessage = _buildConnectionMessage();

    if (useCertificate) {
      _client.secure = true;
      _client.onBadCertificate = (cert) => true;
      //Todo:  _client.securityContext.setTrustedCertificates(certificateFilePath!);
    }
  }

  factory MQTTManager.fromConfiguration(MqttConfiguration config) {
    switch (config) {
      case MqttConfiguration.quiltBroker:
        return MQTTManager._(
          brokerUrl: EnvironmentConfig.mqttBrokerUrl,
          port: 443,
          useCertificate: false,
          username: EnvironmentConfig.mqttUsername,
          password: EnvironmentConfig.mqttPassword,
        );
      case MqttConfiguration.testBroker:
        return MQTTManager._(
          brokerUrl: 'broker.emqx.io',
          port: 1883,
          username: 'mqtttest',
          password: 'mqtttest',
          useCertificate: false,
        );
    }
  }

  void _onAutoReconnected() {}

  MqttConnectMessage _buildConnectionMessage() {
    final message = MqttConnectMessage()..withClientIdentifier(clientId);

    if (!useCertificate && username != null && password != null) {
      message.authenticateAs(username!, password!);
    }
    return message;
  }

  Future<void> connect() async {
    try {
      await _client.connect();
      _listen();
    } on Exception catch (_) {
      _client.disconnect();
      rethrow;
    }
  }

  bool isConnected() =>
      _client.connectionStatus?.state == MqttConnectionState.connected;

  void disconnect() {
    if (_client.connectionStatus?.state == MqttConnectionState.disconnected) {
      return;
    }
    if (_topicControllers.isNotEmpty) {
      _topicControllers.forEach((topic, controller) {
        _client.unsubscribeStringTopic(topic);
        controller.close();
      });

      _topicControllers.clear();
    }
    _client.disconnect();
  }

  Future<void> subscribe(String topic) async {
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }
    if (_topicControllers.containsKey(topic)) return;

    _topicControllers[topic] = StreamController<dynamic>.broadcast();
    _client.subscribe(topic, MqttQos.atMostOnce);
  }

  Future<void> reSubscribe(String topic) async {
    final status = _client.connectionStatus?.state;
    if (_client.connectionStatus?.state != MqttConnectionState.connected) {
      await connect();
    }

    if (_topicControllers.containsKey(topic)) {
      if (status == MqttConnectionState.disconnected) {
        _client.subscribe(topic, MqttQos.atMostOnce);
      } else {
        _client.resubscribe();
      }
    } else {
      await subscribe(topic);
    }
  }

  void unsubscribe(String topic) {
    if (_topicControllers.containsKey(topic)) {
      _client.unsubscribeStringTopic(topic);
      _topicControllers[topic]?.close();
      _topicControllers.remove(topic);
    }
  }

  bool isSubscribed(String topic) => _topicControllers.containsKey(topic);

  Stream<T>? getStream<T>({
    required String topic,
    T Function(Map<String, dynamic>)? fromJson,
    T Function(List<dynamic>)? fromJsonList,
  }) {
    final rawStream = _topicControllers[topic]?.stream;

    if (rawStream == null) return null;
    return rawStream.map((rawData) {
      if (rawData is Map<String, dynamic>) {
        if (rawData.isEmpty) throw Exception("Data empty!!!");
        try {
          if (kDebugMode) {
            debugPrint(rawData.toString());
          }
          return fromJson!(rawData);
        } catch (e) {
          throw Exception("Error parsing JSON to $T: $e");
        }
      } else if (rawData is List<dynamic>) {
        if (rawData.isEmpty) throw Exception("Data empty!!!");
        try {
          if (kDebugMode) {
            debugPrint(rawData.toString());
          }
          return fromJsonList!(rawData);
        } catch (e) {
          throw Exception("Error parsing JSON to $T: $e");
        }
      } else {
        throw Exception(
          "Unexpected data type: Expected Map<String, dynamic>, got ${rawData.runtimeType}",
        );
      }
    });
  }

  void publish(String topic, dynamic message) {
    final payload = jsonEncode(message).codeUnits;
    final buffer = typed.Uint8Buffer()..addAll(payload);
    _client.publishMessage(topic, MqttQos.atLeastOnce, buffer);
  }

  void _listen() {
    _client.updates.listen((messages) {
      for (var message in messages) {
        final topic = message.topic;
        final payload = (message.payload as MqttPublishMessage).payload.message;

        if (_topicControllers.containsKey(topic)) {
          try {
            final decodedPayload = utf8.decode(payload?.toList() ?? []);
            final json = jsonDecode(decodedPayload);

            if (json is Map<String, dynamic>) {
              _topicControllers[topic]?.add(json);
            } else if (json is List<dynamic>) {
              _topicControllers[topic]?.add(json);
            } else {
              _topicControllers[topic]?.addError(
                "Payload is not a Map<String, dynamic>: ${json.runtimeType}",
              );
            }
          } catch (e) {
            _topicControllers[topic]?.addError("Error decoding payload: $e");
          }
        }
      }
    });
  }

  void onConnected() {
    debugPrint('Connected to MQTT broker');
  }

  void onDisconnected() {
    debugPrint('Disconnected from MQTT broker');
  }
}
