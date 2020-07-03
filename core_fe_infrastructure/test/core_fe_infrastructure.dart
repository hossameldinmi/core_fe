import 'package:core_fe_flutter/src/utils/base_module.dart';
import 'package:core_fe_infrastructure/src/providers/json_model_provider.dart';

class CoreFeInfrastructureTest extends BaseModule {
  CoreFeInfrastructureTest() {
    reset();
    setupSerializables();
  }

  @override
  void setupDomainLogic() {}

  @override
  void setupInfrastucture() {}

  @override
  void setupPresentation() {}

  @override
  void setupSerializables() {
    registerSingleton<IJsonModelProvider>(TestJsonModelProvider());
  }

  @override
  void setupStatesWithRoutes() {}
}

class TestJsonModelProvider extends JsonModelProvider {}
