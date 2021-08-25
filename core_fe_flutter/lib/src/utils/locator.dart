import 'package:get_it/get_it.dart';
import 'package:core_fe_dart/extensions.dart';

class Locator {
  static final locator = Locator();
  static final services = Locator();
  static final providers = Locator();
  static final managers = Locator();
  static final utils = Locator();
  final _instance = GetIt.asNewInstance();

  T? call<T>({String? instanceName}) => _instance<T>(instanceName: instanceName!);
  T get<T extends Object>({String? instanceName, dynamic args}) =>
      _instance.get<T>(instanceName: instanceName, param1: args);

  void registerSingleton<T extends Object>(T instance, {String? instanceName}) {
    _instance.registerSingleton<T>(instance, instanceName: instanceName);
  }

  void registerFactoryParam<T extends Object, TParam1, TParam2>(T Function(TParam1, TParam2) factoryFunc,
      {String? instanceName}) {
    _instance.registerFactoryParam<T, TParam1, TParam2>(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  void registerLazySingleton<T extends Object>(
    T Function() factoryFunc, {
    String? instanceName,
  }) {
    _instance.registerLazySingleton(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  void registerFactory<T extends Object>(T Function() factory, {String? instanceName}) {
    _instance.registerFactory<T>(factory, instanceName: instanceName);
  }

  void reset() => _instance.reset();
}

abstract class BaseModule {
  Future<void> setUp();
}

class CustomModule implements BaseModule {
  CustomModule(this.setUpFunc);
  final Future<void> Function() setUpFunc;

  @override
  Future<void> setUp() => setUpFunc();
}

class Initer {
  static final Map<String, BaseModule> _modules = {};
  static Future<void> loadModules() {
    return _modules.values.asyncMap(((e) => e!.setUp()));
  }

  static void addModule(String key, BaseModule module) => _modules[key] = module;
}
