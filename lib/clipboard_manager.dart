import 'dart:async';

// import 'package:clipboard/clipboard.dart';
// import 'package:clipboard_watcher/clipboard_watcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copypaste/copied_data.dart';
// import 'package:firedart/firedart.dart' as firedart;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'main.dart';

class ClipboardManager {
  static String lastDataFromCloud = "";

  static Future sendDataToCloud({
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

      if (mobileAndWeb.contains(device)) {
        CollectionReference reference = FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail!)
            .collection("text");

        await reference.add(copiedData.toJson());
      }
      // else {
      //   firedart.CollectionReference reference = firedart.Firestore.instance
      //       .collection("users")
      //       .document(userEmail!)
      //       .collection("text");
      //
      //   await reference.add(copiedData.toJson());
      // }
    }
  }

  static Future getDataFromCloud({
    required DevicePlatform device,
  }) async {
    if (mobileAndWeb.contains(device)) {
      CollectionReference copiedCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userEmail!)
          .collection("text");

      copiedCollection
          .orderBy("time", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((e) => CopiedData.fromJson(e.data() as Map<String, dynamic>))
              .toList())
          .listen(
        (event) async {
          debugPrint(event.last.toJson().toString());
          if (
              // await getCurrentDeviceData() != event.last.data &&
              lastDataFromCloud != event.first.data) {
            // print("Native to be called");
            // AndroidService.notifyNewDataFromCloudService(
            //   data: event.last.data,
            //   device: event.last.deviceName,
            // );
            lastDataFromCloud = event.first.data;
            // Clipboard.setData(
            //   ClipboardData(
            //     text: event.last.data,
            //   ),
            // );
          }
        },
      );
    }
    // else {
    //   firedart.CollectionReference copiedCollection = firedart
    //       .Firestore.instance
    //       .collection('users')
    //       .document(userEmail!)
    //       .collection("text");
    //   List<firedart.Document> cloudData = [];
    //   Timer.periodic(
    //     const Duration(seconds: 1),
    //         (timer) {
    //       Stream<firedart.Page<firedart.Document>> copiedStream =
    //       copiedCollection.get().asStream();
    //       copiedStream.listen(
    //             (event) async {
    //           List<firedart.Document> newCloudData = [];
    //           newCloudData = event.toList(growable: false);
    //           newCloudData
    //               .sort((a, b) => a.map["time"].compareTo(b.map["time"]));
    //
    //           if (cloudData.isNotEmpty) {
    //             if (newCloudData.last.map["data"] !=
    //                 cloudData.last.map["data"]) {
    //               String data = newCloudData.last.map["data"];
    //               await setDataToClipboard(data);
    //               cloudData = newCloudData;
    //             }
    //           } else {
    //             cloudData = newCloudData;
    //           }
    //         },
    //       );
    //     },
    //   );
    // }
  }

  static Future<void> setDataToClipboard({required String data}) async {
    // DataWriterItem writerItem = DataWriterItem();
    // writerItem.add(Formats.plainText(data));
    // await ClipboardWriter.instance.write([writerItem]);
    // ClipboardReader reader = await ClipboardReader.readClipboard();
    // if (reader.)
    // await FlutterClipboard.copy(data);
    // print("setDataToClipboard: $data");
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
    // String data = await FlutterClipboard.paste().then((value) => value);
    // return data;
  }

  static void listenToClipboardChanges(
      {required DevicePlatform device, required String deviceName}) async {
    // String recentCopiedData = await getCurrentClipboardData();
    // Timer.periodic(
    //   const Duration(seconds: 5),
    //   (timer) async {
    //     String newData = await getCurrentClipboardData();
    //     if (newData != recentCopiedData) {
    //       print("Copied by Timer: $newData");
    //       recentCopiedData = newData;
    //     }
    //   },
    // );
  }
}
