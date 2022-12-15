import 'dart:async';
import 'dart:convert';

import 'package:copypaste/channels/android_channel.dart';
import 'package:copypaste/services/copypaste_firestore.dart';
import 'package:copypaste/services/copypaste_provider.dart';
import 'package:copypaste/services/cloud_rest_api.dart';
import 'package:flutter/material.dart';
import 'package:copypaste/screens/home_screen.dart';
import 'package:copypaste/screens/login_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
String? deviceModel;
String? deviceName;
String? userEmail;
String? userToken;

SharedPreferences? preferences;

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
  preferences = await SharedPreferences.getInstance();
  if (UniversalPlatform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    device = DevicePlatform.android;
    deviceModel = androidInfo.model.toString().trim();
    if (!preferences!.containsKey('as_notification')) {
      await preferences!.setBool('as_notification', true);
    } else {
      AndroidChannel.asNotification = preferences!.getBool('as_notification');
    }
  } else if (UniversalPlatform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    device = DevicePlatform.ios;
    deviceModel = iosInfo.utsname.machine.toString().trim();
  } else if (UniversalPlatform.isWeb) {
    WebBrowserInfo webBrowserInfo = await deviceInfo.webBrowserInfo;
    device = DevicePlatform.web;
    deviceModel = webBrowserInfo.appCodeName;
  } else if (UniversalPlatform.isLinux) {
    LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
    device = DevicePlatform.linux;
    deviceModel = linuxInfo.name.toString().trim();
  } else if (UniversalPlatform.isWindows) {
    WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
    device = DevicePlatform.windows;
    deviceModel = windowsInfo.computerName.toString().trim();
  } else if (UniversalPlatform.isMacOS) {
    MacOsDeviceInfo macOsInfo = await deviceInfo.macOsInfo;
    device = DevicePlatform.macOS;
    deviceModel = macOsInfo.computerName.toString().trim();
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
  Stream? loadingScreenStream;
  StreamController<bool> controller = StreamController();

  Widget checkSignIn(context) {
    return StreamBuilder(
      stream: FirebaseAuthForAll.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          afterSignIn(context);
          return StreamBuilder(
              stream: controller.stream,
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.hasData && asyncSnapshot.data == true) {
                  return HomeScreen();
                }
                return const Center(
                  child: CircularProgressIndicator(),
                );
              });
        } else {
          return LoginScreen();
        }
      },
    );
  }

  Future afterSignIn(context) async {
    controller.sink.add(false);
    userEmail = FirebaseAuthForAll.instance.currentUser!.email;
    userToken = await FirebaseAuthForAll.instance.currentUser?.getIdToken();

    List<Map<String, String>> allDevices = [];
    String unParsedJson = await CloudRestAPI.getCloudDocuments(
      collection: 'devices',
    );

    var parsedJson = json.decode(unParsedJson);

    if (unParsedJson == '{}') {
      await FirestoreForAll.instance
          .collection('users')
          .doc(userEmail!)
          .collection('devices')
          .add({
        'name': deviceModel,
        'model': deviceModel,
        'platform': device.toString().split('.')[1]
      });
    } else {
      List docs = [];
      for (var doc in parsedJson['documents']) {
        String model = doc['fields']['model']['stringValue'];
        String name = doc['fields']['name']['stringValue'];
        String platform = doc['fields']['platform']['stringValue'];
        docs.add({'model': model, 'name': name, 'platform': platform});
      }

      if (!docs.any((element) => element['model'] == deviceModel)) {
        FirestoreForAll.instance
            .collection('users')
            .doc(userEmail!)
            .collection('devices')
            .add({
          'name': deviceModel,
          'model': deviceModel,
          'platform': device.toString().split('.')[1]
        });
      }

      for (Map dev in docs) {
        if (dev['model'] != deviceModel) {
          allDevices.add(dev as Map<String, String>);
        }
      }

      List<String> syncDevices = [];

      for (var dev in allDevices) {
        syncDevices.add(dev['model']!);
      }

      await preferences!.setStringList("devices", syncDevices);

      Provider.of<CopyPasteProvider>(context, listen: false)
          .setSyncDevices(syncDevices);

      for (String dev in syncDevices) {
        if (!preferences!.containsKey('sync_$dev')) {
          await preferences!.setBool('sync_$dev', true);
        }
      }
    }

    CopyPasteFirestore copyPasteFirestore = CopyPasteFirestore();
    copyPasteFirestore.listenToCloudChanges(context: context);

    controller.sink.add(true);
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => CopyPasteProvider(),
      child: MaterialApp(
        title: 'Copy Paste',
        debugShowCheckedModeBanner: false,
        home: SafeArea(
          child: checkSignIn(context),
        ),
      ),
    );
  }
}
