
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'offline_reports.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE offline_reports (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        doctor_id TEXT NOT NULL,
        patient_name TEXT,
        alert_description TEXT,
        alert_type INTEGER,
        latitude REAL,
        longitude REAL,
        latitude_gps REAL,
        longitude_gps REAL,
        local_create_time TEXT,
        images TEXT,
        is_synced INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }


  Future<int> saveOfflineReport({
    required String doctorId,
    required String patientName,
    required String alertDescription,
    required int alertType,
    required double latitude,
    required double longitude,
    required double latitudeGps,
    required double longitudeGps,
    required String localCreateTime,
    List<File>? images,
  }) async {
    final db = await database;
   
    String imagesJson = '';
    if (images != null && images.isNotEmpty) {
      List<String> imagePaths = images.map((file) => file.path).toList();
      imagesJson = jsonEncode(imagePaths);
    }

    Map<String, dynamic> report = {
      'doctor_id': doctorId,
      'patient_name': patientName,
      'alert_description': alertDescription,
      'alert_type': alertType,
      'latitude': latitude,
      'longitude': longitude,
      'latitude_gps': latitudeGps,
      'longitude_gps': longitudeGps,
      'local_create_time': localCreateTime,
      'images': imagesJson,
      'is_synced': 0,
    };

    return await db.insert('offline_reports', report);
  }


  Future<List<Map<String, dynamic>>> getUnsyncedReports() async {
    final db = await database;
    return await db.query(
      'offline_reports',
      where: 'is_synced = ?',
      whereArgs: [0],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> markAsSynced(int reportId) async {
    final db = await database;
    await db.update(
      'offline_reports',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [reportId],
    );
  }


  Future<void> deleteSyncedReports() async {
    final db = await database;
    await db.delete(
      'offline_reports',
      where: 'is_synced = ?',
      whereArgs: [1],
    );
  }

  
  Future<int> getOfflineReportsCount() async {
    final db = await database;
    var result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM offline_reports WHERE is_synced = 0'
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }


  Future<void> deleteAllReports() async {
    final db = await database;
    await db.delete('offline_reports');
  }
}