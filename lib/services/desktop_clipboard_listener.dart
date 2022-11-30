import 'package:copypaste/main.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:copypaste/services/clipboard_manager.dart';

class DesktopClipboardListener extends ClipboardListener {
  @override
  void onClipboardChanged() async {
    ClipboardManager.getCurrentClipboardData().then((value) async {
      print("He is in here with value: $value");
      if (value != ClipboardManager.lastDataFromDevice && value != ClipboardManager.lastDataFromCloud) {
        ClipboardManager.sendDataToCloud(
          newData: value,
          device: device!,
          deviceName: deviceName!,
        );
        ClipboardManager.lastDataFromDevice = value;
      }
      return value;
    });
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
