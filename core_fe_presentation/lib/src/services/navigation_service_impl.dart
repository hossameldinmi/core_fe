import 'package:core_fe_presentation/src/interfaces/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NavigationServiceImpl implements NavigationService {
  final GlobalKey<NavigatorState> _navigatorKey;
  NavigatorState get _navigatorState => _navigatorKey.currentState;
  NavigationServiceImpl(this._navigatorKey);
  @override
  void pop<T extends Object>({T result}) {
    _navigatorState.pop<T>(result);
  }

  @override
  void popUntil({String route}) {
    _navigatorState.popUntil(
        route != null ? ModalRoute.withName(route) : (r) => r.isFirst);
  }

  @override
  Future<T> pushNamedAndRemoveUntil<T>(String route,
      {String startRoute, Object args}) async {
    var result = await _navigatorState.pushNamedAndRemoveUntil<T>(route,
        startRoute != null ? ModalRoute.withName(startRoute) : (s) => s.isFirst,
        arguments: args);
    return result;
  }

  @override
  Future<T> push<T extends Object>(String route, {Object args}) async {
    return _navigatorState.pushNamed<T>(route, arguments: args);
  }

  @override
  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String route,
      {Object args,
      TO result}) async {
    return _navigatorState.pushReplacementNamed<T, TO>(route,
        arguments: args, result: result);
  }
}
