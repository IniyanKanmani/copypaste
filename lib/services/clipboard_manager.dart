import 'dart:async';
import 'package:copypaste/main.dart';
import 'package:flutter/services.dart';
import 'package:copypaste/constants/copied_data.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:copypaste/services/desktop_clipboard_listener.dart';

class ClipboardManager {
  static String lastDataFromCloud = "";
  static String lastDataFromDevice = "";

  static Future sendDataToCloud({
    required String newData,
    required DevicePlatform device,
    required String deviceName,
  }) async {
    if (lastDataFromCloud != newData) {
      CopiedData copiedData = CopiedData(
        data: newData,
        device: deviceName,
        time: DateTime.now(),
      );

      ColRef reference = FirestoreForAll.instance
          .collection('users')
          .doc(userEmail!)
          .collection("text");

      await reference.add(copiedData.toJson());
    }
  }

  static Future<void> setDataToClipboard({required String data}) async {
    Clipboard.setData(
      ClipboardData(
        text: data,
      ),
    );
  }

  static Future<String> getCurrentClipboardData() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData!.text!;
  }

  static void listenToClipboardChanges(
      {required DevicePlatform device, required String deviceName}) async {
    if (!clipboardWatcher.hasListeners) {
      clipboardWatcher.addListener(DesktopClipboardListener());
      clipboardWatcher.start();
    }
  }
}
