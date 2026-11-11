import 'package:flutter/services.dart';

class FirewallService {
  static const MethodChannel _channel = MethodChannel('com.example.datausagetracker/firewall');

  // تشغيل الجدار الناري وحظر قائمة التطبيقات المحددة
  static Future<bool> startFirewall(List<String> blockedPackages) async {
    try {
      final bool result = await _channel.invokeMethod('startFirewall', {
        'packages': blockedPackages,
      });
      return result;
    } on PlatformException catch (e) {
      print('Firewall error: ${e.message}');
      return false;
    }
  }

  // إيقاف الجدار الناري
  static Future<bool> stopFirewall() async {
    try {
      final bool result = await _channel.invokeMethod('stopFirewall');
      return result;
    } on PlatformException catch (e) {
      print('Firewall stop error: ${e.message}');
      return false;
    }
  }
}