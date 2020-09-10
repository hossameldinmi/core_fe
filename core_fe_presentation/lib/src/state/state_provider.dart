import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/src/state/BasePageState.dart';

class StateProvider {
  T call<T extends BasePageState>({String name}) {
    var result = factoryInstance<T>(instanceName: name);
    return result;
  }
}

final stateProvider = StateProvider();
