import 'package:core_fe_infrastructure/interfaces.dart';
import 'package:core_fe_infrastructure/src/interfaces/http_network.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockNoSqlStorageProvider extends Mock with NoSqlStorageProvider {}

class MockSessionProvider extends Mock with SessionProvider {}

class MockSettingsProvider extends Mock with SettingsProvider {}

// class MockLogger extends Mock with Logger {}

class MockHttpClientAdapter extends Mock with HttpClientAdapter {}

class MockNetworkProvider extends Mock with NetworkProvider {}
