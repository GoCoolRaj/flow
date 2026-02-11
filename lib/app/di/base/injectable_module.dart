import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

abstract class InjectableModule {
  final GetIt _getIt = GetIt.I;
  @protected
  final Logger logger = Logger();

  void injectBloc() {}

  Future<void> inject();

  Future<void> lateInject() async {}

  void disposeBloc() {}

  void dispose();

  void safeRegisterFactory<T extends Object>(
    FactoryFunc<T> factoryFunc, [
    String? scope,
  ]) {
    if (!_getIt.isRegistered<T>(instanceName: scope)) {
      _getIt.registerFactory<T>(factoryFunc, instanceName: scope);
    }
  }

  void safeRegisterSingleton<T extends Object>(
    T Function() factoryFunc, [
    String? scope,
  ]) {
    if (!_getIt.isRegistered<T>(instanceName: scope)) {
      _getIt.registerSingleton<T>(factoryFunc(), instanceName: scope);
    }
  }

  void safeRegisterLazySingleton<T extends Object>(
    FactoryFunc<T> factoryFunc, [
    String? scope,
  ]) {
    if (!_getIt.isRegistered<T>(instanceName: scope)) {
      _getIt.registerLazySingleton<T>(factoryFunc, instanceName: scope);
    }
  }

  safeUnregister<T extends Object>({
    String? scope,
  }) {
    if (_getIt.isRegistered<T>(instanceName: scope)) {
      _getIt.unregister<T>(instanceName: scope);
    }
  }
}
