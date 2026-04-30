import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// معالج الرسائل في الخلفية – يجب أن يكون top-level function
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  Logger().d('Background message: ${message.messageId}');
}

/// أنواع الإشعارات المدعومة للتوجيه
enum NotificationType {
  chat,
  order,
  promotion,
  system,
  unknown,
}

extension NotificationTypeExt on String? {
  NotificationType toNotificationType() {
    switch (this) {
      case 'chat':
        return NotificationType.chat;
      case 'order':
        return NotificationType.order;
      case 'promotion':
        return NotificationType.promotion;
      case 'system':
        return NotificationType.system;
      default:
        return NotificationType.unknown;
    }
  }
}

/// خدمة الإشعارات – Singleton
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final _logger = Logger();
  final _messaging = FirebaseMessaging.instance;

  /// Callback يُستدعى عند النقر على إشعار (لتمرير قيمة للـ Router)
  void Function(NotificationType type, Map<String, dynamic> data)?
      onNotificationTap;

  /// تهيئة الخدمة كاملة
  Future<void> init({
    void Function(NotificationType type, Map<String, dynamic> data)?
        onTap,
  }) async {
    onNotificationTap = onTap;

    // تسجيل معالج الخلفية
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // طلب صلاحيات (iOS + Web)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    _logger.i('Notification permission: ${settings.authorizationStatus}');

    // معالجة الإشعارات في المقدمة
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // معالجة النقر على إشعار (التطبيق في الخلفية)
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // معالجة النقر على إشعار الذي أطلق التطبيق (Terminated state)
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    _logger.i('NotificationService initialized');
  }

  /// معالجة الإشعار الوارد في المقدمة
  void _handleForegroundMessage(RemoteMessage message) {
    _logger.d('Foreground message: ${message.data}');
    // هنا يمكن إظهار local notification مخصص
    // مثال: flutter_local_notifications
  }

  /// التوجيه حسب نوع الإشعار
  void _handleNotificationTap(RemoteMessage message) {
    _logger.d('Notification tapped: ${message.data}');

    final type = message.data['type']?.toString().toNotificationType()
        ?? NotificationType.unknown;

    onNotificationTap?.call(type, message.data);
  }

  /// جلب FCM Token للجهاز
  Future<String?> getToken() async {
    try {
      final token = await _messaging.getToken();
      _logger.i('FCM Token: $token');
      return token;
    } catch (e) {
      _logger.e('Failed to get FCM token: $e');
      return null;
    }
  }

  /// الاشتراك في موضوع معين
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    _logger.i('Subscribed to topic: $topic');
  }

  /// إلغاء الاشتراك في موضوع
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    _logger.i('Unsubscribed from topic: $topic');
  }
}
