import 'dart:convert';
import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/pages/agent/schedule.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/animations/fade_animation.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';

class ExistingEnquiryPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ExistingEnquiryPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final configUrl = _baseUrl + '/global-config';
  static final propertyUrl = _baseUrl + '/property/enquiry';
  static final scheduleUrl = _baseUrl + '/property/schedule';
  static final property1Url = _baseUrl + '/property';
  bool _hasBeenPressed = false;
  String _date = 'rent';
  var newDate;
  final format = DateFormat("yyyy-MM-dd");
  var format1 = TimeOfDay.now();
  DateTime selectedDate;
  var format2;
  var format3;
  String _dropDownValue;
  var productName = TextEditingController();
  var phone = TextEditingController();
  var email = TextEditingController();
  var rentPrice = TextEditingController();
  var sellingPrice = TextEditingController();
  var rentPrice1 = TextEditingController();
  var sellingPrice1 = TextEditingController();
  var sizeName = TextEditingController();
  var address = TextEditingController();
  var noOfBedroom = TextEditingController();
  var noOfBathroom = TextEditingController();
  String _selectProperty;
  String token = '';
  bool showProgressloading = false;
  List _unitList = [];
  List property = [];
  String _unitType;
  bool access = false;
  String _enquiryId;
  String formattedTime;
  String formattedTime1;
  String countryCode = "IN";
  String _selectBussinessId;
  var _phone;
  bool _validate = false;
  List _enquiryList = [];
  List _propertyList = [];
  List _configList = [];
  bool _show = false;
  String _property;
  String _type;
  String _enquiry;
  final RegExp phoneRegex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');
  Future<String> getUnitTypeData() async {
    var res = await http.get(
        Uri.encodeFull(configUrl + "?filter[key]=unit_type"),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['globalConfigs'];
    // loop through the json object
    // loop through the json object
    resBody.forEach((value) {
      _unitList = value['value'];
    });
    setState(() {});
    return "Sucess";
  }

  Future<String> getPropertyData() async {
    var res = await http.get(
        Uri.encodeFull(
            property1Url + "?filter[status]=open&filter[status]=confirmed"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['property'];
          // loop through the json object
          // loop through the json object
          _propertyList = resBody;
          setState(() {});
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

  Future<String> getEnquiryData() async {
    var res = await http
        .get(Uri.encodeFull(propertyUrl), headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['enquiry'];
          // loop through the json object
          // loop through the json object
          _enquiryList = resBody;
          setState(() {});
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

  Future<String> getConfigData() async {
    var res = await http.get(Uri.encodeFull(configUrl + "?filter[key]=type"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['globalConfigs'];
          // loop through the json object
          // loop through the json object
          resBody.forEach((value) {
            _configList = value['value'];
          });
          this.getUnitTypeData();
          setState(() {});
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

  _addPropertyRequest(BuildContext context) async {
    // set up POST request arguments
    setState(() {
      showProgressloading = true;
    });
    final msg1 = _date == "rent"
        ? jsonEncode({
            "name": productName.text,
            "type": _date,
            "phone_no": phone.text,
            "email": email.text,
            "preference": {
              "size": int.parse(sizeName.text),
              "rent_start_price": int.parse(rentPrice.text),
              "rent_end_price": int.parse(rentPrice1.text),
              "address": address.text,
              "no_bedroom": _unitType,
              "no_bathroom": noOfBathroom.text,
              "type": _type
            },
            "property_id": [
              {"id": _selectProperty, "businessId": _selectBussinessId}
            ]
          })
        : jsonEncode({
            "name": productName.text,
            "type": _date,
            "phone_no": phone.text,
            "email": email.text,
            "preference": {
              "size": sizeName.text,
              "selling_start_price": sellingPrice.text,
              "selling_end_price": sellingPrice1.text,
              "address": address.text,
              "no_bedroom": _unitType,
              "no_bathroom": noOfBathroom.text,
              "type": _type
            },
            "property_id": [
              {"id": _selectProperty, "businessId": _selectBussinessId}
            ]
          });
    // make POST request
    final response = await http.post(propertyUrl, body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 201) {
      setState(() {
        _enquiryId = json.decode(response.body)['_id'];
        property = json.decode(response.body)['property_id'];
      });
      setState(() {
        showProgressloading = false;
      });
      if (property.length != 0) {
        _bottomSheetMore(context);
      } else {
        Fluttertoast.showToast(
            msg: "Please Select Property !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red);
      }
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      setState(() {
        showProgressloading = false;
      });
      var error = json.decode(response.body);
      Fluttertoast.showToast(
          msg: error["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    }
  }

  _addScheduleRequest(BuildContext context) async {
    // set up POST request arguments
    setState(() {
      showProgressloading = true;
    });
    DateTime duration1;
    DateTime duration2;
    var date3 = newDate + " " + formattedTime;
    var date4 = formattedTime1 != null ? newDate + " " + formattedTime1 : null;
    if (_dropDownValue == '0.5 hr.') {
      duration1 = DateTime.parse(date3).add(new Duration(minutes: 30));
      duration2 = formattedTime1 != null
          ? DateTime.parse(date4).add(new Duration(minutes: 30))
          : null;
    } else if (_dropDownValue == '1.5 hr.') {
      duration1 = DateTime.parse(date3).add(new Duration(minutes: 90));
      duration2 = formattedTime1 != null
          ? DateTime.parse(date4).add(new Duration(minutes: 90))
          : null;
    } else if (_dropDownValue == '10 min.') {
      duration1 = DateTime.parse(date3).add(new Duration(minutes: 10));
      duration2 = formattedTime1 != null
          ? DateTime.parse(date4).add(new Duration(minutes: 10))
          : null;
    } else if (_dropDownValue == '20 min.') {
      duration1 = DateTime.parse(date3).add(new Duration(minutes: 20));
      duration2 = formattedTime1 != null
          ? DateTime.parse(date4).add(new Duration(minutes: 20))
          : null;
    } else {
      duration1 = DateTime.parse(date3)
          .add(new Duration(hours: int.parse(_dropDownValue)));
      duration2 = formattedTime1 != null
          ? DateTime.parse(date4)
              .add(new Duration(hours: int.parse(_dropDownValue)))
          : null;
    }
    final msg1 = formattedTime1 != null
        ? jsonEncode({
            "showDetails": access,
            "date": newDate + "T00:00:00.000Z",
            "start_time": newDate + "T" + formattedTime + ":00.000Z",
            "end_time": duration1.toIso8601String() + "Z",
            "alt_start_time": newDate + "T" + formattedTime1 + ":00.000Z",
            "alt_end_time": duration2.toIso8601String() + "Z",
            "property_id": _selectProperty,
            "enquiry_id": _enquiryId
          })
        : jsonEncode({
            "showDetails": access,
            "date": newDate + "T00:00:00.000Z",
            "start_time": newDate + "T" + formattedTime + ":00.000Z",
            "end_time": duration1.toIso8601String() + "Z",
            /*  "alt_start_time": newDate + "T" + formattedTime1 + ":00.000Z",
      "alt_end_time": duration2.toIso8601String() + "Z", */
            "property_id": _selectProperty,
            "enquiry_id": _enquiryId
          });
    // make POST request
    final response = await http.post(scheduleUrl, body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 201) {
      setState(() {
        showProgressloading = false;
      });
      Navigator.of(context, rootNavigator: true).pop();
      NavigationUtil.clearAllAndAdd(context, ListSchedulePage());
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      setState(() {
        showProgressloading = false;
      });
      var error = json.decode(response.body);
      Fluttertoast.showToast(
          msg: error["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    }
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: new DateTime(2090));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
    Navigator.of(context, rootNavigator: true).pop();
    _bottomSheetMore(context);
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    formattedTime =
        localizations.formatTimeOfDay(timePicked, alwaysUse24HourFormat: true);
    if (timePicked != null)
      setState(() {
        format2 = timePicked;
        newDate = '${format.format(selectedDate)}';
      });
    Navigator.of(context, rootNavigator: true).pop();
    _bottomSheetMore(context);
  }

  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    formattedTime1 =
        localizations.formatTimeOfDay(timePicked, alwaysUse24HourFormat: true);
    if (timePicked != null)
      setState(() {
        format3 = timePicked;
      });
    Navigator.of(context, rootNavigator: true).pop();
    _bottomSheetMore(context);
  }

  void _bottomSheetMore(context) {
    showModalBottomSheet(
      context: context,
      enableDrag: false,
      isDismissible: false,
      // backgroundColor: Colors.black,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (builder) {
        return WillPopScope(
            onWillPop: () => Future.value(false),
            child: new Container(
              padding: EdgeInsets.only(
                left: 5.0,
                right: 5.0,
                top: 5.0,
                bottom: 5.0,
              ),
              decoration: new BoxDecoration(
                  border: Border.all(color: Color(0xff212962), width: 2.0),
                  color: Colors.white,
                  borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(20.0),
                      topRight: const Radius.circular(20.0))),
              child: new Wrap(
                children: <Widget>[
                  new SingleChildScrollView(
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
                        Padding(
                            padding: EdgeInsets.only(left: 10),
                            child: Center(
                              child: Text(
                                  "Please Schedule for this enquiry & Choose property",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff919191),
                                    fontWeight: FontWeight.w500,
                                  )),
                            )),
                        property.length != 0
                            ? new ListTile(
                                title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: 0, left: 0, top: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    singleChildScrollViewListOfProperty(
                                                        context)
                                                  ],
                                                )),
                                          ])
                                    ])))
                            : new Container(),
                        Column(
                          children: [
                            new ListTile(
                                title: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                  Theme(
                                    data: ThemeData(
                                        primarySwatch: Colors.lightBlue),
                                    child: TextButton(
                                      onPressed: () => _selectDate(context),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            selectedDate != null
                                                ? Text(
                                                    "   " +
                                                        DateFormat(
                                                                "MMMM dd, yyyy")
                                                            .format(DateTime.parse(
                                                                "${selectedDate.toLocal()}"
                                                                        .split(
                                                                            ' ')[
                                                                    0])),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal))
                                                : Text("Select Date",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                            Icon(
                                              Icons.date_range_outlined,
                                              color: Color(0xff1C1C1C),
                                              size: 25,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Theme(
                                    data: ThemeData(
                                        primarySwatch: Colors.lightBlue),
                                    child: TextButton(
                                      onPressed: () {
                                        if (selectedDate != null) {
                                          _selectTime(context);
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "please select date first!",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.CENTER,
                                              backgroundColor: Colors.red);
                                        }
                                      },
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 0.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            format2 != null
                                                ? Text(
                                                    "   " +
                                                        format2.format(context),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal))
                                                : Text("   Start Time",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.normal)),
                                            Icon(
                                              Icons.timer,
                                              color: Color(0xff1C1C1C),
                                              size: 25,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ])),
                            new ListTile(
                                title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Theme(
                                  data: ThemeData(
                                      primarySwatch: Colors.lightBlue),
                                  child: TextButton(
                                    onPressed: () {
                                      if (selectedDate != null) {
                                        _selectTime2(context);
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "please select date first!",
                                            toastLength: Toast.LENGTH_SHORT,
                                            gravity: ToastGravity.CENTER,
                                            backgroundColor: Colors.red);
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 0.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          format3 != null
                                              ? Text(
                                                  "   " +
                                                      format3.format(context),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal))
                                              : Text("Alternate Time",
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                          Icon(
                                            Icons.timer,
                                            color: Color(0xff1C1C1C),
                                            size: 25,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                    width: 160,
                                    child: new Theme(
                                        data: ThemeData(
                                            primarySwatch: Colors.lightBlue),
                                        child: DropdownButton(
                                          hint: _dropDownValue == null
                                              ? Text('Duration',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal))
                                              : Text(_dropDownValue,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                          isExpanded: true,
                                          iconSize: 30.0,
                                          style: TextStyle(color: Colors.blue),
                                          items: [
                                            '10 min.',
                                            '20 min.',
                                            '0.5 hr.',
                                            '1 hr.',
                                            '1.5 hr.',
                                            '2 hr.'
                                          ].map(
                                            (val) {
                                              return DropdownMenuItem<String>(
                                                value: val,
                                                child: Text(val,
                                                    style: TextStyle(
                                                        color: Colors.blue)),
                                              );
                                            },
                                          ).toList(),
                                          onChanged: (val) {
                                            if (selectedDate != null &&
                                                formattedTime != null) {
                                              setState(
                                                () {
                                                  _dropDownValue = val;
                                                },
                                              );
                                              Navigator.of(context,
                                                      rootNavigator: true)
                                                  .pop();
                                              _bottomSheetMore(context);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "please select date,time!",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.CENTER,
                                                  backgroundColor: Colors.red);
                                            }
                                          },
                                        ))),
                              ],
                            )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  new Divider(
                    height: 10.0,
                  ),
                  new ListTile(
                    trailing: RaisedButton(
                      onPressed: () {
                        if (newDate != null && _selectProperty != null) {
                          _addScheduleRequest(context);
                        } else {
                          Fluttertoast.showToast(
                              msg: "please select date & time & Property",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                              backgroundColor: Colors.red);
                        }
                      },
                      padding: const EdgeInsets.all(0.0),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80.0)),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          gradient: LinearGradient(
                            colors: <Color>[
                              Color(0xFF89D9F2),
                              Color(0xFF2E879A),
                            ],
                          ),
                        ),
                        child: Text('SCHEDULE',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            )),
                      ),
                    ),
                    onTap: () async {
                      // Add Here
                    },
                  ),
                ],
              ),
            ));
      },
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
      countryCode = Cache.storage.getString('countryCode');
    });
    this.getConfigData();
    this.getUnitTypeData();
    this.getEnquiryData();
    this.getPropertyData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    super.dispose();
  }

  SingleChildScrollView singleChildScrollViewListOfProperty(context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: [
          for (var item1 in property)
            Padding(
                padding: EdgeInsets.only(left: 0, right: 10),
                child: Container(
                  height: 80,
                  width: 80.0,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    elevation: 5,
                    margin: EdgeInsets.all(0),
                    child: Stack(
                      children: <Widget>[
                        item1['id']['images'].length == 0
                            ? Center(
                                child: InkWell(
                                    onTap: () {
                                      setState(() {
                                        _selectProperty = item1['id']['_id'];
                                      });
                                      Navigator.of(context, rootNavigator: true)
                                          .pop();
                                      _bottomSheetMore(context);
                                    },
                                    child: Stack(children: <Widget>[
                                      new Image.asset(
                                        'assets/images/Vector.png',
                                        width: 40.0,
                                        height: 40.0,
                                      ),
                                    ])))
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    _selectProperty = item1['id']['_id'];
                                  });
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  _bottomSheetMore(context);
                                },
                                child: Stack(children: <Widget>[
                                  Image(
                                      image: NetworkImage(
                                          item1['id']['images'][0]),
                                      fit: BoxFit.fill,
                                      width: 80,
                                      height: 80),
                                ])),
                        _selectProperty == item1['id']['_id']
                            ? Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                    child: Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 25,
                                    ),
                                    onTap: () {}),
                              )
                            : new Container(),
                        Container(
                            child: Text(item1['id']['name'],
                                style: TextStyle(
                                    fontSize: 12, color: Colors.white)))
                      ],
                    ),
                  ),
                )),
          showProgressloading == true
              ? Center(
                  child: SizedBox(
                  width: 20,
                  height: 20,
                  child: new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Color(0xff212962)),
                      strokeWidth: 2.0),
                ))
              : new Container()
        ]));
  }

  Widget _balancepaymentTab(BuildContext context) {
    return Column(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _enquiry != null
              ? Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: Text(
                    'Select Enquiry',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: Color(0xff314498),
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ))
              : new Container(),
          Padding(
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: _type == null ? 10 : 0),
            child: DropdownButton(
              isExpanded: true,
              iconEnabledColor: Colors.black,
              hint: _enquiry == null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          Text(
                            'Select Enquiry',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff314498),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          Text(
                            _enquiry,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff314498),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
              iconSize: 30.0,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              style: TextStyle(color: Colors.black),
              items: _enquiryList.map((location) {
                return new DropdownMenuItem(
                  child: _enquiryList.length != 0
                      ? new Text(
                          location['name'] + "(+" + location['phone_no'] + ")")
                      : new Text("No Enquiry"),
                  value: location,
                );
              }).toList(),
              onChanged: (val) {
                try {
                  setState(
                    () {
                      _enquiry = val['name'];
                      productName.text = val['name'];
                      phone.text = val['phone_no'];
                      email.text = val['email'];
                      rentPrice.text =
                          val['preference']['rent_start_price'].toString();
                      rentPrice1.text =
                          val['preference']['rent_end_price'].toString();
                      sellingPrice.text =
                          val['preference']['selling_start_price'].toString();
                      sellingPrice1.text =
                          val['preference']['selling_end_price'].toString();
                      sizeName.text = val['preference']['size'].toString();
                      _date = val['type'];
                      _type = val['preference']['type'];
                      _unitType = val['preference']['no_bedroom'];
                      noOfBathroom.text =
                          val['preference']['no_bathroom'].toString();
                      address.text = val['preference']['address'];
                      _enquiryId = val['_id'];
                      _show = true;
                    },
                  );
                } catch (e) {
                  Navigator.of(context, rootNavigator: true).pop();
                  Fluttertoast.showToast(
                      msg: "there is somthing error please contact to admin",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      backgroundColor: Colors.red);
                }
              },
              //value: _type,
            ),
          ),
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _property != null
              ? Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 10.0),
                  child: Text(
                    'Select Property',
                    textScaleFactor: 1.0,
                    style: TextStyle(
                        color: Color(0xff314498),
                        fontSize: 10,
                        fontWeight: FontWeight.bold),
                  ))
              : new Container(),
          Padding(
            padding: EdgeInsets.only(
                left: 20.0, right: 20.0, top: _type == null ? 10 : 0),
            child: DropdownButton(
              isExpanded: true,
              iconEnabledColor: Colors.black,
              hint: _property == null
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          Text(
                            'Select Property',
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff314498),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ])
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                          Text(
                            _property,
                            textScaleFactor: 1.0,
                            style: TextStyle(
                                color: Color(0xff314498),
                                fontSize: 12,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
              iconSize: 30.0,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              style: TextStyle(color: Colors.black),
              items: _propertyList.map((location) {
                return new DropdownMenuItem(
                  child: _propertyList.length != 0
                      ? new Text(
                          location['name'] + "(" + location['type'] + ")")
                      : new Text("No Property"),
                  value: location,
                );
              }).toList(),
              onChanged: (val) {
                setState(
                  () {
                    _property = val['name'];
                    _selectProperty = val['_id'];
                    _selectBussinessId = val['businessId'];
                  },
                );
              },
              //value: _type,
            ),
          ),
        ],
      ),
      _show == false
          ? new Container()
          : Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
              child: TextFormField(
                controller: productName,
                textCapitalization: TextCapitalization.words,
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                      fontSize: 12.0,
                      color: Color(0xff314498),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              )),
      _show == false
          ? new Container()
          : Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
              child: intlPhoneField()),
      _show == false
          ? new Container()
          : Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
              child: textFormFieldEmail()),
      _show == false
          ? new Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                _date == 'rent'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Container(
                              width: 170,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: textFormFieldRentalPrice()),
                            ),
                            Container(
                              width: 170,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 0.0),
                                  child: textFormFieldRentalPrice1()),
                            )
                          ])
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                            Container(
                                width: 170,
                                child: Padding(
                                    padding: EdgeInsets.only(left: 20.0),
                                    child: textFormFieldSellingPrice())),
                            Container(
                                width: 170,
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.0, right: 20.0),
                                    child: textFormFieldSellingPrice1()))
                          ]),
              ],
            ),
      _show == false
          ? new Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _type != null
                        ? Padding(
                            padding: EdgeInsets.only(left: 20.0, top: 10.0),
                            child: Text(
                              'Property Type',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xff314498),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold),
                            ))
                        : new Container(),
                    Container(
                      width: 180,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 20.0,
                            right: 10.0,
                            top: _type == null ? 10 : 0),
                        child: DropdownButton(
                          isExpanded: true,
                          iconEnabledColor: Colors.black,
                          hint: _type == null
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                      Text(
                                        'Select Type',
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Color(0xff314498),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ])
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                      Text(
                                        _type,
                                        textScaleFactor: 1.0,
                                        style: TextStyle(
                                            color: Color(0xff314498),
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ]),
                          iconSize: 30.0,
                          icon: Icon(
                            Icons.arrow_drop_down,
                            color: Colors.black,
                          ),
                          style: TextStyle(color: Colors.black),
                          items: _configList.map((location) {
                            return new DropdownMenuItem(
                              child: new Text(location),
                              value: location,
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(
                              () {
                                _type = val;
                              },
                            );
                          },
                          value: _type,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _unitType != null
                          ? Padding(
                              padding: EdgeInsets.only(left: 10.0, top: 10.0),
                              child: Text(
                                'No. of Bedroom',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xff314498),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ))
                          : new Container(),
                      Container(
                          width: 140,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0, top: _unitType == null ? 10 : 0),
                            child: DropdownButton(
                              isExpanded: true,
                              iconEnabledColor: Colors.black,
                              hint: _unitType == null
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                          Text(
                                            'No. of Bedroom',
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Color(0xff314498),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ])
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                          Text(
                                            _unitType == "0"
                                                ? "Studio"
                                                : _unitType,
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                color: Color(0xff314498),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ]),
                              iconSize: 30.0,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.black,
                              ),
                              style: TextStyle(color: Colors.black),
                              items: _unitList.map((location) {
                                return new DropdownMenuItem(
                                  child: new Text(
                                    location == "0" ? "Studio" : location,
                                  ),
                                  value: location,
                                );
                              }).toList(),
                              onChanged: (val) {
                                setState(
                                  () {
                                    _unitType = val;
                                  },
                                );
                              },
                              value: _unitType,
                            ),
                          ))
                    ]),
              ],
            ),
      _show == false
          ? new Container()
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                    width: 170,
                    child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: TextFormField(
                          controller: noOfBathroom,
                          keyboardType: TextInputType.number,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter no. of Bathroom';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'No. of Bathroom',
                            labelStyle: TextStyle(
                                fontSize: 12.0,
                                color: Color(0xff314498),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"),
                          ),
                        ))),
                Container(
                    width: 170,
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                        child: textFormFieldSize())),
              ],
            ),
      _show == false
          ? new Container()
          : Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
              child: textFormFieldAddress()),
      /*     _show == false
          ? new Container()
          : Padding(
              padding: EdgeInsets.only(left: 10, right: 0, top: 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                alignment: Alignment(0.0, -1.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    themeShowDetails(),
                    Text(
                      "Show Details",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                        color: Color(0xff212962),
                      ),
                    ),
                  ],
                ),
              )), */
      _show == false
          ? new Container()
          : Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 20),
              child: FadeAnimation(
                  0,
                  Center(
                      child: SizedBox(
                    width: 234,
                    child: raisedButtonAddProperty(context),
                  ))))
    ]);
  }

  RaisedButton raisedButtonAddProperty(BuildContext context) {
    return RaisedButton(
      onPressed: () {
        _addPropertyRequest(context);
      },
      textColor: Colors.white,
      padding: const EdgeInsets.all(0.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: <Color>[
                Color(0xFF314498),
                Color(0xFF2E879A),
              ],
            ),
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          showProgressloading == true
              ? CircularProgressIndicator()
              : const Text('Update Enquiry', style: TextStyle(fontSize: 20)),
        ]),
      ),
    );
  }

/*   Theme themeShowDetails() {
    return Theme(
      data: ThemeData(unselectedWidgetColor: Color(0xff212962)),
      child: Checkbox(
        tristate: false,
        value: access,
        activeColor: Color(0xff212962),
        onChanged: (bool value) {
          setState(() {
            access = value;
          });
        },
      ),
    );
  } */

  TextFormField textFormFieldAddress() {
    return TextFormField(
      maxLines: 2,
      keyboardType: TextInputType.streetAddress,
      textCapitalization: TextCapitalization.words,
      controller: address,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter Preferred Area';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Enter Preferred Area',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
  }

  TextFormField textFormFieldSize() {
    return TextFormField(
      controller: sizeName,
      keyboardType: TextInputType.number,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter Size';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Size (in sqft.)',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
  }

  TextFormField textFormFieldSellingPrice1() {
    return TextFormField(
      controller: sellingPrice1,
      keyboardType: TextInputType.number,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter Saliing End Price';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: _date == 'buy'
            ? 'Saliing End Price'
            : 'Saliing End Price(optional)',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
  }

  TextFormField textFormFieldSellingPrice() {
    return TextFormField(
      controller: sellingPrice,
      keyboardType: TextInputType.number,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter Saliing Start Price';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: _date == 'buy'
            ? 'Saliing Start Price'
            : 'Saliing Start Pricee(optional)',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
  }

  TextFormField textFormFieldRentalPrice() {
    return TextFormField(
      controller: rentPrice,
      keyboardType: TextInputType.number,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter from start price';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: _date == 'rent' ? 'Start Price' : 'Start Price(optional)',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
  }

  TextFormField textFormFieldRentalPrice1() {
    return TextFormField(
      controller: rentPrice1,
      keyboardType: TextInputType.number,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter till end price';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: _date == 'rent' ? 'End Price' : 'End Price(optional)',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
  }

  TextFormField textFormFieldEmail() {
    return TextFormField(
      controller: email,
      keyboardType: TextInputType.emailAddress,
      validator: (input) {
        if (input.isEmpty) {
          return 'Please enter Email';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: 'Email',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
  }

  TextFormField intlPhoneField() {
    return TextFormField(
      enabled: false,
      validator: (value) {
        if (!phoneRegex.hasMatch(value)) {
          return 'Please enter valid phone number';
        }
        return null;
      },
      controller: phone,
      keyboardType: TextInputType.phone,
      onSaved: (phone) {
        setState(() {
          !phoneRegex.hasMatch(_phone) ? _validate = true : _validate = false;
        });
      },
      onChanged: (phone) {
        //when phone number country code is changed
        setState(() {
          _phone = phone;
        });

        //get complete number
        /* print(phone
                                                                  .countryCode); */ // get country code only
        // only phone number
      },
      decoration: InputDecoration(
        errorText: _validate ? 'Please fill the correct number!' : null,
        labelText: 'Phone',
        labelStyle: TextStyle(
            fontSize: 12.0,
            color: Color(0xff314498),
            fontWeight: FontWeight.bold,
            fontFamily: "Roboto"),
      ),
    );
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
        resizeToAvoidBottomInset: true,
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
                            Text(
                              "Enquiry",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 36.0,
                                  color: Color(0xff2E809A),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto"),
                            ),
                            new Image.asset(
                              'assets/images/Vector.png',
                              width: 60.0,
                              height: 55.0,
                            ),
                          ])),
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 21,
                              width: 70,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                elevation: 0,
                                color: _date == "rent"
                                    ? Color(0xff2E809A)
                                    : Color(0xffE2F0FC),
                                /*    disabledColor:
                                                          Color(0xff2E809A),
                                                      disabledTextColor: Colors.white, */
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed = !_hasBeenPressed;
                                    _date = "rent";
                                  });
                                },
                                child: Text(
                                  'Rent',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _date == "rent"
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 21,
                              width: 70,
                              child: RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: _date == "buy"
                                    ? Color(0xff2E809A)
                                    : Color(0xffE2F0FC),
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed = !_hasBeenPressed;
                                    _date = "buy";
                                  });
                                },
                                child: Text(
                                  'Buy',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _date == "buy"
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            )),
                      ]),
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xffE2F0FC)),
                          child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: _balancepaymentTab(context))))
                ])),
              ])),
        ));
  }
}
