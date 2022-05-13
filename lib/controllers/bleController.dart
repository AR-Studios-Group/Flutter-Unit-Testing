import 'package:get/get.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:mockito/mockito.dart';

class MockDiscoverDevice extends Mock implements DiscoveredDevice {
  @override
  int get rssi => 43;

  @override
  String get name => "device name";

  @override
  String get id => "f7826da6-4fa2-4e98-8024-bc5b71e0893e";
}

class BleController extends GetxController {
  final flutterReactiveBle = FlutterReactiveBle();
  var nearByDevices = <DiscoveredDevice>[].obs;

  void scanForDevices() {
    final _device1 = MockDiscoverDevice();

    nearByDevices.add(_device1);
  }

  void connectToDevice(DiscoveredDevice device) {
    flutterReactiveBle.connectToDevice(id: device.id).listen((connectionState) {
      print(device.name);
      print(connectionState.connectionState);
    }, onError: (error) {
      print(error);
    });
  }
}
