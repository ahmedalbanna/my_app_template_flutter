import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';
import 'core/network/connectivity_cubit.dart';
import 'core/widgets/connectivity_banner.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'dependency_injection/injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // ─── Theme ─────────────────────────────────────────────
        BlocProvider(
          create: (_) => getIt<ThemeCubit>(),
        ),

        // ─── Auth – يبدأ فحص المصادقة فوراً ────────────────────
        BlocProvider(
          create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
        ),

        // ─── Connectivity – مراقبة الشبكة شجرياً ────────────────
        BlocProvider(
          create: (_) => getIt<ConnectivityCubit>(),
        ),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp.router(
            title: 'Flutter Template',
            debugShowCheckedModeBanner: false,

            // ─── Localization ──────────────────────────────────
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,

            // ─── Theme ─────────────────────────────────────────
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,

            // ─── Routing ───────────────────────────────────────
            routerConfig: AppRouter.router,

            // ─── Builder – يلفّ كل شاشة بـ ConnectivityBanner ──
            builder: (context, child) {
              return ConnectivityBanner(
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
