import 'package:flutter/material.dart';

import 'colors.dart';

class Style {
  static Widget getRobotoNormalText(String text, double fontSize, Color color,
      {FontWeight fontWeight = FontWeight.normal,
      TextAlign textAlign = TextAlign.start,
      int maxLine = 100}) {
    return Text(text,
        overflow: TextOverflow.ellipsis,
        textScaleFactor: 1.0,
        textAlign: textAlign,
        style: getRobotoTextStyle(color, fontSize, fontWeight: fontWeight));
  }

  static TextStyle getRobotoTextStyle(Color color, double fontSize,
      {FontWeight fontWeight = FontWeight.normal}) {
    return TextStyle(
        color: color,
        fontSize: fontSize,
        fontFamily: 'Roboto',
        fontStyle: FontStyle.normal,
        fontWeight: fontWeight);
  }

  static Widget getButtonWithIconText(
      double width, double height, String buttonText,
      {Function onPressed,
      Widget icon,
      double textFont = 14,
      Color textColor = Colors.white,
      FontWeight fontWeight = FontWeight.normal}) {
    return Container(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          primary: FF212962, // background
          onPrimary: Colors.white, // foreground
        ),
        onPressed: onPressed,
        child: Center(
          child: icon == null
              ? getRobotoNormalText(buttonText, textFont, textColor,
                  fontWeight: fontWeight)
              : Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    icon,
                    SizedBox(
                      width: 10,
                    ),
                    getRobotoNormalText(buttonText, textFont, textColor)
                  ],
                ),
        ),
      ),
    );
  }

  static Widget getClickableIcon(
      IconData icon, Color color, Function onClicked) {
    return IconButton(
      onPressed: onClicked,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
    );
  }

  static Widget getClickableRoundedIcon(
      IconData iconData, Color bgColor, Function onClicked, double size,
      {Color iconColor = Colors.white}) {
    return InkWell(
      borderRadius: BorderRadius.circular(size / 2),
      onTap: onClicked,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
        child: Icon(
          iconData,
          color: iconColor,
          size: size - 6,
        ),
      ),
    );
  }
}
