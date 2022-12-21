import 'package:firebase_for_all/firebase/firestore/models.dart';
import 'package:flutter/material.dart';

class CopyPasteProvider extends ChangeNotifier {
  List<String>? _syncDevices;
  List<DocumentSnapshotForAll<Map<String, dynamic>>> _cloudDocs = [];

  void justNotify() {
    notifyListeners();
  }

  List<String> getSyncDevices() => _syncDevices!;

  List<DocumentSnapshotForAll<Map<String, dynamic>>> getCloudDocs() =>
      _cloudDocs;

  void setSyncDevices(syncDevices) {
    _syncDevices = syncDevices;
    notifyListeners();
  }

  void setCloudDocs(cloudDocs) {
    _cloudDocs = cloudDocs;
    notifyListeners();
  }
}
