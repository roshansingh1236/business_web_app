import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:bussiness_web_app/bloc/auth/auth_bloc.dart';
import 'package:bussiness_web_app/bloc/user/user_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/data/models/user_model.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/notification/notification.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/app_widgets.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:http/http.dart' as http;
part 'home_drawer_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _hasBeenPressed = false;
  String _date = 'Day';
  String _status = "Pending";
  String token = '';
  String _name;
  String _logo;
  String vendorId;
  // ignore: deprecated_member_use
  List _configList = List();
  bool showProgressloading = false;
  List _orderList = [];
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/vendor/business/vid';
  static final _orderUrl = _baseUrl + '/order';
  DateTime _currentSelected = DateTime.now();
  DateTime _currentSelected1 = DateTime.now();
  double counter = 0.0;
  int norders = 0;
  int ndelorders = 0;
  //api calling for get Apt
  Future<String> getBusiness() async {
    var res = await http
        .get(Uri.encodeFull(_businessUrl), headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['businessData'];
          _configList = resBody.toList();
          setState(() {
            _name = _configList[0]['entityName'];
            _logo = _configList[0]['businessLogo']['path'];
          });
          Cache.storage.setString('bussinessId', _configList[0]['_id']);
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

  //api calling for get Apt
  Future<String> getOrder(String status) async {
    print(status);
    setState(() {
      showProgressloading = true;
    });
    _orderList = [];
    var date1 = DateFormat("yyyy-MM-dd").format(_currentSelected);
    var date2 = DateFormat("yyyy-MM-dd").format(_currentSelected1);

    var res = await http.get(
        Uri.encodeFull(_orderUrl +
            "?bussinessId=$vendorId&filter[status]=$status&mode=product&populate=user" +
            "&filter[updatedAt][\$gte]=" +
            date1 +
            "T00:00:00.000Z" +
            "&filter[updatedAt][\$lte]=" +
            date2 +
            "T23:59:59.000Z" +
            "&filter[deleted]=false"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          norders = json.decode(res.body)['n_orders'];
          ndelorders = json.decode(res.body)['n_del_orders'];
          var resBody = json.decode(res.body)['orders'];
          _orderList = resBody.toList();
          _orderList.forEach((doc) => counter += (doc["total"].toDouble()));
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

  /// Find the first date of the week which contains the provided date.
  DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday - 1));
  }

  /// Find last date of the week which contains provided date.
  DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime
        .add(Duration(days: DateTime.daysPerWeek - dateTime.weekday));
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
      vendorId = Cache.storage.getString('bussinessId');
    });

    this.getBusiness();
    this.getOrder("pending");
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
              child: new Column(children: <Widget>[
                Container(
                    child: new Column(children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.only(bottom: 25.0, left: 70, right: 70),
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Container(
                              height: 100,
                              width: 100,
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
                                      radius: 100,
                                      backgroundImage: NetworkImage(_logo))
                                  : Text(
                                      _name != null ? _name[0] : "",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 58.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: "Roboto"),
                                    ),
                            ),
                            new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        _name != null
                                            ? _name.toUpperCase()
                                            : "",
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Color(0xff2E809A),
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Roboto"),
                                      )),
                                  new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: SizedBox(
                                              width: 47,
                                              height: 21,
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                color: _date == "Day"
                                                    ? Color(0xff2E809A)
                                                    : Color(0xffE2F0FC),
                                                onPressed: () {
                                                  var myDate = DateTime.now();
                                                  setState(() {
                                                    _hasBeenPressed =
                                                        !_hasBeenPressed;
                                                    _date = "Day";
                                                    _status = "";
                                                    counter = 0.0;
                                                    _currentSelected = myDate;
                                                    _currentSelected1 = myDate;
                                                  });
                                                  this.getOrder("");
                                                },
                                                child: Text(
                                                  'Day',
                                                  textScaleFactor: 1.0,
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
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                color: _date == "Week"
                                                    ? Color(0xff2E809A)
                                                    : Color(0xffE2F0FC),
                                                /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                                                onPressed: () {
                                                  // Find first date and last date of THIS WEEK
                                                  // Find first date and last date of any provided date
                                                  DateTime date =
                                                      _currentSelected;

                                                  setState(() {
                                                    _hasBeenPressed =
                                                        !_hasBeenPressed;
                                                    _date = "Week";
                                                    _status = "";
                                                    counter = 0.0;
                                                    _currentSelected =
                                                        findFirstDateOfTheWeek(
                                                            date);
                                                    _currentSelected1 =
                                                        findLastDateOfTheWeek(
                                                            date);
                                                  });
                                                  this.getOrder("");
                                                },
                                                child: Text(
                                                  'Week',
                                                  textScaleFactor: 1.0,
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
                                                      BorderRadius.circular(
                                                          6.0),
                                                ),
                                                color: _date == "Month"
                                                    ? Color(0xff2E809A)
                                                    : Color(0xffE2F0FC),
                                                /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                                                onPressed: () {
                                                  var myDate = DateTime.now();
                                                  var startOfMonth =
                                                      new DateTime(myDate.year,
                                                          myDate.month, 1);
                                                  setState(() {
                                                    _hasBeenPressed =
                                                        !_hasBeenPressed;
                                                    _date = "Month";
                                                    _status = "";
                                                    counter = 0.0;
                                                    _currentSelected =
                                                        startOfMonth;
                                                    _currentSelected1 = myDate;
                                                  });
                                                  this.getOrder("");
                                                },
                                                child: Text(
                                                  'Month',
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontSize: 8,
                                                      color: _date == "Month"
                                                          ? Colors.white
                                                          : Color(0xff2E809A)),
                                                ),
                                              ),
                                            )),
                                      ])
                                ]),
                            Padding(
                                padding: EdgeInsets.only(right: 10.0),
                                child: InkWell(
                                    onTap: () {
                                      NavigationUtil.pushToNewScreen(
                                          context, NotificationPage());
                                    },
                                    child: new Image.asset(
                                      'assets/images/Group (3).png',
                                      width: 26.0,
                                      height: 30.0,
                                    ))),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(bottom: 15.0),
                      child: Container(
                          height: 70,
                          width: MediaQuery.of(context).size.width / 1.11,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xff026D00)),
                          child: Padding(
                              padding: EdgeInsets.only(left: 10.0, right: 10),
                              child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Total Sales Amount",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto"),
                                    ),
                                    Text(
                                      "₹  $counter /-",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto"),
                                    )
                                  ])))),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width / 1.11,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffE2F0FC)),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10.0, right: 10, top: 10),
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Image.asset(
                                          'assets/images/Vector (12).png',
                                          width: 20.0,
                                          height: 20.0,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: SizedBox(
                                              width: 70,
                                              height: 21,
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                color: _status == "Pending"
                                                    ? Color(0xff2E809A)
                                                    : Color(0xffE2F0FC),
                                                onPressed: () {
                                                  var myDate = DateTime.now();
                                                  setState(() {
                                                    _status = "Pending";
                                                    _date = "Day";
                                                    counter = 0.0;
                                                    _currentSelected = myDate;
                                                    _currentSelected1 = myDate;
                                                  });
                                                  this.getOrder("pending");
                                                },
                                                child: Text(
                                                  'Pending',
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: _status ==
                                                              "Pending"
                                                          ? Colors.white
                                                          : Color(0xff2E809A)),
                                                ),
                                              ),
                                            )),
                                        Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: SizedBox(
                                              width: 75,
                                              height: 21,
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                color: _status == "Accepted"
                                                    ? Color(0xff2E809A)
                                                    : Color(0xffE2F0FC),
                                                /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                                                onPressed: () {
                                                  // Find first date and last date of THIS WEEK
                                                  // Find first date and last date of any provided date
                                                  var myDate = DateTime.now();
                                                  setState(() {
                                                    _status = "Accepted";
                                                    _date = "Day";
                                                    counter = 0.0;
                                                    _currentSelected = myDate;
                                                    _currentSelected1 = myDate;
                                                  });
                                                  this.getOrder("confirmed");
                                                },
                                                child: Text(
                                                  'Accepted',
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: _status ==
                                                              "Accepted"
                                                          ? Colors.white
                                                          : Color(0xff2E809A)),
                                                ),
                                              ),
                                            )),
                                        Padding(
                                            padding: EdgeInsets.all(5.0),
                                            child: SizedBox(
                                              width: 70,
                                              height: 21,
                                              child: RaisedButton(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                color: _status == "Shipped"
                                                    ? Color(0xff2E809A)
                                                    : Color(0xffE2F0FC),
                                                /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                                                onPressed: () {
                                                  var myDate = DateTime.now();
                                                  setState(() {
                                                    _status = "Shipped";
                                                    _date = "Day";
                                                    counter = 0.0;
                                                    _currentSelected = myDate;
                                                    _currentSelected1 = myDate;
                                                  });
                                                  this.getOrder("shipped");
                                                },
                                                child: Text(
                                                  'Shipped',
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: _status ==
                                                              "Shipped"
                                                          ? Colors.white
                                                          : Color(0xff2E809A)),
                                                ),
                                              ),
                                            )),
                                      ]),
                                  new Container(
                                    height: 150.0,
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    child: new SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Padding(
                                            padding: EdgeInsets.only(top: 5),
                                            child: new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  new Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          'Name  ',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: Color(
                                                                  0xff4F4F4F)),
                                                        ),
                                                        Text(
                                                          'Status  ',
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              fontFamily:
                                                                  'Roboto',
                                                              color: Color(
                                                                  0xff4F4F4F)),
                                                        ),
                                                      ]),
                                                  Divider(
                                                    height: 10,
                                                  ), //
                                                  showProgressloading == true
                                                      ? Center(
                                                          child: SizedBox(
                                                          width: 20,
                                                          height: 20,
                                                          child: new CircularProgressIndicator(
                                                              valueColor:
                                                                  AlwaysStoppedAnimation(
                                                                      Color(
                                                                          0xff212962)),
                                                              strokeWidth: 2.0),
                                                        ))
                                                      : SingleChildScrollView(
                                                          child: _orderList
                                                                      .length !=
                                                                  0
                                                              ? Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              10),
                                                                  child: Column(
                                                                      children: [
                                                                        for (var item
                                                                            in _orderList)
                                                                          Column(
                                                                            children: [
                                                                              InkWell(
                                                                                  onTap: () {},
                                                                                  child: Container(
                                                                                      height: 35,
                                                                                      child: Padding(
                                                                                          padding: EdgeInsets.only(top: 5),
                                                                                          child: new Row(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                                                                                            Container(
                                                                                              width: 150,
                                                                                              child: Text(
                                                                                                item['user_id']['name'] != null ? item['user_id']['name']['first'] + " " + item['user_id']['name']['last'] : "",
                                                                                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Roboto', color: Color(0xff828282)),
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              item['status'],
                                                                                              style: TextStyle(
                                                                                                  fontSize: 12,
                                                                                                  fontWeight: FontWeight.w500,
                                                                                                  color: item['status'] == "pending"
                                                                                                      ? Colors.red
                                                                                                      : item['status'] == "delivered"
                                                                                                          ? Colors.green
                                                                                                          : Color(0xff828282)),
                                                                                            ),
                                                                                          ])))),
                                                                              Divider(
                                                                                height: 10,
                                                                              ),
                                                                            ],
                                                                          )
                                                                      ]))
                                                              : Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          top:
                                                                              15),
                                                                  child: Center(
                                                                      child:
                                                                          new Container(
                                                                    child: Text(
                                                                      "You don't have any orders!",
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          color:
                                                                              Colors.grey),
                                                                    ),
                                                                  ))))
                                                ]))),
                                  ),
                                ]),
                          ))),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width / 2.3,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xffE2F0FC)),
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10.0, top: 10),
                                    child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "New Orders",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xff314498),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Roboto"),
                                          ),
                                          norders == 0
                                              ? Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 10),
                                                  child: Text(
                                                    "No new orders\nrecieved!",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontSize: 10.0,
                                                        color:
                                                            Color(0xffBDBDBD),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Roboto"),
                                                  ))
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      top: 30, right: 20),
                                                  child: Center(
                                                      child: Text(
                                                    "$norders",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        fontSize: 35.0,
                                                        color: Colors.red,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontFamily: "Roboto"),
                                                  ))),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 410, top: 5),
                                              child: new Image.asset(
                                                'assets/images/Vector (12).png',
                                                width: 40.0,
                                                height: 35.0,
                                              )),
                                        ]))),
                            Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width / 2.4,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xffE2F0FC)),
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10.0, top: 10),
                                    child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            "Problems",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                color: Color(0xff314498),
                                                fontWeight: FontWeight.w700,
                                                fontFamily: "Roboto"),
                                          ),
                                          new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                      "5 problem Reported",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          color:
                                                              Color(0xffBDBDBD),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto"),
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                      "3 unsolved Problems",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          color:
                                                              Color(0xffBDBDBD),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto"),
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: Text(
                                                      "Merchant Responded",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontSize: 10.0,
                                                          color:
                                                              Color(0xffBDBDBD),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto"),
                                                    ))
                                              ]),
                                          Padding(
                                              padding: EdgeInsets.only(
                                                  left: 410, top: 10),
                                              child: new Image.asset(
                                                'assets/images/Group 146.png',
                                                width: 40.0,
                                                height: 35.0,
                                              )),
                                        ])))
                          ])),
                  Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width / 1.12,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xffE2F0FC)),
                      child: Padding(
                          padding: EdgeInsets.only(left: 10.0, top: 10),
                          child: new Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Remainders",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 14.0,
                                      color: Color(0xff314498),
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Roboto"),
                                ),
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      ndelorders != norders
                                          ? new Container()
                                          : Padding(
                                              padding: EdgeInsets.only(top: 10),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 0,
                                                                top: 0),
                                                        child: new Image.asset(
                                                          'assets/images/Group 148.png',
                                                          width: 14.0,
                                                          height: 14.0,
                                                        )),
                                                    Text(
                                                      "  Daily delivery Completed!",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontSize: 12.0,
                                                          color:
                                                              Color(0xff4F4F4F),
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontFamily: "Roboto"),
                                                    )
                                                  ])),
                                    ]),
                              ])))
                ])),
              ])),
        ));
  }
}
