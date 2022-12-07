import 'package:copypaste/main.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:copypaste/services/clipboard_manager.dart';
import 'package:flutter/cupertino.dart';

class DesktopClipboardListener extends ClipboardListener {
  BuildContext context;
  DesktopClipboardListener({required this.context});
  @override
  void onClipboardChanged() async {
    String currentClipboardData = await ClipboardManager.getCurrentClipboardData();
      if (currentClipboardData != ClipboardManager.lastDataFromDevice && currentClipboardData != ClipboardManager.lastDataFromCloud) {
        ClipboardManager.sendDataToCloud(
          context: context,
          newData: currentClipboardData,
          device: device!,
          deviceName: deviceModel!,
        );
        ClipboardManager.lastDataFromDevice = currentClipboardData;
      }
  }

  void addDesktopClipboardChangesListener() {
    if (!clipboardWatcher.hasListeners) {
      clipboardWatcher.addListener(this);
      clipboardWatcher.start();
    }
  }

  void removeDesktopClipboardChangesListener() {
    if (clipboardWatcher.hasListeners) {
      clipboardWatcher.removeListener(this);
      clipboardWatcher.stop();
    }
  }
}
