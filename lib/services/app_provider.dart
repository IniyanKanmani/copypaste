import 'package:copypaste/main.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  // DevicePlatform? _device;
  // String? _deviceModel;
  // String? _deviceName;
  // String? _userEmail;
  // String? _userToken;

  List<String>? _syncDevices;
  // bool _changedDeviceSync = false;

  // DevicePlatform getDevice() => _device!;
  //
  // String getDeviceModel() => _deviceModel!;
  //
  // String getDeviceName() => _deviceName!;

  // String getUserEmail() => _userEmail!;
  //
  // String getUserToken() => _userToken!;
  //

  List<String> getSyncDevices() => _syncDevices!;
  // bool getChangedDeviceSync() => _changedDeviceSync;

  // void setDevice(device) {
  //   _device = device;
  //   notifyListeners();
  // }
  //
  // void setDeviceModel(deviceModel) {
  //   _deviceModel = deviceModel;
  //   notifyListeners();
  // }
  //
  // void setDeviceName(deviceName) {
  //   _deviceName = deviceName;
  //   notifyListeners();
  // }

  // void setUserEmail(userEmail) {
  //   _userEmail = userEmail;
  //   notifyListeners();
  // }
  //
  // void setUserToken(userToken) {
  //   _userToken = userToken;
  //   notifyListeners();
  // }
  //

  void setSyncDevices(syncDevices) {
    _syncDevices = syncDevices;
    notifyListeners();
  }

  // void setChangedDeviceSync(changedDeviceSync) {
  //   _changedDeviceSync = changedDeviceSync;
  //   notifyListeners();
  // }

  void justNotify() {
    notifyListeners();
  }
}
