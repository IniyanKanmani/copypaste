import 'package:copypaste/main.dart';
import 'package:copypaste/services/app_provider.dart';
import 'package:flutter/material.dart';
import 'package:copypaste/services/clipboard_manager.dart';
import 'package:copypaste/constants/constants.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';

class CloudScreen extends StatelessWidget {
  static int count = 0;
  bool isTitle = true;
  bool readyToSwitchToTitle = false;
  int eventCount = 0;
  int maxCopiedData = 50;
  FocusNode textFieldFocusNode = FocusNode();
  FocusNode rawKeyboardFocusNode = FocusNode();
  TextEditingController textController = TextEditingController();
  ScrollController scrollController = ScrollController();

  void requestRawFocus() {
    rawKeyboardFocusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return WillPopScope(
              onWillPop: () async {
                if (!isKeyboardVisible && !isTitle) {
                  isTitle = true;
                  readyToSwitchToTitle = false;
                  textController.clear();
                  appProvider.justNotify();
                  return false;
                }
                return true;
              },
              child: RawKeyboardListener(
                focusNode: rawKeyboardFocusNode,
                onKey: (event) {
                  if (event.isKeyPressed(LogicalKeyboardKey.backspace) &&
                      readyToSwitchToTitle &&
                      textFieldFocusNode.hasFocus) {
                    isTitle = true;
                    readyToSwitchToTitle = false;
                    appProvider.justNotify();
                    textFieldFocusNode.unfocus();
                    rawKeyboardFocusNode.requestFocus();
                  } else if (event is RawKeyUpEvent &&
                      event.logicalKey.keyLabel == '/' &&
                      !textFieldFocusNode.hasFocus) {
                    isTitle = false;
                    if (textController.text == '') {
                      readyToSwitchToTitle = true;
                    } else {
                      readyToSwitchToTitle = false;
                    }
                    appProvider.justNotify();
                    textFieldFocusNode.requestFocus();
                  } else if (event.isKeyPressed(LogicalKeyboardKey.escape) &&
                      textFieldFocusNode.hasFocus) {
                    if (textController.text.trim() == '') {
                      isTitle = true;
                      readyToSwitchToTitle = false;
                      textController.clear();
                      appProvider.justNotify();
                    }
                    if (eventCount != 0 &&
                        scrollController.position.hasContentDimensions) {
                      scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                      );
                    }
                    textFieldFocusNode.unfocus();
                    rawKeyboardFocusNode.requestFocus();
                  }
                },
                child: Scaffold(
                  appBar: AppBar(
                    backgroundColor: kAppBarBackgroundColor,
                    shape: kAppBarShape,
                    leading: Center(
                      child: GestureDetector(
                        onTap: () {
                          isTitle = true;
                          readyToSwitchToTitle = false;
                          textController.clear();
                          appProvider.justNotify();
                          if (eventCount != 0 &&
                              scrollController.position.hasContentDimensions) {
                            scrollController.animateTo(
                              scrollController.position.minScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.decelerate,
                            );
                          }
                        },
                        child: Icon(
                          Icons.cloud_rounded,
                          color: kInActiveIconColor,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isTitle)
                          Text(
                            "Cloud Data",
                            style: TextStyle(
                              color: kInActiveIconColor,
                            ),
                          ),
                        if (!isTitle)
                          Expanded(
                            child: TextField(
                              controller: textController,
                              focusNode: textFieldFocusNode,
                              autofocus: true,
                              cursorColor: kInActiveIconColor,
                              cursorHeight: 22.0,
                              textInputAction: TextInputAction.search,
                              onChanged: (value) {
                                if (value == '') {
                                  readyToSwitchToTitle = true;
                                } else {
                                  readyToSwitchToTitle = false;
                                }
                                appProvider.justNotify();
                                if (eventCount != 0 &&
                                    scrollController
                                        .position.hasContentDimensions) {
                                  scrollController.jumpTo(scrollController
                                      .position.minScrollExtent);
                                }
                              },
                              style: TextStyle(
                                color: kInActiveIconColor,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        GestureDetector(
                          onTap: () {
                            if (isTitle) {
                              isTitle = false;
                              readyToSwitchToTitle = true;
                              textFieldFocusNode.requestFocus();
                              textController.clear();
                              appProvider.justNotify();
                            } else if (!isTitle && !isKeyboardVisible) {
                              textFieldFocusNode.requestFocus();
                              if (eventCount != 0 &&
                                  scrollController
                                      .position.hasContentDimensions) {
                                scrollController.animateTo(
                                  scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.decelerate,
                                );
                              }
                            } else if (!isTitle && isKeyboardVisible) {
                              if (textController.text.trim() == '') {
                                isTitle = true;
                                readyToSwitchToTitle = false;
                                textController.clear();
                                appProvider.justNotify();
                                if (eventCount != 0 &&
                                    scrollController
                                        .position.hasContentDimensions) {
                                  scrollController.animateTo(
                                    scrollController.position.minScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.decelerate,
                                  );
                                }
                              }
                              FocusManager.instance.primaryFocus!.unfocus();
                            }
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 5.0),
                            child: Center(
                              child: Icon(
                                Icons.search_rounded,
                                color: kInActiveIconColor,
                              ),
                            ),
                          ),
                        ),
                      ],
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
                          List<DocumentSnapshotForAll<Map<String, dynamic>>>?
                              docs = snapshot.data?.docs as List<
                                  DocumentSnapshotForAll<Map<String, dynamic>>>;

                          docs.sort((b, a) => a["time"].compareTo(b["time"]));

                          List<DocumentSnapshotForAll<Map<String, dynamic>>>
                              docsCopy = List.from(docs);

                          docsCopy.removeWhere(
                            (element) {
                              if (element["device"] == deviceModel) {
                                return true;
                              } else if (preferences!
                                      .getStringList('devices')!
                                      .contains(element['device']) &&
                                  !preferences!
                                      .getBool('sync_${element['device']}')!) {
                                return true;
                              }
                              return false;
                            },
                          );

                          docsCopy = docsCopy.sublist(
                              0,
                              docsCopy.length > maxCopiedData
                                  ? maxCopiedData
                                  : docsCopy.length);

                          if (!isTitle) {
                            docsCopy.retainWhere((element) {
                              if (element["data"]
                                  .toString()
                                  .toLowerCase()
                                  .contains(textController.text
                                      .toLowerCase()
                                      .trim())) {
                                return true;
                              } else if (element["device"]
                                  .toString()
                                  .toLowerCase()
                                  .startsWith(textController.text
                                      .toLowerCase()
                                      .trim())) {
                                return true;
                              }
                              return false;
                            });
                          }

                          eventCount = docsCopy.length;

                          if (eventCount == 0) {
                            return Container();
                          }

                          if (ClipboardManager.lastDataFromCloud !=
                                  docsCopy[0]["data"] &&
                              ClipboardManager.lastDataFromDevice !=
                                  docsCopy[0]["data"]) {
                            if (desktop.contains(device) && count != 0) {
                              ClipboardManager.setDataToClipboard(
                                  data: docsCopy[0]["data"]);
                              ClipboardManager.lastDataFromDevice =
                                  docsCopy[0]["data"];
                            }
                            ClipboardManager.lastDataFromCloud =
                                docsCopy[0]["data"];
                            print(
                                "After Cloud Update Device Data: ${ClipboardManager.lastDataFromDevice}");
                            print(
                                "After Cloud Update Cloud Data: ${ClipboardManager.lastDataFromCloud}");
                          }

                          count++;

                          return Padding(
                            padding: const EdgeInsets.only(
                              top: 7.0,
                            ),
                            child: ListView.builder(
                              controller: scrollController,
                              physics: const BouncingScrollPhysics(),
                              itemCount: eventCount,
                              itemBuilder: (context, index) {
                                DocumentSnapshotForAll doc = docsCopy[index];

                                DateTime time;
                                try {
                                  time = DateTime.parse(
                                          doc["time"].toDate().toString())
                                      .toLocal();
                                } catch (e) {
                                  time = DateTime.parse(doc["time"].toString())
                                      .toLocal();
                                }

                                String cloudDeviceName = doc["device"];

                                return listViewCard(
                                  context: context,
                                  data: doc["data"],
                                  cloudDeviceName: cloudDeviceName,
                                  time: time,
                                );
                              },
                            ),
                          );
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
