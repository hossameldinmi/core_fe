library core_fe_presentation;

import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/interfaces.dart';
import 'package:core_fe_presentation/src/services/navigation_service_impl.dart';
import 'package:flutter/widgets.dart';

class CoreFePresentationModule implements BaseModule {
  CoreFePresentationModule(this._navigationRoot, this._navKey);
  final String _navigationRoot;
  final GlobalKey<NavigatorState> _navKey;
  @override
  Future<void> setUp() {
    locator.registerSingleton<NavigationService>(
        NavigationServiceImpl(_navigationRoot, _navKey));

    return Future.value();
  }
}
