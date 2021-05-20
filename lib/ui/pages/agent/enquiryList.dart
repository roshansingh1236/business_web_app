import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/property/property_details.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bussiness_web_app/utils/navigation_util.dart';

import 'enquiry_for_property.dart';

class ListEnquiryPage extends StatefulWidget {
  var id;
  var bussinessId;
  ListEnquiryPage({Key key, this.id, this.bussinessId}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ListEnquiryPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final enquiryUrl = _baseUrl + '/property/enquiry';
  String token = '';
  bool showProgressloading = true;
  DateTime selectedDate;
  int displayedYear;
  List scheduleList = [];
  String type = 'rent';
  String _zoomImage;
  bool showStatus = false;
  String _status;
  String _id;
  Future<String> getScheduleData() async {
    setState(() {
      showProgressloading = true;
    });
    scheduleList = [];
    var res = await http.get(
        Uri.encodeFull(enquiryUrl +
            "?filter[property_id.id][\$in]=" +
            widget.id +
            "&filter[type]=" +
            type +
            "&sortBy[createdAt]=-1"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;

    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['enquiry'];
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
    final response =
        await http.put(enquiryUrl + "?id=" + _id, body: msg1, headers: {
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
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });
    getScheduleData();
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

  Widget _tabSection2(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          showProgressloading == true
              ? Center(
                  child: SizedBox(
                  width: 20,
                  height: 20,
                  child: new CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.black),
                      strokeWidth: 2.0),
                ))
              : new Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                              color: type == 'rent'
                                  ? Color(0xff2E809A)
                                  : Colors.white,
                              /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                              onPressed: () {
                                setState(() {
                                  type = 'rent';
                                });
                                getScheduleData();
                              },
                              child: Text(
                                'Rent',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: type != 'rent'
                                        ? Color(0xff2E809A)
                                        : Colors.white),
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
                              color: type != 'rent'
                                  ? Color(0xff2E809A)
                                  : Colors.white,
                              /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                              onPressed: () {
                                setState(() {
                                  type = 'sell';
                                });
                                getScheduleData();
                              },
                              child: Text(
                                'Buy',
                                style: TextStyle(
                                    fontSize: 8,
                                    color: type == 'rent'
                                        ? Color(0xff2E809A)
                                        : Colors.white),
                              ),
                            ),
                          )),
                      Padding(
                          padding: EdgeInsets.only(left: 100.0),
                          child: new IconButton(
                            onPressed: () {
                              NavigationUtil.pushToNewScreen(
                                  context,
                                  EnquiryForPropertyPage(
                                      id: widget.id,
                                      bussinessId: widget.bussinessId));
                            },
                            icon: new Icon(
                              Icons.add_circle_rounded,
                              color: Color(0xff212962),
                              size: 30.0,
                            ),
                          )),
                    ]),
          for (var item in scheduleList)
            Container(
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 10, bottom: 10),
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
                                  padding: EdgeInsets.only(right: 0, top: 20),
                                  child: new Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                            child: Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: 5, left: 5),
                                                child: new Image.asset(
                                                  'assets/images/Group (4).png',
                                                  width: 39.0,
                                                  height: 39.0,
                                                )),
                                            new Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                    item['name'].toUpperCase(),
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Text(
                                                    "+" + item['phone_no'],
                                                    style: TextStyle(
                                                        fontSize: 10,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w500),
                                                  ),
                                                ]),
                                          ],
                                        )),
                                      ])),
                              item['preference'] == null
                                  ? new Container()
                                  : Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 10),
                                      child: Container(
                                        width: 140,
                                        color: Colors.transparent,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.white),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0))),
                                            child: new Center(
                                                child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                new Text(
                                                  "Budget Range",
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Cache.storage.getString(
                                                            'country') ==
                                                        "India"
                                                    ? new Text(
                                                        item['type'] == "rent"
                                                            ? " \u20B9" +
                                                                item['preference']
                                                                        [
                                                                        'rent_start_price']
                                                                    .toString() +
                                                                "\n to \n"
                                                                    "\u20B9" +
                                                                item['preference']
                                                                        [
                                                                        'rent_end_price']
                                                                    .toString() +
                                                                " "
                                                            : "\u20B9" +
                                                                item['preference']
                                                                        [
                                                                        'selling_start_price']
                                                                    .toString() +
                                                                "\n to \n" +
                                                                "\u20B9" +
                                                                item['preference']
                                                                        [
                                                                        'selling_end_price']
                                                                    .toString() +
                                                                " ",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textAlign:
                                                            TextAlign.center,
                                                      )
                                                    : new Text(
                                                        item['type'] == "rent"
                                                            ? " S\$" +
                                                                item['preference']
                                                                        [
                                                                        'rent_start_price']
                                                                    .toString() +
                                                                "\n to \n"
                                                                    " S\$" +
                                                                item['preference']
                                                                        [
                                                                        'rent_end_price']
                                                                    .toString() +
                                                                " "
                                                            : " S\$" +
                                                                item['preference']
                                                                        [
                                                                        'selling_start_price']
                                                                    .toString() +
                                                                "\n to \n" +
                                                                " S\$" +
                                                                item['preference']
                                                                        [
                                                                        'selling_end_price']
                                                                    .toString() +
                                                                " ",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                              ],
                                            ))),
                                      )),
                              Padding(
                                  padding: EdgeInsets.only(left: 20, top: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      new Text(
                                        "Suggested Listing\n",
                                        style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal),
                                        textAlign: TextAlign.center,
                                      ),
                                      item['property_id'].length != 0
                                          ? SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Row(
                                                children: [
                                                  for (var item
                                                      in item['property_id'])
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
                                                                        borderRadius:
                                                                            BorderRadius.all(Radius.circular(
                                                                                10.0)),
                                                                        border: Border
                                                                            .all(
                                                                          color:
                                                                              Colors.white,
                                                                          width:
                                                                              2,
                                                                        )),
                                                                child: item['id']['images']
                                                                            .length !=
                                                                        0
                                                                    ? InkWell(
                                                                        child: ClipRRect(
                                                                            borderRadius: BorderRadius.circular(8.0),
                                                                            child: Image.network(
                                                                              item['id']['images'][0],
                                                                              fit: BoxFit.cover,
                                                                            )),
                                                                        onTap:
                                                                            () {
                                                                          NavigationUtil.pushToNewScreen(
                                                                              context,
                                                                              PropertyDetailsPage(
                                                                                id: item['id'],
                                                                              ));
                                                                        },
                                                                      )
                                                                    : InkWell(
                                                                        child:
                                                                            ClipRRect(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                          child:
                                                                              new Image.asset(
                                                                            'assets/images/Vector.png',
                                                                            width:
                                                                                40.0,
                                                                            height:
                                                                                40.0,
                                                                          ),
                                                                        ),
                                                                        onTap:
                                                                            () {
                                                                          NavigationUtil.pushToNewScreen(
                                                                              context,
                                                                              PropertyDetailsPage(
                                                                                id: item['id'],
                                                                              ));
                                                                        },
                                                                      )),
                                                            Container(
                                                                child: Text(
                                                                    item['id'][
                                                                        'name'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color: Colors
                                                                            .white)))
                                                          ],
                                                        )),
                                                ],
                                              ))
                                          : new Container()
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      right: 30, top: 10, left: 20, bottom: 10),
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
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: 5),
                                                  child: new Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Row(children: [
                                                          Text(
                                                            'Status: ',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          showStatus == false
                                                              ? Text(
                                                                  item[
                                                                      'status'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          13,
                                                                      color: item['status'] ==
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
                                                                    isExpanded:
                                                                        false,
                                                                    icon: Icon(
                                                                      // Add this
                                                                      Icons
                                                                          .arrow_drop_down_circle, // Add this
                                                                      color: Color(
                                                                          0xffD3D9EA), // Add this
                                                                    ),
                                                                    iconSize:
                                                                        15.0,
                                                                    hint: _status ==
                                                                            null
                                                                        ? Text(
                                                                            'Change',
                                                                            textScaleFactor:
                                                                                1.0,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
                                                                            ),
                                                                          )
                                                                        : Text(
                                                                            _status,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.white,
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
                                                                          value:
                                                                              val,
                                                                          child:
                                                                              Text(
                                                                            val,
                                                                            textScaleFactor:
                                                                                1.0,
                                                                          ),
                                                                        );
                                                                      },
                                                                    ).toList(),
                                                                    onChanged:
                                                                        (val) {
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
                                                          item['status'] ==
                                                                  "closed"
                                                              ? new Container()
                                                              : IconButton(
                                                                  icon: Icon(
                                                                    Icons.edit,
                                                                  ),
                                                                  iconSize: 20,
                                                                  color: Colors
                                                                      .white,
                                                                  splashColor:
                                                                      Colors
                                                                          .purple,
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      _id = item[
                                                                          '_id'];
                                                                      _status =
                                                                          item[
                                                                              'status'];
                                                                      showStatus =
                                                                          !showStatus;
                                                                    });
                                                                  },
                                                                ),
                                                        ])
                                                      ])),
                                              Text(
                                                'Time Spent: ' +
                                                    item['timeSpent']
                                                        .toString(),
                                                style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ]),
                                      ])),
                              item['property_id'][0]['id']['catalogue']
                                          .length !=
                                      0
                                  ? SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(children: [
                                        for (var item in item['property_id'][0]
                                            ['id']['catalogue'])
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 13, bottom: 10),
                                                    child: Container(
                                                      width: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width) /
                                                          1.27,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white,
                                                      ),
                                                      child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 0,
                                                                  left: 10,
                                                                  top: 10),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(item['name'],
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                              SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis
                                                                          .horizontal,
                                                                  child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        for (var item1
                                                                            in item['photos'])
                                                                          Container(
                                                                            height:
                                                                                59,
                                                                            width:
                                                                                65.0,
                                                                            child:
                                                                                Card(
                                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(6.0),
                                                                              ),
                                                                              elevation: 5,
                                                                              margin: EdgeInsets.all(3),
                                                                              child: Stack(
                                                                                children: <Widget>[
                                                                                  item['photos'] == null
                                                                                      ? Text("sss")
                                                                                      : InkWell(
                                                                                          onTap: () {
                                                                                            setState(() {
                                                                                              _zoomImage = item1;
                                                                                            });
                                                                                            _displayDialog1(context, _zoomImage);
                                                                                          },
                                                                                          child: Image(image: NetworkImage(item1), fit: BoxFit.fitHeight, width: 100, height: 100)),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        showProgressloading ==
                                                                                true
                                                                            ? Center(
                                                                                child: SizedBox(
                                                                                width: 20,
                                                                                height: 20,
                                                                                child: new CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Color(0xff212962)), strokeWidth: 2.0),
                                                                              ))
                                                                            : new Container()
                                                                      ])),
                                                              item['details']
                                                                          .length ==
                                                                      0
                                                                  ? new Container()
                                                                  : Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(bottom: 10, top: 10),
                                                                            child: Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Container(
                                                                                  width: 180,
                                                                                  child: Text("Assets", textScaleFactor: 1.0, style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold)),
                                                                                ),
                                                                                Text("Quantity", textScaleFactor: 1.0, style: TextStyle(color: Colors.grey, fontSize: 15, fontWeight: FontWeight.bold)),
                                                                              ],
                                                                            )),
                                                                        for (var item
                                                                            in item['details'])
                                                                          Padding(
                                                                              padding: EdgeInsets.only(bottom: 10),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.start,
                                                                                children: [
                                                                                  Container(
                                                                                    width: 180,
                                                                                    child: Text(item['amenity'] != null ? item['amenity'].toUpperCase() : "", textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),
                                                                                  ),
                                                                                  Text(item['qty'] != null ? item['qty'] : '', textScaleFactor: 1.0, style: TextStyle(color: Colors.black, fontSize: 15, fontWeight: FontWeight.normal)),
                                                                                ],
                                                                              ))
                                                                      ],
                                                                    )
                                                            ],
                                                          )),
                                                    ))
                                              ])
                                      ]))
                                  : new Container()
                            ]),
                      ))
                ])),
          scheduleList.length == 0
              ? Center(
                  child: Padding(
                      padding: EdgeInsets.only(top: 100),
                      child: Text("No Enquiry")),
                )
              : new Container()
        ]));
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
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              color: Color(0xffF0F6FB),
                              onPressed: () {},
                              child: Text(
                                'Enquiry',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 36,
                                    fontFamily: 'RobotoMono',
                                    color: Color(0xff2E809A)),
                              ),
                            ),
                          )),
                    ]),
                Padding(
                    padding: EdgeInsets.only(right: 10, left: 10, bottom: 10),
                    child: Container(
                        height: MediaQuery.of(context).size.height / 1.31,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Color(0xffE2F0FC)),
                        child: _tabSection2(context)))
              ])),
            ])),
      ),
    );
  }
}
