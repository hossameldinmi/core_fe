import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_infrastructure/interfaces.dart';
import 'package:core_fe_infrastructure/src/interfaces/i_network.dart';
import 'package:dio/dio.dart';
import 'package:mockito/mockito.dart';

class MockINoSqlStorageProvider extends Mock with INoSqlStorageProvider {}

class MockISessionProvider extends Mock with ISessionProvider {}

class MockISettingsProvider extends Mock with ISettingsProvider {}

class MockIILogger extends Mock with ILogger {}

class MockHttpClientAdapter extends Mock with HttpClientAdapter {}
class MockNetwork extends Mock with INetwork {}
