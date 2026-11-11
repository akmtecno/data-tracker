import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class DashboardScreen extends StatelessWidget {
  final double wifiUsageMB;
  final double mobileUsageMB;
  final double dailyLimitMB;

  const DashboardScreen({
    super.key,
    required this.wifiUsageMB,
    required this.mobileUsageMB,
    required this.dailyLimitMB,
  });

  @override
  Widget build(BuildContext context) {
    final double totalUsageMB = wifiUsageMB + mobileUsageMB;
    final double percentage = (dailyLimitMB > 0)
        ? (totalUsageMB / dailyLimitMB).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('لوحة التحكم بالبيانات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة مؤشر الاستهلاك اليومي الدائري
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Column(
                  children: [
                    const Text(
                      'الاستهلاك الإجمالي اليومي',
                      style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 20),
                    CircularPercentIndicator(
                      radius: 95.0,
                      lineWidth: 14.0,
                      animation: true,
                      percent: percentage,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            totalUsageMB >= 1024
                                ? '${(totalUsageMB / 1024).toStringAsFixed(2)} GB'
                                : '${totalUsageMB.toStringAsFixed(0)} MB',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                          ),
                          Text(
                            'من أصل ${(dailyLimitMB / 1024).toStringAsFixed(1)} GB',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: percentage > 0.85
                          ? Colors.redAccent
                          : (percentage > 0.6 ? Colors.orangeAccent : Colors.teal),
                      backgroundColor: Colors.grey.shade200,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'تم استهلاك ${(percentage * 100).toStringAsFixed(1)}% من الحد المسموح به',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: percentage > 0.85 ? Colors.red : Colors.teal.shade800,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // تفصيل استهلاك الواي فاي وبيانات الهاتف
            Row(
              children: [
                Expanded(
                  child: _buildNetworkCard(
                    title: 'واي فاي (Wi-Fi)',
                    amount: wifiUsageMB >= 1024
                        ? '${(wifiUsageMB / 1024).toStringAsFixed(2)} GB'
                        : '${wifiUsageMB.toStringAsFixed(0)} MB',
                    icon: Icons.wifi,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildNetworkCard(
                    title: 'بيانات الهاتف',
                    amount: mobileUsageMB >= 1024
                        ? '${(mobileUsageMB / 1024).toStringAsFixed(2)} GB'
                        : '${mobileUsageMB.toStringAsFixed(0)} MB',
                    icon: Icons.signal_cellular_alt,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // نصائح التوفير وحالة الاتصال
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.shield_outlined, color: Colors.teal.shade700, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'الجدار الناري يعمل ومستعد لحظر التطبيقات المستهلكة في الخلفية.',
                      style: TextStyle(color: Colors.teal.shade900, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetworkCard({
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 6),
            Text(
              amount,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}