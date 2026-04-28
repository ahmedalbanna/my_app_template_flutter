import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_home_data_usecase.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetHomeDataUsecase getHomeDataUsecase;

  HomeBloc({required this.getHomeDataUsecase}) : super(HomeInitial()) {
    on<FetchHomeDataEvent>((event, emit) async {
      emit(HomeLoading());
      
      final failureOrData = await getHomeDataUsecase();
      
      failureOrData.fold(
        (failure) => emit(HomeError(message: failure.message)),
        (data) => emit(HomeLoaded(data: data)),
      );
    });
  }
}
