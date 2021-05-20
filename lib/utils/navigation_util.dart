import 'package:flutter/material.dart';
import 'package:bussiness_web_app/ui/pages/home/home_page.dart';
import 'package:bussiness_web_app/ui/pages/slide_from_left_page_route.dart';
import 'package:bussiness_web_app/ui/pages/slide_from_right.dart';

class NavigationUtil {
  static Future<dynamic> clearAllAndAdd(BuildContext context, Widget widget,
      {bool animateFromRight = false}) {
    return Navigator.of(context).pushAndRemoveUntil(
        animateFromRight
            ? SlideFromRightPageRoute(widget: widget)
            : SlideFromLeftPageRoute(widget: widget),
        (route) => false);
  }

  static Future<dynamic> pushToNewScreen(BuildContext context, Widget widget,
      {bool animateFromRight = false}) {
    return Navigator.of(context).push(animateFromRight
        ? SlideFromRightPageRoute(widget: widget)
        : SlideFromLeftPageRoute(widget: widget));
  }

  static Future<dynamic> pushAndReplaceToNewScreen(
      BuildContext context, Widget widget,
      {bool animateFromRight = false}) {
    return Navigator.of(context).pushReplacement(animateFromRight
        ? SlideFromRightPageRoute(widget: widget)
        : SlideFromLeftPageRoute(widget: widget));
  }

  static void pop(BuildContext context, {dynamic result}) {
    Navigator.pop(context, result);
  }

  static bool canPop(BuildContext context) {
    return Navigator.canPop(context);
  }

  static void handleBackToHomePage(BuildContext context) {
    if (NavigationUtil.canPop(context)) {
      NavigationUtil.pop(context);
    } else {
      NavigationUtil.clearAllAndAdd(context, HomePage());
    }
  }
}
