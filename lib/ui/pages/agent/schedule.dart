import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/style/colors.dart';
import 'package:bussiness_web_app/ui/pages/agent/enquiry.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/common_util.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
//import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

import 'existing_enquiry.dart';

class ListSchedulePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ListSchedulePage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final scheduleUrl = _baseUrl + '/property/schedule';
  static final enquiryUrl = _baseUrl + '/property/enquiry';
  UserRepository userRepository;
  bool _hasBeenPressed = true;
  String token = '';
  bool showProgressloading = true;
  DateTime _currentSelected = DateTime.now();
  //DateTime _currentSelected2 = DateTime.now();
  //DateRangePickerController _controller;
  PageController pageController = PageController(initialPage: 2021);
  DateTime selectedDate;
  int displayedYear;
  List scheduleList = [];
  String id;
  String _phone;
  bool show = false;
  var details;
  String _zoomImage;
  bool showStatus = false;
  String _status;
  Future<String> getScheduleDateViseData() async {
    scheduleList = [];
    var date1 = DateFormat("yyyy-MM-dd").format(selectedDate);
    var date2 = DateFormat("yyyy-MM-dd").format(selectedDate);
    var res = await http.get(
        Uri.encodeFull(scheduleUrl +
            "?filter[date][\$gte]=" +
            date1 +
            "T00:00:00.000Z" +
            "&filter[date][\$lte]=" +
            date2 +
            "T23:59:59.000Z"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['schedule'];
          // loop through the json object
          // loop through the json object
          scheduleList = resBody.toList();
          setState(() {
            showProgressloading = false;
          });
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

  Future<String> getScheduleData() async {
    scheduleList = [];
    var date1 = DateFormat("yyyy-MM-dd").format(_currentSelected);

    var res = await http.get(
        Uri.encodeFull(scheduleUrl +
            "?filter[start_time][\$gte]=" +
            date1 +
            "T00:00:00.000Z"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['schedule'];
          // loop through the json object
          // loop through the json object
          scheduleList = resBody.toList();
          setState(() {
            showProgressloading = false;
          });
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

  _addPropertyRequest(BuildContext context) async {
    // set up POST request arguments
    final msg1 = jsonEncode({"status": _status});

    // make POST request
    final response = await http.put(
        enquiryUrl + "?id=" + details['enquiry_id']['_id'],
        body: msg1,
        headers: {
          "Authorization": token,
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      getScheduleData();
      Fluttertoast.showToast(
          msg: "Status Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    } else if (statusCode == 201) {
      getScheduleData();
      Fluttertoast.showToast(
          msg: "Status Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
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
    //_controller = DateRangePickerController();
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });
    /*  selectedDate = DateTime(2021, 2);
      displayedYear = selectedDate.year; */
    getScheduleData();
  }

  _deleteRequest(BuildContext context) async {
    // set up POST request arguments

    // make POST request
    final response = await http.delete(scheduleUrl + "?id=" + id, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      setState(() {
        _hasBeenPressed = true;
      });
      getScheduleData();
      Fluttertoast.showToast(
          msg: json.decode(response.body)["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      var error = json.decode(response.body);
      Fluttertoast.showToast(
          msg: error["Error"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    }
  }

  Widget _tabSection2(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Column(children: <Widget>[
                new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: SizedBox(
                            width: 57,
                            height: 25,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              color: details['enquiry_id']['type'] == "rent"
                                  ? Color(0xff2E809A)
                                  : Color(0xffE2F0FC),
                              /*    disabledColor:
                                                      Color(0xff2E809A),
                                                  disabledTextColor: Colors.white, */
                              onPressed: () {},
                              child: Text(
                                'Rent',
                                style: TextStyle(
                                    fontSize: 8,
                                    color:
                                        details['enquiry_id']['type'] == "rent"
                                            ? Colors.white
                                            : Color(0xff2E809A)),
                              ),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.all(20.0),
                          child: SizedBox(
                            height: 25,
                            width: 57,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              color: details['enquiry_id']['type'] == "buy"
                                  ? Color(0xff2E809A)
                                  : Color(0xffE2F0FC),
                              /*    disabledColor:
                                                      Color(0xff2E809A),
                                                  disabledTextColor: Colors.white, */
                              onPressed: () {},
                              child: Text(
                                'Buy',
                                style: TextStyle(
                                    fontSize: 8,
                                    color:
                                        details['enquiry_id']['type'] == "buy"
                                            ? Colors.white
                                            : Color(0xff2E809A)),
                              ),
                            ),
                          )),
                    ]),
                Container(
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(right: 20, left: 10, top: 0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
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
                            ),
                            child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding:
                                          EdgeInsets.only(right: 0, top: 20),
                                      child: new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Row(
                                              children: [
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 20, left: 20),
                                                    child: new Image.asset(
                                                      'assets/images/Group (4).png',
                                                      width: 39.0,
                                                      height: 39.0,
                                                    )),
                                                new Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                        details['enquiry_id']
                                                                ['name']
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                            fontSize: 18,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text(
                                                        "+" +
                                                            details['enquiry_id']
                                                                ['phone_no'],
                                                        style: TextStyle(
                                                            fontSize: 10,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                          ])),
                                  Padding(
                                      padding:
                                          EdgeInsets.only(left: 30, top: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          details['enquiry_id']['preference'] ==
                                                  null
                                              ? new Container()
                                              : Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 10),
                                                  child: Container(
                                                    height: 60,
                                                    width: 170,
                                                    color: Colors.transparent,
                                                    child: Container(
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                                color: Colors
                                                                    .white),
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        10.0))),
                                                        child: new Center(
                                                            child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            new Text(
                                                              "Budget Range",
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            Cache.storage.getString(
                                                                        'country') ==
                                                                    "India"
                                                                ? new Text(
                                                                    details['enquiry_id']['type'] ==
                                                                            "rent"
                                                                        ? " \u20B9" +
                                                                            details['enquiry_id']['preference']['rent_start_price']
                                                                                .toString() +
                                                                            " to "
                                                                                "\u20B9" +
                                                                            details['enquiry_id']['preference']['rent_end_price']
                                                                                .toString() +
                                                                            " "
                                                                        : "\u20B9" +
                                                                            details['enquiry_id']['preference']['selling_start_price'].toString() +
                                                                            " to " +
                                                                            "\u20B9" +
                                                                            details['enquiry_id']['preference']['selling_end_price'].toString() +
                                                                            " ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  )
                                                                : new Text(
                                                                    details['enquiry_id']['type'] ==
                                                                            "rent"
                                                                        ? " S\$" +
                                                                            details['enquiry_id']['preference']['rent_start_price']
                                                                                .toString() +
                                                                            " to "
                                                                                " S\$" +
                                                                            details['enquiry_id']['preference']['rent_end_price']
                                                                                .toString() +
                                                                            " "
                                                                        : " S\$" +
                                                                            details['enquiry_id']['preference']['selling_start_price'].toString() +
                                                                            " to " +
                                                                            " S\$" +
                                                                            details['enquiry_id']['preference']['selling_end_price'].toString() +
                                                                            " ",
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                  ),
                                                          ],
                                                        ))),
                                                  )),
                                          new Text(
                                            "Suggested Listing\n",
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.white,
                                                fontWeight: FontWeight.normal),
                                            textAlign: TextAlign.center,
                                          ),
                                          details['property_id'] != null
                                              ? SingleChildScrollView(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  child: Row(
                                                    children: [
                                                      /*    for (var item1 in details[
                                                                'property_id']
                                                            ['images']) */
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Column(
                                                            children: [
                                                              Container(
                                                                  width: 50,
                                                                  height: 50,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                          borderRadius: BorderRadius.all(Radius.circular(
                                                                              10.0)),
                                                                          border:
                                                                              Border.all(
                                                                            color:
                                                                                Colors.white,
                                                                            width:
                                                                                2,
                                                                          )),
                                                                  child: InkWell(
                                                                    child: details['property_id']['images'].length !=
                                                                            0
                                                                        ? ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child: Image.network(
                                                                              details['property_id']['images'][0],
                                                                              fit: BoxFit.cover,
                                                                            ))
                                                                        : ClipRRect(
                                                                            borderRadius:
                                                                                BorderRadius.circular(8.0),
                                                                            child:
                                                                                new Image.asset(
                                                                              'assets/images/Vector.png',
                                                                              fit: BoxFit.cover,
                                                                            ),
                                                                          ),
                                                                    onTap: () {
                                                                      if (details['property_id']['images']
                                                                              .length !=
                                                                          0) {
                                                                        setState(
                                                                            () {
                                                                          _zoomImage =
                                                                              details['property_id']['images'][0];
                                                                        });
                                                                        _displayDialog1(
                                                                            context,
                                                                            _zoomImage);
                                                                      }
                                                                    },
                                                                  )),
                                                              Container(
                                                                  child: Text(
                                                                      details['property_id']
                                                                          [
                                                                          'name'],
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12,
                                                                          color:
                                                                              Colors.white)))
                                                            ],
                                                          )),
                                                    ],
                                                  ))
                                              : new Container(
                                                  child: new Text(
                                                    "No Property Added!",
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                )
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          right: 30,
                                          top: 10,
                                          left: 30,
                                          bottom: 30),
                                      child: new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Row(children: [
                                                    Text(
                                                      'Status: ',
                                                      style: TextStyle(
                                                          fontSize: 13,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    showStatus == false
                                                        ? Text(
                                                            details['enquiry_id']
                                                                ['status'],
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: details['enquiry_id']
                                                                            [
                                                                            'status'] ==
                                                                        'open'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        : SizedBox(
                                                            width: 80,
                                                            child:
                                                                DropdownButtonHideUnderline(
                                                                    child:
                                                                        DropdownButton(
                                                              isExpanded: false,
                                                              icon: Icon(
                                                                // Add this
                                                                Icons
                                                                    .arrow_drop_down_circle, // Add this
                                                                color: Color(
                                                                    0xffD3D9EA), // Add this
                                                              ),
                                                              iconSize: 15.0,
                                                              hint:
                                                                  _status ==
                                                                          null
                                                                      ? Text(
                                                                          'Change',
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        )
                                                                      : Text(
                                                                          _status,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                        ),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .blue),
                                                              items: [
                                                                'open',
                                                                'confirmed',
                                                                'rented',
                                                                'closed'
                                                              ].map(
                                                                (val) {
                                                                  return DropdownMenuItem<
                                                                      String>(
                                                                    value: val,
                                                                    child: Text(
                                                                      val,
                                                                      textScaleFactor:
                                                                          1.0,
                                                                    ),
                                                                  );
                                                                },
                                                              ).toList(),
                                                              onChanged: (val) {
                                                                setState(
                                                                  () {
                                                                    _status =
                                                                        val;
                                                                  },
                                                                );
                                                                _addPropertyRequest(
                                                                    context);
                                                              },
                                                            ))),
                                                    details['enquiry_id']
                                                                ['status'] ==
                                                            "closed"
                                                        ? new Container()
                                                        : IconButton(
                                                            icon: Icon(
                                                              Icons.edit,
                                                            ),
                                                            iconSize: 20,
                                                            color: Colors.white,
                                                            splashColor:
                                                                Colors.purple,
                                                            onPressed: () {
                                                              setState(() {
                                                                showStatus =
                                                                    !showStatus;
                                                              });
                                                            },
                                                          ),
                                                  ]),
                                                  Text(
                                                    'Time Spent: ' +
                                                        details['enquiry_id']
                                                                ['timeSpent']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ]),
                                            details['enquiry_id']['status'] !=
                                                    'open'
                                                ? new Container()
                                                : InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        id = details["_id"];
                                                      });
                                                      CommonUtils
                                                          .showConfirmationDialog(
                                                              context,
                                                              "Do you want to delete this Schedule?",
                                                              "Yes", () async {
                                                        _deleteRequest(context);
                                                      }, "No", () {});
                                                    },
                                                    child: new Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          new Image.asset(
                                                            'assets/images/Group 136.png',
                                                            width: 29.0,
                                                            height: 39.0,
                                                          ),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 20),
                                                              child: Text(
                                                                'Delete\nSchedule',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        10,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal),
                                                              ))
                                                        ])),
                                          ])),
                                ]),
                          ))
                    ])),
                Padding(
                    padding: EdgeInsets.only(top: 20.0, right: 10),
                    child: Container(
                        height: 88,
                        width: MediaQuery.of(context).size.width / 1.1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(21),
                            color: Color(0xff2E809A)),
                        child: Padding(
                            padding: EdgeInsets.only(left: 30.0, right: 30),
                            child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  new Image.asset(
                                    'assets/images/Vector (13) copy 4.png',
                                    width: 21.0,
                                    height: 28.0,
                                  ),
                                  Padding(
                                      padding: EdgeInsets.only(right: 100),
                                      child: Text(
                                        details['enquiry_id']['preference']
                                            ['address'],
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Roboto"),
                                      )),
                                  new Image.asset(
                                    'assets/images/Group 6 (2).png',
                                    width: 25.0,
                                    height: 25.0,
                                  ),
                                ])))),
              ])),
        )
      ],
    );
  }
  /* 
    void selectionChanged(DateRangePickerSelectionChangedArgs args) {
      int firstDayOfWeek = DateTime.sunday % 7;
      int endDayOfWeek = (firstDayOfWeek - 1) % 7;
      endDayOfWeek = endDayOfWeek < 0 ? 7 + endDayOfWeek : endDayOfWeek;
      PickerDateRange ranges = args.value;
      DateTime date1 = ranges.startDate;
      DateTime date2 = ranges.endDate ?? ranges.startDate;
      if (date1.isAfter(date2)) {
        var date = date1;
        date1 = date2;
        date2 = date;
      }
      int day1 = date1.weekday % 7;
      int day2 = date2.weekday % 7;

      DateTime dat1 = date1.add(Duration(days: (firstDayOfWeek - day1)));
      DateTime dat2 = date2.add(Duration(days: (endDayOfWeek - day2)));

      if (!isSameDate(dat1, ranges.startDate) ||
          !isSameDate(dat2, ranges.endDate)) {
        _controller.selectedRange = PickerDateRange(dat1, dat2);
      } else {
        setState(() {
          _currentSelected = dat1;
          _currentSelected2 = dat2;
        });

        getScheduleData();
      }
    } */

  /* bool isSameDate(DateTime date1, DateTime date2) {
      if (date2 == date1) {
        return true;
      }
      if (date1 == null || date2 == null) {
        return false;
      }
      setState(() {
        _currentSelected = date1;
        _currentSelected2 = date2;
      });
      getScheduleData();
      return date1.month == date2.month &&
          date1.year == date2.year &&
          date1.day == date2.day;
    } */
  /* 
    Widget _getCalenderWidget() {
      return CalendarCarousel<Event>(
        onDayPressed: (DateTime date, List<Event> events) {
          setState(() {
            _currentSelected = date;
            _currentSelected2 = date;
          });
          getScheduleData();
        },
        headerMargin: EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 5),
        selectedDateTime: _currentSelected,
        selectedDayBorderColor: FFF2E809A,
        iconColor: FFF2E809A,
        weekFormat: false,
        minSelectedDate: DateTime.now().add(Duration(days: -1)),
        maxSelectedDate: DateTime.now().add(Duration(days: 30)),
        todayBorderColor: Colors.transparent,
        todayButtonColor: Colors.transparent,
        todayTextStyle: Style.getRobotoTextStyle(
          FF212962,
          11,
        ),
        weekendTextStyle: Style.getRobotoTextStyle(
          FF19A517,
          11,
        ),
        daysTextStyle: Style.getRobotoTextStyle(
          FF212962,
          11,
        ),
        headerTextStyle: Style.getRobotoTextStyle(
          FF212962,
          14,
        ),
        prevDaysTextStyle: Style.getRobotoTextStyle(
          FFD9D9D9,
          11,
        ),
        nextDaysTextStyle: Style.getRobotoTextStyle(
          FFD9D9D9,
          11,
        ),
        weekdayTextStyle:
            Style.getRobotoTextStyle(FFF2E809A, 11, fontWeight: FontWeight.w900),
        customDayBuilder: (
          /// you can provide your own build function to make custom day containers
          bool isSelectable,
          int index,
          bool isSelectedDay,
          bool isToday,
          bool isPrevMonthDay,
          TextStyle textStyle,
          bool isNextMonthDay,
          bool isThisMonthDay,
          DateTime day,
        ) {
          if (day.day == _currentSelected.day &&
              day.month == _currentSelected.month &&
              day.year == _currentSelected.year) {
            return Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: FFF2E809A,
              ),
              child: Style.getRobotoNormalText("${day.day}", 11, FFF2E809E),
            );
          } else {
            return null;
          }
        },
      );
    } */

  _launchCaller() async {
    var phone = "tel:" + _phone;
    var url = phone;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _displayPhoneDialog(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Center(
              child: ElevatedButton.icon(
                onPressed: _launchCaller,
                label: Text(
                  'Call for confirmation',
                  style: TextStyle(color: Colors.black),
                ),
                icon: Icon(
                  Icons.phone,
                  color: Colors.black,
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.white, // background
                  onPrimary: Colors.white,
                ),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text('OK',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xff3d74c9), // background
                          onPrimary: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          _launchCaller();
                          Navigator.of(context).pop();
                        },
                      ),
                      ElevatedButton(
                        child: Text('Cancel',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            )),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // background
                          onPrimary: Colors.white,
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ])
              ],
            ),
          );
        });
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: new DateTime(2090));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      this.getScheduleDateViseData();
    }

    //  Navigator.of(context, rootNavigator: true).pop();
  }

  _enquiryDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: new IconButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: new Icon(
                        Icons.cancel,
                        color: Color(0xff212962),
                        size: 30.0,
                      ),
                    ),
                  ),
                  Center(child: Text("Schedule For")),
                  Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Center(
                          child: RaisedButton(
                        onPressed: () {
                          NavigationUtil.pushToNewScreen(
                              context, EnquiryPage());
                        },
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0.0),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(80.0)),
                        child: Container(
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: <Color>[
                                  Color(0xFF89D9F2),
                                  Color(0xFF2E879A),
                                ],
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('New Enquiry',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal)),
                              ]),
                        ),
                      ))),
                  Center(
                      child: RaisedButton(
                    onPressed: () {
                      NavigationUtil.pushToNewScreen(
                          context, ExistingEnquiryPage());
                    },
                    textColor: Colors.white,
                    padding: const EdgeInsets.all(0.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(80.0)),
                    child: Container(
                      decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF314498),
                              Color(0xFF2E879A),
                            ],
                          ),
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Existing Enquiry',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal)),
                          ]),
                    ),
                  ))
                ],
              ),
            ),
          );
        });
  }

  _displayDialog1(BuildContext context, String url) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            contentPadding: EdgeInsets.all(1.0),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0))),
            content: Image(
              image: NetworkImage(url),
              fit: BoxFit.fill,
            ),
          );
        });
  }

  Widget _tabSection(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 35.0),
        child: Container(
          child: showProgressloading == true
              ? Center(
                  child: SizedBox(
                  width: 20,
                  height: 20,
                  child: new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xff212962)),
                      strokeWidth: 2.0),
                ))
              : scheduleList.length != 0
                  ? ListView.builder(
                      // Let the ListView know how many items it needs to build.
                      itemCount: scheduleList.length,
                      // Provide a builder function. This is where the magic happens.
                      // Convert each item into a widget based on the type of item it is.
                      itemBuilder: (context, index) {
                        final item = scheduleList[index];
                        var date0 = DateFormat("MMMM dd, yyyy")
                            .format(DateTime.parse(item['date']));
                        var date = DateFormat("h:mm a")
                            .format(DateTime.parse(item['start_time']));
                        var date1 = DateFormat("h:mm a")
                            .format(DateTime.parse(item['end_time']));
                        var date3 = item['alt_start_time'] != null
                            ? DateFormat("h:mm a")
                                .format(DateTime.parse(item['alt_start_time']))
                            : null;
                        var date4 = item['alt_start_time'] != null
                            ? DateFormat("h:mm a")
                                .format(DateTime.parse(item['alt_end_time']))
                            : null;
                        return Column(
                          children: <Widget>[
                            ListTile(
                              title: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                        onTap: () {
                                          setState(() {
                                            details = item;
                                            _hasBeenPressed = false;
                                          });
                                        },
                                        child: Padding(
                                            padding: EdgeInsets.only(
                                                right: 10, left: 0),
                                            child: Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                10.0)),
                                                    border: Border.all(
                                                      color: Colors.white,
                                                      width: 2,
                                                    )),
                                                child: InkWell(
                                                  child: item['property_id']
                                                                  ['images']
                                                              .length ==
                                                          0
                                                      ? Center(
                                                          child: Text(
                                                          item['property_id']
                                                              ['name'][0],
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              fontSize: 28.0,
                                                              color: Color(
                                                                  0xff314498),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Roboto"),
                                                        ))
                                                      : ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.0),
                                                          child: Image.network(
                                                            item['property_id']
                                                                ['images'][0],
                                                            fit: BoxFit.cover,
                                                          )),
                                                  onTap: () {
                                                    setState(() {
                                                      if (item['property_id']
                                                                  ['images']
                                                              .length !=
                                                          0) {
                                                        _zoomImage =
                                                            item['property_id']
                                                                ['images'][0];
                                                        _displayDialog1(context,
                                                            _zoomImage);
                                                      }
                                                    });
                                                  },
                                                )))),
                                    Column(
                                      children: [
                                        Container(
                                          width: 130,
                                          child: Text(
                                              item['enquiry_id'] != null
                                                  ? item['enquiry_id']['name']
                                                      .toUpperCase()
                                                  : "",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Color(0xff314498),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        Container(
                                          width: 130,
                                          child: Text(date0,
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  color: Color(0xff314498),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500)),
                                        ),
                                        item['slot'] == "main"
                                            ? Container(
                                                width: 130,
                                                child: Text(
                                                    "$date" + " - " + date1,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff314498),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              )
                                            : Container(
                                                width: 130,
                                                child: Text(
                                                    "$date3" + " - " + date4,
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff314498),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ),
                                        Container(
                                            width: 130,
                                            child: Row(
                                              children: [
                                                Text("Status:",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xff314498),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                                Text(
                                                    item['enquiry_id'] != null
                                                        ? item['enquiry_id']
                                                            ['status']
                                                        : "",
                                                    textScaleFactor: 1.0,
                                                    style: TextStyle(
                                                        color: item['enquiry_id'] !=
                                                                null
                                                            ? item['enquiry_id']
                                                                        [
                                                                        'status'] ==
                                                                    'open'
                                                                ? Colors.green
                                                                : Color(
                                                                    0xff314498)
                                                            : Color(0xff314498),
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500)),
                                              ],
                                            )),
                                      ],
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _phone =
                                              item['enquiry_id']['phone_no'];
                                        });
                                        _displayPhoneDialog(context);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 20, left: 10),
                                        child: new Icon(
                                          Icons.call,
                                          color: FFF2E809A,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          id = item["_id"];
                                        });
                                        CommonUtils.showConfirmationDialog(
                                            context,
                                            "Do you want to delete this Schedule?",
                                            "Yes", () async {
                                          _deleteRequest(context);
                                        }, "No", () {});
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: 30, left: 10),
                                        child: new Icon(
                                          Icons.cancel_rounded,
                                          color: FFF2E809A,
                                          size: 20.0,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: new Icon(
                                        Icons.more_horiz_rounded,
                                        color: FFF2E809A,
                                        size: 20.0,
                                      ),
                                      onTap: () {
                                        setState(() {
                                          details = item;
                                          _hasBeenPressed = false;
                                        });
                                      },
                                    )
                                  ]),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 10, left: 10),
                                child:
                                    Divider()), //                           <-- Divider
                          ],
                        );
                        //
                      },
                    )
                  : Center(
                      child: Text("No Schedule",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Color(0xff314498),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ),
        ));
  }

  /* 
    yearMonthPicker() => Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Builder(builder: (context) {
              if (MediaQuery.of(context).orientation == Orientation.portrait) {
                return IntrinsicWidth(
                  child: Column(children: [
                    buildHeader(),
                    Material(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [buildPager()],
                      ),
                    )
                  ]),
                );
              }
              return IntrinsicHeight(
                child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildHeader(),
                      Material(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [buildPager()],
                        ),
                      )
                    ]),
              );
            }),
          ],
        ); */
  /* buildHeader() {
      return Material(
        color: Color(0xffF0F6FB),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_up, color: Colors.black),
                    onPressed: () => pageController.animateToPage(
                        displayedYear - 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut),
                  ),
                  Text('${DateFormat.yMMM().format(selectedDate)}'),
                  /* Text('${DateFormat.y().format(DateTime(displayedYear))}',
                      style: TextStyle(color: Colors.black)), */
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.black),
                    onPressed: () => pageController.animateToPage(
                        displayedYear + 1,
                        duration: Duration(milliseconds: 400),
                        curve: Curves.easeInOut),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } */
  /* 
    buildPager() => Container(
          color: Color(0xffF0F6FB),
          height: 220.0,
          width: 500.0,
          child: Theme(
              data: Theme.of(context).copyWith(
                  buttonTheme: ButtonThemeData(
                      padding: EdgeInsets.all(0.0),
                      shape: CircleBorder(),
                      minWidth: 1.0)),
              child: PageView.builder(
                controller: pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: (index) {
                  setState(() {
                    displayedYear = index;
                  });
                },
                itemBuilder: (context, year) {
                  return GridView.count(
                    padding: EdgeInsets.all(0.0),
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 5,
                    children: List<int>.generate(12, (i) => i + 1)
                        .map((month) => DateTime(year, month))
                        .map(
                          (date) => Padding(
                            padding: EdgeInsets.all(15.0),
                            child: FlatButton(
                              onPressed: () {
                                DateTime lastDayOfMonth =
                                    new DateTime(date.year, date.month + 1, 0);

                                var newDate1 =
                                    new DateTime(date.year, date.month, date.day);
                                var date1 =
                                    DateFormat("yyyy-MM-dd").format(newDate1);
                                var date2 = DateFormat("yyyy-MM-dd")
                                    .format(lastDayOfMonth);
                                setState(
                                  () {
                                    selectedDate =
                                        DateTime(date.year, date.month);
                                    _currentSelected = DateTime.parse(date1);
                                    _currentSelected2 = DateTime.parse(date2);
                                  },
                                );
                                getScheduleData();
                              },
                              color: date.month == selectedDate.month &&
                                      date.year == selectedDate.year
                                  ? Color(0xff2E809A)
                                  : null,
                              textColor: date.month == selectedDate.month &&
                                      date.year == selectedDate.year
                                  ? Colors.white
                                  : date.month == DateTime.now().month &&
                                          date.year == DateTime.now().year
                                      ? Color(0xff2E809A)
                                      : null,
                              child: Text(
                                DateFormat.MMM().format(date),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  );
                },
              )),
        );
  */
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffF0F6FB),
      systemNavigationBarDividerColor: Colors.black,
    ));
    //  Size size = MediaQuery.of(context).size;
    //double remainingHeight = size.height - 475;
    return Scaffold(
        bottomNavigationBar: CommonWidgets.getAppBottomTab(context),
        backgroundColor: Color(0xffF0F6FB),
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 60, left: 5),
          height: MediaQuery.of(context).size.height,
          child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Column(children: <Widget>[
                Container(
                    child: new Column(children: <Widget>[
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                elevation: 0,
                                color: Color(0xffF0F6FB),
                                /*    disabledColor:
                                                      Color(0xff2E809A),
                                                  disabledTextColor: Colors.white, */
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed = true;
                                  });
                                },
                                child: Text(
                                  'Schedules',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 36,
                                      color: _hasBeenPressed == true
                                          ? Color(0xff2E809A)
                                          : Colors.grey),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 25,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Color(0xff2E809A),
                                onPressed: () => _selectDate(context),
                                child: Text(
                                  selectedDate != null
                                      ? DateFormat("dd-MM-yyyy")
                                          .format(selectedDate)
                                      : 'Select Date',
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            )),
                      ]),
                  /*  _hasBeenPressed == true
                        ? Container(
                            height:
                                remainingHeight >= 290 ? remainingHeight : 300,
                            padding: EdgeInsets.only(top: 0, bottom: 0),
                            child: _getCalenderWidget(),
                          )
                        : Container(), */
                  _hasBeenPressed == true
                      ? Padding(
                          padding:
                              EdgeInsets.only(right: 10, left: 10, bottom: 10),
                          child: Container(
                              height: MediaQuery.of(context).size.height / 1.4,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Color(0xffE2F0FC)),
                              child: _tabSection(context)))
                      : _tabSection2(context)
                ])),
              ])),
        ),
        floatingActionButton: _hasBeenPressed == true
            ? new FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.person_add),
                backgroundColor: new Color(0xFFE2E809A),
                onPressed: () {
                  _enquiryDialog(context);
                })
            : new Container());
  }
}
