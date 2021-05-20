//import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/style/colors.dart';
import 'package:bussiness_web_app/style/style.dart';

class CommonUtils {
  static showToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.grey,
      textColor: Colors.black,
    );
  }

  static void showLoadingDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierColor: Colors.white.withOpacity(0.2),
        barrierDismissible: false,
        transitionDuration: Duration(milliseconds: 0),
        pageBuilder: (context, animation, secondaryAnimation) =>
            SizedBox.expand(
              // makes widget fullscreen
              child: Center(
                child: Card(
                    color: Colors.white.withOpacity(.9),
                    elevation: 4,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: new CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    )),
              ),
            ));
  }

  static void dismissLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showMsgDialog(BuildContext context, String msg, String btn1Name) {
    showConfirmationDialog(context, msg, btn1Name, null, null, null);
  }

  static void showConfirmationDialog(BuildContext context, String msg,
      String btn1Name, Function onBtn1, String btn2Name, Function onBtn2) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Style.getRobotoNormalText(msg, 14, FF212962),
            actions:
                _getDialogActions(context, btn1Name, onBtn1, btn2Name, onBtn2),
          );
        });
  }

  static List<Widget> _getDialogActions(BuildContext context, String btn1Name,
      Function onBtn1, String btn2Name, Function onBtn2) {
    List<Widget> actions = [];
    if (btn2Name != null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onBtn2();
        },
        child: Style.getRobotoNormalText(btn2Name, 14, FFA7A7A7,
            fontWeight: FontWeight.w500),
      ));
    }

    if (btn1Name != null) {
      actions.add(TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onBtn1();
        },
        child: Style.getRobotoNormalText(btn1Name, 14, FF212962,
            fontWeight: FontWeight.w500),
      ));
    }

    return actions;
  }

  /* static Future<bool> isConnectedToInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  } */

  /* static Future<bool> checkInternetAndShowMsg() async {
    bool result = await isConnectedToInternet();
    if (!result) {
      showToast("Please check your internet connection");
    }

    return result;
  } */
}
