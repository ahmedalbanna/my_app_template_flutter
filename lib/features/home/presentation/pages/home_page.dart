import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Unauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.brightness_6),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () => context.read<AuthBloc>().add(const AuthLogoutRequested()),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<AuthBloc, AuthState>(
                builder: (context, state) {
                  String name = 'Guest';
                  if (state is Authenticated) {
                    name = '${state.user.firstName} ${state.user.lastName}'.trim();
                    if (name.isEmpty) name = state.user.email;
                  }
                  return Text(
                    'Welcome back, $name!',
                    style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
                  );
                },
              ),
              SizedBox(height: 20.h),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.w,
                  mainAxisSpacing: 16.h,
                  children: [
                    _buildDashboardItem(context, Icons.person, 'Profile'),
                    _buildDashboardItem(context, Icons.settings, 'Settings'),
                    _buildDashboardItem(context, Icons.notifications, 'Notifications'),
                    _buildDashboardItem(context, Icons.info, 'About'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardItem(BuildContext context, IconData icon, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40.sp, color: const Color(0xFF2196F3)),
          SizedBox(height: 12.h),
          Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
