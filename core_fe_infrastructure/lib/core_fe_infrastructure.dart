library core.fe.infrastructure;

export 'constants.dart';
export 'enums.dart';
export 'interfaces.dart';
export 'managers.dart';
export 'models.dart';
export 'providers.dart';
export 'utils.dart';

import 'package:core_fe_dart/utils.dart';
import 'dart:async';
import 'package:core_fe_flutter/enums.dart';
import 'package:core_fe_flutter/utils.dart';
import 'package:core_fe_infrastructure/interfaces.dart';
import 'package:core_fe_infrastructure/managers.dart';
import 'package:core_fe_infrastructure/providers.dart';
import 'package:core_fe_infrastructure/utils.dart';

import 'constants.dart';
import 'models.dart';
import 'src/interfaces/http_network.dart';

class CoreFeInfrastructureModule implements BaseModule {
  CoreFeInfrastructureModule(this._dpName);
  Completer<void>? _completer;
  final String _dpName;

  @override
  Future<void> setUp() {
    _completer ??= Completer();
    PathProvider.getDocumentPath().then((dbPath) {
      Locator.providers.registerLazySingleton<NoSqlStorageProvider>(() => SembastStorageProviderImpl(dbPath + _dpName));
      Locator.providers.registerLazySingleton<NoSqlStorageProvider>(
          () => SembastStorageProviderImpl(dbPath + _dpName, isInMemoryDb: true),
          instanceName: IocKeys.cachedStorageProvider);
      _completer!.complete();
    });
    Locator.utils.registerSingleton<Connectivity>(ConnectivityImpl());
    Locator.utils.registerSingleton<DateTimeWrapper>(DateTimeWrapperImpl());

    Locator.utils.registerLazySingleton<HttpHelper>(
      () => HttpHelperImpl(Locator.managers<SessionManager>(), Locator.managers<SettingsManager>()),
    );

    Locator.managers.registerLazySingleton<NoSqlStorageManager>(
      () => NoSqlStorageManagerImpl(
        Locator.providers<NoSqlStorageProvider>(),
        Locator.utils<DateTimeWrapper>(),
      ),
    );

    Locator.managers.registerLazySingleton<NoSqlStorageManager>(
        () => NoSqlStorageManagerImpl(
              Locator.providers<NoSqlStorageProvider>(instanceName: IocKeys.cachedStorageProvider),
              Locator.utils<DateTimeWrapper>(),
            ),
        instanceName: IocKeys.cachedStorageManager);

    Locator.providers.registerLazySingleton<SessionProvider>(
      () => SessionProviderImpl(
        Locator.managers<NoSqlStorageManager>(),
        Locator.managers<NoSqlStorageManager>(instanceName: IocKeys.cachedStorageManager),
      ),
    );

    Locator.managers.registerLazySingleton<SessionManager>(
      () => SessionManagerImpl(
        Locator.providers<SessionProvider>(),
      ),
    );

    Locator.providers.registerLazySingleton<SettingsProvider>(
      () => SettingsProviderImpl(Locator.managers<NoSqlStorageManager>()),
    );

    Locator.managers.registerLazySingleton<SettingsManager>(
      () => SettingsManagerImpl(
        Locator.providers<SettingsProvider>(),
        defaultSettings: const Settings(
          language: Language.enUS,
        ),
      ),
    );
    return _completer!.future;
  }
}
