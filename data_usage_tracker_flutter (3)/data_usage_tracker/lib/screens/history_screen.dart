import 'package:flutter/material.dart';
import '../models/app_usage.dart';
import '../services/database_helper.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<DailyUsageRecord> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    var records = await DatabaseHelper.instance.getHistory();
    if (records.isEmpty) {
      records = [
        DailyUsageRecord(date: '2026-11-10', wifiMB: 2450, mobileMB: 650, dailyLimitMB: 5120),
        DailyUsageRecord(date: '2026-11-09', wifiMB: 1980, mobileMB: 820, dailyLimitMB: 5120),
        DailyUsageRecord(date: '2026-11-08', wifiMB: 3100, mobileMB: 400, dailyLimitMB: 5120),
        DailyUsageRecord(date: '2026-11-07', wifiMB: 1750, mobileMB: 1100, dailyLimitMB: 5120),
        DailyUsageRecord(date: '2026-11-06', wifiMB: 2800, mobileMB: 530, dailyLimitMB: 5120),
        DailyUsageRecord(date: '2026-11-05', wifiMB: 2150, mobileMB: 710, dailyLimitMB: 5120),
      ];
      for (var r in records) {
        await DatabaseHelper.instance.insertDailyHistory(r);
      }
    }

    setState(() {
      _history = records;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل الاستهلاك الزمني'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                final totalGB = item.totalMB / 1024;
                final limitGB = item.dailyLimitMB / 1024;
                final isExceeded = item.totalMB > item.dailyLimitMB;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item.date,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: isExceeded ? Colors.red.shade100 : Colors.teal.shade100,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                isExceeded ? 'تجاوز الحد' : 'ضمن الحد',
                                style: TextStyle(
                                  color: isExceeded ? Colors.red.shade900 : Colors.teal.shade900,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        LinearProgressIndicator(
                          value: (item.totalMB / item.dailyLimitMB).clamp(0.0, 1.0),
                          backgroundColor: Colors.grey.shade200,
                          color: isExceeded ? Colors.red : Colors.teal,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('الإجمالي: ${totalGB.toStringAsFixed(2)} GB من أصل ${limitGB.toStringAsFixed(1)} GB'),
                            Text('واي فاي: ${(item.wifiMB / 1024).toStringAsFixed(1)} GB | بيانات: ${(item.mobileMB / 1024).toStringAsFixed(1)} GB', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}