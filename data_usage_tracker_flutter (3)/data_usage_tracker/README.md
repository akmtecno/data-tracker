# متتبع ومدير استهلاك البيانات (Data Usage Tracker & Manager)

تطبيق متكامل مبني باستخدام إطار العمل **Flutter** و **Dart** مع دعم خدمة **VpnService** المحلية كجدار ناري، وقاعدة بيانات **SQLite** محلية.

---

## 🚀 خطوات الربط مع مستودع GitHub الخاص بك

لرفع المشروع وتفعيل التجميع الآلي لملفات APK و AAB عبر GitHub Actions:

1. أنشئ مستودعاً جديداً (New Repository) فارغاً على حسابك في GitHub (مثلاً: `data-usage-tracker`).
2. افتح موجه الأوامر (Terminal) داخل مجلد المشروع، ونفذ الأوامر التالية:

```bash
# تهيئة المستودع المحلي
git init
git add .
git commit -m "الإصدار الأول: متتبع استهلاك البيانات والجدار الناري"

# ربط المستودع بحسابك على GitHub (استبدل الرابط برابط مستودعك)
git remote add origin https://github.com/USERNAME/data-usage-tracker.git

# رفع الكود وتفعيل البناء الآلي
git branch -M main
git push -u origin main
```

3. بعد الرفع، انتقل إلى تبويب **Actions** في صفحة مستودعك على GitHub، ستجد أن التجميع بدأ تلقائياً، وبعد حوالي 3 دقائق ستتمكن من تنزيل:
   - ملف التجربة المباشرة: `app-release.apk`
   - ملف الرفع لمتجر جوجل بلاي: `app-release.aab`

---

## 📁 هيكلية المشروع
- `lib/main.dart`: نقطة الدخول وتهيئة الإشعارات وشريط التنقل الرئيسي.
- `lib/screens/dashboard_screen.dart`: لوحة المراقبة اليومية والرسوم الدائرية.
- `lib/screens/app_list_screen.dart`: قائمة التطبيقات مع أزرار الجدار الناري للحظر.
- `lib/screens/history_screen.dart`: شاشة السجل التاريخي وقاعدة البيانات.
- `lib/screens/settings_screen.dart`: ضبط الحد اليومي وإشعارات 50%، 80%، 100%.
- `lib/services/database_helper.dart`: إدارة SQLite لحفظ السجل والبيانات.
- `lib/services/notification_service.dart`: جدولة وإرسال التنبيهات.
- `android/app/src/main/kotlin/.../LocalVpnService.kt`: الجدار الناري لحظر التطبيقات.
- `.github/workflows/build.yml`: ملف سير العمل لأتمتة تجميع APK و AAB.
- `google_play/store_listing.md`: دليل وحزمة الرفع لمتجر Google Play.