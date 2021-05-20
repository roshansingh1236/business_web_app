import 'package:flutter/material.dart';

Widget loadingWidget() {
  return Center(child: CircularProgressIndicator());
}

Widget errorWidget(String message) {
  return Center(
    child: Text(
      message,
      style: TextStyle(
        color: Colors.red
      ),
    )
  );
}
