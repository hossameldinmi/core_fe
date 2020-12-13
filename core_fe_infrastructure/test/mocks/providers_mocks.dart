import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_infrastructure/interfaces.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockNoSqlStorageProvider extends Mock with NoSqlStorageProvider {}

class MockSessionProvider extends Mock with SessionProvider {}

class MockSettingsProvider extends Mock with SettingsProvider {}

class MockLogger extends Mock with Logger {}

class MockHttpClientAdapter extends Mock with HttpClientAdapter {}

class MockNetwork extends Mock with NetworkProvider {}
