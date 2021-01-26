import 'package:flutter/material.dart';

class RouteGenerator {
  static Map<String, WidgetBuilder> routes = {};
  static void registerRoute(String route, WidgetBuilder widgetBuilder) {
    routes[route] = widgetBuilder;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (routes.containsKey(settings.name)) {
      return MaterialPageRoute(
          builder: routes[settings.name], settings: settings);
    } else {
      return MaterialPageRoute(builder: (_) {
        return Scaffold(
          body: Center(
            child: Text('No route defined for ${settings.name}'),
          ),
        );
      });
    }
  }
}
