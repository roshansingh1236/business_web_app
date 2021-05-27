import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:typed_data';

import 'package:bussiness_web_app/ui/pages/about/product.dart';
import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/about/product_details.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/animations/fade_animation.dart';
import 'package:bussiness_web_app/utils/common_util.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as Math;

class ProductListPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ProductListPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/products';
  UserRepository userRepository;
  String token = '';
  List productList = [];
  bool showProgressloading = true;
  var myController = TextEditingController();
  String id = '';
  bool _stock = false;
  //api calling for get Apt
  Future<String> getProductList() async {
    print(myController.text);
    var filter = myController.text != ""
        ? "?sortBy[isSetup]=1&filter[\$text][\$search]=" + myController.text
        : "?sortBy[isSetup]=1";

    var res = await http.get(Uri.encodeFull(_businessUrl + filter),
        headers: {"Authorization": token});
    int statusCode = res.statusCode;
    switch (statusCode.toString()) {
      case '200':
        {
          var resBody = json.decode(res.body)['product'];
          resBody.sort((a, b) {
            if (b['inventory']['stock']) {
              return -1;
            }
            return 1;
          });
          productList = resBody.toList();
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

  _updateProductStockRequest(BuildContext context) async {
    // set up POST request arguments
    final msg1 = jsonEncode({"stock": _stock});
    print(msg1);
    // make POST request
    final response = await http
        .put(_businessUrl + "/inventory" + "?id=" + id, body: msg1, headers: {
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
          msg: "product updated!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      getProductList();
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

  _deleteProductRequest(BuildContext context) async {
    // set up POST request arguments

    // make POST request
    final response = await http.delete(_businessUrl + "?id=" + id, headers: {
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
          msg: "product deleted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      this.getProductList();
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
                      padding:
                          EdgeInsets.only(bottom: 25.0, left: 20, right: 40),
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            new Image.asset(
                              'assets/images/Product Information.png',
                              width: 190.0,
                              height: 84.0,
                            ),
                            new Image.asset(
                              'assets/images/Vector (9).png',
                              width: 48.0,
                              height: 48.0,
                            ),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(right: 30, left: 20, bottom: 10),
                      child: FadeAnimation(
                          0,
                          Container(
                            width: MediaQuery.of(context).size.width,
                            decoration: new BoxDecoration(
                              borderRadius: new BorderRadius.circular(11.0),
                              color: Colors.white,
                              border: Border.all(
                                  color: Color(0xffb4b7c6), width: 0.3),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Theme(
                                  data: new ThemeData(
                                    primaryColor: Colors.white,
                                    primaryColorDark: Colors.white,
                                  ),
                                  child: TextFormField(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    controller: myController,
                                    textInputAction: TextInputAction.search,
                                    //onChanged is called whenever we add or delete something on Text Field
                                    onChanged: (String str) {},
                                    onFieldSubmitted: (term) {
                                      // process
                                      setState(() {
                                        showProgressloading = true;
                                      });
                                      getProductList();
                                    },
                                    // ignore: deprecated_member_use
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          myController.clear();
                                          setState(() {
                                            showProgressloading = true;
                                          });

                                          getProductList();
                                        },
                                        icon: Icon(Icons.clear,
                                            color: Color(0xff212962)),
                                      ),
                                      hintText: 'Search product by name',
                                    ),

                                    style: new TextStyle(
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                )),
                          ))),
                  showProgressloading == true
                      ? Center(
                          child: SizedBox(
                          width: 20,
                          height: 20,
                          child: new CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation(Color(0xff212962)),
                              strokeWidth: 2.0),
                        ))
                      : productList.length != 0
                          ? Column(
                              children: [
                                for (var item in productList)
                                  Stack(children: [
                                    Padding(
                                        padding: EdgeInsets.only(
                                            right: 30, left: 20, bottom: 10),
                                        child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(21),
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
                                                  offset:
                                                      Offset(0.0, 1.0), //(x,y)
                                                  blurRadius: 6.0,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.0, top: 10),
                                                child: new Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: <Widget>[
                                                      new Container(
                                                          height: 70,
                                                          width: 70,
                                                          padding:
                                                              new EdgeInsets
                                                                  .all(2.0),
                                                          decoration:
                                                              new BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                                new BorderRadius
                                                                    .all(new Radius
                                                                        .circular(
                                                                    100.0)),
                                                            border:
                                                                new Border.all(
                                                              color: Color(
                                                                  0xff2E809A),
                                                              width: 1.0,
                                                            ),
                                                          ),
                                                          child:
                                                              item["main_image_url"] !=
                                                                      null
                                                                  ? ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              300.0),
                                                                      child: Image
                                                                          .network(
                                                                        item[
                                                                            "main_image_url"],
                                                                        width:
                                                                            68,
                                                                        height:
                                                                            68,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ),
                                                                    )
                                                                  : Center(
                                                                      child:
                                                                          Text(
                                                                        item['product_name'] !=
                                                                                null
                                                                            ? item['product_name'][0].toUpperCase()
                                                                            : "",
                                                                        textScaleFactor:
                                                                            1.0,
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                48.0,
                                                                            color:
                                                                                Colors.black,
                                                                            fontWeight: FontWeight.w500,
                                                                            fontFamily: "Roboto"),
                                                                      ),
                                                                    )),
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.2,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 30.0),
                                                            child: new Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: <
                                                                    Widget>[
                                                                  Text(
                                                                    item[
                                                                        'brand_name'],
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12.0,
                                                                        color: Color(
                                                                            0xffFFFFFF),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "Roboto"),
                                                                  ),
                                                                  Text(
                                                                    item[
                                                                        'product_name'],
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            23.0,
                                                                        color: Color(
                                                                            0xffFFFFFF),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontFamily:
                                                                            "Roboto"),
                                                                  ),
                                                                  Text(
                                                                    "Price : \u20B9 ${item['pricing']['mrp']}",
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Color(
                                                                            0xffFFFFFF),
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "Roboto"),
                                                                  ),
                                                                  Text(
                                                                    item['inventory']['inventory']
                                                                            .toString() +
                                                                        " " +
                                                                        item['inventory']
                                                                            [
                                                                            'unit_type'],
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14.0,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontFamily:
                                                                            "Roboto"),
                                                                  ),
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          item['inventory']['stock'] == true
                                                                              ? "In Stock"
                                                                              : "Out of stock",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style: TextStyle(
                                                                              fontSize: 14.0,
                                                                              color: item['inventory']['stock'] == true ? Colors.green : Colors.red,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontFamily: "Roboto"),
                                                                        ),
                                                                        Padding(
                                                                            padding:
                                                                                EdgeInsets.only(left: item['inventory']['stock'] == true ? 30.0 : 0),
                                                                            child: Switch(
                                                                              value: item['inventory']['stock'],
                                                                              onChanged: (value) {
                                                                                setState(() {
                                                                                  _stock = value;
                                                                                  id = item["_id"];
                                                                                });

                                                                                _updateProductStockRequest(context);
                                                                              },
                                                                              activeColor: Colors.green,
                                                                              inactiveThumbColor: Colors.red,
                                                                            )),
                                                                      ])
                                                                ])),
                                                      )
                                                    ])))),
                                    new Positioned(
                                        top: 10.0,
                                        right: 40.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                                padding: EdgeInsets.only(
                                                    right: 20.0),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      id = item["_id"];
                                                    });
                                                    CommonUtils
                                                        .showConfirmationDialog(
                                                            context,
                                                            "Do you want to delete this product?",
                                                            "Yes", () async {
                                                      _deleteProductRequest(
                                                          context);
                                                    }, "No", () {});
                                                  },
                                                  child: new Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                            Transform.rotate(
                                                angle: Math.pi / 180 * 90,
                                                alignment: Alignment.center,
                                                child: InkWell(
                                                  onTap: () {
                                                    NavigationUtil
                                                        .pushToNewScreen(
                                                            context,
                                                            ProductDetailsPage(
                                                              id: item,
                                                            ));
                                                  },
                                                  child: new Icon(
                                                    Icons.more_horiz_rounded,
                                                    color: Colors.white,
                                                  ),
                                                ))
                                          ],
                                        ))
                                  ]),
                              ],
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: new Center(
                                child: Text(
                                  "No Product",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      color: Colors.black,
                                      fontWeight: FontWeight.normal,
                                      fontFamily: "Roboto"),
                                ),
                              )),
                ])),
              ])),
        ),
        floatingActionButton: Transform.scale(
          scale: 1.5,
          child: Padding(
              padding: EdgeInsets.only(right: 20, top: 0),
              child: FloatingActionButton(
                onPressed: () {
                  NavigationUtil.pushToNewScreen(context, ProductPage());
                },
                backgroundColor: Colors.red,
                elevation: 0,
                child: Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(
                      Radius.circular(100),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 7,
                        blurRadius: 7,
                        offset: Offset(3, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(0.0),
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
