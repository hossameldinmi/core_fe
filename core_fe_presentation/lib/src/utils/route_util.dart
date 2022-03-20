import 'package:flutter/widgets.dart';

class RouteUtil {
  static RouteSettings getRouteSettings(BuildContext context) {
    return ModalRoute.of(context)!.settings;
  }

  static Object? argsOf(BuildContext context) {
    return getRouteSettings(context).arguments;
  }
}
