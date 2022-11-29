import 'package:copypaste/main.dart';
import 'package:flutter/material.dart';
import 'package:copypaste/services/clipboard_manager.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:firebase_for_all/firebase_for_all.dart';

class CloudScreen extends StatefulWidget {
  @override
  State<CloudScreen> createState() => _CloudScreenState();
}

class _CloudScreenState extends State<CloudScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarBackgroundColor,
        shape: kAppBarShape,
        leading: Center(
          child: Icon(
            Icons.cloud_rounded,
            color: kInActiveIconColor,
          ),
        ),
        title: Text(
          "Cloud Data",
          style: TextStyle(
            color: kInActiveIconColor,
          ),
        ),
      ),
      backgroundColor: kBodyBackgroundColor,
      body: CollectionBuilder(
        stream: FirestoreForAll.instance
            .collection("users")
            .doc(userEmail!)
            .collection("text")
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshotForAll> snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              List<DocumentSnapshotForAll<Map<String, dynamic>>>? docs =
                  snapshot.data?.docs
                      as List<DocumentSnapshotForAll<Map<String, dynamic>>>;

              docs.sort((b, a) => a["time"].compareTo(b["time"]));
              docs.removeWhere(
                (element) {
                  if (element["device"] == deviceName) {
                    return true;
                  }
                  return false;
                },
              );
              int eventCount = docs.length;
              ClipboardManager.setDataToClipboard(data: docs[0]["data"]);

              if (eventCount == 0) {
                return Container();
              }

              return Padding(
                padding: const EdgeInsets.only(
                  top: 7.0,
                ),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: eventCount,
                  itemBuilder: (context, index) {
                    DocumentSnapshotForAll doc = docs[index];

                    List<String> data = doc["data"].split("");
                    int dataLength = data.length;
                    String text;

                    if (dataLength > 28) {
                      List dataList = data.getRange(0, 28).toList();
                      dataList.add(" ...");
                      text = dataList.join("").toString();
                    } else {
                      text = doc["data"];
                    }

                    DateTime time =
                        DateTime.parse(doc["time"].toString()).toLocal();

                    String deviceName = doc["device"];

                    return listViewCard(
                      context: context,
                      data: doc["data"],
                      text: text,
                      deviceName: deviceName,
                      time: time,
                    );
                  },
                ),
              );
          }
        },
      ),
    );
  }
}
