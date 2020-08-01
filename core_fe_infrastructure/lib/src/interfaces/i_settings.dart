import 'package:core_fe_infrastructure/src/models/settings.dart';

abstract class ISettingsManager {
  Future<bool> initSettings(Settings settings);
  Future<Settings> getSettings();
  Future<bool> updateSettings(Settings settings);
  Future<bool> deleteSettings();
}

abstract class ISettingsProvider {
  Future<void> initSettings(Settings settings);
  Future<Settings> getSettings();
  Future<void> updateSettings(Settings settings);
  Future<void> deleteSettings();
}
