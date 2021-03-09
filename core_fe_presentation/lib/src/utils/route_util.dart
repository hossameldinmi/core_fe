import 'package:flutter/widgets.dart';

class RouteUtil {
  static RouteSettings getRouteSettings(BuildContext context) {
    return ModalRoute.of(context)?.settings;
  }
}
