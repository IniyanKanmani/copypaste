import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  List<String>? _syncDevices;

  void justNotify() {
    notifyListeners();
  }

  List<String> getSyncDevices() => _syncDevices!;

  void setSyncDevices(syncDevices) {
    _syncDevices = syncDevices;
    notifyListeners();
  }
}
