abstract class NavigationService {
  Future<T> push<T extends Object>(String route, {Object args});

  Future<T> pushReplacementNamed<T extends Object, TO extends Object>(
      String route,
      {Object args,
      TO result});

  Future<T> pushNamedAndRemoveUntil<T>(String route,
      {String startRoute, Object args});
  void pop<T extends Object>({T result});
  void popUntil({String route});
}
