import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CommonWidgets1 {
  static Widget getAppBar(BuildContext context) {
    return AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color(0xffF0F6FB),
        //`true` if you want Flutter to automatically add Back Button when needed,
        //or `false` if you want to force your own back button every where
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context, false),
        ));
  }
}
