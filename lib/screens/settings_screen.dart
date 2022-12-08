import 'package:copypaste/channels/android_channel.dart';
import 'package:copypaste/main.dart';
import 'package:copypaste/services/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:provider/provider.dart';

enum SettingsScreens {
  main,
  sync,
  asNotification,
}

class SettingsScreen extends StatelessWidget {
  int whichSettingsPage = 0;

  Widget settingsPage() {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      if (whichSettingsPage == 0) {
        return ListView(
          children: [
            ElevatedButton(
              child: const Text('Sync'),
              onPressed: () {
                whichSettingsPage = 1;
                appProvider.justNotify();
                // setState(() {});
              },
            ),
            if (device == DevicePlatform.android)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Text("Get new copied text as Notification"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: CupertinoSwitch(
                      value: preferences!.getBool('asNotification')!,
                      activeColor: kCardDeviceNameTextColor,
                      onChanged: (bool value) async {
                        AndroidChannel.asNotification = value;
                        AndroidChannel.setNewDataAsNotificationMethod();
                        preferences!.setBool('asNotification', value);
                        appProvider.justNotify();
                        // setState(() {});
                      },
                    ),
                  ),
                ],
              ),
          ],
        );
      } else if (whichSettingsPage == 1) {
        return ListView.builder(
          itemCount: appProvider.getSyncDevices().length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(appProvider.getSyncDevices()[index]),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: CupertinoSwitch(
                    value: preferences!.getBool(
                        'sync_${appProvider.getSyncDevices()[index]}')!,
                    activeColor: kCardDeviceNameTextColor,
                    onChanged: (bool value) async {
                      await preferences!.setBool(
                          'sync_${appProvider.getSyncDevices()[index]}', value);
                      appProvider.justNotify();
                      // setState(() {});
                    },
                  ),
                ),
              ],
            );
          },
        );
      }
      return Container();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarBackgroundColor,
        leading: Center(
          child: Icon(
            Icons.settings_rounded,
            color: kActiveIconColor,
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: kActiveIconColor,
          ),
        ),
      ),
      backgroundColor: kBodyBackgroundColor,
      body: settingsPage(),
    );
  }
}
