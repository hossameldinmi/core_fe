import 'package:core_fe_dart/src/enums/user_role.dart';
import 'dart:convert';
import 'package:core_fe_dart/src/extensions/validation_extensions.dart';
import 'package:core_fe_flutter/src/extenstions/date_time_extensions.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:core_fe_dart/src/validations/validation.dart';

@immutable
class UserSession extends Equatable {
  final String _secret;
  final String username;
  final String userId;
  final String token;
  final UserRole userRole;
  final DateTime expiryDate;

  UserSession(
      {@required this.username,
      @required this.token,
      @required this.userId,
      @required this.expiryDate,
      this.userRole = UserRole.user})
      : _secret = _encodeCredentials(username, userRole) {
    validate(!token.isNullEmptyOrWhitespace());
    validate(!userId.isNullEmptyOrWhitespace());
    validate(!userRole.isNullEmptyOrWhitespace());
    validate(!expiryDate.isNullEmptyOrWhitespace());
  }

  UserSession._fromCredentials({
    @required this.token,
    @required this.userId,
    @required this.expiryDate,
    @required String secret,
  })  : _secret = secret,
        username = _decodeCredentials(secret)['usN'],
        userRole = UserRole.fromCode(_decodeCredentials(secret)['usR']) {
    validate(!token.isNullEmptyOrWhitespace());
    validate(!userId.isNullEmptyOrWhitespace());
    validate(expiryDate != null);
    validate(!userRole.isNullEmptyOrWhitespace());
    validate(!secret.isNullEmptyOrWhitespace());
  }

  UserSession updateCredentials({
    @required String token,
    @required DateTime expiryDate,
  }) =>
      UserSession._fromCredentials(
        token: token,
        userId: userId,
        expiryDate: expiryDate,
        secret: _secret,
      );

  bool get isExpired => expiryDate.isBefore(DateTime.now());

  static String _encodeCredentials(String username, UserRole userRole) {
    if (username == null || userRole == null) return null;
    var claims = {'usN': username, 'usR': userRole.toString()};
    var bytes = utf8.encode(json.encode(claims));
    var base64Str = base64.encode(bytes);
    return base64Str;
  }

  static Map<String, dynamic> _decodeCredentials(String credentials) {
    if (credentials.isNullEmptyOrWhitespace()) return null;
    var base64Str = base64.decode(credentials);
    var stringText = utf8.decode(base64Str);
    return json.decode(stringText);
  }

  factory UserSession.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    return UserSession._fromCredentials(
      token: map['token'],
      userId: map['user_id'],
      secret: map['secret'],
      expiryDate: ((map['expiry_date']) as String).parseToDateTime(),
    );
  }
  Map<String, dynamic> toMap() => {
        'token': token,
        'user_id': userId,
        'secret': _secret,
        'expiry_date': expiryDate.format(),
      };

  @override
  List<Object> get props =>
      [_secret, username, userId, token, userRole, expiryDate];
}
