import 'package:copypaste/channels/android_channel.dart';
import 'package:copypaste/main.dart';
import 'package:copypaste/services/copypaste_provider.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
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
  double settingsVerticalPaddingValue = mobile.contains(device) ? 5.0 : 10.0;
  double settingsHorizontalPaddingValue = 10.0;
  double settingsDividerHorizontalPaddingValue = 71.0;

  Widget buildSettingsScreen(CopyPasteProvider copyPasteProvider) {
    List<Widget> settingsScreens = [
      buildMainScreen(copyPasteProvider),
      buildClipboardScreen(copyPasteProvider),
      device == DevicePlatform.android
          ? buildNotificationScreen(copyPasteProvider)
          : Container(),
      buildSyncScreen(copyPasteProvider),
    ];
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, top: 4.0, right: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kClipRRectBorderRadius),
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
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

  Widget buildMainScreen(CopyPasteProvider copyPasteProvider) {
    return Column(
      children: [
        Container(
          decoration: kCardBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  currentScreen = SettingsScreens.clipboard;
                  copyPasteProvider.justNotify();
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
                    padding: EdgeInsets.symmetric(
                      vertical: settingsVerticalPaddingValue,
                      horizontal: settingsHorizontalPaddingValue,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF5196E3),
                              borderRadius: BorderRadius.circular(10.0),
                              // shape: BoxShape.,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.notes_rounded,
                                color: kCardDataTextColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Clipboard',
                            style: kCardDataTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: settingsDividerHorizontalPaddingValue, right: 28.0),
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
                    copyPasteProvider.justNotify();
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
                      padding: EdgeInsets.symmetric(
                        vertical: settingsVerticalPaddingValue,
                        horizontal: settingsHorizontalPaddingValue,
                      ),
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Color(0xFF8A83E6),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.notifications_rounded,
                                  color: kCardDataTextColor,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            Text(
                              'Notification',
                              style: kCardDataTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (device == DevicePlatform.android)
                Padding(
                  padding: EdgeInsets.only(
                      left: settingsDividerHorizontalPaddingValue, right: 28.0),
                  child: Container(
                    width: double.infinity,
                    height: 2.0,
                    color: kCardDividerColor,
                  ),
                ),
              TextButton(
                onPressed: () {
                  currentScreen = SettingsScreens.sync;
                  copyPasteProvider.justNotify();
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
                    padding: EdgeInsets.symmetric(
                      vertical: settingsVerticalPaddingValue,
                      horizontal: settingsHorizontalPaddingValue,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF94C421),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.sync_rounded,
                                color: kCardDataTextColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Manage sync',
                            style: kCardDataTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Container(
          decoration: kCardBoxDecoration,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  currentScreen = SettingsScreens.clipboard;
                  copyPasteProvider.justNotify();
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
                    padding: EdgeInsets.symmetric(
                      vertical: settingsVerticalPaddingValue,
                      horizontal: settingsHorizontalPaddingValue,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFDC6F8E),
                              borderRadius: BorderRadius.circular(10.0),
                              // shape: BoxShape.,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                mobile.contains(device)
                                    ? Icons.phone_iphone_rounded
                                    : Icons.laptop_mac_rounded,
                                color: kCardDataTextColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'This device',
                            style: kCardDataTextStyle,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: settingsDividerHorizontalPaddingValue, right: 28.0),
                child: Container(
                  width: double.infinity,
                  height: 2.0,
                  color: kCardDividerColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  copyPasteProvider.setCloudDocs([]);
                  FirebaseAuthForAll.instance.signOut();
                  copyPasteProvider.justNotify();
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
                    padding: EdgeInsets.symmetric(
                      vertical: settingsVerticalPaddingValue,
                      horizontal: settingsHorizontalPaddingValue,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF2BB2CF),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Icons.sync_rounded,
                                color: kCardDataTextColor,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20.0,
                          ),
                          Text(
                            'Logout',
                            style:
                                kCardDataTextStyle.copyWith(color: Colors.red.shade400),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildClipboardScreen(CopyPasteProvider copyPasteProvider) {
    return Container(
      decoration: kCardBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [],
      ),
    );
  }

  Widget buildNotificationScreen(CopyPasteProvider copyPasteProvider) {
    return Container(
      decoration: kCardBoxDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
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
                    copyPasteProvider.justNotify();
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildSyncScreen(CopyPasteProvider copyPasteProvider) {
    return Container(
      decoration: kCardBoxDecoration,
      child: ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: const BouncingScrollPhysics(),
        itemCount: copyPasteProvider.getSyncDevices().length,
        separatorBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Container(
              width: double.infinity,
              height: 2.0,
              color: kCardDividerColor,
            ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          String cloudDeviceName = copyPasteProvider.getSyncDevices()[index];
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 28.0, vertical: 10.0),
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
                    copyPasteProvider.justNotify();
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
    return Consumer<CopyPasteProvider>(
      builder: (context, copyPasteProvider, child) {
        return WillPopScope(
          onWillPop: () async {
            if (currentScreen != SettingsScreens.main) {
              currentScreen = SettingsScreens.main;
              copyPasteProvider.justNotify();
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
                          copyPasteProvider.justNotify();
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
            body: buildSettingsScreen(copyPasteProvider),
          ),
        );
      },
    );
  }
}
