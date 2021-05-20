import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bussiness_web_app/bloc/auth/auth_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/about/policy.dart';
import 'package:bussiness_web_app/ui/pages/about/product_list.dart';
import 'package:bussiness_web_app/ui/pages/about/profile.dart';
import 'package:bussiness_web_app/ui/pages/about/terms.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/common_util.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AboutPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffF0F6FB),
      systemNavigationBarDividerColor: Colors.black,
    ));
    return Scaffold(
        bottomNavigationBar: CommonWidgets.getAppBottomTab(context),
        backgroundColor: Color(0xffF0F6FB),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 60, left: 10),
          height: MediaQuery.of(context).size.height,
          child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Column(children: <Widget>[
                Container(
                    child: new Column(children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.only(bottom: 25.0, left: 20, right: 40),
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Settings.png',
                              width: 135.0,
                              height: 42.0,
                            ),
                            new Image.asset(
                              'assets/images/Vector (9).png',
                              width: 48.0,
                              height: 48.0,
                            ),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(right: 30, left: 20),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffE2F0FC)),
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.0, top: 10),
                              child: new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          InkWell(
                                            onTap: () {
                                              NavigationUtil.pushToNewScreen(
                                                  context, ProfilePage());
                                            },
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 30),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20,
                                                                top: 0),
                                                        child: Text("Profile",
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto")),
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20,
                                                                  top: 0),
                                                          child:
                                                              new Image.asset(
                                                            'assets/images/Group 6.png',
                                                            width: 14.0,
                                                            height: 14.0,
                                                          )),
                                                    ])),
                                          ),
                                          Cache.storage.getString(
                                                      'vendorRole') !=
                                                  "Real Estate Agent"
                                              ? InkWell(
                                                  onTap: () {
                                                    NavigationUtil
                                                        .pushToNewScreen(
                                                            context,
                                                            ProductListPage());
                                                  },
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30),
                                                      child: new Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        top: 0),
                                                                child: Text(
                                                                  "Product Information",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Roboto"),
                                                                )),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20,
                                                                        top: 0),
                                                                child: new Image
                                                                    .asset(
                                                                  'assets/images/Group 6.png',
                                                                  width: 14.0,
                                                                  height: 14.0,
                                                                )),
                                                          ])),
                                                )
                                              : new Container(),
                                          /*   Cache.storage.getString(
                                                      'vendorRole') !=
                                                  "Real Estate Agent"
                                              ? InkWell(
                                                  onTap: () {
                                                    NavigationUtil
                                                        .pushToNewScreen(
                                                            context,
                                                            PaymentPage());
                                                  },
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          top: 30),
                                                      child: new Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20,
                                                                        top: 0),
                                                                child: Text(
                                                                  "Payment Setting",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Roboto"),
                                                                )),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20,
                                                                        top: 0),
                                                                child: new Image
                                                                    .asset(
                                                                  'assets/images/Group 6.png',
                                                                  width: 14.0,
                                                                  height: 14.0,
                                                                )),
                                                          ])))
                                              : new Container(), */
                                          InkWell(
                                            onTap: () {
                                              NavigationUtil.pushToNewScreen(
                                                  context, PolicyPage());
                                            },
                                            child: Padding(
                                                padding:
                                                    EdgeInsets.only(top: 30),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 0),
                                                          child: Text(
                                                            "Privacy Policy",
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          )),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20,
                                                                  top: 0),
                                                          child:
                                                              new Image.asset(
                                                            'assets/images/Group 6.png',
                                                            width: 14.0,
                                                            height: 14.0,
                                                          )),
                                                    ])),
                                          ),
                                          InkWell(
                                              onTap: () {
                                                NavigationUtil.pushToNewScreen(
                                                    context, TermsPage());
                                              },
                                              child: Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 30),
                                                  child: new Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 20,
                                                                    top: 0),
                                                            child: Text(
                                                              "Terms & Conditions",
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      12.0,
                                                                  color: Color(
                                                                      0xff314498),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontFamily:
                                                                      "Roboto"),
                                                            )),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 20,
                                                                    top: 0),
                                                            child:
                                                                new Image.asset(
                                                              'assets/images/Group 6.png',
                                                              width: 14.0,
                                                              height: 14.0,
                                                            )),
                                                      ]))),
                                          Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: InkWell(
                                                onTap: () {
                                                  CommonUtils
                                                      .showConfirmationDialog(
                                                          context,
                                                          "Do you want to logout?",
                                                          "Yes", () async {
                                                    BlocProvider.of<AuthBloc>(
                                                            context)
                                                        .add(
                                                            UnAuthorizeEvent());

                                                    Cache.storage.clear();
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    await prefs?.clear();
                                                    Navigator
                                                        .pushNamedAndRemoveUntil(
                                                            context,
                                                            '/',
                                                            (_) => true);
                                                  }, "No", () {});
                                                },
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  top: 0),
                                                          child: Text(
                                                            "Log Out",
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          )),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20,
                                                                  top: 0),
                                                          child:
                                                              new Image.asset(
                                                            'assets/images/Group 6.png',
                                                            width: 14.0,
                                                            height: 14.0,
                                                          )),
                                                    ]),
                                              )),
                                        ]),
                                  ]))))
                ])),
              ])),
        ));
  }
}
