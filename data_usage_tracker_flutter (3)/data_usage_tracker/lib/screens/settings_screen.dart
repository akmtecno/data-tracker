import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  final double currentDailyLimitGB;
  final ValueChanged<double> onLimitChanged;

  const SettingsScreen({
    super.key,
    required this.currentDailyLimitGB,
    required this.onLimitChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double _limit;
  bool _alertAt50 = true;
  bool _alertAt80 = true;
  bool _alertAt100 = true;

  @override
  void initState() {
    super.initState();
    _limit = widget.currentDailyLimitGB;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات التنبيه والحدود'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'الحد اليومي المسموح به (Daily Limit)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_limit.toStringAsFixed(1)} جيجابايت / يومياً',
                    style: const TextStyle(fontSize: 22, color: Colors.teal, fontWeight: FontWeight.bold),
                  ),
                  Slider(
                    value: _limit,
                    min: 1.0,
                    max: 20.0,
                    divisions: 38,
                    activeColor: Colors.teal,
                    label: '${_limit.toStringAsFixed(1)} GB',
                    onChanged: (val) {
                      setState(() {
                        _limit = val;
                      });
                      widget.onLimitChanged(val);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('تنبيه عند استهلاك 50%'),
                  subtitle: const Text('إشعار عندما تصل لنصف باقتك اليومية'),
                  value: _alertAt50,
                  activeColor: Colors.teal,
                  onChanged: (val) => setState(() => _alertAt50 = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('تنبيه عند استهلاك 80%'),
                  subtitle: const Text('إشعار تحذيري عند الاقتراب من نفاذ الباقة'),
                  value: _alertAt80,
                  activeColor: Colors.orange,
                  onChanged: (val) => setState(() => _alertAt80 = val),
                ),
                const Divider(height: 1),
                SwitchListTile(
                  title: const Text('تنبيه عند استهلاك 100%'),
                  subtitle: const Text('إشعار عند تجاوز الحد اليومي بالكامل'),
                  value: _alertAt100,
                  activeColor: Colors.red,
                  onChanged: (val) => setState(() => _alertAt100 = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}