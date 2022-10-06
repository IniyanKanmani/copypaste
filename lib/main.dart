import 'dart:io';

import 'package:copypaste/screens/home_screen.dart';
import 'package:copypaste/screens/login_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum DevicePlatform {
  android,
  ios,
  web,
  webLinux,
  webWindows,
  webMacOS,
  linux,
  windows,
  macOS,
}

DevicePlatform? device;
String? deviceName;
String? userEmail;

List<DevicePlatform> mobileAndWeb = [
  DevicePlatform.android,
  DevicePlatform.ios,
  DevicePlatform.web,
  DevicePlatform.webLinux,
  DevicePlatform.webWindows,
  DevicePlatform.webMacOS,
];

List<DevicePlatform> desktop = [
  DevicePlatform.linux,
  DevicePlatform.windows,
  DevicePlatform.macOS,
];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await onCreate();
  runApp(MyApp());
}

Future<void> onCreate() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    device = DevicePlatform.android;
    deviceName = androidInfo.model.toString().trim();
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    device = DevicePlatform.ios;
    deviceName = iosInfo.utsname.machine.toString().trim();
  } else if (kIsWeb) {
    if (kIsWeb) {
      print("Web");
    } else if (Platform.isLinux) {
      print("WebLinux");
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      device = DevicePlatform.webLinux;
      deviceName = linuxInfo.name.toString().trim();
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      device = DevicePlatform.webWindows;
      deviceName = windowsInfo.computerName.toString().trim();
    } else if (Platform.isMacOS) {
      MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
      device = DevicePlatform.webMacOS;
      deviceName = macOsInfo.computerName.toString().trim();
    }
  } else if (Platform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    device = DevicePlatform.linux;
    deviceName = linuxInfo.name.toString().trim();
  } else if (Platform.isWindows) {
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    device = DevicePlatform.windows;
    deviceName = windowsInfo.computerName.toString().trim();
  } else if (Platform.isMacOS) {
    MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
    device = DevicePlatform.macOS;
    deviceName = macOsInfo.computerName.toString().trim();
  }

  if (mobileAndWeb.contains(device)) {
    // await Firebase.initializeApp();
  }
  // else {
  //   firedart.Firestore.initialize(PROJECTID);
  //   firedart.FirebaseAuth.initialize(APIKEY, firedart.VolatileStore());
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   bool? loggedIn = prefs.getBool("loggedIn");
  //   if (loggedIn != null && loggedIn == true) {
  //     await firedart.FirebaseAuth.instance.signIn(
  //       prefs.getString("email")!,
  //       prefs.getString("password")!,
  //     );
  //   }
  // }
}

class MyApp extends StatelessWidget {
  Widget checkSignIn() {
    if (mobileAndWeb.contains(device)) {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userEmail = FirebaseAuth.instance.currentUser?.email;
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      );
    } else {
      return Container();
      // return StreamBuilder<bool>(
      //   stream: firedart.FirebaseAuth.instance.signInState,
      //   builder: (context, snapshot) {
      //     if (snapshot.hasData && snapshot.data == true) {
      //       SharedPreferences.getInstance().then((value) {
      //         userEmail = value.getString("email");
      //       });
      //       return HomeScreen();
      //     } else {
      //       return LoginScreen();
      //     }
      //   },
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Copy Paste',
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: checkSignIn(),
      ),
    );
  }
}
