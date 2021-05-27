import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/pages/home/home_page.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';

class UserPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<UserPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/vendor/preference/user';
  final formKey = GlobalKey<FormState>();
  String token = '';
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

  var name = TextEditingController();
  var email = TextEditingController();
  var phone = TextEditingController();

  _addBusinessRequest(BuildContext context) async {
    // set up POST request arguments
    final msg1 = jsonEncode({
      "name": name.text,
      "phone": _phone.replaceAll('+', ''),
      "email": email.text,
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
      HomePage();
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
      country = Cache.storage.getString('country');
      countryCode = Cache.storage.getString('countryCode');
    });
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
        body: SingleChildScrollView(
            child: Container(
          padding: const EdgeInsets.only(top: 5, left: 0),
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
                                new Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                          padding: EdgeInsets.only(right: 20.0),
                                          child: Text(
                                            "Add Users",
                                            textScaleFactor: 1.0,
                                            style: TextStyle(
                                                fontSize: 35.0,
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
                                                              'User Name',
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
                                                      controller: email,
                                                      validator: validateEmail,
                                                      keyboardType:
                                                          TextInputType
                                                              .emailAddress,
                                                      decoration: InputDecoration(
                                                          labelText: 'Email',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black54)),
                                                      onSaved: (input) =>
                                                          data['email'] = input,
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
                                                        top: 2.0,
                                                        bottom: 20),
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
                                                          TextInputType.phone,
                                                      decoration: InputDecoration(
                                                          labelText: 'Phone',
                                                          labelStyle: TextStyle(
                                                              color: Colors
                                                                  .black54)),
                                                      onSaved: (input) {
                                                        data['phone'] = input;
                                                      },
                                                    ),
                                                  )),
                                            ]),
                                      ]))))
                    ])),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 20),
                          child: SizedBox(
                            width: 178,
                            height: 56,
                            child: RaisedButton(
                              elevation: 0,
                              onPressed: () {
                                _addBusinessRequest(context);
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
                                      const Text('Save',
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
