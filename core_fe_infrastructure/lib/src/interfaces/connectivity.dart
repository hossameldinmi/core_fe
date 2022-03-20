import 'dart:async';

abstract class Connectivity {
  Stream<bool> get onConnectivityChanged;
  Future<bool> isConnected();
}
