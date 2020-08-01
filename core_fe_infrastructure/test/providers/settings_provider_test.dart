import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_infrastructure/constants.dart';
import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks/managers_mocks.dart';

void main() {
  final mockINoSqlStorageManager = MockINoSqlStorageManager();
  final settingsProvider = SettingsProvider(mockINoSqlStorageManager);
  var settings = Settings(language: Language.en_US);
  test('init settings', () async {
    await settingsProvider.initSettings(settings);
    verify(mockINoSqlStorageManager.addOrUpdate(
        key: StorageKey.kSettingsStorageKey, data: settings));
  });

  test('get settings', () async {
    when(mockINoSqlStorageManager.get<Settings>(StorageKey.kSettingsStorageKey))
        .thenAnswer((realInvocation) => Future.value(settings));
    var actualSettings = await settingsProvider.getSettings();
    expect(actualSettings, settings);
  });

  test('update settings', () async {
    await settingsProvider.updateSettings(settings);
    verify(mockINoSqlStorageManager.addOrUpdate(
        key: StorageKey.kSettingsStorageKey, data: settings));
  });

  test('delete settings', () async {
    await settingsProvider.deleteSettings();
    verify(mockINoSqlStorageManager.delete(StorageKey.kSettingsStorageKey));
  });
}
