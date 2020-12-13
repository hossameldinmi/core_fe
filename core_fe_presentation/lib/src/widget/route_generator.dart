import 'package:flutter/material.dart';

class RouteGenerator {
  static Map<String, WidgetBuilder> wiringWidgets = {};
  static void registerPage(String route, WidgetBuilder widgetBuilder) {
    wiringWidgets[route] = widgetBuilder;
  }

  static Route<dynamic> generateRoute(RouteSettings settings) {
    if (wiringWidgets.containsKey(settings.name)) {
      return MaterialPageRoute(
          builder: wiringWidgets[settings.name], settings: settings);
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
