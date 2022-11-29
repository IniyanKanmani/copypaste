import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:copypaste/clipboard_manager.dart';
import 'package:copypaste/main.dart';

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
