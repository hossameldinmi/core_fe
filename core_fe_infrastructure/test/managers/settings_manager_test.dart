import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_infrastructure/models.dart';
import 'package:core_fe_infrastructure/managers.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/providers_mocks.dart';

void main() {
  final mockSettingsProvider = MockISettingsProvider();
  final settingsManager = SettingsManager(mockSettingsProvider);
  var settings = Settings(language: Language.en_US);
  test('init settings', () async {
    await settingsManager.initSettings(settings);
    verify(mockSettingsProvider.initSettings(settings));
  });

  test('get settings', () async {
    when(mockSettingsProvider.getSettings())
        .thenAnswer((realInvocation) => Future.value(settings));
    var actualSettings = await settingsManager.getSettings();
    expect(actualSettings, settings);
  });

  test('update settings', () async {
    await settingsManager.updateSettings(settings);
    verify(mockSettingsProvider.updateSettings(settings));
  });

  test('delete settings', () async {
    await settingsManager.deleteSettings();
    verify(mockSettingsProvider.deleteSettings());
  });
}
