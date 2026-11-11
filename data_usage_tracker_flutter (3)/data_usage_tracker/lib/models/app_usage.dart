class AppUsage {
  final String id;
  final String appName;
  final String packageName;
  final double wifiUsageMB;
  final double mobileUsageMB;
  bool isBlocked;

  AppUsage({
    required this.id,
    required this.appName,
    required this.packageName,
    required this.wifiUsageMB,
    required this.mobileUsageMB,
    this.isBlocked = false,
  });

  double get totalUsageMB => wifiUsageMB + mobileUsageMB;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'appName': appName,
      'packageName': packageName,
      'wifiUsageMB': wifiUsageMB,
      'mobileUsageMB': mobileUsageMB,
      'isBlocked': isBlocked ? 1 : 0,
    };
  }

  factory AppUsage.fromMap(Map<String, dynamic> map) {
    return AppUsage(
      id: map['id'],
      appName: map['appName'],
      packageName: map['packageName'],
      wifiUsageMB: (map['wifiUsageMB'] as num).toDouble(),
      mobileUsageMB: (map['mobileUsageMB'] as num).toDouble(),
      isBlocked: map['isBlocked'] == 1,
    );
  }
}

class DailyUsageRecord {
  final String date; // YYYY-MM-DD
  final double wifiMB;
  final double mobileMB;
  final double dailyLimitMB;

  DailyUsageRecord({
    required this.date,
    required this.wifiMB,
    required this.mobileMB,
    required this.dailyLimitMB,
  });

  double get totalMB => wifiMB + mobileMB;

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'wifiMB': wifiMB,
      'mobileMB': mobileMB,
      'dailyLimitMB': dailyLimitMB,
    };
  }

  factory DailyUsageRecord.fromMap(Map<String, dynamic> map) {
    return DailyUsageRecord(
      date: map['date'],
      wifiMB: (map['wifiMB'] as num).toDouble(),
      mobileMB: (map['mobileMB'] as num).toDouble(),
      dailyLimitMB: (map['dailyLimitMB'] as num).toDouble(),
    );
  }
}