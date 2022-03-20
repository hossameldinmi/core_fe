import 'package:core_fe_infrastructure/src/interfaces/settings_manager.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';

class SettingsManagerImpl implements SettingsManager {
  final SettingsProvider _settingsProvider;
  final Settings? defaultSettings;
  SettingsManagerImpl(this._settingsProvider, {this.defaultSettings});

  @override
  Future<bool> deleteSettings() => _settingsProvider.deleteSettings().then((value) => true);

  @override
  Future<Settings?> getSettings() {
    try {
      return _settingsProvider.getSettings().then((value) => value ??= defaultSettings);
    } catch (e) {
      return Future.value(defaultSettings);
    }
  }

  @override
  Future<bool> initSettings(Settings settings) => _settingsProvider.initSettings(settings).then((value) => true);

  @override
  Future<bool> updateSettings(Settings settings) => _settingsProvider.updateSettings(settings).then((value) => true);
}
