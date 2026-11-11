import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(settings);
  }

  Future<void> showDataAlert({
    required int id,
    required String title,
    required String body,
  }) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'data_usage_alerts',
      'تنبيهات استهلاك البيانات',
      channelDescription: 'قناة إرسال تنبيهات تجاوز حدود استهلاك الإنترنت',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);
    await _notifications.show(id, title, body, details);
  }

  // فحص نسبة الاستهلاك وإطلاق التنبيهات
  void checkAndNotifyThreshold({
    required double currentMB,
    required double limitMB,
    required Set<int> triggeredAlerts,
  }) {
    if (limitMB <= 0) return;
    double percentage = (currentMB / limitMB) * 100;

    if (percentage >= 100 && !triggeredAlerts.contains(100)) {
      showDataAlert(
        id: 100,
        title: '⚠️ تجاوزت الحد الأقصى (100%)',
        body: 'لقد استهلكت كامل باقتك المحددة (${(limitMB / 1024).toStringAsFixed(1)} جيجابايت)!',
      );
      triggeredAlerts.add(100);
    } else if (percentage >= 80 && !triggeredAlerts.contains(80)) {
      showDataAlert(
        id: 80,
        title: '🔔 تنبيه استهلاك (80%)',
        body: 'اقتربت من نفاذ الحد اليومي، استهلكت 80% من باقتك.',
      );
      triggeredAlerts.add(80);
    } else if (percentage >= 50 && !triggeredAlerts.contains(50)) {
      showDataAlert(
        id: 50,
        title: 'ℹ️ تنبيه استهلاك (50%)',
        body: 'لقد استهلكت نصف الحد المسموح به لهذا اليوم.',
      );
      triggeredAlerts.add(50);
    }
  }
}