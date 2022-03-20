import 'package:flutter/foundation.dart';
import 'navigation_direction.dart';

@immutable
class NavigationArgs {
  final NavigationDirection direction;
  final Object? param;
  final String? prevRoute;
  const NavigationArgs({required this.param, this.direction = NavigationDirection.newPage, this.prevRoute});

  NavigationArgs copyWith({
    NavigationDirection? direction,
    Object? param,
    String? prevRoute,
  }) =>
      NavigationArgs(
          direction: direction ?? this.direction, param: param ?? this.param, prevRoute: prevRoute ?? this.prevRoute);
}
