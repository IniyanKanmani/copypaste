import 'package:copypaste/main.dart';
import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:copypaste/services/clipboard_manager.dart';

class DesktopClipboardListener extends ClipboardListener {
  @override
  void onClipboardChanged() async {
    ClipboardManager.getCurrentClipboardData().then((value) {
      if (value != ClipboardManager.lastDataFromDevice) {
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
}
