import 'package:get_it/get_it.dart';

Locator locator = Locator();

class Locator {
  final _instance = GetIt.asNewInstance();

  T call<T>({String instanceName}) => _instance<T>(instanceName: instanceName);

  void registerSingleton<T>(T instance, {String instanceName}) {
    _instance.registerSingleton<T>(instance, instanceName: instanceName);
  }

  void registerLazySingleton<T>(T Function() factoryFunc,
      {String instanceName}) {
    _instance.registerLazySingleton(
      factoryFunc,
      instanceName: instanceName,
    );
  }

  void registerFactory<T>(T Function() factory, {String instanceName}) {
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
  static Future<void> loadModules() async {
    var futures = _modules.values.map((e) => e.setUp());
    return Future.wait(futures);
    // for (var m in _modules.values) {
    //   await m.setUp();
    // }
  }

  static void addModule(String key, BaseModule module) =>
      _modules[key] = module;
  static void _initFactory([Locator instance]) {
    locator = instance ?? Locator();
  }

  static Future<void> init([Locator instance]) {
    _initFactory(instance);
    return loadModules();
  }
}
