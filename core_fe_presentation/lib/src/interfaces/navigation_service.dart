import 'package:flutter/widgets.dart';

abstract class NavigationService {
  Future<T> push<T extends Object>(BuildContext context, String route,
      {Object args});

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      BuildContext context, String route,
      {Object args, TO result});

  Future<T> pushNamedAndRemoveUntil<T>(BuildContext context, String route,
      {Object args});
  void pop<T extends Object>(BuildContext context, {T result});
  void popUntil(BuildContext context, {String route});
}
