import 'package:copypaste/clipboard_manager.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Color kLoginCursorColorColor = const Color(0xFFC0C0C0);
Color kLoginTextColorColor = const Color(0xFF999999);
Color kLoginTextButtonColor = const Color(0xFFDDDDDD);
Color kAppBarBackgroundColor = const Color(0xFF252525);
Color kBodyBackgroundColor = const Color(0xFF151515);
Color kActiveIconColor = const Color(0xFFE270FF);
Color kInActiveIconColor = const Color(0xFFDAC1FE);
Color kCardShadowColor = const Color(0xFF505050);
Color kCardDateTextColor = const Color(0xFFB5179E);
Color kCardTimeTextColor = const Color(0xFFFC95FC);
Color kCardDataTextColor = const Color(0xFF130066);
Color kCardDeviceTextColor = const Color(0xFF6F1AEF);
Color kCardDeviceNameTextColor = const Color(0xFFD7BDFF);
Color kCardCopyIconColor = const Color(0xFFC6ADFE);
Color kCardGradientColor1 = const Color(0xFFE270FF);
Color kCardGradientColor2 = const Color(0xFFA020F0);

double kCardHeight = 100.0;
double kCardElevation = 20.0;
double kCardLeftPadding = 7.0;
double kCardBorderRadius = 13.0;
double kLoginTextFieldFontSize = 17.0;

TextStyle kCardDateTextStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  color: kCardDateTextColor,
);

TextStyle kCardTimeTextStyle = TextStyle(
  fontSize: 12.0,
  fontWeight: FontWeight.w500,
  color: kCardTimeTextColor,
);

TextStyle kCardDataTextStyle = TextStyle(
  fontSize: 18.0,
  fontWeight: FontWeight.w400,
  color: kCardDataTextColor,
);

TextStyle kCardDeviceTextStyle = TextStyle(
  fontSize: 13.0,
  color: kCardDeviceTextColor,
  fontWeight: FontWeight.w500,
);

TextStyle kCardDeviceNameTextStyle = TextStyle(
  fontSize: 13.0,
  color: kCardDeviceNameTextColor,
  fontWeight: FontWeight.w500,
);

Text kCardDeviceText = Text(
  "Device: ",
  style: kCardDeviceTextStyle,
);

Icon kCardCopyButtonIcon = Icon(
  Icons.copy_outlined,
  color: kCardCopyIconColor,
);

ShapeBorder kAppBarShape = const RoundedRectangleBorder(
  borderRadius: BorderRadius.only(
    bottomLeft: Radius.circular(
      15.0,
    ),
    bottomRight: Radius.circular(
      15.0,
    ),
  ),
);

ShapeBorder kCardShape = RoundedRectangleBorder(
  borderRadius: BorderRadius.circular(
    kCardBorderRadius,
  ),
);

BoxDecoration kCardDecoration = BoxDecoration(
  gradient: LinearGradient(
    colors: [
      kCardGradientColor1,
      kCardGradientColor2,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  ),
);

String parseWeekday(int index) {
  switch (index) {
    case 1:
      return "Mon";
    case 2:
      return "Tue";
    case 3:
      return "Wed";
    case 4:
      return "Thu";
    case 5:
      return "Fri";
    case 6:
      return "Sat";
    case 7:
      return "Sun";
    default:
      return "";
  }
}

Widget listViewCard({
  required BuildContext context,
  required String data,
  required String text,
  required String deviceName,
  required DateTime time,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 4.0,
      horizontal: 10.0,
    ),
    child: SizedBox(
      height: kCardHeight,
      child: Card(
        clipBehavior: Clip.antiAlias,
        shape: kCardShape,
        elevation: kCardElevation,
        shadowColor: kCardShadowColor,
        child: Container(
          decoration: kCardDecoration,
          child: Padding(
            padding: const EdgeInsets.all(
              5.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                cardTimeRow(
                  time: time,
                ),
                cardDataRow(
                  context: context,
                  text: text,
                  data: data,
                ),
                cardDeviceRow(
                  deviceName: deviceName,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget cardTimeRow({
  required DateTime time,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: EdgeInsets.only(
          left: kCardLeftPadding,
        ),
        child: Text(
          "${parseWeekday(time.weekday)}, ${DateFormat("MMM").format(time)} ${NumberFormat("00").format(time.day)}",
          style: kCardDateTextStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          right: 10.0,
        ),
        child: Text(
          "${NumberFormat("00").format(time.hour)}:${NumberFormat("00").format(time.minute)}",
          style: kCardTimeTextStyle,
        ),
      ),
    ],
  );
}

Widget cardDataRow(
    {required BuildContext context,
    required String text,
    required String data}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Padding(
        padding: const EdgeInsets.only(
          left: 15.0,
        ),
        child: Text(
          text,
          textAlign: TextAlign.left,
          style: kCardDataTextStyle,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          right: 5.0,
        ),
        child: IconButton(
          onPressed: () {
            ClipboardManager.setDataToClipboard(data: data);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text(
                  "Copied to Clipboard",
                ),
                backgroundColor: kBodyBackgroundColor,
              ),
            );
          },
          icon: kCardCopyButtonIcon,
        ),
      ),
    ],
  );
}

Widget cardDeviceRow({
  required String deviceName,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      Padding(
        padding: EdgeInsets.only(
          left: kCardLeftPadding,
        ),
        child: Row(
          children: [
            kCardDeviceText,
            Text(
              deviceName,
              style: kCardDeviceNameTextStyle,
            ),
          ],
        ),
      ),
    ],
  );
}

Widget loginTextField({
  required TextEditingController controller,
  required TextInputAction action,
  required TextInputType inputType,
  required String hintText,
  required bool obscureText,
}) {
  return TextField(
    controller: controller,
    textInputAction: action,
    keyboardType: inputType,
    style: TextStyle(
      fontSize: kLoginTextFieldFontSize,
      color: kLoginTextColorColor,
    ),
    obscureText: obscureText,
    cursorColor: kLoginCursorColorColor,
    decoration: InputDecoration(
      filled: true,
      fillColor: kAppBarBackgroundColor,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: kLoginTextFieldFontSize,
        color: kLoginTextColorColor,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: kLoginTextColorColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            kCardBorderRadius,
          ),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            kCardBorderRadius,
          ),
        ),
      ),
    ),
  );
}

Widget loginElevatedButton({
  required VoidCallback onTap,
  required String text,
}) {
  return Container(
    width: 140,
    height: 42,
    decoration: kCardDecoration.copyWith(
      borderRadius: BorderRadius.circular(
        kCardBorderRadius,
      ),
    ),
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            kCardBorderRadius,
          ),
        ),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            color: kLoginTextButtonColor,
          ),
        ),
      ),
    ),
  );
}
