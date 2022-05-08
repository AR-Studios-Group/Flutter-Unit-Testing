import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sqlController.dart';
import '../models/Report.dart';

class Home extends StatelessWidget {
  final SqlController dbController = Get.put(SqlController());

  Home({Key? key}) : super(key: key);

  var reports = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Wiget Testing"),
            TextButton(
                key: Key("add button"),
                onPressed: () async {
                  DateTime _now = DateTime.now();

                  var creationTime =
                      '${_now.hour}:${_now.minute}:${_now.second}.${_now.millisecond}';

                  var r = Report(creationTime, "device_name", "userId",
                      "phoneId", "alias", "installation_result");

                  await dbController.add(r);
                },
                child: const Text('Add')),
            TextButton(
                key: Key("read all"),
                onPressed: () async {
                  await dbController.readAll();
                  print(dbController.reports.length);
                },
                child: const Text('Read All')),
          ],
        ),
      ),
    );
  }
}
