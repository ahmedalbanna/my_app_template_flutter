import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../network/connectivity_cubit.dart';
import '../theme/app_colors.dart';

/// شريط تنبيه انقطاع الإنترنت – يظهر تلقائياً عند فقدان الاتصال
class ConnectivityBanner extends StatelessWidget {
  final Widget child;

  const ConnectivityBanner({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ConnectivityCubit, bool>(
      listenWhen: (prev, curr) => prev != curr,
      listener: (context, isConnected) {
        if (isConnected) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.wifi, color: Colors.white, size: 18),
                  const SizedBox(width: 8),
                  const Text('You\'re back online!'),
                ],
              ),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, isConnected) {
        return Column(
          children: [
            if (!isConnected) _buildBanner(),
            Expanded(child: child),
          ],
        );
      },
    );
  }

  Widget _buildBanner() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      color: AppColors.error,
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        children: [
          const Icon(Icons.wifi_off_rounded, color: Colors.white, size: 18),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              'No Internet Connection',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
