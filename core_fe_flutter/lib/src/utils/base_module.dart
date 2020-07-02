import 'package:get_it/get_it.dart';

/// initialize it in app start
BaseModule moduleInstance;

abstract class BaseModule {
  final instance = GetIt.instance;
  static void init(BaseModule instance) {
    moduleInstance = instance;
  }

  T call<T>({String instanceName}) => instance<T>(instanceName: instanceName);
  void setupDomainLogic();
  void setupInfrastucture();
  void setupPresentation();
  void setupStatesWithRoutes();
  void setupSerializables();
}
