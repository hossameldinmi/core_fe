import 'package:core_fe_dart/enums.dart';

class NavigationDirection extends Enum {
  final String _mode;
  const NavigationDirection(this._mode);
  static const NavigationDirection newPage = NavigationDirection('newPage');
  static const NavigationDirection back = NavigationDirection('back');

  @override
  List<Object> get props => [_mode];
}
