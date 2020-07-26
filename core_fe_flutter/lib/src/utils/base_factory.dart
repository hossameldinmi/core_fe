import 'package:get_it/get_it.dart';

/// initialize it in app start
BaseFactory factoryInstance;

abstract class BaseFactory {
  final _instance = GetIt.instance;
  static void init(BaseFactory instance) {
    factoryInstance = instance;
  }

  T call<T>({String instanceName}) => _instance<T>(instanceName: instanceName);
  void setupDomainLogic();
  void setupInfrastucture();
  void setupPresentation();
  void setupStatesWithRoutes();
  void setupSerializables();

  void registerSingleton<T>(T instance, {String instanceName}) {
    _instance.registerSingleton<T>(instance, instanceName: instanceName);
  }

  void reset() {
    _instance.reset();
  }
}
