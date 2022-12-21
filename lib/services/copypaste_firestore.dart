import 'dart:async';

import 'package:copypaste/main.dart';
import 'package:copypaste/services/copypaste_provider.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CopyPasteFirestore {
  void listenToCloudChanges(
      {required BuildContext context,
      required StreamController<bool> controller}) {
    CollectionSnapshots snapshots = FirestoreForAll.instance
        .collection("users")
        .doc(userEmail!)
        .collection("text")
        .snapshots();

    snapshots.listen(
      (snapshot) async {
        List<DocumentSnapshotForAll<Map<String, dynamic>>>? docs =
            snapshot.docs as List<DocumentSnapshotForAll<Map<String, dynamic>>>;

        docs.sort((b, a) => a["time"].compareTo(b["time"]));

        Provider.of<CopyPasteProvider>(context, listen: false)
            .setCloudDocs(docs);

        if (!controller.isClosed) {
          controller.sink.add(true);
          controller.close();
        }
      },
    );
  }
}
