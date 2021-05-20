import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/ui/pages/about/about.dart';
import 'package:bussiness_web_app/ui/pages/agent/schedule.dart';
import 'package:bussiness_web_app/ui/pages/home/agent_home.dart';
import 'package:bussiness_web_app/ui/pages/home/delivery_home.dart';
import 'package:bussiness_web_app/ui/pages/home/home_page.dart';
import 'package:bussiness_web_app/ui/pages/orders/new_order.dart';
import 'package:bussiness_web_app/ui/pages/property/list_property.dart';
import 'package:bussiness_web_app/ui/pages/user/userList.dart';

import 'package:bussiness_web_app/utils/navigation_util.dart';

class CommonWidgets {
  static Widget getAppBottomTab(BuildContext context) {
    /*  if (!UserFeaturesUtils.get().isBottomTabEnabled()) {
      return null;
    }
 */
    return BottomAppBar(
      elevation: 0,
      child: Container(
        height: 87.0,
        color: Color(0xffF0F6FB),
        child: Cache.storage.getString('vendorRole') == "Real Estate Agent"
            ? new Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  /*  if (UserFeaturesUtils.get().commonAreaBookingEnabled) */
                  InkWell(
                      onTap: () {
                        NavigationUtil.pushToNewScreen(
                            context, AgentHomePage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Vector (11).png',
                              width: 25.0,
                              height: 22.32,
                            ),
                            /* Text(
                        "Book",
                        textScaleFactor: 1.0,
                        style: TextStyle(color: Color(0xff212962)),
                      ) */
                          ])),
                  /*  if (UserFeaturesUtils.get().servicesRequestEnabled) */
                  InkWell(
                      onTap: () {
                        NavigationUtil.pushToNewScreen(
                            context, PropertyListPage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Vector.png',
                              width: 25.0,
                              height: 22.0,
                            ),
                          ])),
                  InkWell(
                      onTap: () {
                        NavigationUtil.pushToNewScreen(
                            context, ListSchedulePage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Vector (1).png',
                              width: 25.0,
                              height: 25.25,
                            ),
                          ])),

                  /* if (UserFeaturesUtils.get().paymentsEnabled) */
                  InkWell(
                      onTap: () {
                        NavigationUtil.pushToNewScreen(context, AboutPage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Vector (9).png',
                              width: 25.0,
                              height: 25.0,
                            ),
                          ])),
                ],
              )
            : new Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  /*  if (UserFeaturesUtils.get().commonAreaBookingEnabled) */
                  InkWell(
                      onTap: () {
                        Cache.storage.getString('vendorRole') == "teamMember"
                            ? NavigationUtil.pushToNewScreen(
                                context, DeliveryHomePage())
                            : NavigationUtil.pushToNewScreen(
                                context, HomePage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Vector (11).png',
                              width: 25.0,
                              height: 22.32,
                            ),
                            /* Text(
                        "Book",
                        textScaleFactor: 1.0,
                        style: TextStyle(color: Color(0xff212962)),
                      ) */
                          ])),
                  /*  if (UserFeaturesUtils.get().servicesRequestEnabled) */
                  InkWell(
                      onTap: () {
                        NavigationUtil.pushToNewScreen(context, NewOrderPage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Vector (10).png',
                              width: 25.0,
                              height: 22.0,
                            ),
                          ])),
                  InkWell(
                      onTap: () {
                        NavigationUtil.pushToNewScreen(context, NewUserPage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/2202248-512.png',
                              width: 25.0,
                              height: 25.25,
                            ),
                          ])),

                  /* if (UserFeaturesUtils.get().paymentsEnabled) */
                  InkWell(
                      onTap: () {
                        NavigationUtil.pushToNewScreen(context, AboutPage());
                      },
                      child: new Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Vector (9).png',
                              width: 25.0,
                              height: 25.0,
                            ),
                          ])),
                ],
              ),
      ),
      shape: CircularNotchedRectangle(),
      color: Colors.white,
      notchMargin: 8.0,
    );
  }
}
