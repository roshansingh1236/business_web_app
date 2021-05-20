import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/home/detail_delivery.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:http/http.dart' as http;

class DeliveryHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DeliveryHomePage> {
  String token = '';
  String _name;
  static final _baseUrl = Env.apiBaseUrl;
  static final _vendorUrl = _baseUrl + '/vendor/getdetails';
  String _logo;
  //api calling for get Apt
  Future<String> getVednorDetails() async {
    var res = await http
        .get(Uri.encodeFull(_vendorUrl), headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['vendorData'][0];
          setState(() {
            _logo = resBody['photo'];
            _name = resBody['name'];
          });

          Cache.storage.setString('bussinessType', resBody['businessType']);
        }
        break;

      case "502":
        {
          Fluttertoast.showToast(
              msg: "Bad Gateway",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red);
          return "Fail";
        }
        break;

      case '400':
        {
          var error = json.decode(res.body);
          Fluttertoast.showToast(
              msg: error["message"],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red);
        }
        break;

      default:
        return "Fail";
    }

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });
    getVednorDetails();
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
          padding: const EdgeInsets.only(top: 60, left: 0),
          height: MediaQuery.of(context).size.height,
          child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Column(children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(bottom: 0.0, left: 25),
                        child: new Image.asset(
                          'assets/images/Delivery (1).png',
                          width: 135.0,
                          height: 87.0,
                        ),
                      ),
                    ]),
                    Container(
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 25, bottom: 10),
                              child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    new Container(
                                      height: 80,
                                      width: 80,
                                      padding: new EdgeInsets.all(2.0),
                                      alignment: Alignment.center,
                                      decoration: new BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Color(0xff314498),
                                          style: BorderStyle.solid,
                                          width: 1.0,
                                        ),
                                        color: const Color(0xff7c94b6),
                                      ),
                                      child: _logo != null
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  NetworkImage(_logo))
                                          : Text(
                                              _name != null ? _name[0] : "",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 58.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            ),
                                    )
                                  ])),
                          Container(
                            padding: const EdgeInsets.only(top: 10, left: 10),
                            height: MediaQuery.of(context).size.height,
                            child: new SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: new Column(children: <Widget>[
                                  Container(
                                      child: new Column(children: <Widget>[
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 20, left: 10),
                                        child: Container(
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                1.6,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Color(0xffE2F0FC)),
                                            child: new Column(
                                                children: <Widget>[
                                                  Container(
                                                    height: 420,
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10.0),
                                                    child: ListView.separated(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 8,
                                                              left: 8,
                                                              right: 8,
                                                              bottom: 8),
                                                      itemCount: 4,
                                                      reverse: false,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                            onTap: () {
                                                              NavigationUtil
                                                                  .pushToNewScreen(
                                                                      context,
                                                                      DeliveryDetailsPage());
                                                            },
                                                            child: ListTile(
                                                              trailing:
                                                                  new Icon(
                                                                Icons
                                                                    .more_horiz_rounded,
                                                                color: Color(
                                                                    0xff314498),
                                                                size: 20.0,
                                                              ),
                                                              title: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    InkWell(
                                                                        child: Padding(
                                                                            padding: EdgeInsets.only(right: 10),
                                                                            child: Image.asset(
                                                                              'assets/images/Vector (13).png',
                                                                              width: 35.0,
                                                                              height: 25.0,
                                                                            ))),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width /
                                                                          2.5,
                                                                      child: Text(
                                                                          "Shree Complex",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style: TextStyle(
                                                                              color: Color(0xff314498),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500)),
                                                                    ),
                                                                    Image.asset(
                                                                      'assets/images/Vector (13) copy.png',
                                                                      width:
                                                                          11.0,
                                                                      height:
                                                                          11.0,
                                                                    ),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            left:
                                                                                5,
                                                                            top:
                                                                                1),
                                                                        child: Text(
                                                                            "5",
                                                                            textScaleFactor:
                                                                                1.0,
                                                                            style: TextStyle(
                                                                                color: Color(0xff314498),
                                                                                fontSize: 14,
                                                                                fontWeight: FontWeight.w500))),
                                                                  ]),
                                                            ));
                                                      },
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                                  int index) =>
                                                              Divider(
                                                        thickness: 0,
                                                        color:
                                                            Color(0xffE2F0FC),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 35, right: 35),
                                                      child: Container(
                                                          child: new Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                            Container(
                                                                child: new Row(
                                                                    children: <
                                                                        Widget>[
                                                                  Image.asset(
                                                                    'assets/images/Group 111.png',
                                                                    width: 86.0,
                                                                    height:
                                                                        27.0,
                                                                  ),
                                                                ])),
                                                            Container(
                                                                child: new Row(
                                                                    children: <
                                                                        Widget>[
                                                                  Container(
                                                                      height:
                                                                          34,
                                                                      width: 34,
                                                                      padding:
                                                                          new EdgeInsets.all(
                                                                              2.0),
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        color: Color(
                                                                            0xff2E809A),
                                                                        borderRadius: new BorderRadius
                                                                            .all(new Radius
                                                                                .circular(
                                                                            100.0)),
                                                                        border:
                                                                            new Border.all(
                                                                          color:
                                                                              Color(0xff2E809A),
                                                                          width:
                                                                              1.0,
                                                                        ),
                                                                      ),
                                                                      child: Image
                                                                          .asset(
                                                                        'assets/images/Group (4).png',
                                                                        width:
                                                                            5.0,
                                                                        height:
                                                                            5.0,
                                                                      )),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              1),
                                                                      child: Text(
                                                                          "Assign\nOrders",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style: TextStyle(
                                                                              color: Color(0xff2E809A),
                                                                              fontSize: 10,
                                                                              fontWeight: FontWeight.w500))),
                                                                ]))
                                                          ])))
                                                ]))),
                                  ])),
                                ])),
                          )
                        ])),
                  ])),
        ));
  }
}
