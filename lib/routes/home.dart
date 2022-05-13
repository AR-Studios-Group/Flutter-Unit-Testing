import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/bleController.dart';
import '../controllers/sqlController.dart';

class Home extends StatelessWidget {
  final SqlController dbController = Get.put(SqlController());
  final BleController bleController = Get.put(BleController());

  Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  bleController.scanForDevices();
                },
                child: const Text("Search Devices")),
            TextButton(
                onPressed: () {
                  bleController.connectToDevice(bleController.nearByDevices[0]);
                },
                child: const Text("Connect to Device"))
          ],
        ),
      ),
    );
  }
}
