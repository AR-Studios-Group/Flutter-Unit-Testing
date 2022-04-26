import 'package:get/get.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

class BleController extends GetxController {
  final flutterReactiveBle = FlutterReactiveBle();
  var nearByDevices = <DiscoveredDevice>[].obs;

  void scanForDevices() {
    flutterReactiveBle.scanForDevices(withServices: []).listen((device) {},
        onError: (error) {
      print(error);
    });
  }

  void connectToDevice(DiscoveredDevice device) {
    flutterReactiveBle
        .connectToDevice(id: device.id)
        .listen((connectionState) {}, onError: (error) {
      print(error);
    });
  }
}
