import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../storage/local_data_source.dart';

@injectable
class ThemeCubit extends Cubit<bool> {
  final LocalDataSource localDataSource;

  ThemeCubit(this.localDataSource) : super(localDataSource.getTheme());

  void toggleTheme() {
    final isDark = !state;
    localDataSource.saveTheme(isDark);
    emit(isDark);
  }
}
