import 'package:quilt_flow_app/domain/fabric_creation/model/fabric_mqtt_response.dart';

class CheckFabricImageResponse {
  final int status;
  final FabricMQTT? data;
  final String message;

  CheckFabricImageResponse({
    required this.status,
    this.data,
    required this.message,
  });

  factory CheckFabricImageResponse.fromJson(Map<String, dynamic> json) {
    return CheckFabricImageResponse(
      status: json['status'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? FabricMQTT.fromJsonList(json['data'] as List)
          : null,
    );
  }
}
