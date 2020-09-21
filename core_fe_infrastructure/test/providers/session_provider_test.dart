import 'package:core_fe_infrastructure/constants.dart';
import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/src/providers/session_provider.dart';
import 'package:mockito/mockito.dart';
import '../mocks/managers_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:core_fe_dart/enums.dart';

MockNoSqlStorageManager _mockCachedINoSqlStorageManager =
    MockNoSqlStorageManager();
MockNoSqlStorageManager _mockNoSqlStorageManager = MockNoSqlStorageManager();
void main() {
  var _sessionProvider = SessionProviderImpl(
      _mockNoSqlStorageManager, _mockCachedINoSqlStorageManager);
  final tomorrowDate = DateTime.now().add(Duration(days: 1));
  var userSession = UserSession(
      expiryDate: tomorrowDate,
      token: 'TOKEN',
      userRole: UserRole.user,
      userId: 'ID1',
      username: 'UserName');
  test('valid session start', () async {
    when(
      _mockNoSqlStorageManager.addOrUpdate(
          key: StorageKey.currentUserFolder,
          data: userSession,
          expiryDate: userSession.expiryDate,
          shared: true),
    ).thenAnswer((realInvocation) => Future.value());
    when(
      _mockCachedINoSqlStorageManager.addOrUpdate(
          key: StorageKey.currentUserFolder,
          data: userSession,
          expiryDate: userSession.expiryDate,
          shared: true),
    ).thenAnswer((realInvocation) => Future.value());

    await _sessionProvider.startSession(userSession);
    verify(_mockNoSqlStorageManager.addOrUpdate(
        key: StorageKey.currentUserFolder,
        data: userSession,
        expiryDate: userSession.expiryDate,
        shared: true));
    verify(_mockCachedINoSqlStorageManager.addOrUpdate(
        key: StorageKey.currentUserFolder,
        data: userSession,
        expiryDate: userSession.expiryDate,
        shared: true));
  });

  test('end session', () async {
    when(_mockNoSqlStorageManager.delete(StorageKey.currentUserFolder, shared: true))
        .thenAnswer((realInvocation) => Future.value());
    when(_mockCachedINoSqlStorageManager.delete(StorageKey.currentUserFolder,
            shared: true))
        .thenAnswer((realInvocation) => Future.value());

    await _sessionProvider.endSession();

    verify(_mockNoSqlStorageManager.delete(StorageKey.currentUserFolder, shared: true));
    verify(_mockCachedINoSqlStorageManager.delete(StorageKey.currentUserFolder,
        shared: true));
  });

  test('get current sessoin from cached storage', () async {
    when(_mockCachedINoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
            shared: true, ignoreExpiry: true))
        .thenAnswer((realInvocation) => Future.value(userSession));
    var currentSession = await _sessionProvider.getCurrentSession();

    verify(
      _mockCachedINoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
          shared: true, ignoreExpiry: true),
    );
    verifyNever(
      _mockNoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
          shared: true, ignoreExpiry: true),
    );
    expect(currentSession, userSession);
  });

  test('get current sessoin from disk storage', () async {
    when(_mockCachedINoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
            shared: true, ignoreExpiry: true))
        .thenAnswer((realInvocation) => Future.value(null));

    when(_mockNoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
            shared: true, ignoreExpiry: true))
        .thenAnswer((realInvocation) => Future.value(userSession));
    var currentSession = await _sessionProvider.getCurrentSession();

    verify(
      _mockCachedINoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
          shared: true, ignoreExpiry: true),
    );
    verify(
      _mockNoSqlStorageManager.get<UserSession>(StorageKey.currentUserFolder,
          shared: true, ignoreExpiry: true),
    );
    expect(currentSession, userSession);
  });

  test('update Credentials with valid Credentials', () async {
    when(_mockCachedINoSqlStorageManager.addOrUpdate<UserSession>(
            key: StorageKey.currentUserFolder,
            data: userSession,
            shared: true,
            expiryDate: userSession.expiryDate))
        .thenAnswer((realInvocation) => Future.value());
    when(_mockNoSqlStorageManager.addOrUpdate<UserSession>(
            key: StorageKey.currentUserFolder,
            data: userSession,
            shared: true,
            expiryDate: userSession.expiryDate))
        .thenAnswer((realInvocation) => Future.value());

    await _sessionProvider.updateSession(userSession);

    verify(_mockCachedINoSqlStorageManager.addOrUpdate<UserSession>(
        key: StorageKey.currentUserFolder,
        data: userSession,
        shared: true,
        expiryDate: userSession.expiryDate));
    verify(_mockNoSqlStorageManager.addOrUpdate<UserSession>(
        key: StorageKey.currentUserFolder,
        data: userSession,
        shared: true,
        expiryDate: userSession.expiryDate));
  });
}
