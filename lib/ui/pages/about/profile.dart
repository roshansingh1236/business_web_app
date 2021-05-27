import 'dart:convert';
import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:bussiness_web_app/bloc/user/user_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/team/add_team.dart';
import 'package:bussiness_web_app/ui/pages/team/team_details.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bussiness_web_app/utils/navigation_util.dart';

class ProfilePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ProfilePage> {
  UserRepository userRepository;
  String token = '';
  String _name;
  String _logo;
  String _address;
  String _email;
  String _gst;
  String _pan;
  String _phone;
  String _type;
  String _role;
  String _fin;
  String _cea;
  bool showEdit = false;
  // ignore: deprecated_member_use
  List _configList1 = List();
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/vendor/business/vid';
  static final _updateBusinessUrl = _baseUrl + '/vendor/update/business';
  static final orgUrl = _baseUrl + '/organisation';
  static final _memberUrl = _baseUrl + '/vendor-team';
  static final _vendorUrl = _baseUrl + '/vendor/getdetails';
  List organisationId = [];
  String _vid;
  List org = [];
  String _mySelection2;
  //api calling for get Apt
  Future<String> getBusiness() async {
    var res = await http.get(Uri.encodeFull(_businessUrl + "?mode=vendor"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['data'];
          setState(() {
            _name = resBody['entityName'];
            _logo = resBody['businessLogo']['path'];
            _gst = resBody['gstNumber'];
            _pan = resBody['panNumber'];
            _address = resBody['address'];
            _email = resBody['email'];
            _phone = resBody['vendor_id'][0]['phone'];
            _type = resBody['businessType'];
            _vid = resBody['business_id'];
            _role = resBody['vendorRole'];
            _fin = resBody['finNumber'];
            _cea = resBody['ceaNumber'];
          });
          organisationId = resBody['vendor_id'][0]['organisationId'];
          Cache.storage.setString('bussinessType', resBody['businessType']);
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

  _addBusinessRequest(BuildContext context) async {
    // set up POST request arguments
    // make POST request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token
    };

    final msg = jsonEncode({
      "organisationId": organisationId,
    });
    Response response =
        await put(_updateBusinessUrl, body: msg, headers: headers);

    // check the status code for the result
    int statusCode = response.statusCode;
    //print(response.body);
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      this.getBusiness();
    } else if (statusCode == 502) {
      Fluttertoast.showToast(
          msg: "Bad Gateway",
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
            _name = resBody['name'];
            _logo = resBody['photo'];
            _email = resBody['email'];
            _phone = resBody['phone'];
            _type = resBody['serviceType'];
            _address = resBody['businessType'];
            _gst = resBody['companyName'];
            _pan = resBody['vendorRole'];
          });
          organisationId = resBody['organisationId'];
          Cache.storage.setString('bussinessType', resBody['businessType']);
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
  Future<String> getMembers() async {
    var res = await http
        .get(Uri.encodeFull(_memberUrl), headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['vendorTeam'];

          _configList1 = resBody.toList();
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

  // api calling Apartment
  Future<String> getOrgData() async {
    var res = await http
        .get(Uri.encodeFull(orgUrl), headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['organisations'];
          //print(resBody);
          setState(() {
            org = resBody.toList();
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

  // api calling Apartment
  Future<String> getSingleOrgData() async {
    var res = await http.get(
        Uri.encodeFull(orgUrl + "?filter[_id]=" + _mySelection2),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['organisations'][0];
    // print(resBody);
    organisationId.add({"_id": resBody['_id'], "name": resBody['name']});
    this._addBusinessRequest(context);
    setState(() {});
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });

    Cache.storage.getString('vendorRole') == "teamMember"
        ? this.getVednorDetails()
        : this.getBusiness();
    this.getMembers();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffF0F6FB),
      systemNavigationBarDividerColor: Colors.black,
    ));
    return Scaffold(
        bottomNavigationBar: CommonWidgets.getAppBottomTab(context),
        appBar: CommonWidgets1.getAppBar(context),
        backgroundColor: Color(0xffF0F6FB),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(top: 5, left: 0),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Cache.storage.getString('vendorRole') == "teamMember"
                    ? Container(
                        child: new Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  new Container(
                                    height: 95,
                                    width: 95,
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
                                  new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 20.0),
                                            child: Text(
                                              "Member\nInformation",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 24.0,
                                                  color: Color(0xff2E809A),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            )),
                                      ]),
                                  new Image.asset(
                                    'assets/images/Group 109.png',
                                    width: 26.0,
                                    height: 30.0,
                                  ),
                                ])),
                        Container(
                            height: 323,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xffE2F0FC)),
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 10),
                                child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Business Name",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _name != null
                                                                ? _name
                                                                : "",
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
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Bussiness Type",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 16),
                                                          child: Text(
                                                            _address != null
                                                                ? _address
                                                                    .toUpperCase()
                                                                : "",
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
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Type",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _type != null
                                                                ? _type
                                                                : "",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Email",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _email != null
                                                                ? _email
                                                                : "",
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
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Phone",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                _phone != null
                                                                    ? "+" +
                                                                        _phone
                                                                    : "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
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
                                                              )))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Company Name",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _gst != null
                                                                ? _gst
                                                                : "",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Vendor Role",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _pan != null
                                                                ? _pan
                                                                : "",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          ))
                                                    ])),
                                          ]),
                                    ])))
                      ]))
                    : Container(
                        child: new Column(children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(bottom: 25.0),
                            child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    height: 95,
                                    width: 95,
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
                                  new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                            padding:
                                                EdgeInsets.only(right: 20.0),
                                            child: Text(
                                              "Business\nInformation",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 24.0,
                                                  color: Color(0xff2E809A),
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            )),
                                      ]),
                                ])),
                        Container(
                            height: 323,
                            width: MediaQuery.of(context).size.width / 1.12,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xffE2F0FC)),
                            child: Padding(
                                padding: EdgeInsets.only(left: 10.0, top: 10),
                                child: new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Name",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _name != null
                                                                ? _name
                                                                : "",
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
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Address",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 16),
                                                          child: Text(
                                                            _address != null
                                                                ? _address
                                                                    .toUpperCase()
                                                                : "",
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
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Type",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _type != null
                                                                ? _type
                                                                : "",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Role",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _role != null
                                                                ? _role
                                                                : "",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Email",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _email != null
                                                                ? _email
                                                                : "",
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
                                                          ))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "Phone",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Container(
                                                              alignment: Alignment
                                                                  .centerLeft,
                                                              child: Text(
                                                                _phone != null
                                                                    ? "+" +
                                                                        _phone
                                                                    : "",
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
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
                                                              )))
                                                    ])),
                                            Padding(
                                                padding:
                                                    EdgeInsets.only(top: 20),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: <Widget>[
                                                      Container(
                                                          width: 150,
                                                          child: new Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: <
                                                                  Widget>[
                                                                Text(
                                                                  "GST Number",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                ),
                                                                Text(
                                                                  "-",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .start,
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
                                                                )
                                                              ])),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 20),
                                                          child: Text(
                                                            _gst != null
                                                                ? _gst
                                                                : "",
                                                            textScaleFactor:
                                                                1.0,
                                                            textAlign:
                                                                TextAlign.start,
                                                            style: TextStyle(
                                                                fontSize: 12.0,
                                                                color: Color(
                                                                    0xff314498),
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontFamily:
                                                                    "Roboto"),
                                                          ))
                                                    ])),
                                            _cea != null
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: new Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                              width: 150,
                                                              child: new Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "CEA Number",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                    Text(
                                                                      "-",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    )
                                                                  ])),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          20),
                                                              child: Text(
                                                                _cea != null
                                                                    ? _cea
                                                                    : "",
                                                                textScaleFactor:
                                                                    1.0,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
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
                                                              ))
                                                        ]))
                                                : Container(),
                                            Cache.storage
                                                        .getString('country') ==
                                                    "India"
                                                ? Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: new Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                              width: 150,
                                                              child: new Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "PAN Number",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                    Text(
                                                                      "-",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    )
                                                                  ])),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          20),
                                                              child: Text(
                                                                _pan != null
                                                                    ? _pan
                                                                    : "",
                                                                textScaleFactor:
                                                                    1.0,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
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
                                                              ))
                                                        ]))
                                                : Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 20),
                                                    child: new Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: <Widget>[
                                                          Container(
                                                              width: 150,
                                                              child: new Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                    Text(
                                                                      "NRIC/FIN",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                    Text(
                                                                      "-",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .start,
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    )
                                                                  ])),
                                                          Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      right:
                                                                          20),
                                                              child: Text(
                                                                _fin != null
                                                                    ? _fin
                                                                    : "",
                                                                textScaleFactor:
                                                                    1.0,
                                                                textAlign:
                                                                    TextAlign
                                                                        .start,
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
                                                              ))
                                                        ])),
                                          ]),
                                    ])))
                      ])),
                organisationId != null
                    ? Padding(
                        padding: const EdgeInsets.only(left: 20, top: 0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Cache.storage.getString('vendorRole') !=
                                    "Agent/Owner"
                                ? new Container()
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                        Text("Added Organisation",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 17.0,
                                                color: Color(0xff314498),
                                                fontWeight: FontWeight.bold)),
                                        Cache.storage.getString('vendorRole') ==
                                                    "Agent/Owner" ||
                                                Cache.storage.getString(
                                                        'vendorRole') ==
                                                    "Real Estate Agent"
                                            ? IconButton(
                                                icon: Icon(
                                                  Icons.arrow_downward_outlined,
                                                  color: Colors.green,
                                                ),
                                                onPressed: () {
                                                  this.getOrgData();
                                                  setState(() {
                                                    showEdit = !showEdit;
                                                  });
                                                },
                                              )
                                            : new Container()
                                      ]),
                            showEdit == true
                                ? Padding(
                                    padding:
                                        EdgeInsets.only(right: 0.0, top: 0.0),
                                    child: FittedBox(
                                      child: Container(
                                        width: (MediaQuery.of(context)
                                                .size
                                                .width) /
                                            1.18,
                                        child: new Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              new DropdownButton(
                                                isDense: false,
                                                iconSize: 30.0,
                                                hint: new Text(
                                                    "Select Organisation",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12.0,
                                                        color:
                                                            Color(0xff314498),
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontFamily: "Roboto")),
                                                items: org.map((item) {
                                                  return new DropdownMenuItem(
                                                    child:
                                                        new Text(item['name']),
                                                    value: item['_id'],
                                                  );
                                                }).toList(),
                                                onChanged: (newVal) {
                                                  setState(() {
                                                    _mySelection2 = newVal;
                                                  });
                                                },
                                                value: _mySelection2,
                                              ),
                                              Padding(
                                                  padding:
                                                      EdgeInsets.only(top: 2.0),
                                                  child: IconButton(
                                                    icon: Icon(Icons
                                                        .check_circle_outline_outlined),
                                                    color: Colors.green,
                                                    onPressed: () {
                                                      if (_mySelection2 !=
                                                          null) {
                                                        this.getSingleOrgData();
                                                        setState(() {
                                                          _mySelection2 = null;
                                                        });
                                                      } else {
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "select organisation first",
                                                            toastLength: Toast
                                                                .LENGTH_SHORT,
                                                            gravity:
                                                                ToastGravity
                                                                    .CENTER);
                                                      }
                                                    },
                                                  )),
                                            ]),
                                      ),
                                    ))
                                : new Container(),
                            organisationId.length == 0
                                ? new Container()
                                : Padding(
                                    padding: EdgeInsets.only(left: 50.0),
                                    child: new Container(
                                      width:
                                          (MediaQuery.of(context).size.width) /
                                              1.12,
                                      child: new SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: DataTable(
                                            columns: [
                                              DataColumn(
                                                  label: Text('Name',
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13))),
                                              DataColumn(
                                                  label: Text('Action',
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                          fontSize: 13))),
                                            ],
                                            rows:
                                                organisationId // Loops through dataColumnText, each iteration assigning the value to element
                                                    .map(
                                                      ((element) => DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(Text(
                                                                  element[
                                                                      "name"],
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal,
                                                                      fontSize:
                                                                          18))),
                                                              //Extracting from Map element the value
                                                              DataCell(Cache
                                                                          .storage
                                                                          .getString(
                                                                              'vendorRole') !=
                                                                      "teamMember"
                                                                  ? IconButton(
                                                                      icon:
                                                                          Icon(
                                                                        Icons
                                                                            .cancel_outlined,
                                                                        color: Colors
                                                                            .red,
                                                                      ),
                                                                      onPressed:
                                                                          () {
                                                                        organisationId
                                                                            .forEach((userDetail) {
                                                                          if (userDetail["_id"]
                                                                              .contains((element['_id']))) {
                                                                            organisationId.removeWhere((item) =>
                                                                                userDetail["_id"] ==
                                                                                item['_id']);
                                                                          }
                                                                          _addBusinessRequest(
                                                                              context);
                                                                        });
                                                                      },
                                                                    )
                                                                  : new Container()),
                                                            ],
                                                          )),
                                                    )
                                                    .toList(),
                                          )),
                                    )),
                          ],
                        ))
                    : new Container(),
                Cache.storage.getString('vendorRole') != "Agent/Owner"
                    ? new Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 30, top: 30),
                        child: Text(
                          "Team Members",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 12.0,
                              color: Color(0xff2E809A),
                              fontWeight: FontWeight.w500,
                              fontFamily: "Roboto"),
                        )),
                Cache.storage.getString('vendorRole') != "Agent/Owner"
                    ? new Container()
                    : Padding(
                        padding: EdgeInsets.only(left: 15, top: 20),
                        child: new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                width: _configList1.length != 0
                                    ? MediaQuery.of(context).size.width / 1.4
                                    : 0,
                                height: 79,
                                child: ListView.builder(
                                    physics: ClampingScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _configList1.length,
                                    itemBuilder: (BuildContext context,
                                            int i) =>
                                        Padding(
                                            padding: EdgeInsets.only(left: 15),
                                            child: new InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        TeamDetailsPage(
                                                      id: _configList1[i]
                                                          ["_id"],
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: new Stack(
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                100)),
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 79,
                                                      height: 79,
                                                      color: Color(0xff2E809A),
                                                      child: _configList1[i]
                                                                  ["photo"] !=
                                                              "No Image"
                                                          ? CircleAvatar(
                                                              radius: 60,
                                                              backgroundImage:
                                                                  NetworkImage(
                                                                      _configList1[
                                                                              i]
                                                                          [
                                                                          "photo"]))
                                                          : Text(
                                                              _configList1[i][
                                                                          "name"] !=
                                                                      null
                                                                  ? _configList1[
                                                                              i]
                                                                          [
                                                                          'name']
                                                                      .toUpperCase()
                                                                      .toUpperCase()
                                                                  : "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 30),
                                                            ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ))),
                              ),
                              Expanded(
                                child: Align(
                                    alignment: FractionalOffset.bottomRight,
                                    child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: 0.0, left: 0, right: 15),
                                        child: SizedBox(
                                            width: 79,
                                            height: 79,
                                            child: MaterialButton(
                                              onPressed: () {
                                                NavigationUtil.pushToNewScreen(
                                                    context, TeamPage());
                                              },
                                              color: Color(0xff2E809A),
                                              textColor: Colors.white,
                                              child: Icon(
                                                Icons.add,
                                                size: 30,
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.all(0),
                                              shape: CircleBorder(),
                                            )))),
                              ),
                            ])),
              ]),
        )));
  }
}
