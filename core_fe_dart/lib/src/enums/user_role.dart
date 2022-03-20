import 'package:core_fe_dart/src/enums/enum.dart';

class UserRole extends Enum {
  const UserRole(this.code);
  final String code;
  static const UserRole user = UserRole('user');
  static const UserRole admin = UserRole('admin');

  static const List<UserRole> values = <UserRole>[user, admin];
  @override
  String toString() => code;
  @override
  List<Object> get props => [code];
  factory UserRole.fromCode(String code) =>
      values.firstWhere((role) => role.code == code);
}
