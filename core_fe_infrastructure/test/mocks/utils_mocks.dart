import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_infrastructure/src/interfaces/connectivity.dart';
import 'package:core_fe_infrastructure/src/utils/i_http_helper.dart';
import 'package:mockito/mockito.dart';

class MockIDateTimeWrapper extends Mock with IDateTimeWrapper {}

class MockHttpHelper extends Mock with IHttpHelper {}

class MockConnectivity extends Mock with Connectivity {}
