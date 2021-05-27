import 'dart:convert';
import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;
import 'package:bussiness_web_app/utils/navigation_util.dart';

import 'new_order.dart';

// ignore: must_be_immutable
class OrderDetailsPage extends StatefulWidget {
  var id;
  var userName;
  var total;
  var delivery;
  var id1;
  var status;
  OrderDetailsPage(
      {Key key,
      this.id,
      this.userName,
      this.total,
      this.delivery,
      this.id1,
      this.status})
      : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<OrderDetailsPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _orderUrl = _baseUrl + '/order';
  String token = '';
  List cart = [];
  List json = [];
  List<bool> selected = [];
  List _options1 = ['confirmed', 'processing', 'shipped', 'delivered'];
  List _options2 = ['processing', 'shipped', 'delivered'];
  List _options3 = ['shipped', 'delivered'];
  List _options4 = ['delivered'];
  _updateStatsusForOrder(String status) async {
    // set up POST request arguments
    final msg1 = jsonEncode({"status": status});

    // make POST request
    final response =
        await http.put(_orderUrl + "?id=" + widget.id1, body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "Status Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      NavigationUtil.clearAllAndAdd(context, NewOrderPage());
    } else if (statusCode == 201) {
      Fluttertoast.showToast(
          msg: "Status Updated",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      Fluttertoast.showToast(
          msg: "Not Update",
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
      json = widget.id['cart'];
    });
    json.forEach((value) {
      cart.addAll(value['data']);
    });
    selected = List<bool>.generate(cart.length, (int index) => false);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    super.dispose();
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
              child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(
                                  bottom: 25.0, left: 20, right: 40),
                              child: new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "Order Details",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 36.0,
                                          color: Color(0xff2E809A),
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto"),
                                    ),
                                    new Image.asset(
                                      'assets/images/Vector (10).png',
                                      width: 60.0,
                                      height: 55.0,
                                    ),
                                  ])),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: 20, left: 20, bottom: 5),
                              child: Text("Name :" + widget.userName,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13))),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: 20, left: 20, bottom: 5),
                              child: Text("Address :" + widget.delivery,
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13))),
                          Padding(
                              padding: EdgeInsets.only(
                                  right: 20, left: 20, bottom: 5),
                              child: Text(
                                  'Price :' +
                                      " \u20B9" +
                                      widget.total.toString(),
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 13))),
                          Padding(
                              padding: EdgeInsets.only(right: 10, left: 0),
                              child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 1.5,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Color(0xffE2F0FC)),
                                  child: new SingleChildScrollView(
                                      scrollDirection: Axis.vertical,
                                      child: Column(children: [
                                        cart.length == 0
                                            ? new Container()
                                            : new Container(
                                                width: (MediaQuery.of(context)
                                                        .size
                                                        .width) /
                                                    1.12,
                                                child:
                                                    new SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: DataTable(
                                                          columns: const <
                                                              DataColumn>[
                                                            DataColumn(
                                                                label: Text(
                                                                    'Product Name',
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            13))),
                                                            DataColumn(
                                                                label: Text(
                                                                    'Brand Name',
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            13))),
                                                            DataColumn(
                                                                label: Text(
                                                                    'Type',
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            13))),
                                                            DataColumn(
                                                                label: Text(
                                                                    'Unit Type',
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            13))),
                                                            DataColumn(
                                                                label: Text(
                                                                    'Price',
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            13))),
                                                            DataColumn(
                                                                label: Text(
                                                                    'Qty.',
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            13))),
                                                          ],
                                                          rows: List<
                                                              DataRow>.generate(
                                                            cart.length,
                                                            (int index) =>
                                                                DataRow(
                                                              cells: <DataCell>[
                                                                DataCell(Text(
                                                                    cart[index][
                                                                            "productid"]
                                                                        [
                                                                        'product_name'],
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            12))),
                                                                //Extracting from Map element the value
                                                                DataCell(Text(
                                                                    cart[index][
                                                                            "productid"]
                                                                        [
                                                                        'brand_name'],
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            12))),
                                                                DataCell(Text(
                                                                    cart[index][
                                                                            "productid"]
                                                                        [
                                                                        'product_type'],
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            12))),
                                                                DataCell(Text(
                                                                    cart[index]["productid"]['inventory']['quantity']
                                                                            .toString() +
                                                                        " " +
                                                                        cart[index]["productid"]['inventory'][
                                                                            'unit_type'],
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            12))),
                                                                DataCell(Text(
                                                                    " \u20B9" +
                                                                        cart[index]["price"]
                                                                            .toString(),
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            12))),
                                                                DataCell(Text(
                                                                    cart[index][
                                                                            "quantity"]
                                                                        .toString(),
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .normal,
                                                                        fontSize:
                                                                            12))),
                                                              ],
                                                              selected:
                                                                  selected[
                                                                      index],
                                                              onSelectChanged:
                                                                  (bool value) {
                                                                setState(() {
                                                                  selected[
                                                                          index] =
                                                                      value;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        )),
                                              ),
                                        Padding(
                                            padding: EdgeInsets.only(
                                                right: 10,
                                                top: 10,
                                                left: 10,
                                                bottom: 10),
                                            child: new Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  InkWell(
                                                      onTap: () {
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
                                                          children: <Widget>[
                                                            new Image.asset(
                                                                'assets/images/Group 136.png',
                                                                width: 29.0,
                                                                height: 39.0,
                                                                color:
                                                                    Colors.red),
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            20),
                                                                child: Text(
                                                                  widget.status ==
                                                                          "reject"
                                                                      ? 'Rejected Order'
                                                                      : 'Reject Order',
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: widget.status ==
                                                                              "reject"
                                                                          ? Colors
                                                                              .red
                                                                          : Colors
                                                                              .black,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ))
                                                          ])),
                                                  widget.status == "reject"
                                                      ? new Container()
                                                      : widget.status ==
                                                              "delivered"
                                                          ? new Container()
                                                          : InkWell(
                                                              onTap: () {},
                                                              child: new Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    new Icon(
                                                                      Icons
                                                                          .shopping_basket,
                                                                      color: Colors
                                                                          .green,
                                                                      size:
                                                                          30.0,
                                                                    ),
                                                                    new Row(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment
                                                                                .start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .start,
                                                                        children: <
                                                                            Widget>[
                                                                          PopupMenuButton(
                                                                            color:
                                                                                Colors.white.withOpacity(0.8),
                                                                            child: Padding(
                                                                                padding: EdgeInsets.only(left: 20),
                                                                                child: Text(
                                                                                  widget.status == "pending"
                                                                                      ? "Confirm"
                                                                                      : widget.status == "confirmed"
                                                                                          ? "process"
                                                                                          : widget.status == "processing"
                                                                                              ? "Ship"
                                                                                              : widget.status == "shipped"
                                                                                                  ? "Deliver"
                                                                                                  : "Confirm",
                                                                                  style: TextStyle(fontSize: 10, color: Colors.black, fontWeight: FontWeight.bold),
                                                                                )),
                                                                            itemBuilder: widget.status == "pending"
                                                                                ? (BuildContext bc) {
                                                                                    return _options1
                                                                                        .map((day) => PopupMenuItem(
                                                                                              child: Text(day.toUpperCase()),
                                                                                              value: day,
                                                                                            ))
                                                                                        .toList();
                                                                                  }
                                                                                : widget.status == "confirmed"
                                                                                    ? (BuildContext bc) {
                                                                                        return _options2
                                                                                            .map((day) => PopupMenuItem(
                                                                                                  child: Text(day.toUpperCase()),
                                                                                                  value: day,
                                                                                                ))
                                                                                            .toList();
                                                                                      }
                                                                                    : widget.status == "processing"
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
                                                                            onSelected:
                                                                                (value) {
                                                                              // Note You must create respective pages for navigation
                                                                              _updateStatsusForOrder(value);
                                                                            },
                                                                          ),
                                                                          Text(
                                                                            " Order",
                                                                            style: TextStyle(
                                                                                fontSize: 10,
                                                                                color: Colors.black,
                                                                                fontWeight: FontWeight.bold),
                                                                          )
                                                                        ])
                                                                  ])),
                                                ])),
                                      ])))),
                        ])),
                  ])),
        ));
  }
}
