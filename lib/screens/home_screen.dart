import 'package:copypaste/main.dart';
import 'package:copypaste/services/clipboard_manager.dart';
import 'package:copypaste/services/desktop_clipboard_listener.dart';
import 'package:flutter/material.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:copypaste/screens/cloud_screen.dart';
import 'package:copypaste/screens/device_screen.dart';
import 'package:copypaste/screens/settings_screen.dart';
import 'package:copypaste/channels/android_channel.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int currentIndex = 0;
  DesktopClipboardListener? desktopClipboardListener;
  bool asNotifications = true;

  List<Widget> screens = [
    CloudScreen(),
    DeviceScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    onCreate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        if (device == DevicePlatform.android) {
          AndroidChannel.resumeBackgroundServiceMethod();
        }
        break;
      case AppLifecycleState.resumed:
        if (device == DevicePlatform.android) {
          AndroidChannel.pauseBackgroundServiceMethod();
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    onDestroy();
    super.dispose();
  }

  void onCreate() async {
    WidgetsBinding.instance.addObserver(this);

    try {
      ClipboardManager.lastDataFromDevice =
      await ClipboardManager.getCurrentClipboardData();
      ClipboardManager.lastDataFromCloud =
      await ClipboardManager.getLastCloudData();
    } catch (e) {}

    if (device == DevicePlatform.android) {
      AndroidChannel.setEmailAndDeviceMethod();
      AndroidChannel.setNewDataAsNotificationMethod();
      AndroidChannel.requestBackgroundServiceMethod();
    } else if (desktop.contains(device)) {
      desktopClipboardListener = DesktopClipboardListener(context: context);
      desktopClipboardListener!.addDesktopClipboardChangesListener();
    }
  }

  void onDestroy() {
    WidgetsBinding.instance.removeObserver(this);
    if (desktop.contains(device)) {
      desktopClipboardListener!.removeDesktopClipboardChangesListener();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBodyBackgroundColor,
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        activeIndex: currentIndex,
        backgroundColor: kAppBarBackgroundColor,
        activeColor: kActiveIconColor,
        inactiveColor: kInActiveIconColor,
        splashSpeedInMilliseconds: 0,
        leftCornerRadius: 15.0,
        rightCornerRadius: 15.0,
        gapLocation: GapLocation.none,
        notchSmoothness: NotchSmoothness.defaultEdge,
        onTap: (index) {
          currentIndex = index;
          setState(() {});
        },
        icons: [
          currentIndex != 0 ? Icons.cloud_queue_rounded : Icons.cloud_rounded,
          currentIndex != 1 ? Icons.notes_outlined : Icons.notes_rounded,
          currentIndex != 2 ? Icons.settings_outlined : Icons.settings_rounded,
        ],
      ),
    );
  }
}
