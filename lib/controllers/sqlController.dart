import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/Report.dart';

class SqlController extends GetxController {
  Database? db;
  static const tableName = 'Reports';

  var reports = <Report>[].obs;

  Future<Database?> open() async {
    try {
      String path = join(await getDatabasesPath(), 'reportsDB.db');
      final database = await openDatabase(path, version: 1,
          onCreate: (Database _db, int _version) async {
        _db.execute('''
        CREATE TABLE $tableName (
          create_date TEXT PRIMARY KEY, 
          device_name TEXT,
          userId TEXT, 
          phoneId TEXT, 
          alias TEXT, 
          installation_result TEXT
        )
      ''');
      });
      return database;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<void> close() async {
    db?.close();
  }

  Future<bool> add(Report report) async {
    try {
      await db?.insert(tableName, report.toMap());
      reports.insert(0, report);
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<bool> delete(Report report) async {
    try {
      await db?.delete(tableName,
          where: 'create_date = ?', whereArgs: [report.create_date]);
      reports.remove(report);
      return true;
    } catch (err) {
      print(err);
      return false;
    }
  }

  Future<void> updateItem(Report report) async {
    try {
      int? res = await db!.update(tableName, report.toMap(),
          where: 'create_date = ?', whereArgs: [report.create_date]);
      print(res);
    } catch (err) {
      print(err);
    }
  }

  Future<void> readAll() async {
    try {
      reports.clear();
      var results = await db?.rawQuery('SELECT * FROM $tableName') ?? [];

      if (results.isNotEmpty) {
        for (var r in results) {
          var date = r['create_date'].toString();
          var deviceName = r['device_name'].toString();
          var userID = r['userId'].toString();
          var phoneID = r['phoneId'].toString();
          var alias = r['alias'].toString();
          var installationResult = r['installation_result'].toString();

          reports.insert(
              0,
              Report(date, deviceName, userID, phoneID, alias,
                  installationResult));
        }
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  void onInit() async {
    db = await open();
    super.onInit();
  }

  @override
  void onClose() async {
    close();
    super.onClose();
  }
}
