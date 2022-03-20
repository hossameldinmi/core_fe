import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/src/state/page_view_model_base.dart';

class ViewModelProvider {
  static final instance = ViewModelProvider();

  final _locator = Locator();
  T call<T extends PageViewModelBase>({String? route, dynamic args}) {
    var result = _locator.get<T>(instanceName: route, args: args);
    return result;
  }

  void registerViewModel<TPageViewModel extends PageViewModelBase, TParam1, TParam2>({
    required TPageViewModel Function(TParam1, TParam2) viewModelFactory,
    required String route,
  }) {
    _locator.registerFactoryParam<TPageViewModel, TParam1, TParam2>(
      viewModelFactory,
      instanceName: route,
    );
  }

  void registerSingletonViewModel<TPageViewModel extends PageViewModelBase>(
      {required TPageViewModel Function() viewModelFactory, required String route}) {
    _locator.registerLazySingleton<TPageViewModel>(viewModelFactory, instanceName: route);
  }
}
