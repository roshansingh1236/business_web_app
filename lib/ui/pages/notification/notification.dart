import 'dart:convert';

import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:http/http.dart' as http;
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';

class NotificationPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NotificationPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final enquiryUrl = _baseUrl + '/notifications';
  String token = '';
  String _id = '';
  bool showProgressloading = false;
  List scheduleList = [];
  String title = '';
  String _id1 = '';
  String deviceToken = '';
  Future<String> getNotification() async {
    setState(() {
      showProgressloading = true;
    });
    scheduleList = [];
    print(enquiryUrl + "?filter[type]=pushvendor" + "&filter[vendorId]=" + _id);
    var res = await http.get(
        Uri.encodeFull(
            enquiryUrl + "?filter[type]=push" + "&filter[_userId]=" + _id),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;

    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['notifications'];
          // loop through the json object
          // loop through the json object
          scheduleList = resBody.toList();
          setState(() {
            showProgressloading = false;
          });
          print(scheduleList.length);
          return "Sucess";
        }
        break;

      case "502":
        {
          setState(() {
            showProgressloading = false;
          });
          Fluttertoast.showToast(
              msg: "Bad Gateway",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red);

          return "Fail";
        }
        break;

      case '404':
        {
          setState(() {
            showProgressloading = false;
          });
          Fluttertoast.showToast(
              msg: "404 Not Found",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              backgroundColor: Colors.red);
        }
        break;
      case '400':
        {
          setState(() {
            showProgressloading = false;
          });
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

  _readNotification(BuildContext context) async {
    // set up POST request arguments
    final msg1 = jsonEncode({
      "_userId": _id,
      "read": true,
      "new": false,
      "type": "push",
      "title": title
    });

    // make POST request
    final response =
        await http.put(enquiryUrl + "/" + _id1, body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    print(json.decode(response.body));
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      getNotification();
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      var error = json.decode(response.body);
      Fluttertoast.showToast(
          msg: error["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
      _id = Cache.storage.getString('vendorId');
    });
    getNotification();
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
        appBar: CommonWidgets1.getAppBar(context),
        body: Container(
          padding: const EdgeInsets.only(top: 5, left: 10),
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
                              'assets/images/Alerts.png',
                              width: 135.0,
                              height: 42.0,
                            ),
                            new Image.asset(
                              'assets/images/Group (3).png',
                              width: 57.0,
                              height: 65.0,
                            ),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.4,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffE2F0FC)),
                          child: showProgressloading == true
                              ? Center(
                                  child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: new CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation(
                                          Color(0xff212962)),
                                      strokeWidth: 2.0),
                                ))
                              : Container(
                                  padding: const EdgeInsets.all(10.0),
                                  height: MediaQuery.of(context).size.height,
                                  child: scheduleList.length == 0
                                      ? Center(
                                          child: Text(
                                            "No Notification",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Color(0xff314498),
                                                fontSize: 15),
                                          ),
                                        )
                                      : ListView.separated(
                                          padding: const EdgeInsets.only(
                                              top: 8,
                                              left: 8,
                                              right: 8,
                                              bottom: 8),
                                          itemCount: scheduleList.length,
                                          reverse: false,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    _id1 = scheduleList[index]
                                                        ['_id'];
                                                    title = scheduleList[index]
                                                        ['title'];
                                                  });
                                                  _readNotification(context);
                                                },
                                                child: ListTile(
                                                  trailing: new Image.asset(
                                                    'assets/images/Group 33 (1).png',
                                                    width: 20,
                                                  ),
                                                  title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 10),
                                                            child: Image.asset(
                                                              'assets/images/Group 83 (1).png',
                                                              width: 30.0,
                                                              height: 20.0,
                                                            )),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              2.1,
                                                          child: Text(
                                                            scheduleList[index]
                                                                ["message"],
                                                            textScaleFactor:
                                                                1.0,
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xff314498),
                                                                fontSize: 12,
                                                                fontWeight: scheduleList[index]
                                                                            [
                                                                            "new"] ==
                                                                        true
                                                                    ? FontWeight
                                                                        .bold
                                                                    : FontWeight
                                                                        .normal),
                                                          ),
                                                        )
                                                      ]),
                                                ));
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  Divider(
                                            thickness: 1,
                                          ),
                                        ),
                                )))
                ])),
              ])),
        ));
  }
}
