import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_presentation/src/interfaces/navigation_service.dart';
import 'package:core_fe_presentation/src/services/navigation_service_impl.dart';
import 'package:core_fe_presentation/test_lib/mocks/page1.dart';

class TestModule extends BaseModule {
  @override
  Future<void> setUp() {
    iocInstance.registerSingleton<NavigationService>(
        NavigationServiceImpl(Page1.route));
    return Future.value();
  }
}

final testModule = TestModule();
