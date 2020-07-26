import 'package:core_fe_dart/core_fe_dart.dart';

class UserRole extends Enum<String, UserRole> {
  const UserRole(String code) : super(code);

  static const UserRole user = UserRole('user');
  static const UserRole admin = UserRole('admin');

  static const List<UserRole> values = <UserRole>[user, admin];
  @override
  String toString() => super.key;

  factory UserRole.fromCode(String code) {
    return values.firstWhere((role) => role.key == code);
  }
}
