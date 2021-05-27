import 'dart:convert';
import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

import 'order_details.dart';

class NewOrderPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<NewOrderPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _orderUrl = _baseUrl + '/order';
  String token = '';
  List _orderList = [];
  String vendorId;
  List enquiryList = [];
  bool showStatus = false;
  bool showProgressloading = true;
  String id = '';
  bool showSearch = false;
  String id1;
  bool show = false;
  DateTime _currentSelected = DateTime.now();
  var myController = TextEditingController();
  List _options1 = ['confirmed', 'processing', 'shipped', 'delivered'];
  List _options2 = ['processing', 'shipped', 'delivered'];
  List _options3 = ['shipped', 'delivered'];
  List _options4 = ['delivered'];
  //api calling for get Apt
  Future<String> getOrder() async {
    setState(() {
      showProgressloading = true;
    });
    _orderList = [];
    var date1 = DateFormat("yyyy-MM-dd").format(_currentSelected);

    var res = await http.get(
        Uri.encodeFull(_orderUrl +
            "?bussinessId=$vendorId&mode=product&populate=user" +
            "&filter[updatedAt][\$gte]=" +
            date1 +
            "T00:00:00.000Z" +
            "&filter[deleted]=false"),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['orders'];
          _orderList = resBody.toList();
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

  _updateStatsusForOrder(String status) async {
    print(id1);
    // set up POST request arguments
    final msg1 = jsonEncode({"status": status});

    // make POST request
    final response =
        await http.put(_orderUrl + "?id=" + id1, body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      getOrder();
      Fluttertoast.showToast(
          msg: "Status Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    } else if (statusCode == 201) {
      getOrder();
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
      vendorId = Cache.storage.getString('bussinessId');
    });

    this.getOrder();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      this.getOrder();
    });
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
            child: _orderList.length != 0
                ? Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Column(children: [
                      for (var item in _orderList)
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Stack(children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
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
                                          colors: item['status'] == "reject"
                                              ? [
                                                  Colors.grey,
                                                  Colors.grey,
                                                ]
                                              : [
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
                                              id1 = item['_id'];
                                            });
                                            NavigationUtil.pushToNewScreen(
                                                context,
                                                OrderDetailsPage(
                                                    id: item,
                                                    userName: item['user_id']
                                                            ['name']['first'] +
                                                        " " +
                                                        item['user_id']['name']
                                                            ['last'],
                                                    total: item['total'],
                                                    delivery:
                                                        item['delivery_add'],
                                                    id1: item['_id'],
                                                    status: item['status']));
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
                                                MainAxisAlignment.start,
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
                                              Text(
                                                  item['user_id']['name'] !=
                                                          null
                                                      ? item['user_id']['name']
                                                              ['first'] +
                                                          " " +
                                                          item['user_id']
                                                              ['name']['last']
                                                      : "",
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
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
                                                            1.5,
                                                        child: Text(
                                                            item['delivery_add'] !=
                                                                    ""
                                                                ? "Address: " +
                                                                    item[
                                                                        'delivery_add']
                                                                : "",
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
                                                            "Phone: " +
                                                                "+" +
                                                                item['cart'][0][
                                                                    'phone_no'],
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
                                                            "Price: " +
                                                                "\u{20B9} " +
                                                                item['total']
                                                                    .toString() +
                                                                "\n" +
                                                                "Gst: " +
                                                                "\u{20B9} " +
                                                                item['gst']
                                                                    .toString() +
                                                                "\n" +
                                                                "Discount: " +
                                                                "\u{20B9} " +
                                                                item['discount']
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
                                                  for (var item1
                                                      in item['cart'])
                                                    SafeArea(
                                                        child:
                                                            ListView.separated(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 0),
                                                      itemCount:
                                                          item1['data'].length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      reverse: false,
                                                      itemBuilder:
                                                          (BuildContext context,
                                                              int index) {
                                                        return InkWell(
                                                            onTap: () {},
                                                            child: ListTile(
                                                              trailing: Text(
                                                                item1['data'][index]
                                                                            [
                                                                            'quantity']
                                                                        .toString() +
                                                                    " qty.",
                                                                textScaleFactor:
                                                                    1.0,
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w700),
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
                                                                        padding: EdgeInsets.only(
                                                                            right:
                                                                                10),
                                                                        child: Image
                                                                            .asset(
                                                                          'assets/images/Group 7.png',
                                                                          width:
                                                                              11.0,
                                                                          height:
                                                                              11.0,
                                                                        )),
                                                                    Container(
                                                                        width: MediaQuery.of(context).size.width /
                                                                            1.8,
                                                                        child: Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                item1['data'][index]['productid']['product_name'] + ", " + item1['data'][index]['productid']['brand_name'],
                                                                                textScaleFactor: 1.0,
                                                                                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                                                                              ),
                                                                              Text(
                                                                                item1['data'][index]['productid']['product_type'] + ", " + item1['data'][index]['productid']['inventory']['quantity'].toString() + " " + item1['data'][index]['productid']['inventory']['unit_type'],
                                                                                textScaleFactor: 1.0,
                                                                                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                                                                              ),
                                                                            ])),
                                                                  ]),
                                                            ));
                                                      },
                                                      separatorBuilder:
                                                          (BuildContext context,
                                                                  int index) =>
                                                              Divider(
                                                        thickness: 1,
                                                      ),
                                                    )),
                                                  Divider(
                                                    thickness: 1,
                                                  ),
                                                  Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10,
                                                          top: 10,
                                                          left: 10,
                                                          bottom: 10),
                                                      child: new Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    id1 = item[
                                                                        '_id'];
                                                                  });
                                                                  _updateStatsusForOrder(
                                                                      "reject");
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
                                                                      Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left:
                                                                                  20),
                                                                          child:
                                                                              Text(
                                                                            item['status'] == "reject"
                                                                                ? 'Rejected Order'
                                                                                : 'Reject Order',
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: item['status'] == "reject" ? Colors.red : Colors.white,
                                                                                fontWeight: FontWeight.bold),
                                                                          ))
                                                                    ])),
                                                            item['status'] ==
                                                                    "reject"
                                                                ? new Container()
                                                                : item['status'] ==
                                                                        "delivered"
                                                                    ? new Container()
                                                                    : InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            id1 =
                                                                                item['_id'];
                                                                          });
                                                                        },
                                                                        child: new Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.center,
                                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                                            children: <Widget>[
                                                                              new Icon(
                                                                                Icons.shopping_basket,
                                                                                color: Colors.green,
                                                                                size: 30.0,
                                                                              ),
                                                                              new Row(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
                                                                                PopupMenuButton(
                                                                                  color: Colors.white.withOpacity(0.8),
                                                                                  child: Padding(
                                                                                      padding: EdgeInsets.only(left: 20),
                                                                                      child: Text(
                                                                                        item['status'] == "pending"
                                                                                            ? "Confirm"
                                                                                            : item['status'] == "confirmed"
                                                                                                ? "process"
                                                                                                : item['status'] == "processing"
                                                                                                    ? "Ship"
                                                                                                    : item['status'] == "shipped"
                                                                                                        ? "Deliver"
                                                                                                        : "Confirm",
                                                                                        style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                      )),
                                                                                  itemBuilder: item['status'] == "pending"
                                                                                      ? (BuildContext bc) {
                                                                                          return _options1
                                                                                              .map((day) => PopupMenuItem(
                                                                                                    child: Text(day.toUpperCase()),
                                                                                                    value: day,
                                                                                                  ))
                                                                                              .toList();
                                                                                        }
                                                                                      : item['status'] == "confirmed"
                                                                                          ? (BuildContext bc) {
                                                                                              return _options2
                                                                                                  .map((day) => PopupMenuItem(
                                                                                                        child: Text(day.toUpperCase()),
                                                                                                        value: day,
                                                                                                      ))
                                                                                                  .toList();
                                                                                            }
                                                                                          : item['status'] == "processing"
                                                                                              ? (BuildContext bc) {
                                                                                                  return _options3
                                                                                                      .map((day) => PopupMenuItem(
                                                                                                            child: Text(day.toUpperCase()),
                                                                                                            value: day,
                                                                                                          ))
                                                                                                      .toList();
                                                                                                }
                                                                                              : (BuildContext bc) {
                                                                                                  return _options4
                                                                                                      .map((day) => PopupMenuItem(
                                                                                                            child: Text(day.toUpperCase()),
                                                                                                            value: day,
                                                                                                          ))
                                                                                                      .toList();
                                                                                                },
                                                                                  onSelected: (value) {
                                                                                    // Note You must create respective pages for navigation
                                                                                    _updateStatsusForOrder(value);
                                                                                  },
                                                                                ),
                                                                                Text(
                                                                                  " Order",
                                                                                  style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                                                                )
                                                                              ])
                                                                            ])),
                                                          ])),
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
                        "No Orders",
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
                    padding: EdgeInsets.only(bottom: 25.0, left: 20, right: 40),
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          new Image.asset(
                            'assets/images/New Order.png',
                            width: 200.0,
                            height: 42.0,
                          ),
                          new Image.asset(
                            'assets/images/Vector (10).png',
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
    );
  }
}
