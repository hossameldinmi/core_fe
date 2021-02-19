import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/src/state/page_view_model_base.dart';
import 'package:flutter/foundation.dart';

class ViewModelProvider {
  static final instance = ViewModelProvider();

  final _locator = Locator();
  T call<T extends PageViewModelBase>({String name}) {
    var result = _locator<T>(instanceName: name);
    return result;
  }

  void registerViewModel<TPageViewModel extends PageViewModelBase>({
    @required TPageViewModel Function() viewModelFactory,
    @required String route,
  }) {
    _locator.registerFactory<TPageViewModel>(
      viewModelFactory,
      instanceName: route,
    );
  }

  void registerSingletonViewModel<TPageViewModel extends PageViewModelBase>(
      {@required TPageViewModel Function() viewModelFactory,
      @required String route}) {
    _locator.registerLazySingleton<TPageViewModel>(viewModelFactory,
        instanceName: route);
  }
}
