import 'package:core_fe_dart/extensions.dart';
import 'package:core_fe_infrastructure/src/interfaces/session_manager.dart';
import 'package:core_fe_infrastructure/src/models/user_session.dart';
import 'package:core_fe_dart/enums.dart';

class SessionManagerImpl implements SessionManager {
  final SessionProvider? _sessionProvider;
  SessionManagerImpl(
    this._sessionProvider,
  );
  @override
  Future<void> startSession({
    required String? username,
    required String? token,
    required String? userId,
    required DateTime? expiryDate,
    UserRole? userRole = UserRole.user,
  }) {
    return _sessionProvider!.startSession(
      UserSession(
        username: username,
        token: token,
        userId: userId,
        expiryDate: expiryDate,
        userRole: userRole,
      ),
    );
  }

  @override
  Future<void> endSession() async {
    return _sessionProvider!.endSession();
  }

  @override
  Future<UserSession?> getCurrentSession() async {
    try {
      return _sessionProvider!.getCurrentSession();
    } on AssertionError {
      return null;
    }
  }

  @override
  Future<bool> isAnonymousSession() async {
    return getCurrentSession().then((userSession) => [userSession, userSession?.token].anyIsNullEmptyOrWhitespace());
  }

  @override
  Future<bool> isSessionExpired() async {
    return getCurrentSession().then(
      (userSession) => userSession!.isExpired,
    );
  }

  @override
  Future<void> updateCredentials({required String? token, required DateTime? expiryDate}) async {
    return getCurrentSession()
        .then(
          (userSession) => _updateSession(userSession!, token: token, expiryDate: expiryDate),
        )
        .then(
          (userSession) => _sessionProvider!.updateSession(userSession),
        );
  }

  UserSession _updateSession(UserSession userSession, {required String? token, required DateTime? expiryDate}) =>
      userSession.updateCredentials(token: token, expiryDate: expiryDate);
}
