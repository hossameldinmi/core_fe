import 'package:core_fe_infrastructure/src/constants/storage_keys.dart';
import 'package:core_fe_infrastructure/src/interfaces/i_noSql_storage.dart';
import 'package:core_fe_infrastructure/src/interfaces/i_session_manager.dart';
import 'package:core_fe_infrastructure/src/models/user_session.dart';

class SessionProvider implements ISessionProvider {
  final INoSqlStorageManager _noSqlStorageManager;
  final INoSqlStorageManager _cachedNoSqlStorageManager;
  SessionProvider(this._noSqlStorageManager, this._cachedNoSqlStorageManager);
  @override
  Future<void> startSession(UserSession userSession) async {
    return Future.wait(
      [
        _cachedNoSqlStorageManager.addOrUpdate(
            key: currentUserFolder,
            data: userSession,
            shared: true,
            expiryDate: userSession.expiryDate),
        _noSqlStorageManager.addOrUpdate(
            key: currentUserFolder,
            data: userSession,
            shared: true,
            expiryDate: userSession.expiryDate)
      ],
    );
  }

  @override
  Future<UserSession> getCurrentSession() async {
    var result = await _cachedNoSqlStorageManager
        .get<UserSession>(currentUserFolder, ignoreExpiry: true, shared: true);
    return result ??
        _noSqlStorageManager.get<UserSession>(currentUserFolder,
            shared: true, ignoreExpiry: true);
  }

  @override
  Future<void> endSession() async {
    return Future.wait([
      _cachedNoSqlStorageManager.delete(currentUserFolder, shared: true),
      _noSqlStorageManager.delete(currentUserFolder, shared: true)
    ]);
  }

  @override
  Future<void> updateSession(UserSession userSession) async {
    return Future.wait([
      _cachedNoSqlStorageManager.addOrUpdate(
          key: currentUserFolder,
          data: userSession,
          shared: true,
          expiryDate: userSession.expiryDate),
      _noSqlStorageManager.addOrUpdate(
          key: currentUserFolder,
          data: userSession,
          shared: true,
          expiryDate: userSession.expiryDate)
    ]);
  }
}
