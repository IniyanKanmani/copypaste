import 'package:copypaste/constants/constants.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarBackgroundColor,
        shape: kAppBarShape,
        leading: Center(
          child: Icon(
            Icons.settings_rounded,
            color: kInActiveIconColor,
          ),
        ),
        title: Text(
          "Settings",
          style: TextStyle(
            color: kInActiveIconColor,
          ),
        ),
      ),
      backgroundColor: kBodyBackgroundColor,
    );
  }
}
