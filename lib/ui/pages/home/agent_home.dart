import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/style/colors.dart';
import 'package:bussiness_web_app/ui/pages/agent/schedule.dart';
import 'package:bussiness_web_app/ui/pages/notification/notification.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/common_util.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class AgentHomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<AgentHomePage> {
  String token = '';
  String _name;
  String id;
  String _logo;
  bool showProgressloading = false;
  String _zoomImage;
  List scheduleList = [];
  DateTime _currentSelected = DateTime.now();
  int _property = 0;
  int count_enq_succ = 0;
  int count_enq_wip = 0;
  int count_enq_new = 0;
  // ignore: deprecated_member_use
  List _configList = List();
  String _phone;
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/vendor/business/vid';
  static final scheduleUrl = _baseUrl + '/property/schedule';
  //api calling for get Apt

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

  Future<String> getBusiness() async {
    print(token);
    var res = await http
        .get(Uri.encodeFull(_businessUrl), headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['businessData'];
          _configList = resBody.toList();
          print(_configList);
          setState(() {
            _name = _configList[0]['entityName'];
            _logo = _configList[0]['businessLogo']['path'];
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
          return "Sucess";
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
                                            /*      details = item;
                                            _hasBeenPressed = false; */
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
                                        NavigationUtil.pushToNewScreen(
                                            context, ListSchedulePage());
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

  Future<String> getScheduleDateViseData() async {
    scheduleList = [];
    var date1 = DateFormat("yyyy-MM-dd").format(_currentSelected);
    var res = await http.get(
        Uri.encodeFull(
            scheduleUrl + "?filter[date][\$gte]=" + date1 + "T00:00:00.000Z"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          setState(() {
            _property = json.decode(res.body)['count_property'];
            count_enq_succ = json.decode(res.body)['count_enq_succ'];
            count_enq_wip = json.decode(res.body)['count_enq_wip'];
            count_enq_new = json.decode(res.body)['count_enq_new'];
          });
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

      getScheduleDateViseData();
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

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWT" + " " + Cache.storage.getString('authToken');
    });
    this.getBusiness();
    this.getScheduleDateViseData();
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
                    Container(
                        child: new Column(children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(bottom: 25.0),
                          child: new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                new Container(
                                  height: 87,
                                  width: 87,
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
                                      ? _logo != "No Image"
                                          ? CircleAvatar(
                                              radius: 50,
                                              backgroundImage:
                                                  NetworkImage(_logo))
                                          : Text(
                                              _name != null
                                                  ? _name[0].toUpperCase()
                                                  : "",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 58.0,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            )
                                      : Text(
                                          _name != null
                                              ? _name[0].toUpperCase()
                                              : "",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 58.0,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: "Roboto"),
                                        ),
                                ),
                                new Container(
                                  width: 200,
                                  child: Padding(
                                      padding: EdgeInsets.only(left: 0.0),
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
                                ),
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
                    ])),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                            width: 145,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xffeaeaea),
                              border: Border.all(
                                color: Color(0xff888888),
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Properties",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xff2E459A),
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Roboto"),
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    new Image.asset(
                                      'assets/images/Vector.png',
                                      width: 20.0,
                                      height: 29.0,
                                    ),
                                    Text(
                                      "$_property",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 30.0,
                                          color: Colors.red,
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Roboto"),
                                    ),
                                  ],
                                )
                              ],
                            )),
                        Container(
                            width: 193,
                            height: 75,
                            decoration: BoxDecoration(
                              color: Color(0xffeaeaea),
                              border: Border.all(
                                color: Color(0xff888888),
                                style: BorderStyle.solid,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Leads",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: Color(0xff2E459A),
                                          fontWeight: FontWeight.normal,
                                          fontFamily: "Roboto"),
                                    )),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "$count_enq_succ",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              color: Colors.green,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Roboto"),
                                        ),
                                        Text(
                                          "Success",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Roboto"),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "$count_enq_wip",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Roboto"),
                                        ),
                                        Text(
                                          "WIP",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Roboto"),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "$count_enq_new",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 30.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Roboto"),
                                        ),
                                        Text(
                                          "New",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 10.0,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal,
                                              fontFamily: "Roboto"),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ))
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 12.0, top: 20),
                            child: Text(
                              "Upcoming Schedules",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Roboto"),
                            )),
                        Padding(
                            padding: EdgeInsets.only(
                                left: 12.0, right: 12.0, top: 20),
                            child: Container(
                                height:
                                    MediaQuery.of(context).size.height / 2.2,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Color(0xff888888),
                                    style: BorderStyle.solid,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: _tabSection(context)))
                      ],
                    )
                  ])),
        ));
  }
}
