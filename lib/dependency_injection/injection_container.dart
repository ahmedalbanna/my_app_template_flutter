import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../core/network/api_client.dart';
import '../features/home/data/datasources/home_remote_datasource.dart';
import '../features/home/data/repositories/home_repository_impl.dart';
import '../features/home/domain/repositories/home_repository.dart';
import '../features/home/domain/usecases/get_home_data_usecase.dart';
import '../features/home/presentation/bloc/home_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());
  sl.registerLazySingleton<Dio>(() => sl<ApiClient>().dio);

  // Features - Home
  // Data sources
  sl.registerLazySingleton<HomeRemoteDataSource>(() => HomeRemoteDataSourceImpl(dio: sl()));
  
  // Repositories
  sl.registerLazySingleton<HomeRepository>(() => HomeRepositoryImpl(remoteDataSource: sl()));
  
  // Usecases
  sl.registerLazySingleton(() => GetHomeDataUsecase(sl()));
  
  // Blocs
  sl.registerFactory(() => HomeBloc(getHomeDataUsecase: sl()));
}
