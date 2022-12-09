import 'package:copypaste/channels/android_channel.dart';
import 'package:copypaste/main.dart';
import 'package:copypaste/services/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:provider/provider.dart';

enum SettingsScreens {
  main,
  clipboard,
  notification,
  sync,
}

class SettingsScreen extends StatelessWidget {
  SettingsScreens currentScreen = SettingsScreens.main;

  Widget buildSettingsScreen(AppProvider appProvider) {
    List<Widget> settingsScreens = [
      buildMainScreen(appProvider),
      buildClipboardScreen(appProvider),
      device == DevicePlatform.android
          ? buildNotificationScreen(appProvider)
          : Container(),
      buildSyncScreen(appProvider),
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 4.0, right: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kClipRRectBorderRadius),
        child: Column(
          children: [
            IndexedStack(
              index: SettingsScreens.values.indexOf(currentScreen),
              children: settingsScreens,
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMainScreen(AppProvider appProvider) {
    return Container(
      decoration: kCardBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            onPressed: () {
              currentScreen = SettingsScreens.clipboard;
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
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 15.0,
                  right: 20.0,
                  bottom: 10.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Clipboard',
                    style: kCardDataTextStyle,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              width: double.infinity,
              height: 2.0,
              color: kCardDividerColor,
            ),
          ),
          if (device == DevicePlatform.android)
            TextButton(
              onPressed: () {
                currentScreen = SettingsScreens.notification;
                appProvider.justNotify();
              },
              style: TextButton.styleFrom(
                foregroundColor: kSwitchTrackColor,
                backgroundColor: kCardBackgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: device == DevicePlatform.android
                      ? BorderRadius.zero
                      : BorderRadius.only(
                          bottomLeft: Radius.circular(kCardBorderRadius),
                          bottomRight: Radius.circular(kCardBorderRadius),
                        ),
                ),
              ),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Notification',
                      style: kCardDataTextStyle,
                    ),
                  ),
                ),
              ),
            ),
          if (device == DevicePlatform.android)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Container(
                width: double.infinity,
                height: 2.0,
                color: kCardDividerColor,
              ),
            ),
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
                  bottomLeft: Radius.circular(kCardBorderRadius),
                  bottomRight: Radius.circular(kCardBorderRadius),
                ),
              ),
            ),
            child: Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 10.0,
                  right: 20.0,
                  bottom: 15.0,
                ),
                child: SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Manage Sync',
                    style: kCardDataTextStyle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildClipboardScreen(AppProvider appProvider) {
    return Container(
      decoration: kCardBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }

  Widget buildNotificationScreen(AppProvider appProvider) {
    return Container(
      decoration: kCardBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "New text as notification",
                  style: kCardDataTextStyle,
                ),
                CupertinoSwitch(
                  activeColor: kSwitchActiveColor,
                  trackColor: kSwitchTrackColor,
                  value: preferences!.getBool('as_notification')!,
                  onChanged: (value) async {
                    AndroidChannel.asNotification = value;
                    AndroidChannel.setNewDataAsNotificationMethod();
                    await preferences!.setBool('as_notification', value);
                    appProvider.justNotify();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSyncScreen(AppProvider appProvider) {
    return Container(
      decoration: kCardBoxDecoration,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: appProvider.getSyncDevices().length,
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Container(
              width: double.infinity,
              height: 2.0,
              color: kCardDividerColor,
            ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          String cloudDeviceName = appProvider.getSyncDevices()[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  cloudDeviceName,
                  style: kCardDataTextStyle,
                ),
                CupertinoSwitch(
                  activeColor: kSwitchActiveColor,
                  trackColor: kSwitchTrackColor,
                  value: preferences!.getBool('sync_$cloudDeviceName')!,
                  onChanged: (value) async {
                    await preferences!.setBool('sync_$cloudDeviceName', value);
                    appProvider.justNotify();
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }

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
            body: buildSettingsScreen(appProvider),
          ),
        );
      },
    );
  }
}
