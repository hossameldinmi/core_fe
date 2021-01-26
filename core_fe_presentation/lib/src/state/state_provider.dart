import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/src/state/page_view_model_base.dart';

class ViewModelProvider {
  final _locator = Locator();
  T call<T extends PageViewModelBase>({String name}) {
    var result = _locator<T>(instanceName: name);
    return result;
  }
}

final viewModelProvider = ViewModelProvider();
