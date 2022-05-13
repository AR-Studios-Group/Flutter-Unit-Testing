import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';

import 'package:testing/controllers/sqlController.dart';
import 'package:testing/models/Report.dart';

// https://dev-yakuza.posstree.com/en/flutter/widget/sqflite/#outline
// https://stackoverflow.com/questions/66685369/unit-testing-getxcontroller

class MockSqlController extends SqlController {
  @override
  Future<Database?> open() async {
    late Database? _database;
    try {
      _database = await openDatabase('../../assets/reportsDB.db', version: 1,
          onCreate: (Database _db, int _version) async {
        _db.execute('''
        CREATE TABLE Reports (
          create_date TEXT PRIMARY KEY, 
          device_name TEXT,
          userId TEXT, 
          phoneId TEXT, 
          alias TEXT, 
          installation_result TEXT
        )
      ''');
      });
    } catch (e) {
      _database = null;
    }
    return Future.value(_database);
  }
}

void main() {
  test("Initilization, checking value of constants and state variables",
      () async {
    // Arrange
    final db = MockSqlController();

    // Act

    // Assert
    expect(db.reports.isEmpty, true);
    expect(SqlController.tableName, 'Reports');

    // Not possible
    // expect(db.db, isInstanceOf<Database>());
  });

  test("Addition of a new item in the database", () async {
    // Arrange
    final report = Report("create_date", "device_name", "userId", "phoneId",
        "alias", "installation_result");
    final db = MockSqlController();

    // Act
    await db.add(report);

    // Assert
    expect(db.reports.length, 1);
  });

  group("Remove an item from the database", () {
    test("Remove - Success", () async {
      // Arrange
      final report = Report("create_date", "device_name", "userId", "phoneId",
          "alias", "installation_result");

      final db = MockSqlController();

      // Act
      await db.add(report);
      final res = await db.delete(report);

      // Assert
      expect(res, true);
      expect(db.reports.length, 0);
    });
  });
}

/* 
  Other database function can't be tested
  as those methods depend on performing database
  query to update the class state.
*/