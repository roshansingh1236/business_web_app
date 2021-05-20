import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/pages/about/product_list.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'dart:html' as html;

class ProductDetailsPage extends StatefulWidget {
  var id;
  ProductDetailsPage({Key key, this.id}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ProductDetailsPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _s3Url1 = _baseUrl + '/core/s3signature';
  static final _businessUrl = _baseUrl + '/products';
  static final configUrl = _baseUrl + '/global-config';
  String token = '';
  UserRepository userRepository;
  File _pickedImage;
  String _fileName;
  String _s3URL = "No Image";
  String _s3URL1 = "No Image";
  List _configList = [];
  String _zoomImage;
  bool stock = false;
  bool bulk = false;
  String unit;
  bool showProgressloading = true;
  var productName = TextEditingController();
  var brandName = TextEditingController();
  var mrp = TextEditingController();
  var features = TextEditingController();
  var cgst = TextEditingController();
  var qty = TextEditingController();
  var disc = TextEditingController();
  var sgst = TextEditingController();
  var type = TextEditingController();
  var searchkeyword = TextEditingController();
  var image1 = [];
  var discount = [];
  bool allowSubscription = false;
  var _currentValue = TextEditingController();
  var _minValue = TextEditingController();
  var _maxValue = TextEditingController();
  List details = [];
  Image image;
  String name = '';
  Uint8List data;
  void _pickImage(int number) async {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/*';

    input.onChange.listen((e) {
      if (input.files.isEmpty) return;
      final reader = html.FileReader();
      reader.readAsDataUrl(input.files[0]);

      reader.onLoad.first.then((res) {
        final encoded = reader.result as String;
        // remove data:image/*;base64 preambule
        final stripped =
            encoded.replaceFirst(RegExp(r'data:image/[^;]+;base64,'), '');

        setState(() {
          name = input.files[0].name;
          data = base64.decode(stripped);
        });

        if (input.files[0] != null) {
          if (number == 1) {
            setState(() {
              _fileName = name;
            });
            //calling api for s3
            this.getS3Data();
          } else {
            setState(() {
              _fileName = name;
            });
            //calling api for s3
            this.getS3DataForProductImage();
          }
        }
      });
    });

    input.click();
  }

// upload image to s3
  Future<String> getS3DataForProductImage() async {
    var res = await http.get(
        Uri.encodeFull(_s3Url1 +
            "?_organisationId=5d147d1dfb6fc00e79b12fdc&folder=" +
            Cache.storage.getString('bussinessType') +
            "&fileName=$_fileName&fileType=image/jpeg"),
        headers: {"Authorization": token});
    var url = json.decode(res.body)["url"];
    var uri = Uri.parse(json.decode(res.body)["signedRequest"]);
    // ignore: unused_local_variable
    var response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Access-Control-Allow-Origin': 'true',
      },
      body: data,
    );
    setState(() {
      _s3URL1 = url;
      image1.add(_s3URL1);
    });
    return "Sucess";
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

// upload image to s3
  Future<String> getS3Data() async {
    var res = await http.get(
        Uri.encodeFull(_s3Url1 +
            "?_organisationId=5d147d1dfb6fc00e79b12fdc&folder=product" +
            "&fileName=$_fileName&fileType=image/jpeg"),
        headers: {"Authorization": token});
    var url = json.decode(res.body)["url"];
    var uri = Uri.parse(json.decode(res.body)["signedRequest"]);
    // ignore: unused_local_variable
    var response = await http.put(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Access-Control-Allow-Origin': 'true',
      },
      body: data,
    );
    setState(() {
      _s3URL = url;
    });
    return "Sucess";
  }

  Future<String> getUnitData() async {
    var res = await http.get(
        Uri.encodeFull(configUrl + "?filter[key]=UNIT_TYPE"),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['globalConfigs'];
    // loop through the json object
    resBody.forEach((value) {
      _configList = value['value'];
    });

    _bottomSheetMore(context);
    return "Sucess";
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
                            _configList = [];
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
                            child: Text("Choose Product Unit",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                  fontSize: 18.0,
                                  color: Color(0xff919191),
                                  fontWeight: FontWeight.w500,
                                )),
                          )),
                      Container(
                          height: 400,
                          child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Wrap(children: [
                                for (var item in _configList)
                                  Padding(
                                      padding: EdgeInsets.only(right: 15),
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              unit = item;
                                            });
                                            Navigator.of(context,
                                                    rootNavigator: true)
                                                .pop();
                                          },
                                          child: Chip(
                                            backgroundColor: unit == item
                                                ? Colors.green
                                                : null,
                                            avatar: CircleAvatar(
                                              backgroundColor: unit == item
                                                  ? Colors.red
                                                  : Theme.of(context)
                                                      .accentColor,
                                              child:
                                                  Text(item[0].toUpperCase()),
                                            ),
                                            label: Text(item),
                                          )))
                              ])))
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _addProductRequest(BuildContext context) async {
    // set up POST request arguments
    final msg1 = jsonEncode({
      "brand_name": brandName.text,
      "product_name": productName.text,
      "main_image_url": _s3URL,
      "features": features.text,
      "product_images": image1,
      "product_type": type.text,
      "search_keyword": searchkeyword.text,
      "allowSubscription": allowSubscription
    });
    // make POST request
    final response =
        await http.put(_businessUrl + "?id=" + widget.id, body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    print(response.body);
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      NavigationUtil.clearAllAndAdd(context, ProductListPage());
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

  _addProductInventoryRequest(BuildContext context) async {
    // set up POST request arguments
    final msg1 = jsonEncode({
      "stock": stock,
      "bulk": bulk,
      "min_order_qty": _minValue.text,
      "max_order_qty": _maxValue.text,
      "quantity": _currentValue.text,
      "unit_type": unit,
    });
    // make POST request
    final response = await http.put(
        _businessUrl + "/inventory" + "?id=" + widget.id,
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
      NavigationUtil.clearAllAndAdd(context, ProductListPage());
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

  _addProductPricingRequest(BuildContext context) async {
    // set up POST request arguments
    final msg1 = jsonEncode({
      "mrp": mrp.text,
      "cgst": cgst.text,
      "discount": discount,
      "sgst": sgst.text,
    });
    // make POST request
    final response = await http.put(
        _businessUrl + "/pricing" + "?id=" + widget.id,
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
      Fluttertoast.showToast(
          msg: "product Details updated!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      NavigationUtil.clearAllAndAdd(context, ProductListPage());
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

  //api calling for get Apt
  Future<String> getBusiness() async {
    var res = await http.get(Uri.encodeFull(_businessUrl + "?id=" + widget.id),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['product'];
    details = resBody;
    setState(() {
      productName.text = details[0]['product_name'];
      brandName.text = details[0]['brand_name'];
      features.text = details[0]['features'];
      searchkeyword.text = details[0]['search_keyword'];
      type.text = details[0]['product_type'];
      allowSubscription = details[0]['allowSubscription'];
      _s3URL = details[0]['main_image_url'];
      image1 = details[0]['product_images'];
      mrp.text = details[0]['pricing']['mrp'].toString();
      sgst.text = details[0]['pricing']['sp'].toString();
      cgst.text = details[0]['pricing']['gst'].toString();
      _currentValue.text = details[0]['inventory']['quantity'].toString();
      _minValue.text = details[0]['inventory']['min_order_qty'].toString();
      _maxValue.text = details[0]['inventory']['max_order_qty'].toString();
      unit = details[0]['inventory']['unit_type'];
      stock = details[0]['inventory']['stock'];
      bulk = details[0]['inventory']['bulk'];
      showProgressloading = false;
    });
    discount = details[0]['pricing']['discount'];
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });
    this.getBusiness();
    userRepository = UserRepository();
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
      body: Container(
        padding: const EdgeInsets.only(top: 60, left: 10),
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
                    : Padding(
                        padding: EdgeInsets.only(right: 30, left: 20),
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: Color(0xffE2F0FC)),
                                child: Padding(
                                    padding:
                                        EdgeInsets.only(left: 10.0, top: 10),
                                    child: new Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: <Widget>[
                                                Card(
                                                  color: Color(0xffE2F0FC),
                                                  elevation: 0,
                                                  child: ExpansionTile(
                                                    trailing: Image.asset(
                                                      'assets/images/Group 6 (1).png',
                                                      width: 11.0,
                                                      height: 11.0,
                                                    ),
                                                    title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              new Icon(
                                                                Icons
                                                                    .add_circle_rounded,
                                                                color: Color(
                                                                    0xff314498),
                                                                size: 20.0,
                                                              ),
                                                              Text(
                                                                  "Add Product Information",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ],
                                                          ),
                                                        ]),
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        productName,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Name';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Product Name',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        brandName,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Name';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Brand Name',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        type,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Name';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Product Type',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        features,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Name';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Features',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              TextFormField(
                                                                minLines: 2,
                                                                controller:
                                                                    searchkeyword,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      'Search Keywords',
                                                                  hintText:
                                                                      'ie:x,y,z',
                                                                  labelStyle: TextStyle(
                                                                      fontSize:
                                                                          12.0,
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                      fontFamily:
                                                                          "Roboto"),
                                                                ), // any number you need (It works as the rows for the textarea)
                                                                keyboardType:
                                                                    TextInputType
                                                                        .multiline,
                                                                maxLines: null,
                                                              )
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  color: Color(0xffE2F0FC),
                                                  elevation: 0,
                                                  child: ExpansionTile(
                                                    trailing: Image.asset(
                                                      'assets/images/Group 6 (1).png',
                                                      width: 11.0,
                                                      height: 11.0,
                                                    ),
                                                    title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                _pickImage(1);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  new Icon(
                                                                    Icons
                                                                        .add_circle_rounded,
                                                                    color: Color(
                                                                        0xff314498),
                                                                    size: 20.0,
                                                                  ),
                                                                  Text(
                                                                      " Add Main Image",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                ],
                                                              )),
                                                        ]),
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              _s3URL !=
                                                                      "No Image"
                                                                  ? new Container(
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      decoration:
                                                                          new BoxDecoration(
                                                                        shape: BoxShape
                                                                            .rectangle,
                                                                        color: const Color(
                                                                            0xff7c94b6),
                                                                        image:
                                                                            new DecorationImage(
                                                                          image:
                                                                              NetworkImage(_s3URL),
                                                                          fit: BoxFit
                                                                              .fill,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Container(
                                                                      decoration: new BoxDecoration(
                                                                          color: Colors
                                                                              .grey,
                                                                          shape: BoxShape
                                                                              .rectangle,
                                                                          borderRadius:
                                                                              BorderRadius.all(Radius.circular(10.0))),
                                                                      height:
                                                                          50,
                                                                      width: 50,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .add_a_photo,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            30,
                                                                      ),
                                                                    )
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  color: Color(0xffE2F0FC),
                                                  elevation: 0,
                                                  child: ExpansionTile(
                                                    trailing: Image.asset(
                                                      'assets/images/Group 6 (1).png',
                                                      width: 11.0,
                                                      height: 11.0,
                                                    ),
                                                    title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          InkWell(
                                                              onTap: () {
                                                                _pickImage(2);
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  new Icon(
                                                                    Icons
                                                                        .add_circle_rounded,
                                                                    color: Color(
                                                                        0xff314498),
                                                                    size: 20.0,
                                                                  ),
                                                                  Text(
                                                                      " Add Product Image",
                                                                      textScaleFactor:
                                                                          1.0,
                                                                      style: TextStyle(
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontSize:
                                                                              15,
                                                                          fontWeight:
                                                                              FontWeight.w500)),
                                                                ],
                                                              )),
                                                        ]),
                                                    children: <Widget>[
                                                      ListTile(
                                                        title:
                                                            SingleChildScrollView(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                child: Row(
                                                                    children: image1
                                                                        .map(
                                                                          (item) => Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.center,
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: <Widget>[
                                                                                Container(
                                                                                  height: 59,
                                                                                  width: 60.0,
                                                                                  child: Card(
                                                                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(6.0),
                                                                                    ),
                                                                                    elevation: 5,
                                                                                    margin: EdgeInsets.all(8),
                                                                                    child: Stack(
                                                                                      children: <Widget>[
                                                                                        image1 == null
                                                                                            ? Text("sss")
                                                                                            : InkWell(
                                                                                                onTap: () {
                                                                                                  setState(() {
                                                                                                    _zoomImage = item;
                                                                                                  });
                                                                                                  _displayDialog1(context, _zoomImage);
                                                                                                },
                                                                                                child: Image(
                                                                                                  image: NetworkImage(item),
                                                                                                  fit: BoxFit.cover,
                                                                                                  width: 50,
                                                                                                )),
                                                                                        Positioned(
                                                                                          right: 0,
                                                                                          top: 0,
                                                                                          child: InkWell(
                                                                                            child: Icon(
                                                                                              Icons.close,
                                                                                              size: 20,
                                                                                              color: Colors.red,
                                                                                            ),
                                                                                            onTap: () {
                                                                                              image1.remove(item);
                                                                                              setState(() {});
                                                                                            },
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ]),
                                                                        )
                                                                        .toList())),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  color: Color(0xffE2F0FC),
                                                  elevation: 0,
                                                  child: ExpansionTile(
                                                    trailing: Image.asset(
                                                      'assets/images/Group 6 (1).png',
                                                      width: 11.0,
                                                      height: 11.0,
                                                    ),
                                                    title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              new Icon(
                                                                Icons
                                                                    .add_circle_rounded,
                                                                color: Color(
                                                                    0xff314498),
                                                                size: 20.0,
                                                              ),
                                                              Text(
                                                                  "Add Pricing",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ],
                                                          ),
                                                        ]),
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        mrp,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Name';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Please enter price',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        sgst,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter SGST(%)';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Please enter SGST(%)',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        cgst,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter CGST(%)';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Please enter CGST(%)',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  color: Color(0xffE2F0FC),
                                                  elevation: 0,
                                                  child: ExpansionTile(
                                                    trailing: Image.asset(
                                                      'assets/images/Group 6 (1).png',
                                                      width: 11.0,
                                                      height: 11.0,
                                                    ),
                                                    title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              new Icon(
                                                                Icons
                                                                    .add_circle_rounded,
                                                                color: Color(
                                                                    0xff314498),
                                                                size: 20.0,
                                                              ),
                                                              Text(
                                                                  "Add Discount",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ],
                                                          ),
                                                        ]),
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        qty,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Name';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Please enter Qty.',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    new Flexible(
                                                                        child: Padding(
                                                                            padding: EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0),
                                                                            child: TextFormField(
                                                                              controller: disc,
                                                                              validator: (input) {
                                                                                if (input.isEmpty) {
                                                                                  return 'Please enter Name';
                                                                                }
                                                                                return null;
                                                                              },
                                                                              keyboardType: TextInputType.number,
                                                                              decoration: InputDecoration(
                                                                                labelText: 'Please enter Discount in %',
                                                                                labelStyle: TextStyle(fontSize: 12.0, color: Color(0xff314498), fontWeight: FontWeight.w500, fontFamily: "Roboto"),
                                                                              ),
                                                                            ))),
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            right:
                                                                                0.0,
                                                                            top:
                                                                                0.0),
                                                                        child: IconButton(
                                                                            onPressed: () {
                                                                              discount.add({
                                                                                "qty": qty.text,
                                                                                "discount": disc.text
                                                                              });
                                                                              qty.clear();
                                                                              disc.clear();
                                                                              setState(() {});
                                                                            },
                                                                            icon: new Icon(
                                                                              Icons.add_circle_rounded,
                                                                              color: Color(0xff314498),
                                                                              size: 30.0,
                                                                            ))),
                                                                  ]),
                                                              discount.length ==
                                                                      0
                                                                  ? new Container()
                                                                  : new Container(
                                                                      width:
                                                                          300.0,
                                                                      child: new SingleChildScrollView(
                                                                          scrollDirection: Axis.vertical,
                                                                          child: DataTable(
                                                                            columns: [
                                                                              DataColumn(label: Text('Quantity', textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13))),
                                                                              DataColumn(label: Text('Discount', textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 13))),
                                                                            ],
                                                                            rows: discount // Loops through dataColumnText, each iteration assigning the value to element
                                                                                .map(
                                                                                  ((element) => DataRow(
                                                                                        cells: <DataCell>[
                                                                                          DataCell(Text(element["qty"].toString(), textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10))),
                                                                                          //Extracting from Map element the value
                                                                                          DataCell(Text(element["discount"].toString() + " %", textScaleFactor: 1.0, style: TextStyle(fontWeight: FontWeight.normal, fontSize: 10))),
                                                                                        ],
                                                                                      )),
                                                                                )
                                                                                .toList(),
                                                                          )),
                                                                    ),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Card(
                                                  color: Color(0xffE2F0FC),
                                                  elevation: 0,
                                                  child: ExpansionTile(
                                                    trailing: Image.asset(
                                                      'assets/images/Group 6 (1).png',
                                                      width: 11.0,
                                                      height: 11.0,
                                                    ),
                                                    title: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              new Icon(
                                                                Icons
                                                                    .add_circle_rounded,
                                                                color: Color(
                                                                    0xff314498),
                                                                size: 20.0,
                                                              ),
                                                              Text(
                                                                  "Add Inventory",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500)),
                                                            ],
                                                          ),
                                                        ]),
                                                    children: <Widget>[
                                                      ListTile(
                                                        title: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _currentValue,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Qty.';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Enter Quantity',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _minValue,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Min. Order Qty.';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Enter Min. Order Qty.',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets.only(
                                                                      left: 0.0,
                                                                      right:
                                                                          0.0,
                                                                      top: 0.0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        _maxValue,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .number,
                                                                    validator:
                                                                        (input) {
                                                                      if (input
                                                                          .isEmpty) {
                                                                        return 'Please enter Max. Order Qty.';
                                                                      }
                                                                      return null;
                                                                    },
                                                                    decoration:
                                                                        InputDecoration(
                                                                      labelText:
                                                                          'Enter Max. Order Qty.',
                                                                      labelStyle: TextStyle(
                                                                          fontSize:
                                                                              12.0,
                                                                          color: Color(
                                                                              0xff314498),
                                                                          fontWeight: FontWeight
                                                                              .w500,
                                                                          fontFamily:
                                                                              "Roboto"),
                                                                    ),
                                                                  )),
                                                              InkWell(
                                                                onTap: () {
                                                                  getUnitData();
                                                                },
                                                                child: Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            15.0,
                                                                        right:
                                                                            0.0,
                                                                        top:
                                                                            10.0),
                                                                    child: unit ==
                                                                            null
                                                                        ? Row(
                                                                            children: [
                                                                              Text('Please select Unit Type',
                                                                                  textScaleFactor: 1.0,
                                                                                  style: TextStyle(
                                                                                    color: Color(0xff314498),
                                                                                  )),
                                                                              Icon(
                                                                                Icons.add_circle_rounded,
                                                                                size: 15,
                                                                              )
                                                                            ],
                                                                          )
                                                                        : Row(
                                                                            children: [
                                                                              Text(
                                                                                "Unit Type : " + unit,
                                                                                textScaleFactor: 1.0,
                                                                                style: TextStyle(
                                                                                  fontSize: 15.0,
                                                                                  color: Color(0xff314498),
                                                                                ),
                                                                              ),
                                                                              Icon(
                                                                                Icons.arrow_drop_down,
                                                                                size: 15,
                                                                              )
                                                                            ],
                                                                          )),
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          top:
                                                                              0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    alignment:
                                                                        Alignment(
                                                                            0.0,
                                                                            -1.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Theme(
                                                                          data:
                                                                              ThemeData(unselectedWidgetColor: Color(0xff212962)),
                                                                          child:
                                                                              Checkbox(
                                                                            value:
                                                                                stock,
                                                                            activeColor:
                                                                                Color(0xff212962),
                                                                            onChanged:
                                                                                (bool value) {
                                                                              setState(() {
                                                                                stock = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "Stock",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff212962),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          top:
                                                                              0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    alignment:
                                                                        Alignment(
                                                                            0.0,
                                                                            -1.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Theme(
                                                                          data:
                                                                              ThemeData(unselectedWidgetColor: Color(0xff212962)),
                                                                          child:
                                                                              Checkbox(
                                                                            value:
                                                                                bulk,
                                                                            activeColor:
                                                                                Color(0xff212962),
                                                                            onChanged:
                                                                                (bool value) {
                                                                              setState(() {
                                                                                bulk = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "Bulk",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff212962),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                              Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              0,
                                                                          right:
                                                                              0,
                                                                          top:
                                                                              0),
                                                                  child:
                                                                      Container(
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    alignment:
                                                                        Alignment(
                                                                            0.0,
                                                                            -1.0),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: <
                                                                          Widget>[
                                                                        Theme(
                                                                          data:
                                                                              ThemeData(unselectedWidgetColor: Color(0xff212962)),
                                                                          child:
                                                                              Checkbox(
                                                                            value:
                                                                                allowSubscription,
                                                                            activeColor:
                                                                                Color(0xff212962),
                                                                            onChanged:
                                                                                (bool value) {
                                                                              setState(() {
                                                                                allowSubscription = value;
                                                                              });
                                                                            },
                                                                          ),
                                                                        ),
                                                                        Text(
                                                                          "Allow Subscription",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style:
                                                                              TextStyle(
                                                                            color:
                                                                                Color(0xff212962),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                            ]),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ]),
                                        ]))))),
                Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10),
                    child: SizedBox(
                      width: 234,
                      child: RaisedButton(
                        onPressed: () {
                          _addProductRequest(context);
                          _addProductInventoryRequest(context);
                          _addProductPricingRequest(context);
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
                                const Text('Update Product',
                                    style: TextStyle(fontSize: 20)),
                              ]),
                        ),
                      ),
                    ))
              ])),
            ])),
      ),
    );
  }
}
