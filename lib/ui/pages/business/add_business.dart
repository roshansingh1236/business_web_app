import 'dart:typed_data';

import 'package:bussiness_web_app/ui/pages/business/add_global_product.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/pages/home/agent_home.dart';
import 'package:bussiness_web_app/ui/pages/home/delivery_home.dart';
import 'package:bussiness_web_app/ui/pages/home/home_page.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class BusinessPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<BusinessPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/vendor/add/business';
  static final orgUrl = _baseUrl + '/organisation';
  static final _s3Url1 = _baseUrl + '/core/s3signature';
  static final configUrl = _baseUrl + '/global-config';
  final formKey = GlobalKey<FormState>();
  String token = '';
  File _pickedImage;
  List org = [];
  String _fileName;
  String _role;
  String _role1;
  String _s3URL;
  bool _showContainer = false;
  String _mySelection2;
  List organisationId = [];
  List _configList = [];
  List _configList1 = [];
  String country = "India";
  String countryCode = "IN";
  bool showProgressloading = false;
  var _phone;
  Map data = {
    'name': String,
    'address': String,
    'gstin': String,
    'pan': String
  };
  String name1 = '';
  Uint8List data1;
  // ignore: missing_return
  String validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (value.length != 0) {
      if (!regex.hasMatch(value)) return 'Enter Valid Email';
    } else
      return null;
  }

  Future<String> getConfigRoleData() async {
    var res = await http.get(
        Uri.encodeFull(configUrl + "?filter[key]=" + _role),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['globalConfigs'];
    resBody.forEach((value) {
      _configList1 = value['value'];
    });
    // loop through the json object
    // loop through the json object

    setState(() {});
    return "Sucess";
  }

  Future<String> getConfigData() async {
    var type = country != "India"
        ? "?filter[key]=PROPERTY_TYPE"
        : "?filter[key]=BUSINESS_TYPE";
    var res = await http.get(Uri.encodeFull(configUrl + type),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['globalConfigs'];
    // loop through the json object
    // loop through the json object
    resBody.forEach((value) {
      _configList = value['value'];
    });
    setState(() {});
    return "Sucess";
  }

  var name = TextEditingController();
  var address = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();
  var gst = TextEditingController();
  var pan = TextEditingController();
  var cea = TextEditingController();
  var firstname = TextEditingController();
  var finNumber = TextEditingController();

  _addBusinessRequest(BuildContext context) async {
    // set up POST request arguments
    setState(() {
      showProgressloading = true;
    });
    final msg1 = country != "India"
        ? jsonEncode({
            "gstNumber": gst.text,
            "entityName": name.text,
            "address": address.text,
            "organisationId": organisationId,
            "businessLogo": {"path": _s3URL},
            "phone": _phone.replaceAll('+', ''),
            "businessType": _role,
            "vendorRole": _role1,
            "firstName": firstname.text,
            "ceaNumber": cea.text,
            "finNumber": finNumber.text,
            "isforeign": true
          })
        : jsonEncode({
            "gstNumber": gst.text,
            "panNumber": pan.text,
            "entityName": name.text,
            "address": address.text,
            "organisationId": organisationId,
            "businessLogo": {"path": _s3URL},
            "email": email.text,
            "businessType": _role,
            "vendorRole": _role1,
            "firstName": firstname.text,
            "isforeign": false
          });
    // make POST request
    final response = await http.post(_businessUrl, body: msg1, headers: {
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
        showProgressloading = false;
      });
      if (json.decode(response.body)['vendorRole'] != null) {
        Cache.storage
            .setString('vendorRole', json.decode(response.body)['vendorRole']);
      }
      Cache.storage.setString('bussinessId', json.decode(response.body)['_id']);
      Cache.storage.setInt('isProfileCompleted', 1);
      json.decode(response.body)['vendorRole'] == "teamMember"
          ? DeliveryHomePage()
          : json.decode(response.body)['vendorRole'] == "Real Estate Agent"
              ? NavigationUtil.pushToNewScreen(context, AgentHomePage())
              : NavigationUtil.pushToNewScreen(context, NewProductPage());
    } else if (statusCode == 201) {
      setState(() {
        showProgressloading = false;
      });
      Cache.storage.setInt('isProfileCompleted', 1);
      NavigationUtil.pushToNewScreen(context, NewProductPage());
    } else {
      setState(() {
        showProgressloading = false;
      });
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
          name1 = input.files[0].name;
          data1 = base64.decode(stripped);
        });

        if (input.files[0] != null) {
          if (number == 1) {
            setState(() {
              _fileName = name1;
            });
            //calling api for s3
            this.getS3Data();
          }
        }
      });
    });

    input.click();
  }

// upload image to s3
  Future<String> getS3Data() async {
    var res = await http.get(
        Uri.encodeFull(_s3Url1 +
            "?_organisationId=5d147d1dfb6fc00e79b12fdc&folder=business" +
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
      body: data1,
    );
    setState(() {
      _s3URL = url;
      showProgressloading = true;
    });
    return "Sucess";
  }

  // api calling Apartment
  Future<String> getOrgData() async {
    var res = await http
        .get(Uri.encodeFull(orgUrl), headers: {"Authorization": token});
    var resBody = json.decode(res.body)['organisations'];
    setState(() {
      org = resBody.toList();
    });
    return "Sucess";
  }

  // api calling Apartment
  Future<String> getSingleOrgData() async {
    var res = await http.get(
        Uri.encodeFull(orgUrl + "?filter[_id]=" + _mySelection2),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['organisations'][0];
    organisationId.add({"_id": resBody['_id'], "name": resBody['name']});
    setState(() {});
    _showContainer = true;
    return "Sucess";
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
      country = Cache.storage.getString('country');
      countryCode = Cache.storage.getString('countryCode');
    });
    this.getConfigData();

    this.getOrgData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffF0F6FB),
      systemNavigationBarDividerColor: Colors.black,
    ));
    return Scaffold(
        backgroundColor: Color(0xffF0F6FB),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(top: 60, left: 0),
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
                                InkWell(
                                    onTap: () {
                                      _pickImage(2);
                                    },
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          _s3URL != null
                                              ? new Container(
                                                  height: 150,
                                                  width: 150,
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: Color(0xff314498),
                                                      style: BorderStyle.solid,
                                                      width: 1.0,
                                                    ),
                                                    color:
                                                        const Color(0xff7c94b6),
                                                    image: new DecorationImage(
                                                      image:
                                                          NetworkImage(_s3URL),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : showProgressloading == true
                                                  ? Center(
                                                      child: Container(
                                                          decoration:
                                                              new BoxDecoration(
                                                            color: Colors.grey,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          height: 150,
                                                          width: 150,
                                                          child: SizedBox(
                                                            width: 20,
                                                            height: 20,
                                                            child: new CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation(
                                                                        Color(
                                                                            0xff212962)),
                                                                strokeWidth:
                                                                    2.0),
                                                          )))
                                                  : Container(
                                                      decoration:
                                                          new BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color:
                                                              Color(0xff314498),
                                                          style:
                                                              BorderStyle.solid,
                                                          width: 1.0,
                                                        ),
                                                        color: const Color(
                                                            0xff7c94b6),
                                                      ),
                                                      height: 150,
                                                      width: 150,
                                                      child: Icon(
                                                        Icons.add_a_photo,
                                                        color: Colors.black,
                                                        size: 50,
                                                      ),
                                                    )
                                        ])),
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(right: 20.0),
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
                                new Image.asset(
                                  'assets/images/Group 109.png',
                                  width: 26.0,
                                  height: 30.0,
                                ),
                              ])),
                      new SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              width: MediaQuery.of(context).size.width / 1.12,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Color(0xffE2F0FC)),
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0, top: 10),
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
                                              Container(
                                                  width: (MediaQuery.of(context)
                                                          .size
                                                          .width) /
                                                      1.1,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 3.0,
                                                        top: 2.0),
                                                    child: TextFormField(
                                                      controller: name,
                                                      validator: (input) {
                                                        if (input.isEmpty) {
                                                          return 'Please enter Business Name';
                                                        }
                                                        return null;
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Business Name',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black54)),
                                                      onSaved: (input) =>
                                                          data['name'] = input,
                                                    ),
                                                  )),
                                              Container(
                                                  width: (MediaQuery.of(context)
                                                          .size
                                                          .width) /
                                                      1.20,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 3.0,
                                                        top: 2.0),
                                                    child: TextFormField(
                                                      controller: firstname,
                                                      validator: (input) {
                                                        if (input.isEmpty) {
                                                          return 'Please enter Your Name';
                                                        }
                                                        return null;
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'Your Full Name',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black54)),
                                                      onSaved: (input) =>
                                                          data['firstname'] =
                                                              input,
                                                    ),
                                                  )),
                                              Container(
                                                  width: (MediaQuery.of(context)
                                                          .size
                                                          .width) /
                                                      1.20,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 3.0,
                                                        top: 2.0),
                                                    child: TextFormField(
                                                      controller: address,
                                                      validator: (input) {
                                                        if (input.isEmpty) {
                                                          return 'Please enter Address';
                                                        }
                                                        return null;
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText: 'Address',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black54)),
                                                      onSaved: (input) =>
                                                          data['address'] =
                                                              input,
                                                    ),
                                                  )),
                                              new SizedBox(
                                                height: 1.0,
                                                child: new Center(
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 18.0),
                                                      child: new Container(
                                                        width: (MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width) /
                                                            1.2,
                                                        height: 1.0,
                                                        color: Colors.grey,
                                                      )),
                                                ),
                                              ),
                                              country != "India"
                                                  ? Container(
                                                      width: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width) /
                                                          1.20,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                right: 3.0,
                                                                top: 2.0),
                                                        child: IntlPhoneField(
                                                          initialCountryCode:
                                                              countryCode,
                                                          onChanged: (phone) {
                                                            //when phone number country code is changed
                                                            /*  print(phone
                                                                .completeNumber); //get complete number
                                                            print(phone
                                                                .countryCode); // get country code only
                                                            print(phone.number); */
                                                            setState(() {
                                                              _phone = phone
                                                                  .completeNumber;
                                                            }); // only phone number
                                                          },
                                                          inputFormatters: [
                                                            new LengthLimitingTextInputFormatter(
                                                                10)
                                                          ],
                                                          controller: phone,
                                                          keyboardType:
                                                              TextInputType
                                                                  .phone,
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  'Phone',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                          onSaved: (input) {
                                                            data['phone'] =
                                                                input;
                                                          },
                                                        ),
                                                      ))
                                                  : Container(
                                                      width: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width) /
                                                          1.20,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                right: 3.0,
                                                                top: 2.0),
                                                        child: TextFormField(
                                                          controller: email,
                                                          validator:
                                                              validateEmail,
                                                          keyboardType:
                                                              TextInputType
                                                                  .emailAddress,
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  'Email',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                          onSaved: (input) =>
                                                              data['email'] =
                                                                  input,
                                                        ),
                                                      )),
                                              country != "India"
                                                  ? Container(
                                                      width: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width) /
                                                          1.20,
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 8.0,
                                                                right: 3.0,
                                                                top: 2.0),
                                                        child: TextFormField(
                                                          controller: cea,
                                                          validator: (input) {
                                                            if (input.isEmpty) {
                                                              return 'Please enter CEA Number';
                                                            }
                                                            return null;
                                                          },
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  'CEA Number',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                          onSaved: (input) =>
                                                              data['cea'] =
                                                                  input,
                                                        ),
                                                      ))
                                                  : new Container(),
                                              Container(
                                                  width: (MediaQuery.of(context)
                                                          .size
                                                          .width) /
                                                      1.20,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 3.0,
                                                        top: 2.0),
                                                    child: TextFormField(
                                                      controller: gst,
                                                      validator: (input) {
                                                        if (input.isEmpty) {
                                                          return 'Please enter GST Number';
                                                        }
                                                        return null;
                                                      },
                                                      decoration: InputDecoration(
                                                          labelText:
                                                              'GST Number',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black54)),
                                                      onSaved: (input) =>
                                                          data['gstin'] = input,
                                                    ),
                                                  )),
                                              country == "India"
                                                  ? Container(
                                                      width: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width) /
                                                          1.20,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 3.0,
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                            top: 2.0),
                                                        child: TextFormField(
                                                          controller: pan,
                                                          validator: (input) {
                                                            if (input.isEmpty) {
                                                              return 'Please enter PAN';
                                                            }
                                                            return null;
                                                          },
                                                          decoration: InputDecoration(
                                                              labelText: 'Pan',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                          onSaved: (input) =>
                                                              data['pan'] =
                                                                  input,
                                                        ),
                                                      ))
                                                  : Container(
                                                      width: (MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width) /
                                                          1.20,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 8.0,
                                                            right: 3.0,
                                                            bottom:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom,
                                                            top: 2.0),
                                                        child: TextFormField(
                                                          controller: finNumber,
                                                          validator: (input) {
                                                            if (input.isEmpty) {
                                                              return 'Please enter NRIC/FIN';
                                                            }
                                                            return null;
                                                          },
                                                          decoration: InputDecoration(
                                                              labelText:
                                                                  'NRIC/FIN',
                                                              labelStyle: TextStyle(
                                                                  color: Colors
                                                                      .black54)),
                                                          onSaved: (input) =>
                                                              data['finNumber'] =
                                                                  input,
                                                        ),
                                                      )),
                                            ]),
                                        Column(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, right: 0),
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.2,
                                                    height: 45,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 0),
                                                        child: DropdownButton(
                                                          isExpanded: true,
                                                          iconEnabledColor:
                                                              Colors.black,
                                                          hint: _role == null
                                                              ? Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                      Text(
                                                                        'Select Business Type',
                                                                      )
                                                                    ])
                                                              : Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                      Text(
                                                                        _role.replaceAll(
                                                                            new RegExp(r'[_]'),
                                                                            "  "),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      )
                                                                    ]),
                                                          iconSize: 30.0,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors.black,
                                                          ),
                                                          items: _configList
                                                              .map((location) {
                                                            return new DropdownMenuItem(
                                                              child: new Text(
                                                                  location.replaceAll(
                                                                      new RegExp(
                                                                          r'[_]'),
                                                                      "  ")),
                                                              value: location,
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            FocusScope.of(
                                                                    context)
                                                                .unfocus();
                                                            setState(
                                                              () {
                                                                _role1 = null;
                                                                _role = val;
                                                              },
                                                            );
                                                            this.getConfigRoleData();
                                                          },
                                                          value: _role,
                                                        )))),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                        Column(
                                          children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0, right: 0),
                                                child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            1.2,
                                                    height: 45,
                                                    child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 0),
                                                        child: DropdownButton(
                                                          isExpanded: true,
                                                          iconEnabledColor:
                                                              Colors.black,
                                                          hint: _role1 == null
                                                              ? Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                      Text(
                                                                        'Select Vendor Role',
                                                                      )
                                                                    ])
                                                              : Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: <
                                                                      Widget>[
                                                                      Text(
                                                                        _role1.replaceAll(
                                                                            new RegExp(r'[_]'),
                                                                            "  "),
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Colors.black,
                                                                        ),
                                                                      )
                                                                    ]),
                                                          iconSize: 30.0,
                                                          icon: Icon(
                                                            Icons
                                                                .arrow_drop_down,
                                                            color: Colors.black,
                                                          ),
                                                          items: _configList1
                                                              .map((location) {
                                                            return new DropdownMenuItem(
                                                              child: new Text(
                                                                  location.replaceAll(
                                                                      new RegExp(
                                                                          r'[_]'),
                                                                      "  ")),
                                                              value: location,
                                                            );
                                                          }).toList(),
                                                          onChanged: (val) {
                                                            setState(
                                                              () {
                                                                _role1 = val;
                                                              },
                                                            );
                                                            print(_role1);
                                                          },
                                                          value: _role1,
                                                        )))),
                                          ],
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                        ),
                                        country == "India"
                                            ? new Container()
                                            : FittedBox(
                                                child: Container(
                                                  width: (MediaQuery.of(context)
                                                          .size
                                                          .width) /
                                                      1.17,
                                                  child: new Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 10.0,
                                                                  top: 10.0,
                                                                  left: 10,
                                                                  bottom: 20),
                                                          child:
                                                              new DropdownButton(
                                                            isDense: true,
                                                            iconSize: 30.0,
                                                            hint: new Text(
                                                                "Select Apartment",
                                                                textAlign:
                                                                    TextAlign
                                                                        .center),
                                                            items:
                                                                org.map((item) {
                                                              return new DropdownMenuItem(
                                                                child: new Text(
                                                                    item[
                                                                        'name']),
                                                                value:
                                                                    item['_id'],
                                                              );
                                                            }).toList(),
                                                            onChanged:
                                                                (newVal) {
                                                              FocusScope.of(
                                                                      context)
                                                                  .unfocus();
                                                              setState(() {
                                                                _mySelection2 =
                                                                    newVal;
                                                              });
                                                            },
                                                            value:
                                                                _mySelection2,
                                                          ),
                                                        ),
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    top: 2.0),
                                                            child: IconButton(
                                                              icon: Icon(Icons
                                                                  .add_circle),
                                                              onPressed: () {
                                                                if (_mySelection2 !=
                                                                    null) {
                                                                  this.getSingleOrgData();
                                                                  setState(() {
                                                                    _mySelection2 =
                                                                        null;
                                                                  });
                                                                } else {
                                                                  Fluttertoast.showToast(
                                                                      msg:
                                                                          "select apartment first",
                                                                      toastLength:
                                                                          Toast
                                                                              .LENGTH_SHORT,
                                                                      gravity:
                                                                          ToastGravity
                                                                              .CENTER);
                                                                }
                                                              },
                                                            )),
                                                      ]),
                                                ),
                                              ),
                                      ]))))
                    ])),
                    _showContainer == true
                        ? Padding(
                            padding: const EdgeInsets.only(left: 25, top: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                for (var item in organisationId)
                                  Container(
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                        Text(item['name'],
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 17.0,
                                                color: Colors.black)),
                                        Padding(
                                            padding: EdgeInsets.only(top: 0.0),
                                            child: IconButton(
                                              icon: Icon(
                                                Icons.cancel_outlined,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                organisationId
                                                    .forEach((userDetail) {
                                                  if (userDetail["_id"]
                                                      .contains(
                                                          (item['_id']))) {
                                                    organisationId.removeWhere(
                                                        (item) =>
                                                            userDetail["_id"] ==
                                                            item['_id']);
                                                    setState(() {});
                                                  }
                                                });
                                              },
                                            ))
                                      ]))
                              ],
                            ))
                        : new Container(),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 20),
                          child: SizedBox(
                            width: 178,
                            height: 56,
                            child: RaisedButton(
                              elevation: 0,
                              onPressed: () {
                                if (_role != null && _role1 != null) {
                                  _addBusinessRequest(context);
                                } else {
                                  Fluttertoast.showToast(
                                      msg:
                                          "please select Bussiness Type & Vendor Role first!",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.CENTER,
                                      backgroundColor: Colors.red);
                                }
                              },
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(0.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(80.0)),
                              child: Container(
                                width: 178,
                                height: 56,
                                decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: <Color>[
                                        Color(0xFF314498),
                                        Color(0xFF2E879A),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(10.0))),
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      showProgressloading == true
                                          ? CircularProgressIndicator()
                                          : const Text('Save',
                                              style: TextStyle(fontSize: 20)),
                                    ]),
                              ),
                            ),
                          )),
                    )
                  ])),
        )));
  }
}
