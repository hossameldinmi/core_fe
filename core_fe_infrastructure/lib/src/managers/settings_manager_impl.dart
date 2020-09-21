import 'package:core_fe_infrastructure/src/interfaces/settings_manager.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';

class SettingsManagerImpl implements SettingsManager {
  final SettingsProvider _settingsProvider;
  SettingsManagerImpl(
    this._settingsProvider,
  );

  @override
  Future<bool> deleteSettings() => _settingsProvider.deleteSettings();

  @override
  Future<Settings> getSettings() => _settingsProvider.getSettings();

  @override
  Future<bool> initSettings(Settings settings) =>
      _settingsProvider.initSettings(settings);

  @override
  Future<bool> updateSettings(Settings settings) =>
      _settingsProvider.updateSettings(settings);
}
