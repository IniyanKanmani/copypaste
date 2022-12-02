import 'package:copypaste/main.dart';
import 'package:flutter/services.dart';

class AndroidChannel {
  static MethodChannel platform = const MethodChannel("background_service");

  static void requestBackgroundServiceMethod() async {
    await platform.invokeMethod(
      "backgroundService",
      {
        "deviceName": deviceName,
        "userEmail": userEmail,
      },
    );
  }

  static void pauseBackgroundServiceMethod() async {
    await platform.invokeMethod("stopBackgroundService");
  }

  static void resumeBackgroundServiceMethod() async {
    await platform.invokeMethod("resumeBackgroundService");
  }

  static void setNewDataAsNotificationMethod({asNotification = true}) async {
    await platform.invokeMethod(
      "setNewDataAsNotification",
      {
        "asNotification": asNotification,
      },
    );
  }
}
