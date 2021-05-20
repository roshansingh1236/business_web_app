import 'package:flutter/material.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';

class PaymentPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PaymentPage> {
  UserRepository userRepository;
  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
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
                              'assets/images/Payment Settings.png',
                              width: 144.0,
                              height: 84.0,
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
                                            onTap: () {},
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
                                                            "Credit Card",
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
                                          InkWell(
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
                                                            "Debit",
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
                                          Padding(
                                              padding: EdgeInsets.only(top: 30),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                          "Payment 3",
                                                          textScaleFactor: 1.0,
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
                                                        child: new Image.asset(
                                                          'assets/images/Group 6.png',
                                                          width: 14.0,
                                                          height: 14.0,
                                                        )),
                                                  ])),
                                          InkWell(
                                            onTap: () {},
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
                                                            "Payment 4",
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
                                              onTap: () {},
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
                                                              "Payment 4",
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
                                        ]),
                                  ]))))
                ])),
              ])),
        ));
  }
}
