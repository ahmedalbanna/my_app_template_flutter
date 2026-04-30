// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core/network/api_client.dart' as _i510;
import '../core/network/connectivity_cubit.dart' as _i458;
import '../core/storage/local_data_source.dart' as _i486;
import '../core/theme/theme_cubit.dart' as _i596;
import '../features/auth/data/repositories/auth_repository_impl.dart' as _i570;
import '../features/auth/domain/repositories/auth_repository.dart' as _i869;
import '../features/auth/presentation/bloc/auth_bloc.dart' as _i59;
import '../features/onboarding/presentation/cubit/onboarding_cubit.dart'
    as _i244;
import 'register_module.dart' as _i291;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    final networkModule = _$NetworkModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity);
    gh.lazySingleton<_i486.LocalDataSource>(
      () => _i486.LocalDataSourceImpl(
        sharedPreferences: gh<_i460.SharedPreferences>(),
        secureStorage: gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.factory<_i596.ThemeCubit>(
      () => _i596.ThemeCubit(gh<_i486.LocalDataSource>()),
    );
    gh.factory<_i244.OnboardingCubit>(
      () => _i244.OnboardingCubit(gh<_i486.LocalDataSource>()),
    );
    gh.lazySingleton<_i361.Dio>(
      () => networkModule.dio(gh<_i486.LocalDataSource>()),
    );
    gh.factory<_i458.ConnectivityCubit>(
      () => _i458.ConnectivityCubit(gh<_i895.Connectivity>()),
    );
    gh.factory<_i869.AuthRepository>(
      () => _i570.AuthRepositoryImpl(
        dio: gh<_i361.Dio>(),
        localDataSource: gh<_i486.LocalDataSource>(),
      ),
    );
    gh.factory<_i59.AuthBloc>(() => _i59.AuthBloc(gh<_i869.AuthRepository>()));
    return this;
  }
}

class _$RegisterModule extends _i291.RegisterModule {}

class _$NetworkModule extends _i510.NetworkModule {}
