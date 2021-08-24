import 'package:core_fe_infrastructure/src/constants/storage_key.dart';
import 'package:core_fe_infrastructure/src/interfaces/noSql_storage.dart';
import 'package:core_fe_infrastructure/src/interfaces/settings_manager.dart';
import 'package:core_fe_infrastructure/src/models/settings.dart';

class SettingsProviderImpl implements SettingsProvider {
  final NoSqlStorageManager _noSqlStorageManager;
  SettingsProviderImpl(this._noSqlStorageManager);
  @override
  Future<void> deleteSettings() =>
      _noSqlStorageManager.delete(StorageKey.settingsStorageKey);

  @override
  Future<Settings> getSettings() =>
      _noSqlStorageManager.get<Settings>(StorageKey.settingsStorageKey,
          fromJsonFunc: (map) => Settings.fromMap(map));

  @override
  Future<void> initSettings(Settings settings) =>
      _noSqlStorageManager.addOrUpdate<Settings>(
        key: StorageKey.settingsStorageKey,
        data: settings,
        toJsonFunc: (s) => s.toMap(),
      );

  @override
  Future<void> updateSettings(Settings settings) =>
      _noSqlStorageManager.addOrUpdate<Settings>(
        key: StorageKey.settingsStorageKey,
        data: settings,
        toJsonFunc: (s) => s.toMap(),
      );
}
