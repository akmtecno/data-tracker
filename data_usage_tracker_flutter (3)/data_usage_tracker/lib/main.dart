import 'package:flutter/material.dart';
import 'screens/dashboard_screen.dart';
import 'screens/app_list_screen.dart';
import 'screens/history_screen.dart';
import 'screens/settings_screen.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const DataUsageApp());
}

class DataUsageApp extends StatelessWidget {
  const DataUsageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'متتبع استهلاك البيانات',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        fontFamily: 'Roboto',
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  double _dailyLimitGB = 5.0; // الحد الافتراضي 5 جيجابايت
  final double _wifiUsageMB = 2450.0;
  final double _mobileUsageMB = 680.0;
  final Set<int> _triggeredAlerts = {};

  @override
  void initState() {
    super.initState();
    _checkLimits();
  }

  void _checkLimits() {
    final totalMB = _wifiUsageMB + _mobileUsageMB;
    final limitMB = _dailyLimitGB * 1024;
    NotificationService().checkAndNotifyThreshold(
      currentMB: totalMB,
      limitMB: limitMB,
      triggeredAlerts: _triggeredAlerts,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      DashboardScreen(
        wifiUsageMB: _wifiUsageMB,
        mobileUsageMB: _mobileUsageMB,
        dailyLimitMB: _dailyLimitGB * 1024,
      ),
      const AppListScreen(),
      const HistoryScreen(),
      SettingsScreen(
        currentDailyLimitGB: _dailyLimitGB,
        onLimitChanged: (newLimit) {
          setState(() {
            _dailyLimitGB = newLimit;
            _checkLimits();
          });
        },
      ),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'الرئيسية',
          ),
          NavigationDestination(
            icon: Icon(Icons.security_outlined),
            selectedIcon: Icon(Icons.security),
            label: 'التطبيقات والحظر',
          ),
          NavigationDestination(
            icon: Icon(Icons.history_outlined),
            selectedIcon: Icon(Icons.history),
            label: 'السجل',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'الإعدادات',
          ),
        ],
      ),
    );
  }
}