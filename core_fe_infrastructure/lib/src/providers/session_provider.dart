import 'package:core_fe_infrastructure/src/constants/storage_key.dart';
import 'package:core_fe_infrastructure/src/interfaces/no_sql_storage.dart';
import 'package:core_fe_infrastructure/src/interfaces/session_manager.dart';
import 'package:core_fe_infrastructure/src/models/user_session.dart';

class SessionProviderImpl implements SessionProvider {
  final NoSqlStorageManager _noSqlStorageManager;
  final NoSqlStorageManager _cachedNoSqlStorageManager;
  SessionProviderImpl(this._noSqlStorageManager, this._cachedNoSqlStorageManager);
  @override
  Future<void> startSession(UserSession userSession) async {
    await Future.wait(
      [
        _cachedNoSqlStorageManager.addOrUpdate(
            key: StorageKey.currentUserFolder, data: userSession, shared: true, expiryDate: userSession.expiryDate),
        _noSqlStorageManager.addOrUpdate(
            key: StorageKey.currentUserFolder, data: userSession, shared: true, expiryDate: userSession.expiryDate)
      ],
    );
  }

  @override
  Future<UserSession?> getCurrentSession() async {
    var result = await _cachedNoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
        ignoreExpiry: true, shared: true);
    return result ??
        await _noSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder, shared: true, ignoreExpiry: true);
  }

  @override
  Future<void> endSession() async {
    await Future.wait<void>([
      _cachedNoSqlStorageManager.delete(StorageKey.currentUserFolder, shared: true),
      _noSqlStorageManager.delete(StorageKey.currentUserFolder, shared: true)
    ]);
  }

  @override
  Future<void> updateSession(UserSession userSession) async {
    await Future.wait([
      _cachedNoSqlStorageManager.addOrUpdate(
          key: StorageKey.currentUserFolder, data: userSession, shared: true, expiryDate: userSession.expiryDate),
      _noSqlStorageManager.addOrUpdate(
          key: StorageKey.currentUserFolder, data: userSession, shared: true, expiryDate: userSession.expiryDate)
    ]);
  }
}
