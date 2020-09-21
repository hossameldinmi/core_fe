import 'package:connectivity/connectivity.dart' as connectivity;
import 'dart:async';

import 'package:core_fe_infrastructure/src/interfaces/connectivity.dart';

class ConnectivityImpl implements Connectivity {
  final connectivity.Connectivity _connectivity = connectivity.Connectivity();
  final StreamController<bool> _connectivityChangedController =
      StreamController<bool>();

  ConnectivityImpl() {
    _connectivity.onConnectivityChanged.listen(
        (event) => _connectivityChangedController.add(_isConnected(event)));
  }

  @override
  Stream<bool> get onConnectivityChanged =>
      _connectivityChangedController.stream;

  @override
  Future<bool> isConnected() {
    return _connectivity.checkConnectivity().then(_isConnected);
  }

  bool _isConnected(connectivity.ConnectivityResult connection) {
    return connection == connectivity.ConnectivityResult.mobile ||
        connection == connectivity.ConnectivityResult.wifi;
  }
}
