import 'package:get_it/get_it.dart';

IocFactory iocInstance = IocFactory();

class IocFactory {
  final _instance = GetIt.instance;

  T call<T>({String instanceName}) => _instance<T>(instanceName: instanceName);

  void registerSingleton<T>(T instance, {String instanceName}) {
    _instance.registerSingleton<T>(instance, instanceName: instanceName);
  }

  void registerSingletonWithDependencies<T>(T Function() factoryFunc,
      {String instanceName, Iterable<Type> dependsOn, bool signalsReady}) {
    _instance.registerSingletonWithDependencies<T>(factoryFunc,
        instanceName: instanceName,
        dependsOn: dependsOn,
        signalsReady: signalsReady);
  }

  void reset() => _instance.reset();
}

abstract class BaseModule {
  Future<void> setUp();
}

class CustomModule extends BaseModule {
  CustomModule(this.setUpFunc);
  final Future<void> Function() setUpFunc;

  @override
  Future<void> setUp() => setUpFunc();
}

class Initer {
  static Map<String, BaseModule> modules = {};
  static Future<void> loadModules() async {
    modules.forEach((k, m) async {
      await m.setUp();
    });
  }

  static void addModule(String key, BaseModule module) => modules[key] = module;
  static void _initFactory([IocFactory instance]) {
    iocInstance = instance ?? IocFactory();
  }

  static Future<void> init([IocFactory instance]) async {
    _initFactory(instance);
    await loadModules();
  }
}
