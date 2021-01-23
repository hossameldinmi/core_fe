import 'package:flutter/material.dart';

abstract class ViewModelBase with ChangeNotifier {
  bool get isLoading => _isLoading;
  bool _isLoading = false;
  String get busyMessage => _busyMessage;
  String _busyMessage;
  void showLoading({String message}) {
    _isLoading = true;
    _busyMessage = message;
    notify();
  }

  void notify() {
    notifyListeners();
  }

  void hideLoading() {
    _isLoading = false;
    _busyMessage = null;
    notifyListeners();
  }

}
