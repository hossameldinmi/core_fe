import 'package:core_fe_infrastructure/src/models/user_session.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/src/enums/user_role.dart';
import 'package:core_fe_flutter/src/extenstions/date_time_extensions.dart';

void main() {
  final beforeNowDate = DateTime.now().subtract(Duration(seconds: 1));
  final tomorrowDate = DateTime.now().add(Duration(days: 1));

  group('constructor', () {
    test('assertions', () {
      expect(() {
        UserSession(
            expiryDate: tomorrowDate,
            token: 'TOKEN',
            userRole: UserRole.user,
            userId: 'ID1',
            username: 'UserName');
      }, returnsNormally);
      expect(() {
        UserSession(
            expiryDate: tomorrowDate,
            token: 'TOKEN',
            userRole: UserRole.user,
            userId: 'ID1',
            username: '');
      }, returnsNormally);
      expect(() {
        UserSession(
            expiryDate: null,
            token: 'TOKEN',
            userRole: UserRole.user,
            userId: 'ID1',
            username: 'UserName');
      }, throwsAssertionError);
      expect(() {
        UserSession(
            expiryDate: tomorrowDate,
            token: '',
            userRole: UserRole.user,
            userId: 'ID1',
            username: 'UserName');
      }, throwsAssertionError);
      expect(() {
        UserSession(
            expiryDate: tomorrowDate,
            token: 'TOKEN',
            userRole: null,
            userId: 'ID1',
            username: 'UserName');
      }, throwsAssertionError);
      expect(() {
        UserSession(
            expiryDate: tomorrowDate,
            token: 'TOKEN',
            userRole: UserRole.user,
            userId: '',
            username: 'UserName');
      }, throwsAssertionError);
    });
  });
  group('Serialization & Deserialization', () {
    var userSession = UserSession(
        expiryDate: tomorrowDate,
        token: 'TOKEN',
        userRole: UserRole.user,
        userId: 'US12',
        username: 'UserName');
    test('from map', () {
      var map = {
        'token': userSession.token,
        'user_id': userSession.userId,
        'secret': 'eyJ1c04iOiJVc2VyTmFtZSIsInVzUiI6InVzZXIifQ==',
        'expiry_date': userSession.expiryDate.format(),
      };

      var actual = UserSession.fromMap(map);

      expect(actual, userSession);
    });

    test('to map', () {
      var map = {
        'token': userSession.token,
        'user_id': userSession.userId,
        'secret': 'eyJ1c04iOiJVc2VyTmFtZSIsInVzUiI6InVzZXIifQ==',
        'expiry_date': userSession.expiryDate.format(),
      };

      var actual = userSession.toMap();

      expect(actual, map);
    });

    test('session expiry', () {
      var userSession = UserSession(
          expiryDate: tomorrowDate,
          token: 'TOKEN',
          userRole: UserRole.user,
          userId: 'US12',
          username: 'UserName');
      expect(userSession.isExpired, false);
      expect(
          userSession
              .updateCredentials(token: 'null', expiryDate: beforeNowDate)
              .isExpired,
          true);
    });
  });
}
