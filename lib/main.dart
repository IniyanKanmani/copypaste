import 'package:flutter/material.dart';
import 'package:copypaste/screens/home_screen.dart';
import 'package:copypaste/screens/login_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

enum DevicePlatform {
  android,
  ios,
  web,
  linux,
  windows,
  macOS,
}

String apiKey = "AIzaSyCeIRVm7445etJK1CK5RsvM8YlpEzl1yY0";
String appId = "1:89175436933:web:0771afeae9ba11ba1403ec";
String messagingSenderId = "89175436933";
String projectId = "copypaste-85843";

DevicePlatform? device;
String? deviceName;
String? userEmail;
String? userToken;

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

  FirebaseOptions options = FirebaseOptions(
    apiKey: apiKey,
    appId: appId,
    messagingSenderId: messagingSenderId,
    projectId: projectId,
  );

  try {
    await FirebaseCoreForAll.initializeApp(
      options: options,
      firestore: true,
      auth: true,
      storage: false,
    );
  } catch (e) {
    print(e);
    print("Default was already Created");
    await FirebaseCoreForAll.initializeApp(
      name: "Copy Paste",
      options: options,
      firestore: true,
      auth: true,
      storage: false,
    );
  }
}

class MyApp extends StatelessWidget {
  Widget checkSignIn() {
    return StreamBuilder(
      stream: FirebaseAuthForAll.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          userEmail = FirebaseAuthForAll.instance.currentUser!.email;
          FirebaseAuthForAll.instance.currentUser?.getIdToken().then(
                (value) {
              userToken = value;
              return value;
            },
          );
          return HomeScreen();
        } else {
          return LoginScreen();
        }
      },
    );
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
