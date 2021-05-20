import 'dart:io';

import 'package:device_id/device_id.dart';

class CommonDataSource {
  static final CommonDataSource _instance = CommonDataSource.internal();

  factory CommonDataSource() => _instance;

  CommonDataSource.internal();

  static CommonDataSource get() => _instance;

  String deviceId;
  String deviceName;

  Future<void> getDeviceDetails() async {
    deviceId = await DeviceId.getID;
    deviceName = Platform.isIOS ? "IOS" : "Android";
  }
}
