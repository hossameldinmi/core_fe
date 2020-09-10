import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:core_fe_flutter/utils.dart';

import 'mocks/mocks.dart';

class CoreFeInfrastructureTest extends BaseModule {
  @override
  Future<void> setUp() {
    factoryInstance.reset();
    factoryInstance
        .registerSingleton<IJsonModelFactory>(TestJsonModelProvider());
    return Future.value();
  }
}

class TestJsonModelProvider extends JsonModelFactory {
  TestJsonModelProvider() {
    register<UserSession>(
      fromJson: (json) => UserSession.fromMap(json),
      toJson: (value) => value.toMap(),
    );
    register<Todo>(fromJson: (json) => Todo.fromJson(json as Map));
  }
}
