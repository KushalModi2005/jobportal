import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'package:path/path.dart' show join;

class DatabaseConfig {
  static Future<void> initialize() async {
    if (kIsWeb) {
      // Initialize database for web
      databaseFactory = databaseFactoryFfiWeb;
    } else if (Platform.isWindows) {
      // Initialize FFI for Windows
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  static Future<Database> openDb() async {
    if (kIsWeb) {
      return await databaseFactoryFfiWeb.openDatabase(
        'job_board.db',
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE jobs(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                companyName TEXT NOT NULL,
                jobTitle TEXT NOT NULL,
                jobDescription TEXT NOT NULL,
                createdAt TEXT NOT NULL
              )
            ''');
          },
        ),
      );
    } else if (Platform.isWindows) {
      return await databaseFactoryFfi.openDatabase(
        inMemoryDatabasePath,
        options: OpenDatabaseOptions(
          version: 1,
          onCreate: (db, version) async {
            await db.execute('''
              CREATE TABLE jobs(
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                companyName TEXT NOT NULL,
                jobTitle TEXT NOT NULL,
                jobDescription TEXT NOT NULL,
                createdAt TEXT NOT NULL
              )
            ''');
          },
        ),
      );
    } else {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'job_board.db');
      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE jobs(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              companyName TEXT NOT NULL,
              jobTitle TEXT NOT NULL,
              jobDescription TEXT NOT NULL,
              createdAt TEXT NOT NULL
            )
          ''');
        },
      );
    }
  }
}
