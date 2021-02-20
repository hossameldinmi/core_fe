import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/src/interfaces/navigation_service.dart';
import 'package:core_fe_presentation/src/services/navigation_service_impl.dart';
import 'package:flutter/widgets.dart';

class TestModule extends BaseModule {
  @override
  Future<void> setUp() {
    Locator.managers
        .registerSingleton<NavigationService>(NavigationServiceImpl(navKey));
    return Future.value();
  }
}

final testModule = TestModule();
final navKey = GlobalKey<NavigatorState>();
