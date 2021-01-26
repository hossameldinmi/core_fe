import 'package:core_fe_presentation/src/interfaces/navigation_service.dart';
import 'package:flutter/widgets.dart';

class NavigationServiceImpl implements NavigationService {
  String _root;
  final GlobalKey<NavigatorState>  _navigatorKey;
  NavigationServiceImpl(this._root,this._navigatorKey);
  @override
  void pop<T extends Object>( {T result}) {
    _navigatorKey.currentState.pop<T>(result);
  }

  @override
  void popUntil({String route}) {
    _navigatorKey.currentState.popUntil(ModalRoute.withName(route ?? _root));
  }

  @override
  Future<T> pushNamedAndRemoveUntil<T>( String route,
      {Object args}) async {
    var result = await _navigatorKey.currentState.pushNamedAndRemoveUntil<T>(
        route, (s) => s.currentResult == _root,
        arguments: args);
    _root = route;
    return result;
  }

  @override
  Future<T> push<T extends Object>( String route,
      {Object args}) async {
    return _navigatorKey.currentState.pushNamed<T>(route, arguments: args);
  }

  @override
  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String route,
      {Object args, TO result}) async {
    return _navigatorKey.currentState
        .pushReplacementNamed<T, TO>(route, arguments: args, result: result);
  }
}
