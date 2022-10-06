import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:copypaste/main.dart';
import 'package:flutter/material.dart';

class DeviceScreen extends StatefulWidget {
  @override
  State<DeviceScreen> createState() => _DeviceScreenState();
}

class _DeviceScreenState extends State<DeviceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kAppBarBackgroundColor,
        shape: kAppBarShape,
        leading: Center(
          child: Icon(
            Icons.notes_rounded,
            color: kInActiveIconColor,
          ),
        ),
        title: Text(
          "Device Clipboard",
          style: TextStyle(
            color: kInActiveIconColor,
          ),
        ),
      ),
      backgroundColor: kBodyBackgroundColor,
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(userEmail)
            .collection("text")
            .where("device", isEqualTo: deviceName)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Container();
          }

          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            default:
              List<QueryDocumentSnapshot<Map<String, dynamic>>>? docs =
                  snapshot.data?.docs;

              docs?.sort((b, a) => a["time"].compareTo(b["time"]));
              int eventCount = docs!.length;

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
                    DocumentSnapshot doc = docs[index];

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
                        DateTime.parse(doc["time"].toDate().toString())
                            .toLocal();

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
