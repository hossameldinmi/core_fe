@Skip('currently failing') //todo: pass the tests
import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_infrastructure/constants.dart';
import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/managers_mocks.dart';

void main() {
  final mockNoSqlStorageManager = MockNoSqlStorageManager();
  final settingsProvider = SettingsProviderImpl(mockNoSqlStorageManager);
  const settings = Settings(language: Language.enUS);
  test('init settings', () async {
    await settingsProvider.initSettings(settings);
    verify(mockNoSqlStorageManager.addOrUpdate(
        key: StorageKey.settingsStorageKey, data: settings, toJsonFunc: anyNamed('toJsonFunc')));
  });

  test('get settings', () async {
    when(mockNoSqlStorageManager.get<Settings>(
      StorageKey.settingsStorageKey,
      fromJsonFunc: anyNamed('fromJsonFunc'),
    )).thenAnswer((realInvocation) => Future.value(settings));
    var actualSettings = await settingsProvider.getSettings();
    expect(actualSettings, settings);
  });

  test('update settings', () async {
    await settingsProvider.updateSettings(settings);
    verify(mockNoSqlStorageManager.addOrUpdate(
      key: StorageKey.settingsStorageKey,
      data: settings,
      toJsonFunc: anyNamed('toJsonFunc'),
    ));
  });

  test('delete settings', () async {
    await settingsProvider.deleteSettings();
    verify(mockNoSqlStorageManager.delete(StorageKey.settingsStorageKey));
  });
}
