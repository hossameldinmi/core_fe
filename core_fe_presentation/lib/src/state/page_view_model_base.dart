import 'package:core_fe_presentation/src/state/view_model_base.dart';

abstract class PageViewModelBase extends ViewModelBase {
  Future<void> initState(Object args);
}
