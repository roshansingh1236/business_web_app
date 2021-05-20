import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bussiness_web_app/utils/navigation_util.dart';

import 'new_user.dart';

class NewUserPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NewUserPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _orderUrl = _baseUrl + '/vendor/preference/user';
  String token = '';
  List _userList = [];
  String vendorId;
  List enquiryList = [];
  bool showStatus = false;
  bool showProgressloading = true;
  String id = '';
  bool showSearch = false;
  String id1;
  bool show = false;
  String _id;
  var myController = TextEditingController();

  //api calling for get Apt
  Future<String> getOrder() async {
    setState(() {
      showProgressloading = true;
    });
    _userList = [];
    var res = await http
        .get(Uri.encodeFull(_orderUrl), headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['preference'];
          _userList = resBody.toList();
          setState(() {
            showProgressloading = false;
          });
          return "Sucess";
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
      vendorId = Cache.storage.getString('vendorId');
    });
    this.getOrder();
  }

  // ignore: non_constant_identifier_names
  Widget RecurringCardList() {
    return showProgressloading == true
        ? Center(
            child: SizedBox(
            width: 20,
            height: 20,
            child: new CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xff212962)),
                strokeWidth: 2.0),
          ))
        : SingleChildScrollView(
            child: _userList.length != 0
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(children: [
                      for (var item in _userList)
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Stack(children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    show = !show;
                                    id1 = item['_id'];
                                  });
                                },
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 20),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xff314498),
                                            Color(0xff2E879A),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            offset: Offset(0.0, 1.0), //(x,y)
                                            blurRadius: 6.0,
                                          ),
                                        ],
                                      ),
                                      child: ExpansionTile(
                                        trailing: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              show = !show;
                                            });
                                            // You enter here what you want the button to do once the user interacts with it
                                          },
                                          icon: Image.asset(
                                            'assets/images/Group 6 (2).png',
                                            width: 20.0,
                                            height: 20.0,
                                          ),
                                          iconSize: 20.0,
                                        ),
                                        title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              InkWell(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10),
                                                      child: Image.asset(
                                                        'assets/images/Vector (13) copy 4.png',
                                                        width: 35.0,
                                                        height: 35.0,
                                                      ))),
                                              Column(children: [
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.1,
                                                  child: Text(item['name'],
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                ),
                                              ])
                                            ]),
                                        children: <Widget>[
                                          ListTile(
                                            title: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  item['address'].length != 0
                                                      ? Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20,
                                                                  bottom: 6),
                                                          child: Container(
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width /
                                                                2.1,
                                                            child: Text(
                                                                "Address: " +
                                                                    item['address']
                                                                        [0],
                                                                textScaleFactor:
                                                                    1.0,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ))
                                                      : new Container(),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, bottom: 6),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            2.1,
                                                        child: Text(
                                                            "Phone: " +
                                                                "+" +
                                                                item['phone']
                                                                    .toString(),
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, bottom: 6),
                                                      child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.1,
                                                        child: Text(
                                                            "Email: " +
                                                                item['email'],
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      )),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    )),
                              )
                            ]))
                    ]))
                : Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: new Center(
                      child: Text(
                        "No User",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Roboto"),
                      ),
                    )));
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
                            Text(
                              "User",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 36.0,
                                  color: Color(0xff2E809A),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto"),
                            ),
                            new Image.asset(
                              'assets/images/2202248-512.png',
                              width: 63.0,
                              height: 65.0,
                            ),
                          ])),
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height / 1.4,
                            child: RecurringCardList()),
                      ],
                    ),
                  )
                ])),
              ])),
        ),
        floatingActionButton: Transform.scale(
          scale: 1.5,
          child: Padding(
              padding: EdgeInsets.only(right: 20, top: 0),
              child: FloatingActionButton(
                onPressed: () {
                  NavigationUtil.pushToNewScreen(context, UserPage());
                },
                backgroundColor: Colors.red,
                elevation: 0,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: Offset(3, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
                    child: Icon(
                      Icons.add,
                      size: 40.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              )),
        ));
  }
}
