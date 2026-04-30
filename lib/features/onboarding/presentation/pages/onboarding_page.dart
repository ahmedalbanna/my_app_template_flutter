import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../dependency_injection/injection_container.dart';
import '../../../../core/theme/app_colors.dart';
import '../cubit/onboarding_cubit.dart';

/// نموذج بيانات شريحة الـ Onboarding
class OnboardingSlide {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color primaryColor;
  final Color secondaryColor;

  const OnboardingSlide({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.primaryColor,
    required this.secondaryColor,
  });
}

final List<OnboardingSlide> _slides = [
  const OnboardingSlide(
    icon: Icons.rocket_launch_rounded,
    title: 'Welcome to the App',
    subtitle: 'A powerful, flexible Flutter template\nto kickstart your project with ease.',
    primaryColor: Color(0xFF6C63FF),
    secondaryColor: Color(0xFF3D35CC),
  ),
  const OnboardingSlide(
    icon: Icons.architecture_rounded,
    title: 'Built with Best Practices',
    subtitle: 'Clean Architecture, BLoC, GoRouter,\nand Dependency Injection — all ready.',
    primaryColor: Color(0xFF00D4AA),
    secondaryColor: Color(0xFF009E7C),
  ),
  const OnboardingSlide(
    icon: Icons.bolt_rounded,
    title: "Let's Get Started",
    subtitle: 'Create your account or log in\nto start building something amazing.',
    primaryColor: Color(0xFFF59E0B),
    secondaryColor: Color(0xFFD97706),
  ),
];

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish(OnboardingCubit cubit) async {
    await cubit.completeOnboarding();
    if (mounted) context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OnboardingCubit>(),
      child: BlocConsumer<OnboardingCubit, int>(
        listener: (context, slideIndex) {
          _pageController.animateToPage(
            slideIndex,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeInOut,
          );
        },
        builder: (context, currentIndex) {
          final cubit = context.read<OnboardingCubit>();
          final slide = _slides[currentIndex];

          return Scaffold(
            body: AnimatedContainer(
              duration: const Duration(milliseconds: 400),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.darkBackground,
                    slide.secondaryColor.withValues(alpha: 0.4),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    // ─── Skip Button ─────────────────────────────
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: () => _finish(cubit),
                        child: Text(
                          'Skip',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    // ─── PageView ────────────────────────────────
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: cubit.goToSlide,
                        itemCount: _slides.length,
                        itemBuilder: (_, i) => _SlideContent(slide: _slides[i]),
                      ),
                    ),

                    // ─── Indicators ──────────────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _slides.length,
                        (i) => _DotIndicator(isActive: i == currentIndex),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // ─── Buttons ─────────────────────────────────
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          if (currentIndex > 0)
                            Expanded(
                              child: OutlinedButton(
                                onPressed: cubit.previousSlide,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 16.h),
                                ),
                                child: const Text('Back'),
                              ),
                            ),
                          if (currentIndex > 0) SizedBox(width: 12.w),
                          Expanded(
                            flex: 2,
                            child: ElevatedButton(
                              onPressed: cubit.isLastSlide
                                  ? () => _finish(cubit)
                                  : cubit.nextSlide,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: slide.primaryColor,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16.h),
                              ),
                              child: Text(
                                cubit.isLastSlide ? 'Get Started' : 'Next',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Slide Content Widget
// ─────────────────────────────────────────────────────────────────────

class _SlideContent extends StatelessWidget {
  final OnboardingSlide slide;

  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ─── Icon Container ─────────────────────────────────────
          Container(
            width: 140.w,
            height: 140.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  slide.primaryColor.withValues(alpha: 0.3),
                  slide.secondaryColor.withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(
                color: slide.primaryColor.withValues(alpha: 0.4),
                width: 1.5,
              ),
            ),
            child: Icon(slide.icon, size: 68.sp, color: slide.primaryColor),
          ),

          SizedBox(height: 40.h),

          // ─── Title ──────────────────────────────────────────────
          Text(
            slide.title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 16.h),

          // ─── Subtitle ───────────────────────────────────────────
          Text(
            slide.subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.65),
              fontSize: 15.sp,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// Dot Indicator
// ─────────────────────────────────────────────────────────────────────

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: isActive ? 24.w : 8.w,
      height: 8.h,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : Colors.white.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}
