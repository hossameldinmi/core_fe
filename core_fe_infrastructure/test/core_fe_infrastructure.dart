import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:core_fe_flutter/utils.dart';

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
