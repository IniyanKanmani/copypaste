import 'package:copypaste/main.dart';
import 'package:copypaste/services/copypaste_provider.dart';
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

  Widget cloudScreenListView({required CopyPasteProvider copyPasteProvider}) {
    List<DocumentSnapshotForAll<Map<String, dynamic>>> docs;
    try {
      docs = copyPasteProvider.getCloudDocs();
    } catch (e) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    List<DocumentSnapshotForAll<Map<String, dynamic>>> docsCopy =
        List.from(docs);

    docsCopy.removeWhere(
      (element) {
        if (element["device"] == deviceModel) {
          return true;
        } else if (preferences!
                .getStringList('devices')!
                .contains(element['device']) &&
            !preferences!.getBool('sync_${element['device']}')!) {
          return true;
        }
        return false;
      },
    );

    docsCopy = docsCopy.sublist(
        0, docsCopy.length > maxCopiedData ? maxCopiedData : docsCopy.length);

    if (!isTitle) {
      docsCopy.retainWhere((element) {
        if (element["data"]
            .toString()
            .toLowerCase()
            .contains(textController.text.toLowerCase().trim())) {
          return true;
        } else if (element["device"]
            .toString()
            .toLowerCase()
            .startsWith(textController.text.toLowerCase().trim())) {
          return true;
        }
        return false;
      });
    }

    eventCount = docsCopy.length;

    if (eventCount == 0) {
      return Container();
    }

    if (ClipboardManager.lastDataFromCloud != docsCopy[0]["data"] &&
        ClipboardManager.lastDataFromDevice != docsCopy[0]["data"]) {
      if (desktop.contains(device) && count != 0) {
        ClipboardManager.setDataToClipboard(data: docsCopy[0]["data"]);
        ClipboardManager.lastDataFromDevice = docsCopy[0]["data"];
      }
      ClipboardManager.lastDataFromCloud = docsCopy[0]["data"];
      print(
          "After Cloud Update Device Data: ${ClipboardManager.lastDataFromDevice}");
      print(
          "After Cloud Update Cloud Data: ${ClipboardManager.lastDataFromCloud}");
    }

    count++;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kClipRRectBorderRadius),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          controller: scrollController,
          physics: const BouncingScrollPhysics(),
          itemCount: eventCount,
          itemBuilder: (context, index) {
            DocumentSnapshotForAll doc = docsCopy[index];

            DateTime time;
            try {
              time = DateTime.parse(doc["time"].toDate().toString()).toLocal();
            } catch (e) {
              time = DateTime.parse(doc["time"].toString()).toLocal();
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CopyPasteProvider>(
      builder: (context, copyPasteProvider, child) {
        return KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            return WillPopScope(
              onWillPop: () async {
                if (!isKeyboardVisible && !isTitle) {
                  isTitle = true;
                  readyToSwitchToTitle = false;
                  textController.clear();
                  copyPasteProvider.justNotify();
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
                    copyPasteProvider.justNotify();
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
                    copyPasteProvider.justNotify();
                    textFieldFocusNode.requestFocus();
                  } else if (event.isKeyPressed(LogicalKeyboardKey.escape) &&
                      textFieldFocusNode.hasFocus) {
                    if (textController.text.trim() == '') {
                      isTitle = true;
                      readyToSwitchToTitle = false;
                      textController.clear();
                      copyPasteProvider.justNotify();
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
                    leadingWidth: isTitle ? 0 : 40.0,
                    leading: isTitle
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(left: 15.0),
                            child: GestureDetector(
                              onTap: () {
                                isTitle = true;
                                readyToSwitchToTitle = false;
                                textController.clear();
                                copyPasteProvider.justNotify();
                                if (eventCount != 0 &&
                                    scrollController
                                        .position.hasContentDimensions) {
                                  scrollController.animateTo(
                                    scrollController.position.minScrollExtent,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.decelerate,
                                  );
                                }
                              },
                              child: Center(
                                child: Icon(
                                  Icons.arrow_back_ios_rounded,
                                  color: kActiveIconColor,
                                ),
                              ),
                            ),
                          ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (isTitle)
                          GestureDetector(
                            onTap: () {
                              isTitle = true;
                              readyToSwitchToTitle = false;
                              textController.clear();
                              copyPasteProvider.justNotify();
                              if (eventCount != 0 &&
                                  scrollController
                                      .position.hasContentDimensions) {
                                scrollController.animateTo(
                                  scrollController.position.minScrollExtent,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.decelerate,
                                );
                              }
                            },
                            child: Text(
                              "Cloud Clipboard",
                              style: TextStyle(
                                color: kActiveIconColor,
                              ),
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
                                copyPasteProvider.justNotify();
                                if (eventCount != 0 &&
                                    scrollController
                                        .position.hasContentDimensions) {
                                  scrollController.jumpTo(scrollController
                                      .position.minScrollExtent);
                                }
                              },
                              style: TextStyle(
                                color: kActiveIconColor,
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
                              copyPasteProvider.justNotify();
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
                                copyPasteProvider.justNotify();
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
                                color: kActiveIconColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: kBodyBackgroundColor,
                  body:
                      cloudScreenListView(copyPasteProvider: copyPasteProvider),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
