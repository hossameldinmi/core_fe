
import 'package:core_fe_infrastructure/src/interfaces/i_settings.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';

class SettingsManager implements ISettingsManager {
  final ISettingsProvider _settingsProvider;
  SettingsManager(
    this._settingsProvider,
  );

  @override
  Future<bool> deleteSettings() {
    return _settingsProvider.deleteSettings();
  }

  @override
  Future<Settings> getSettings() {
    return _settingsProvider.getSettings();
  }

  @override
  Future<bool> initSettings(Settings settings) {
    return _settingsProvider.initSettings(settings);
  }

  @override
  Future<bool> updateSettings(Settings settings) {
    return _settingsProvider.updateSettings(settings);
  }
}
