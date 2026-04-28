import 'package:dio/dio.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/home_model.dart';

abstract class HomeRemoteDataSource {
  Future<HomeModel> getHomeData();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final Dio dio;

  HomeRemoteDataSourceImpl({required this.dio});

  @override
  Future<HomeModel> getHomeData() async {
    try {
      // Simulate an API call
      // final response = await dio.get('/home');
      // return HomeModel.fromJson(response.data);
      
      // Mocked data for template
      await Future.delayed(const Duration(seconds: 1));
      return const HomeModel(
        title: 'Feature-First Architecture',
        description: 'Welcome to your Clean Architecture Flutter template!',
      );
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Unknown Error');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
