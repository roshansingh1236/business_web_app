import 'package:flutter/material.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/orders/new_order.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';

class OrderPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<OrderPage> {
  UserRepository userRepository;
  bool _hasBeenPressed = false;
  String _date = 'Day';
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
                          EdgeInsets.only(bottom: 25.0, left: 20, right: 28),
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: 15.0),
                                child: Container(
                                    height: 51,
                                    width: 112,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff026D00)),
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: new Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(
                                                "Total Profits",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: 10.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Roboto"),
                                              ),
                                              Text(
                                                "₹  1105 /-",
                                                textScaleFactor: 1.0,
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Roboto"),
                                              )
                                            ])))),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(left: 25.0),
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 0.0),
                                child: Text(
                                  "Orders",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      color: Color(0xff2E809A),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Roboto"),
                                )),
                            new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width: 47,
                                        height: 21,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          color: _date == "Day"
                                              ? Color(0xff2E809A)
                                              : Color(0xffE2F0FC),
                                          /*    disabledColor:
                                                        Color(0xff2E809A),
                                                    disabledTextColor: Colors.white, */
                                          onPressed: () {
                                            setState(() {
                                              _hasBeenPressed =
                                                  !_hasBeenPressed;
                                              _date = "Day";
                                            });
                                          },
                                          child: Text(
                                            'Day',
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: _date == "Day"
                                                    ? Colors.white
                                                    : Color(0xff2E809A)),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width: 55,
                                        height: 21,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          color: _date == "Week"
                                              ? Color(0xff2E809A)
                                              : Color(0xffE2F0FC),
                                          /*    disabledColor:
                                                        Color(0xff2E809A),
                                                    disabledTextColor: Colors.white, */
                                          onPressed: () {
                                            setState(() {
                                              _hasBeenPressed =
                                                  !_hasBeenPressed;
                                              _date = "Week";
                                            });
                                          },
                                          child: Text(
                                            'Week',
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: _date == "Week"
                                                    ? Colors.white
                                                    : Color(0xff2E809A)),
                                          ),
                                        ),
                                      )),
                                  Padding(
                                      padding: EdgeInsets.all(5.0),
                                      child: SizedBox(
                                        width: 60,
                                        height: 21,
                                        child: RaisedButton(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(6.0),
                                          ),
                                          color: _date == "Month"
                                              ? Color(0xff2E809A)
                                              : Color(0xffE2F0FC),
                                          /*    disabledColor:
                                                        Color(0xff2E809A),
                                                    disabledTextColor: Colors.white, */
                                          onPressed: () {
                                            setState(() {
                                              _hasBeenPressed =
                                                  !_hasBeenPressed;
                                              _date = "Month";
                                            });
                                          },
                                          child: Text(
                                            'Month',
                                            style: TextStyle(
                                                fontSize: 8,
                                                color: _date == "Month"
                                                    ? Colors.white
                                                    : Color(0xff2E809A)),
                                          ),
                                        ),
                                      )),
                                  InkWell(
                                      onTap: () {
                                        NavigationUtil.pushToNewScreen(
                                            context, NewOrderPage());
                                      },
                                      child: Padding(
                                          padding: EdgeInsets.only(left: 100.0),
                                          child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                new Image.asset(
                                                  'assets/images/Vector (10).png',
                                                  width: 33.0,
                                                  height: 29.0,
                                                ),
                                                Text(
                                                  '\nNew Order',
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Color(0xff2E809A)),
                                                ),
                                              ])))
                                ])
                          ])),
                  Padding(
                      padding: EdgeInsets.only(right: 30, left: 20, top: 20),
                      child: Container(
                          height: 300,
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
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  bottom: 25.0,
                                                  left: 20,
                                                  right: 28),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Text(
                                                      "Milk",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontSize: 24.0,
                                                          color:
                                                              Color(0xff314498),
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontFamily: "Roboto"),
                                                    ),
                                                    Padding(
                                                        padding: EdgeInsets
                                                            .only(bottom: 15.0),
                                                        child: Container(
                                                            height: 28,
                                                            width: 86,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                                color: Color(
                                                                    0xff026D00)),
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            10.0,
                                                                        right:
                                                                            10),
                                                                child: new Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: <
                                                                        Widget>[
                                                                      Text(
                                                                        "+ ₹212 /-",
                                                                        textScaleFactor:
                                                                            1.0,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                14.0,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w700,
                                                                            fontFamily: "Roboto"),
                                                                      )
                                                                    ])))),
                                                  ])),
                                          new Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: <Widget>[
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(0.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 0.0),
                                                              child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Quantity\n   Sold',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ])),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 0.0),
                                                              child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '298',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              24,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ]))
                                                        ])),
                                                InkWell(
                                                    onTap: () {
                                                      NavigationUtil
                                                          .pushToNewScreen(
                                                              context,
                                                              NewOrderPage());
                                                    },
                                                    child: Padding(
                                                        padding: EdgeInsets.all(
                                                            30.0),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              0.0),
                                                                  child: Column(
                                                                      children: [
                                                                        Text(
                                                                          'Purchase\n Quantity',
                                                                          style: TextStyle(
                                                                              fontSize: 14,
                                                                              color: Color(0xff314498),
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ])),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              10.0),
                                                                  child: Column(
                                                                      children: [
                                                                        Image
                                                                            .asset(
                                                                          'assets/images/Group 143.png',
                                                                          width:
                                                                              21.0,
                                                                          height:
                                                                              21.0,
                                                                        ),
                                                                      ]))
                                                            ]))),
                                                Padding(
                                                    padding:
                                                        EdgeInsets.all(30.0),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 0.0),
                                                              child: Column(
                                                                  children: [
                                                                    Text(
                                                                      'Defected/\nDamages',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              14,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ])),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 0.0),
                                                              child: Column(
                                                                  children: [
                                                                    Text(
                                                                      '5',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              24,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight:
                                                                              FontWeight.bold),
                                                                    ),
                                                                  ]))
                                                        ])),
                                              ]),
                                          Center(
                                            child: SizedBox(
                                              width: 284,
                                              height: 54,
                                              child: RaisedButton(
                                                onPressed: () {},
                                                textColor: Colors.white,
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            80.0)),
                                                child: Container(
                                                  decoration:
                                                      const BoxDecoration(
                                                          gradient:
                                                              LinearGradient(
                                                            colors: <Color>[
                                                              Color(0xFF314498),
                                                              Color(0xFF2E879A),
                                                            ],
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      10.0))),
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          20, 10, 20, 10),
                                                  child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        const Text(
                                                            'View Damage Report',
                                                            style: TextStyle(
                                                                fontSize: 20)),
                                                        Icon(
                                                          Icons.arrow_right,
                                                          color:
                                                              Color(0xFF2E879A),
                                                          size: 37.0,
                                                          semanticLabel:
                                                              'Text to announce in accessibility modes',
                                                        )
                                                      ]),
                                                ),
                                              ),
                                            ),
                                          )
                                        ]),
                                  ])))),
                ])),
              ])),
        ),
        floatingActionButton: Padding(
            padding: EdgeInsets.only(right: 30, top: 600),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              new FloatingActionButton(
                  elevation: 0.0,
                  child: new Icon(
                    Icons.person,
                    size: 20,
                  ),
                  backgroundColor: new Color(0xFFE2E809A),
                  onPressed: () {}),
              const Text('Invite/Import\n  Customers',
                  style: TextStyle(fontSize: 10)),
            ])));
  }
}
