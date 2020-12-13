import 'package:core_fe_presentation/src/state/base_state.dart';

abstract class BasePageState extends BaseState {
  Future<void> initState(Object args);
}
