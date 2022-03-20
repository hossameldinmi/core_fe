import 'package:core_fe_dart/utils.dart';
import 'package:core_fe_infrastructure/src/interfaces/connectivity.dart';
import 'package:core_fe_infrastructure/src/interfaces/http_network.dart';
import 'package:mockito/mockito.dart';

class MockDateTimeWrapper extends Mock with DateTimeWrapper {}

class MockHttpHelper extends Mock with HttpHelper {}

class MockConnectivity extends Mock with Connectivity {}
