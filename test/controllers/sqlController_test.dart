import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:testing/controllers/sqlController.dart';
import 'package:testing/models/Report.dart';

// In the project directory create a folder assets
// and inside the folder create a file reportsDB.db

// https://dev-yakuza.posstree.com/en/flutter/widget/sqflite/#outline

class MockSqlController extends SqlController {
  @override
  Future<Database?> open() async {
    try {
      final database =
          await databaseFactoryFfi.openDatabase('../../../assets/reportsDB.db');
      database.execute('''
        CREATE TABLE Reports (
          create_date TEXT PRIMARY KEY, 
          device_name TEXT,
          userId TEXT, 
          phoneId TEXT, 
          alias TEXT, 
          installation_result TEXT
        )
        ''');
      print(db);
      return database;
    } catch (err) {
      print(err);
      return null;
    }
  }
}

void main() {
  sqfliteFfiInit();

  setUp(() {
    File(join('assets', 'reportsDB.db'))
        .copySync(join('assets', 'reportsDB.db'));
  });

  test("SQL Database Initization", () async {
    // Checking if the opening and closing of the database
    final db = await MockSqlController();

    expect(db.reports.isEmpty, true);

    await db.close();

    expect(db.db, null);
  });

  test("Adding item to DB", () async {
    final db = MockSqlController();

    final r = Report("create_date", "device_name", "userId", "phoneId", "alias",
        "installation_result");

    await db.add(r);

    expect(db.reports[0], r);
  });

  test("Removing an item", () async {
    final db = MockSqlController();

    final r = Report("create_date", "device_name", "userId", "phoneId", "alias",
        "installation_result");

    await db.add(r);
    await db.delete(r);

    expect(db.reports.isEmpty, true);
  });

  test("Read items in the database", () async {
    final db = MockSqlController();

    final r = Report("create_date", "device_name", "userId", "phoneId", "alias",
        "installation_result");

    await db.add(r);
    await db.add(r);

    db.readAll();

    print(db.reports);

    expect(db.reports.length, 2);
  });

  test("Update item in the database", () async {
    final db = MockSqlController();

    final r = Report("create_date", "device_name", "userId", "phoneId", "alias",
        "installation_result");

    final r2 = Report("create_date", "DEVICE NAME", "userId", "phoneId",
        "alias", "installation_result");

    await db.updateItem(r2);
  });
}
