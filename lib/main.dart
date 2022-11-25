// import 'dart:io';

import 'package:copypaste/screens/home_screen.dart';
import 'package:copypaste/screens/login_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';

enum DevicePlatform {
  android,
  ios,
  web,
  linux,
  windows,
  macOS,
}

DevicePlatform? device;
String? deviceName;
String? userEmail;

List<DevicePlatform> mobile = [
  DevicePlatform.android,
  DevicePlatform.ios,
];

List<DevicePlatform> web = [
  DevicePlatform.web,
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
  if (UniversalPlatform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    device = DevicePlatform.android;
    deviceName = androidInfo.model.toString().trim();
  } else if (UniversalPlatform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    device = DevicePlatform.ios;
    deviceName = iosInfo.utsname.machine.toString().trim();
  } else if (UniversalPlatform.isWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    device = DevicePlatform.web;
    deviceName = webBrowserInfo.appCodeName;
  } else if (UniversalPlatform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    device = DevicePlatform.linux;
    deviceName = linuxInfo.name.toString().trim();
  } else if (UniversalPlatform.isWindows) {
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    device = DevicePlatform.windows;
    deviceName = windowsInfo.computerName.toString().trim();
  } else if (UniversalPlatform.isMacOS) {
    MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
    device = DevicePlatform.macOS;
    deviceName = macOsInfo.computerName.toString().trim();
  }

  if (mobile.contains(device)) {
    await Firebase.initializeApp();
  } else if (web.contains(device)) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCeIRVm7445etJK1CK5RsvM8YlpEzl1yY0",
        appId: "1:89175436933:web:0771afeae9ba11ba1403ec",
        messagingSenderId: "89175436933",
        projectId: "copypaste-85843",
      ),
    );
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
    if (mobile.contains(device) || web.contains(device)) {
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
