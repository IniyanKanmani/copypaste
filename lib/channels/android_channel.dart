import 'package:copypaste/main.dart';
import 'package:flutter/services.dart';

class AndroidChannel {
  static MethodChannel platform = const MethodChannel("background_service");
  static bool? asNotification;

  static setEmailAndDeviceMethod() async {
    await platform.invokeMethod(
      "setEmailAndDevice",
      {
        "userEmail": userEmail,
        "deviceName": deviceModel,
      },
    );
  }

  static setNewDataAsNotificationMethod() async {
    await platform.invokeMethod(
      "setNewDataAsNotification",
      {
        "asNotification": asNotification,
      },
    );
  }

  static requestBackgroundServiceMethod() async {
    await platform.invokeMethod("backgroundService");
  }

  static pauseBackgroundServiceMethod() async {
    await platform.invokeMethod("stopBackgroundService");
  }

  static resumeBackgroundServiceMethod() async {
    await platform.invokeMethod("resumeBackgroundService");
  }
}
