import 'package:core_fe_infrastructure/src/models/user_session.dart';
import 'package:core_fe_dart/enums.dart';

abstract class SessionManager {
  Future<void> startSession({
    required String username,
    required String token,
    required String userId,
    required DateTime expiryDate,
    UserRole userRole = UserRole.user,
  });
  Future<void> endSession();
  Future<UserSession?> getCurrentSession();
  Future<bool> isAnonymousSession();
  Future<bool> isSessionExpired();

  Future<void> updateCredentials({
    required String token,
    required DateTime expiryDate,
  });
}

abstract class SessionProvider {
  Future<void> startSession(UserSession userSession);
  Future<void> endSession();
  Future<UserSession?> getCurrentSession();
  Future<void> updateSession(UserSession userSession);
}
