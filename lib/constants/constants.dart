import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:copypaste/services/clipboard_manager.dart';

Color kLoginCursorColor = const Color(0xFF999999);
Color kLoginTextColor = const Color(0xFFDDDDDD);
Color kLoginTextButtonColor = const Color(0xFFDDDDDD);
Color kAppBarBackgroundColor = const Color(0xFF010101);
Color kBodyBackgroundColor = const Color(0xFF010101);
Color kActiveIconColor = const Color(0xFFFAFAFA);
Color kInActiveIconColor = const Color(0xFF989898);
Color kCardDividerColor = const Color(0xFF343434);
Color kCardDateTextColor = const Color(0xFF989898);
Color kCardTimeTextColor = const Color(0xFF989898);
Color kCardDataTextColor = const Color(0xFFFAFAFA);
Color kCardDeviceTextColor = const Color(0xFF989898);
Color kCardDeviceNameTextColor = const Color(0xFFD0D0D0);
Color kCardCopyIconColor = const Color(0xFF0381FE);
Color kCardBackgroundColor = const Color(0xFF171717);
Color kSwitchActiveColor = const Color(0xFF0381FE);
Color kSwitchTrackColor = const Color(0xFF666660);

double kCardHeight = 100.0;
double kCardElevation = 20.0;
double kCardLeftPadding = 7.0;
double kCardBorderRadius = 20.0;
double kClipRRectBorderRadius = 20.0;
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

BoxDecoration kCardBoxDecoration = BoxDecoration(
  color: kCardBackgroundColor,
  borderRadius: BorderRadius.circular(
    kCardBorderRadius,
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
  required String cloudDeviceName,
  required DateTime time,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(
      vertical: 4.0,
    ),
    child: Container(
      height: kCardHeight,
      decoration: kCardBoxDecoration,
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
              data: data,
            ),
            cardDeviceRow(
              cloudDeviceName: cloudDeviceName,
            ),
          ],
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

Widget cardDataRow({
  required BuildContext context,
  required String data,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Expanded(
        child: Padding(
            padding: const EdgeInsets.only(
              left: 15.0,
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              child: Text(
                data.replaceAll(RegExp('\n'), ' '),
                textAlign: TextAlign.left,
                style: kCardDataTextStyle,
              ),
            )),
      ),
      Padding(
        padding: const EdgeInsets.only(
          right: 5.0,
          left: 6.0,
        ),
        child: IconButton(
          splashRadius: 1.0,
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
  required String cloudDeviceName,
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
              cloudDeviceName,
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
      color: kLoginTextColor,
    ),
    obscureText: obscureText,
    cursorColor: kLoginCursorColor,
    decoration: InputDecoration(
      filled: true,
      fillColor: kCardBackgroundColor,
      hintText: hintText,
      hintStyle: TextStyle(
        fontSize: kLoginTextFieldFontSize,
        color: kLoginTextColor,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: kLoginCursorColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(
            kCardBorderRadius - 5,
          ),
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(
            kCardBorderRadius - 5,
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
    decoration: kCardBoxDecoration,
    child: ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            kCardBorderRadius - 5,
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
