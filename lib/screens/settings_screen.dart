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
  listenClipboard,
}

class SettingsScreen extends StatelessWidget {
  int whichSettingsPage = 0;
  SettingsScreens currentScreen = SettingsScreens.main;

  // Widget settingsPage() {
  //     if (whichSettingsPage == 0) {
  //       return ListView(
  //         children: [
  //           ElevatedButton(
  //             child: const Text('Sync'),
  //             onPressed: () {
  //               whichSettingsPage = 1;
  //               appProvider.justNotify();
  //               // setState(() {});
  //             },
  //           ),
  //           if (device == DevicePlatform.android)
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const Padding(
  //                   padding: EdgeInsets.only(left: 15.0),
  //                   child: Text("Get new copied text as Notification"),
  //                 ),
  //                 Padding(
  //                   padding: const EdgeInsets.only(right: 15.0),
  //                   child: CupertinoSwitch(
  //                     value: preferences!.getBool('asNotification')!,
  //                     activeColor: kCardDeviceNameTextColor,
  //                     onChanged: (bool value) async {
  //                       AndroidChannel.asNotification = value;
  //                       AndroidChannel.setNewDataAsNotificationMethod();
  //                       preferences!.setBool('asNotification', value);
  //                       appProvider.justNotify();
  //                       // setState(() {});
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //         ],
  //       );
  //     } else if (whichSettingsPage == 1) {
  //       return ListView.builder(
  //         itemCount: appProvider.getSyncDevices().length,
  //         itemBuilder: (context, index) {
  //           return Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 15.0),
  //                 child: Text(appProvider.getSyncDevices()[index]),
  //               ),
  //               Padding(
  //                 padding: const EdgeInsets.only(right: 15.0),
  //                 child: CupertinoSwitch(
  //                   value: preferences!.getBool(
  //                       'sync_${appProvider.getSyncDevices()[index]}')!,
  //                   activeColor: kCardDeviceNameTextColor,
  //                   onChanged: (bool value) async {
  //                     await preferences!.setBool(
  //                         'sync_${appProvider.getSyncDevices()[index]}', value);
  //                     appProvider.justNotify();
  //                     // setState(() {});
  //                   },
  //                 ),
  //               ),
  //             ],
  //           );
  //         },
  //       );
  //     }
  //     return Container();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            if (currentScreen != SettingsScreens.main) {
              currentScreen = SettingsScreens.main;
              appProvider.justNotify();
              return false;
            }
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: kAppBarBackgroundColor,
              leadingWidth: currentScreen == SettingsScreens.main ? 0 : 40.0,
              leading: currentScreen == SettingsScreens.main
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: GestureDetector(
                        onTap: () {
                          currentScreen = SettingsScreens.main;
                          appProvider.justNotify();
                        },
                        child: Center(
                          child: Icon(
                            Icons.arrow_back_ios_rounded,
                            color: kActiveIconColor,
                          ),
                        ),
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
            body: Column(
              children: [
                if (currentScreen == SettingsScreens.main)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Container(
                      decoration: kCardBoxDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              currentScreen = SettingsScreens.sync;
                              appProvider.justNotify();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: kSwitchTrackColor,
                              backgroundColor: kCardBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(kCardBorderRadius),
                                  topRight: Radius.circular(kCardBorderRadius),
                                ),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Devices in Sync',
                                    style: kCardDataTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 28.0),
                            child: Container(
                              width: double.infinity,
                              height: 2.0,
                              color: kCardDividerColor,
                            ),
                          ),
                          if (device == DevicePlatform.android)
                            TextButton(
                              onPressed: () {
                                currentScreen = SettingsScreens.asNotification;
                                appProvider.justNotify();
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: kSwitchTrackColor,
                                backgroundColor: kCardBackgroundColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: device == DevicePlatform.android
                                      ? BorderRadius.zero
                                      : BorderRadius.only(
                                          bottomLeft: Radius.circular(
                                              kCardBorderRadius),
                                          bottomRight: Radius.circular(
                                              kCardBorderRadius),
                                        ),
                                ),
                              ),
                              child: Container(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 15.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: Text(
                                      'New copied text Notification',
                                      style: kCardDataTextStyle,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          if (device == DevicePlatform.android)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 28.0),
                              child: Container(
                                width: double.infinity,
                                height: 2.0,
                                color: kCardDividerColor,
                              ),
                            ),
                          TextButton(
                            onPressed: () {
                              currentScreen = SettingsScreens.listenClipboard;
                              appProvider.justNotify();
                            },
                            style: TextButton.styleFrom(
                              foregroundColor: kSwitchTrackColor,
                              backgroundColor: kCardBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  bottomLeft:
                                      Radius.circular(kCardBorderRadius),
                                  bottomRight:
                                      Radius.circular(kCardBorderRadius),
                                ),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 15.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Text(
                                    'Listen to Clipboard in Background',
                                    style: kCardDataTextStyle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
