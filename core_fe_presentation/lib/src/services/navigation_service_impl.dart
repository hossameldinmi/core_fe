import 'package:core_fe_presentation/src/interfaces/navigation_service.dart';
import 'package:flutter/widgets.dart';

class NavigationServiceImpl implements NavigationService {
  String _root;
  NavigationServiceImpl(this._root);
  @override
  void pop<T extends Object>(BuildContext context, {T result}) {
    Navigator.of(context).pop<T>(result);
  }

  @override
  void popUntil(BuildContext context, {String route}) {
    Navigator.of(context).popUntil(ModalRoute.withName(route ?? _root));
  }

  @override
  Future<T> pushNamedAndRemoveUntil<T>(BuildContext context, String route,
      {Object args}) async {
    var result = await Navigator.of(context).pushNamedAndRemoveUntil<T>(
        route, (s) => s.currentResult == _root,
        arguments: args);
    _root = route;
    return result;
  }

  @override
  Future<T> push<T extends Object>(BuildContext context, String route,
      {Object args}) async {
    return Navigator.of(context).pushNamed<T>(route, arguments: args);
  }

  @override
  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      BuildContext context, String route,
      {Object args, TO result}) async {
    return Navigator.of(context)
        .pushReplacementNamed<T, TO>(route, arguments: args, result: result);
  }
}
