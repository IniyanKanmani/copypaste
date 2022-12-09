import 'dart:async';
import 'package:copypaste/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:copypaste/constants/copied_data.dart';
import 'package:firebase_for_all/firebase_for_all.dart';

class ClipboardManager {
  static String lastDataFromCloud = "";
  static String lastDataFromDevice = "";

  static Future sendDataToCloud({
    required BuildContext context,
    required String newData,
    required DevicePlatform device,
    required String deviceName,
  }) async {
    if (lastDataFromCloud != newData) {
      CopiedData copiedData = CopiedData(
        data: newData,
        device: deviceName,
        time: DateTime.now(),
      );

      ColRef reference = FirestoreForAll.instance
          .collection('users')
          .doc(userEmail!)
          .collection("text");

      await reference.add(copiedData.toJson());
    }
  }

  static Future<String> getLastCloudData() async {
    QuerySnapshotForAll<Map<String, Object?>> snapshot = await FirestoreForAll
        .instance
        .collection("users")
        .doc(userEmail!)
        .collection("text")
        .get();

    List<DocumentSnapshotForAll<Map<String, dynamic>>> docs = snapshot.docs;

    docs.sort((b, a) => a["time"].compareTo(b["time"]));

    return docs[0]["data"];
  }

  static Future<void> setDataToClipboard({required String data}) async {
    Clipboard.setData(
      ClipboardData(
        text: data,
      ),
    );
  }

  static Future<String> getCurrentClipboardData() async {
    ClipboardData? clipboardData =
        await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData!.text!;
  }
}
