import 'package:flutter/material.dart';
import 'failures.dart';

/// معالج الأخطاء المركزي – يعرض SnackBar أو Dialog عند أي Failure
class ErrorHandler {
  /// عرض SnackBar في أسفل الشاشة
  static void showSnackBar(
    BuildContext context,
    Failure failure, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          failure.message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor:
            failure is UnauthorizedFailure ? Colors.orange[800] : Colors.redAccent,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration,
      ),
    );
  }

  /// عرض SnackBar بسيط برسالة نصية مباشرة
  static void showMessage(
    BuildContext context,
    String message, {
    Color backgroundColor = Colors.green,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.clearSnackBars();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: duration,
      ),
    );
  }

  /// عرض حوار خطأ مع زر إغلاق
  static Future<void> showErrorDialog(
    BuildContext context,
    Failure failure, {
    String? title,
    VoidCallback? onRetry,
  }) async {
    return showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title ?? 'Error'),
        content: Text(failure.message),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                onRetry();
              },
              child: const Text('Retry'),
            ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
