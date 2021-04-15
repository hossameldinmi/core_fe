library core_fe_presentation;

export 'interfaces.dart';
export 'services.dart';
export 'state.dart';
export 'tests.dart';
export 'utils.dart';
export 'widget.dart';

import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/interfaces.dart';
import 'package:core_fe_presentation/src/services/navigation_service_impl.dart';
import 'package:flutter/widgets.dart';

class CoreFePresentationModule implements BaseModule {
  CoreFePresentationModule(this._navKey);

  final GlobalKey<NavigatorState> _navKey;
  @override
  Future<void> setUp() {
    Locator.managers
        .registerSingleton<NavigationService>(NavigationServiceImpl(_navKey));

    return Future.value();
  }
}
