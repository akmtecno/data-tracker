import 'package:flutter/material.dart';
import '../models/app_usage.dart';
import '../services/database_helper.dart';
import '../services/firewall_service.dart';

class AppListScreen extends StatefulWidget {
  const AppListScreen({super.key});

  @override
  State<AppListScreen> createState() => _AppListScreenState();
}

class _AppListScreenState extends State<AppListScreen> {
  List<AppUsage> _apps = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps() async {
    // تحميل التطبيقات من قاعدة البيانات أو وضع عينات واقعية
    List<AppUsage> apps = await DatabaseHelper.instance.getAllApps();
    if (apps.isEmpty) {
      apps = [
        AppUsage(id: '1', appName: 'YouTube', packageName: 'com.google.android.youtube', wifiUsageMB: 1840.0, mobileUsageMB: 450.0),
        AppUsage(id: '2', appName: 'TikTok', packageName: 'com.zhiliaoapp.musically', wifiUsageMB: 1200.0, mobileUsageMB: 680.0),
        AppUsage(id: '3', appName: 'Instagram', packageName: 'com.instagram.android', wifiUsageMB: 850.0, mobileUsageMB: 320.0),
        AppUsage(id: '4', appName: 'Netflix', packageName: 'com.netflix.mediaclient', wifiUsageMB: 1400.0, mobileUsageMB: 50.0),
        AppUsage(id: '5', appName: 'WhatsApp', packageName: 'com.whatsapp', wifiUsageMB: 310.0, mobileUsageMB: 140.0),
        AppUsage(id: '6', appName: 'Telegram', packageName: 'org.telegram.messenger', wifiUsageMB: 280.0, mobileUsageMB: 90.0),
        AppUsage(id: '7', appName: 'Spotify', packageName: 'com.spotify.music', wifiUsageMB: 210.0, mobileUsageMB: 75.0),
        AppUsage(id: '8', appName: 'Chrome', packageName: 'com.android.chrome', wifiUsageMB: 190.0, mobileUsageMB: 110.0),
      ];
      for (var app in apps) {
        await DatabaseHelper.instance.insertOrUpdateApp(app);
      }
    }

    // فرز التطبيقات من الأكثر استهلاكاً إلى الأقل
    apps.sort((a, b) => b.totalUsageMB.compareTo(a.totalUsageMB));

    setState(() {
      _apps = apps;
      _isLoading = false;
    });
  }

  void _toggleBlock(AppUsage app) async {
    final updatedStatus = !app.isBlocked;
    setState(() {
      app.isBlocked = updatedStatus;
    });

    await DatabaseHelper.instance.updateAppBlockStatus(app.packageName, updatedStatus);

    // تحديث خدمة الجدار الناري المحلية
    final blockedList = _apps.where((a) => a.isBlocked).map((a) => a.packageName).toList();
    await FirewallService.startFirewall(blockedList);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updatedStatus
              ? 'تم حظر الإنترنت عن تطبيق ${app.appName}'
              : 'تم إلغاء حظر الإنترنت عن تطبيق ${app.appName}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredApps = _apps.where((app) {
      return app.appName.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('إحصائيات التطبيقات والجدار الناري'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'البحث عن تطبيق...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
                fillColor: Colors.grey.shade100,
              ),
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filteredApps.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final app = filteredApps[index];
                      final isBlocked = app.isBlocked;

                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isBlocked ? Colors.red.shade100 : Colors.teal.shade100,
                          child: Icon(
                            isBlocked ? Icons.block : Icons.apps,
                            color: isBlocked ? Colors.red : Colors.teal,
                          ),
                        ),
                        title: Text(
                          app.appName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: isBlocked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          'واي فاي: ${app.wifiUsageMB.toStringAsFixed(0)} MB | بيانات: ${app.mobileUsageMB.toStringAsFixed(0)} MB',
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  app.totalUsageMB >= 1024
                                      ? '${(app.totalUsageMB / 1024).toStringAsFixed(2)} GB'
                                      : '${app.totalUsageMB.toStringAsFixed(0)} MB',
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  isBlocked ? 'محظور' : 'متصل',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: isBlocked ? Colors.red : Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),
                            Switch(
                              value: isBlocked,
                              activeColor: Colors.red,
                              onChanged: (_) => _toggleBlock(app),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}