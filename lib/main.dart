// import 'dart:io';

import 'package:copypaste/screens/home_screen.dart';
import 'package:copypaste/screens/login_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dart/firebase_dart.dart' as FirebaseDart;
import 'package:firebase_dart/auth.dart' as FirebaseDartAuth;
// import 'package:path_provider/path_provider.dart';

// import 'package:flutter/foundation.dart';
// import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:universal_platform/universal_platform.dart';
// import 'package:desktop_webview_window/desktop_webview_window.dart';
// import 'package:webview_dart/webview_dart.dart';

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

FirebaseDart.FirebaseApp? desktopApp;

// Webview? webView;

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
      options: FirebaseOptions(
        apiKey: apiKey,
        appId: appId,
        messagingSenderId: messagingSenderId,
        projectId: projectId,
      ),
    );
  } else if (desktop.contains(device)) {
    FirebaseDart.FirebaseDart.setup();

    desktopApp = await FirebaseDart.Firebase.initializeApp(
      name: "CopyPasteDesktop",
      options: FirebaseDart.FirebaseOptions(
          apiKey: apiKey,
          appId: appId,
          messagingSenderId: messagingSenderId,
          projectId: projectId),
    );

    // webView = await WebviewWindow.create(
    //   configuration: CreateConfiguration(
    //     windowHeight: 1280,
    //     windowWidth: 720,
    //     title: "CopyPaste",
    //     titleBarHeight: 50,
    //     titleBarTopPadding: 500,
    //     userDataFolderWindows: await _getWebViewPath(),
    //   ),
    // );

    // webView.launch('https://www.google.com/');
    // webView?.launch('https://iniyankanmani.github.io/copypaste_web/#/');
    // webView?.launch('https://flutter.github.io/samples/web/github_dataviz/');

    // Webview(false).navigate('https://iniyankanmani.github.io/copypaste_web/#/').run();
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
            FirebaseAuth.instance.currentUser?.getIdToken().then((value) {
              userToken = value;
              print('Firebase token: $userToken');
              return value;
            });
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        },
      );
    } else {
      return StreamBuilder<FirebaseDartAuth.User?>(
        stream: FirebaseDartAuth.FirebaseAuth.instanceFor(app: desktopApp!).authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            userEmail = FirebaseDartAuth.FirebaseAuth.instanceFor(app: desktopApp!).currentUser?.email;
            FirebaseDartAuth.FirebaseAuth.instanceFor(app: desktopApp!).currentUser?.getIdToken(false).then((value) {
              userToken = value;
              print('Firebase Desktop token: $userToken');
              return value;
            });
            return HomeScreen();
          } else {
            return LoginScreen();
          }
        }
      );
      // return Container(
      //   color: Colors.blue,
      //   child: ElevatedButton(
      //     onPressed: () {
      //       webView?.reload();
      //     },
      //     child: Container(),
      //   ),
      // );

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

// Future<String> _getWebViewPath() async {
//   final document = await getApplicationDocumentsDirectory();
//   return p.join(
//     document.path,
//     'desktop_webview_window',
//   );
// }
