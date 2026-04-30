import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/storage/local_data_source.dart';

/// Cubit لإدارة حالة شاشة الـ Onboarding
@injectable
class OnboardingCubit extends Cubit<int> {
  final LocalDataSource localDataSource;

  OnboardingCubit(this.localDataSource) : super(0);

  static const int totalSlides = 3;

  /// الانتقال للشريحة التالية
  void nextSlide() {
    if (state < totalSlides - 1) emit(state + 1);
  }

  /// الانتقال للشريحة السابقة
  void previousSlide() {
    if (state > 0) emit(state - 1);
  }

  /// القفز لشريحة معينة
  void goToSlide(int index) {
    if (index >= 0 && index < totalSlides) emit(index);
  }

  bool get isLastSlide => state == totalSlides - 1;

  /// تعليم الـ Onboarding كـ "تمّت مشاهدته"
  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingSeen();
  }
}
