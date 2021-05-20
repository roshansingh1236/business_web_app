import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/pages/agent/enquiry.dart';
import 'package:bussiness_web_app/ui/pages/agent/enquiryList.dart';
import 'package:bussiness_web_app/ui/pages/agent/update_single_enquiry.dart';
import 'package:bussiness_web_app/ui/pages/property/add_property.dart';
import 'package:bussiness_web_app/ui/pages/property/property_details.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/animations/fade_animation.dart';
import 'package:bussiness_web_app/utils/common_util.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

class PropertyListPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PropertyListPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + "/property";
  String token = '';
  List productList = [];
  List enquiryList = [];
  bool showStatus = false;
  String _status;
  bool showProgressloading = true;
  String id = '';
  bool _hasBeenPressed = false;
  bool showSearch = false;
  String _date = 'rent';
  String _zoomImage;
  String id1;
  String _name = "Property";
  bool show = false;
  String _id;
  var myController = TextEditingController();
  //api calling for get Apt
  Future<String> getEnquiryList() async {
    enquiryList = [];
    var res = await http.get(
        Uri.encodeFull(_businessUrl +
            "/enquiry" +
            "?filter[type]=" +
            _date +
            "&sortBy[status]=-1&sortBy[createdAt]=-1&filter[name]=" +
            myController.text),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['enquiry'];
          enquiryList = resBody.toList();
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
  Future<String> getProductList() async {
    productList = [];
    var res = await http.get(
        Uri.encodeFull(_businessUrl + "?filter[classification]=" + _date),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['property'];
          productList = resBody.toList();
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
    final response = await http
        .put(_businessUrl + "/enquiry" + "?id=" + _id, body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      getEnquiryList();
      Fluttertoast.showToast(
          msg: "Status Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    } else if (statusCode == 201) {
      getEnquiryList();
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

  _deleteRequest(BuildContext context) async {
    // set up POST request arguments

    // make POST request
    final response =
        await http.delete(_businessUrl + "/enquiry" + "?id=" + _id, headers: {
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
      getEnquiryList();
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
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });
    this.getProductList();
    this.getEnquiryList();
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

  // ignore: non_constant_identifier_names
  Widget RecurringCard1List() {
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
            child: enquiryList.length != 0
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(children: [
                      for (var item in enquiryList)
                        Stack(children: [
                          Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    show = !show;
                                    id1 = item['_id'];
                                  });
                                },
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(right: 20, left: 15),
                                    child: Container(
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(21),
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
                                            // You enter here what you want the button to do once the user interacts with it
                                            NavigationUtil.pushToNewScreen(
                                                context,
                                                ExistingUpdateEnquiryPage(
                                                    enquiryObject: item));
                                          },
                                          icon: Transform.rotate(
                                              angle: 90 * math.pi / 180,
                                              child: Icon(
                                                Icons.more_horiz,
                                                color: Colors.white,
                                              )),
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
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.1,
                                                  child: Text(
                                                      "+" + item['phone_no'],
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight
                                                              .normal)),
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
                                                  item['preference'] == null
                                                      ? new Container()
                                                      : Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20),
                                                          child: Container(
                                                            width: 170,
                                                            color: Colors
                                                                .transparent,
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white),
                                                                    borderRadius:
                                                                        BorderRadius.all(Radius.circular(
                                                                            10.0))),
                                                                child:
                                                                    new Center(
                                                                        child:
                                                                            Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                5),
                                                                        child:
                                                                            new Text(
                                                                          "Budget Range",
                                                                          style: TextStyle(
                                                                              fontSize: 17,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        )),
                                                                    Cache.storage.getString('country') ==
                                                                            "India"
                                                                        ? new Text(
                                                                            item['type'] == "rent"
                                                                                ? " \u20B9" +
                                                                                    item['preference']['rent_start_price'].toString() +
                                                                                    "\n to \n"
                                                                                        "\u20B9" +
                                                                                    item['preference']['rent_end_price'].toString() +
                                                                                    " "
                                                                                : "\u20B9" + item['preference']['selling_start_price'].toString() + " to " + "\u20B9" + item['preference']['selling_end_price'].toString() + " ",
                                                                            style: TextStyle(
                                                                                fontSize: 14,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.w500),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          )
                                                                        : new Text(
                                                                            item['type'] == "rent"
                                                                                ? " S\$" +
                                                                                    item['preference']['rent_start_price'].toString() +
                                                                                    "\n to \n"
                                                                                        " S\$" +
                                                                                    item['preference']['rent_end_price'].toString() +
                                                                                    " "
                                                                                : " S\$" + item['preference']['selling_start_price'].toString() + " to " + " S\$" + item['preference']['selling_end_price'].toString() + " ",
                                                                            style: TextStyle(
                                                                                fontSize: 12,
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.normal),
                                                                            textAlign:
                                                                                TextAlign.center,
                                                                          ),
                                                                  ],
                                                                ))),
                                                          )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20, top: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          new Text(
                                                            "Suggested Listing\n",
                                                            style: TextStyle(
                                                                fontSize: 10,
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                          item['property_id']
                                                                      .length !=
                                                                  0
                                                              ? SingleChildScrollView(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  child: Row(
                                                                    children: [
                                                                      for (var item1
                                                                          in item[
                                                                              'property_id'])
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(right: 20),
                                                                            child: Column(
                                                                              children: [
                                                                                Container(
                                                                                    width: 50,
                                                                                    height: 50,
                                                                                    decoration: BoxDecoration(
                                                                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                                                                        border: Border.all(
                                                                                          color: Colors.white,
                                                                                          width: 2,
                                                                                        )),
                                                                                    child: item1['id']['images'].length != 0
                                                                                        ? InkWell(
                                                                                            child: ClipRRect(
                                                                                                borderRadius: BorderRadius.circular(8.0),
                                                                                                child: Image.network(
                                                                                                  item1['id']['images'][0],
                                                                                                  fit: BoxFit.cover,
                                                                                                )),
                                                                                            onTap: () {
                                                                                              NavigationUtil.pushToNewScreen(
                                                                                                  context,
                                                                                                  PropertyDetailsPage(
                                                                                                    id: item1['id'],
                                                                                                  ));
                                                                                            },
                                                                                          )
                                                                                        : InkWell(
                                                                                            child: ClipRRect(
                                                                                              borderRadius: BorderRadius.circular(10.0),
                                                                                              child: new Image.asset(
                                                                                                'assets/images/Vector.png',
                                                                                                width: 40.0,
                                                                                                height: 40.0,
                                                                                              ),
                                                                                            ),
                                                                                            onTap: () {
                                                                                              NavigationUtil.pushToNewScreen(
                                                                                                  context,
                                                                                                  PropertyDetailsPage(
                                                                                                    id: item1['id'],
                                                                                                  ));
                                                                                            },
                                                                                          )),
                                                                                Container(child: Text(item1['id']['name'], style: TextStyle(fontSize: 12, color: Colors.white)))
                                                                              ],
                                                                            )),
                                                                    ],
                                                                  ))
                                                              : new Container()
                                                        ],
                                                      )),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 30,
                                                          left: 20,
                                                          bottom: 10),
                                                      child: new Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            new Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                children: <
                                                                    Widget>[
                                                                  Row(
                                                                      children: [
                                                                        Text(
                                                                          'Status: ',
                                                                          style: TextStyle(
                                                                              fontSize: 13,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold),
                                                                        ),
                                                                        showStatus ==
                                                                                false
                                                                            ? Text(
                                                                                item['status'],
                                                                                style: TextStyle(fontSize: 13, color: item['status'] == 'open' ? Colors.green : Colors.white, fontWeight: FontWeight.bold),
                                                                              )
                                                                            : SizedBox(
                                                                                width: 80,
                                                                                child: DropdownButtonHideUnderline(
                                                                                    child: DropdownButton(
                                                                                  isExpanded: false,
                                                                                  icon: Icon(
                                                                                    // Add this
                                                                                    Icons.arrow_drop_down_circle, // Add this
                                                                                    color: Color(0xffD3D9EA), // Add this
                                                                                  ),
                                                                                  iconSize: 15.0,
                                                                                  hint: _status == null
                                                                                      ? Text(
                                                                                          'Change',
                                                                                          textScaleFactor: 1.0,
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        )
                                                                                      : Text(
                                                                                          _status,
                                                                                          style: TextStyle(
                                                                                            color: Colors.white,
                                                                                          ),
                                                                                        ),
                                                                                  style: TextStyle(color: Colors.blue),
                                                                                  items: [
                                                                                    'open',
                                                                                    'confirmed',
                                                                                    'rented',
                                                                                    'closed'
                                                                                  ].map(
                                                                                    (val) {
                                                                                      return DropdownMenuItem<String>(
                                                                                        value: val,
                                                                                        child: Text(
                                                                                          val,
                                                                                          textScaleFactor: 1.0,
                                                                                        ),
                                                                                      );
                                                                                    },
                                                                                  ).toList(),
                                                                                  onChanged: (val) {
                                                                                    setState(
                                                                                      () {
                                                                                        _status = val;
                                                                                        _id = item["_id"];
                                                                                      },
                                                                                    );
                                                                                    _addPropertyRequest(context);
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
                                                                                color: Colors.white,
                                                                                splashColor: Colors.purple,
                                                                                onPressed: () {
                                                                                  setState(() {
                                                                                    showStatus = !showStatus;
                                                                                  });
                                                                                },
                                                                              ),
                                                                      ]),
                                                                  Text(
                                                                    'Time Spent: ' +
                                                                        item['timeSpent']
                                                                            .toString(),
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            13,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ]),
                                                            item['status'] !=
                                                                    'open'
                                                                ? new Container()
                                                                : InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        _id = item[
                                                                            "_id"];
                                                                      });
                                                                      CommonUtils.showConfirmationDialog(
                                                                          context,
                                                                          "Do you want to delete this Enquiry?",
                                                                          "Yes",
                                                                          () async {
                                                                        _deleteRequest(
                                                                            context);
                                                                      }, "No",
                                                                          () {});
                                                                    },
                                                                    child: new Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .center,
                                                                        children: <
                                                                            Widget>[
                                                                          new Image
                                                                              .asset(
                                                                            'assets/images/Group 136.png',
                                                                            width:
                                                                                29.0,
                                                                            height:
                                                                                39.0,
                                                                          ),
                                                                          showStatus == false
                                                                              ? Padding(
                                                                                  padding: EdgeInsets.only(left: 20),
                                                                                  child: Text(
                                                                                    'Delete\nEnquiry',
                                                                                    style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.normal),
                                                                                  ))
                                                                              : new Container()
                                                                        ])),
                                                          ])),
                                                ]),
                                          ),
                                        ],
                                      ),
                                    )),
                              ))
                        ])
                    ]))
                : Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: new Center(
                      child: Text(
                        "No Enquiry",
                        style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.normal,
                            fontFamily: "Roboto"),
                      ),
                    )));
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
            child: productList.length != 0
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(children: [
                      for (var item in productList)
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
                                        trailing: show == false
                                            ? PopupMenuButton(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                icon: Transform.rotate(
                                                    angle: 90 * math.pi / 180,
                                                    child: Icon(
                                                      Icons.more_horiz,
                                                      color: Colors.white,
                                                    )),
                                                iconSize: 20.0,
                                                itemBuilder:
                                                    (BuildContext bc) => [
                                                  PopupMenuItem(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          new Tooltip(
                                                            message: "Details",
                                                            preferBelow: true,
                                                            child:
                                                                new Image.asset(
                                                              'assets/images/details.png',
                                                              width: 40.0,
                                                              height: 40.0,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      value: "1"),
                                                  PopupMenuItem(
                                                      child: Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        children: [
                                                          new Tooltip(
                                                              message:
                                                                  "Enquiry",
                                                              child: new Image
                                                                  .asset(
                                                                'assets/images/enquiry.png',
                                                                width: 40.0,
                                                                height: 40.0,
                                                              )),
                                                        ],
                                                      ),
                                                      value: "2"),
                                                ],
                                                onSelected: (route) {
                                                  // Note You must create respective pages for navigation
                                                  if (route == "1") {
                                                    NavigationUtil
                                                        .pushToNewScreen(
                                                            context,
                                                            PropertyDetailsPage(
                                                              id: item,
                                                            ));
                                                  } else if (route == "2") {
                                                    NavigationUtil.pushToNewScreen(
                                                        context,
                                                        ListEnquiryPage(
                                                            id: item["_id"],
                                                            bussinessId: item[
                                                                'businessId']));
                                                  }
                                                },
                                              )
                                            : IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    show = !show;
                                                    id1 = item['_id'];
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
                                                Padding(
                                                    padding:
                                                        EdgeInsets.only(top: 5),
                                                    child: Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width /
                                                              2.1,
                                                      child: Text(item['type'],
                                                          textScaleFactor: 1.0,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal)),
                                                    )),
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
                                                            "Address: ${item['det_address']['street']},${item['det_address']['postal_code']}",
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
                                                            2.1,
                                                        child: Text(
                                                            "Phone: +${item['owner_details']['phone']}",
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
                                                          left: 20),
                                                      child: Container(
                                                          width: 280,
                                                          height: 50,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8),
                                                            border: Border.all(
                                                                width: 1.0,
                                                                color: Colors
                                                                    .white,
                                                                style:
                                                                    BorderStyle
                                                                        .solid),
                                                          ),
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Container(
                                                                        child: new Text(
                                                                            item[
                                                                                'type'],
                                                                            style:
                                                                                TextStyle(fontSize: 10, color: Colors.white))),
                                                                    Container(
                                                                        child: new Text(
                                                                            "No. of Bedroom  " +
                                                                                item['no_bedroom'].toString(),
                                                                            style: TextStyle(fontSize: 10, color: Colors.white)))
                                                                  ],
                                                                ),
                                                                Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceAround,
                                                                  children: [
                                                                    Container(
                                                                        child: new Text(
                                                                            item[
                                                                                'unit_type'],
                                                                            style:
                                                                                TextStyle(fontSize: 10, color: Colors.white))),
                                                                    Container(
                                                                      child: new Text(
                                                                          "No. of Bathroom  " +
                                                                              item['no_bathroom']
                                                                                  .toString(),
                                                                          style: TextStyle(
                                                                              fontSize: 10,
                                                                              color: Colors.white)),
                                                                    )
                                                                  ],
                                                                )
                                                              ]))),
                                                  item['images'].length != 0
                                                      ? SingleChildScrollView(
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          child: Row(children: [
                                                            for (var item1
                                                                in item[
                                                                    'images'])
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              10,
                                                                          top:
                                                                              10),
                                                                  child:
                                                                      Container(
                                                                    height: 48,
                                                                    width: 48.0,
                                                                    child: Card(
                                                                      clipBehavior:
                                                                          Clip.antiAliasWithSaveLayer,
                                                                      shape:
                                                                          RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(6.0),
                                                                      ),
                                                                      elevation:
                                                                          1,
                                                                      margin: EdgeInsets
                                                                          .all(
                                                                              0),
                                                                      child:
                                                                          Stack(
                                                                        children: <
                                                                            Widget>[
                                                                          InkWell(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  _zoomImage = item["images"][0];
                                                                                });
                                                                                _displayDialog1(context, _zoomImage);
                                                                              },
                                                                              child: Stack(children: <Widget>[
                                                                                Image(image: NetworkImage(item1), fit: BoxFit.fill, width: 80, height: 80),
                                                                              ])),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  )),
                                                            showProgressloading ==
                                                                    true
                                                                ? Center(
                                                                    child:
                                                                        SizedBox(
                                                                    width: 20,
                                                                    height: 20,
                                                                    child: new CircularProgressIndicator(
                                                                        valueColor:
                                                                            AlwaysStoppedAnimation(Color(
                                                                                0xff212962)),
                                                                        strokeWidth:
                                                                            2.0),
                                                                  ))
                                                                : new Container()
                                                          ]))
                                                      : new Container(),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 20,
                                                          top: 10,
                                                          bottom: 10),
                                                      child: Container(
                                                          child: new Text(
                                                              "Status: " +
                                                                  item[
                                                                      'status'],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)))),
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
                        "No Property",
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
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    _name = "Property";
                                    showProgressloading = true;
                                  });
                                  this.getProductList();
                                },
                                child: Text(
                                  "Property",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      color: _name == "Property"
                                          ? Color(0xff2E809A)
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto"),
                                )),
                            InkWell(
                                onTap: () {
                                  setState(() {
                                    _name = "Enquiry";
                                    showProgressloading = true;
                                  });
                                  this.getEnquiryList();
                                },
                                child: Text(
                                  "Enquiry",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 36.0,
                                      color: _name == "Enquiry"
                                          ? Color(0xff2E809A)
                                          : Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto"),
                                )),
                          ])),
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: SizedBox(
                              height: 21,
                              width: 58,
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
                                    showProgressloading = true;
                                  });
                                  this.getProductList();
                                  this.getEnquiryList();
                                },
                                child: Text(
                                  'Rent',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: _date == "rent"
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.only(left: 10.0),
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
                                    showProgressloading = true;
                                  });
                                  this.getProductList();
                                  this.getEnquiryList();
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
                        showSearch == false
                            ? _name == "Enquiry"
                                ? IconButton(
                                    onPressed: () {
                                      setState(() {
                                        showSearch = !showSearch;
                                      });
                                      // You enter here what you want the button to do once the user interacts with it
                                    },
                                    icon: Icon(
                                      Icons.search_outlined,
                                      color: Colors.black,
                                    ),
                                    iconSize: 20.0,
                                  )
                                : new Container()
                            : Padding(
                                padding: EdgeInsets.only(left: 10.0),
                                child: FadeAnimation(
                                    0,
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                          2.1,
                                      height: 39,
                                      decoration: new BoxDecoration(
                                        borderRadius:
                                            new BorderRadius.circular(11.0),
                                        color: Color(0xffF2F2F2),
                                        border: Border.all(
                                            color: Color(0xffb4b7c6),
                                            width: 0.3),
                                      ),
                                      child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10),
                                          child: Theme(
                                            data: new ThemeData(
                                              primaryColor: Colors.white,
                                              primaryColorDark: Colors.white,
                                            ),
                                            child: TextFormField(
                                              textCapitalization:
                                                  TextCapitalization.words,
                                              controller: myController,
                                              textInputAction:
                                                  TextInputAction.next,
                                              //onChanged is called whenever we add or delete something on Text Field
                                              onChanged: (String str) {},
                                              onFieldSubmitted: (term) {
                                                // process
                                                setState(() {
                                                  showProgressloading = true;
                                                });
                                                getEnquiryList();
                                              },
                                              // ignore: deprecated_member_use
                                              decoration: new InputDecoration(
                                                border: InputBorder.none,
                                                suffixIcon: IconButton(
                                                  onPressed: () {
                                                    myController.clear();
                                                    setState(() {
                                                      showProgressloading =
                                                          true;
                                                      showSearch = !showSearch;
                                                    });

                                                    getEnquiryList();
                                                  },
                                                  icon: Icon(Icons.clear,
                                                      color: Color(0xff212962)),
                                                ),
                                                hintText: 'Search by Name.',
                                              ),

                                              style: new TextStyle(
                                                fontFamily: "Poppins",
                                              ),
                                            ),
                                          )),
                                    )))
                      ]),
                  _name == "Property"
                      ? Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.4,
                                  child: RecurringCardList()),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                  width: MediaQuery.of(context).size.width,
                                  height:
                                      MediaQuery.of(context).size.height / 1.4,
                                  child: RecurringCard1List()),
                            ],
                          ),
                        ),
                ])),
              ])),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(right: 20, top: 0),
          child: Material(
              type: MaterialType
                  .transparency, //Makes it usable on any background color, thanks @IanSmith
              child: Ink(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 3.0),
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  //This keeps the splash effect within the circle
                  borderRadius: BorderRadius.circular(
                      1000.0), //Something large to ensure a circle
                  onTap: () {
                    _name == "Enquiry"
                        ? NavigationUtil.pushToNewScreen(context, EnquiryPage())
                        : NavigationUtil.pushToNewScreen(
                            context, PropertyPage());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
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
