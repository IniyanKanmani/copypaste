import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:copypaste/channels/android_channel.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:copypaste/main.dart';
import 'package:copypaste/screens/cloud_screen.dart';
import 'package:copypaste/screens/device_screen.dart';
import 'package:copypaste/screens/settings_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  TextEditingController copyTextController = TextEditingController();
  int currentIndex = 0;

  List<Widget> screens = [
    CloudScreen(),
    DeviceScreen(),
    SettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    onCreate();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        AndroidChannel.resumeBackgroundServiceMethod();
        break;
      case AppLifecycleState.resumed:
        AndroidChannel.pauseBackgroundServiceMethod();
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
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void onCreate() async {
    if (device == DevicePlatform.android) {
      AndroidChannel.requestBackgroundServiceMethod();
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
