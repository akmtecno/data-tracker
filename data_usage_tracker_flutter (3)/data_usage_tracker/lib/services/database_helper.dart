import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/app_usage.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('data_usage_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // جدول إحصائيات التطبيقات
    await db.execute('''
      CREATE TABLE app_usage (
        id TEXT PRIMARY KEY,
        appName TEXT NOT NULL,
        packageName TEXT NOT NULL,
        wifiUsageMB REAL NOT NULL,
        mobileUsageMB REAL NOT NULL,
        isBlocked INTEGER NOT NULL
      )
    ''');

    // جدول السجل اليومي والتاريخي
    await db.execute('''
      CREATE TABLE daily_history (
        date TEXT PRIMARY KEY,
        wifiMB REAL NOT NULL,
        mobileMB REAL NOT NULL,
        dailyLimitMB REAL NOT NULL
      )
    ''');
  }

  Future<int> insertOrUpdateApp(AppUsage app) async {
    final db = await instance.database;
    return await db.insert(
      'app_usage',
      app.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<AppUsage>> getAllApps() async {
    final db = await instance.database;
    final result = await db.query('app_usage');
    return result.map((json) => AppUsage.fromMap(json)).toList();
  }

  Future<int> updateAppBlockStatus(String packageName, bool isBlocked) async {
    final db = await instance.database;
    return await db.update(
      'app_usage',
      {'isBlocked': isBlocked ? 1 : 0},
      where: 'packageName = ?',
      whereArgs: [packageName],
    );
  }

  Future<int> insertDailyHistory(DailyUsageRecord record) async {
    final db = await instance.database;
    return await db.insert(
      'daily_history',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<DailyUsageRecord>> getHistory() async {
    final db = await instance.database;
    final result = await db.query('daily_history', orderBy: 'date DESC');
    return result.map((json) => DailyUsageRecord.fromMap(json)).toList();
  }
}