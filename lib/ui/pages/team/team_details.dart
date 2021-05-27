import 'dart:convert';
import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:bussiness_web_app/bloc/user/user_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class TeamDetailsPage extends StatefulWidget {
  var id;
  TeamDetailsPage({Key key, this.id}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TeamDetailsPage> {
  UserRepository userRepository;
  String token = '';
  String _name;
  String _logo = 'No Image';
  String _email;
  String _joiningDate;
  String _phone;
  String _type;
  String vendorRole;
  // ignore: deprecated_member_use
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/vendor-team';
  //api calling for get Apt
  Future<String> getBusiness() async {
    print(_businessUrl + "?id=" + widget.id);
    var res = await http.get(Uri.encodeFull(_businessUrl + "?id=" + widget.id),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['vendorTeam'];
    setState(() {
      _name = resBody[0]['name'];
      _logo = resBody[0]['photo'];
      _joiningDate = DateFormat("dd-MM-yyyy")
          .format(DateTime.parse(resBody[0]['joiningDate']));
      _email = resBody[0]['email'];
      _phone = resBody[0]['phone'];
      _type = resBody[0]['serviceType'];
    });

    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWT" + " " + Cache.storage.getString('authToken');
    });
    this.getBusiness();
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
        body: Container(
          padding: const EdgeInsets.only(top: 5, left: 0),
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
                                  child: _logo != "No Image"
                                      ? CircleAvatar(
                                          radius: 50,
                                          backgroundImage: NetworkImage(_logo))
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
                                          padding: EdgeInsets.only(right: 20.0),
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
                                    new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            children: <Widget>[
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
                                                        ))
                                                  ])),
                                          Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            children: <Widget>[
                                                              Text(
                                                                "Service Type",
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
                                                          textScaleFactor: 1.0,
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
                                              padding: EdgeInsets.only(top: 20),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                            children: <Widget>[
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
                                                        ))
                                                  ])),
                                          Padding(
                                              padding: EdgeInsets.only(top: 20),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                            children: <Widget>[
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
                                                                  ? _phone
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
                                              padding: EdgeInsets.only(
                                                  top: 20, bottom: 20),
                                              child: new Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
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
                                                            children: <Widget>[
                                                              Text(
                                                                "Joining Date",
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
                                                          _joiningDate != null
                                                              ? _joiningDate
                                                              : "",
                                                          textScaleFactor: 1.0,
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
                    ])),
                  ])),
        ));
  }
}
