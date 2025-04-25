import 'package:sqflite/sqflite.dart';
import '../models/job.dart';
import 'database_config.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await DatabaseConfig.openDb();
    return _database!;
  }

  Future<int> createJob(Job job) async {
    final db = await instance.database;
    return await db.insert('jobs', job.toMap());
  }

  Future<List<Job>> getAllJobs() async {
    final db = await instance.database;
    final result = await db.query('jobs', orderBy: 'createdAt DESC');
    return result.map((map) => Job.fromMap(map)).toList();
  }

  Future<Job?> getJob(int id) async {
    final db = await instance.database;
    final maps = await db.query('jobs', where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Job.fromMap(maps.first);
    }
    return null;
  }

  Future<void> close() async {
    final db = await instance.database;
    await db.close();
  }
}
