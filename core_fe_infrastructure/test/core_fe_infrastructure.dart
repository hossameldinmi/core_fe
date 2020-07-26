import 'package:core_fe_infrastructure/src/models/user_session.dart';
import 'package:core_fe_infrastructure/src/providers/json_model_factory.dart';
import 'package:core_fe_flutter/src/utils/base_factory.dart';

class CoreFeInfrastructureTest extends BaseFactory {
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
    registerSingleton<IJsonModelFactory>(TestJsonModelProvider());
  }

  @override
  void setupStatesWithRoutes() {}
}

class TestJsonModelProvider extends JsonModelFactory {
  TestJsonModelProvider() {
    register<UserSession>(
      fromJson: (json) => UserSession.fromMap(json),
      toJson: (value) => value.toMap(),
    );
  }
}
