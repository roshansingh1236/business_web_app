import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:device_info/device_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:bussiness_web_app/bloc/login/login_bloc.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/utils/animations/fade_animation.dart';
import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';

class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _otpUrl = _baseUrl + '/vendor/login';
  String country = "India";
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  int _otpCodeLength = 6;
  bool _isLoadingButton = false;
  String _otpCode = "";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showDiv = false;
  String deviceId;
  String _token;
  String deviceType;
  String countryCode = "IN";
  var _phone;
  bool _validate = false;
  final RegExp phoneRegex = new RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

  @override
  void initState() {
    super.initState();

    lookupUserCountry();
    _getSignatureCode();
  }

// to get country name
  Future<String> lookupUserCountry() async {
    final response = await http.get('https://api.ipregistry.co?key=tryout');

    if (response.statusCode == 200) {
      setState(() {
        country = json.decode(response.body)['location']['country']['name'];
      });
      print(json.decode(response.body)['location']['country']['calling_code']);
      Cache.storage.setString(
          'country', json.decode(response.body)['location']['country']['name']);
      Cache.storage.setString('calling_code',
          json.decode(response.body)['location']['country']['calling_code']);
      Cache.storage.setString('countryCode',
          json.decode(response.body)['location']['country']['code']);
      setState(() {
        countryCode = json.decode(response.body)['location']['country']['code'];
      });
      return json.decode(response.body)['location']['country']['name'];
    } else {
      throw Exception('Failed to get user country from IP address');
    }
  }

  _otpRequest(BuildContext context) async {
    // set up POST request arguments
    //  print(_deviceid);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final msg = country != "India"
        ? jsonEncode({"isforeign": true, "email": _emailController.text})
        : jsonEncode({
            "isforeign": false,
            "phoneNumber": _phone,
          });
    //print(msg);
    //print(_otpUrl);
    // make POST request
    Response response = await post(_otpUrl, headers: headers, body: msg);
    // check the status code for the result
    int statusCode = response.statusCode;
    //print(statusCode);
    print(response.body);
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      Fluttertoast.showToast(
          msg: "OTP has been sent on your number",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      setState(() {
        showDiv = true;
      });
      // Navigator.of(context, rootNavigator: true).pop();
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

  /// get signature code
  _getSignatureCode() async {
    String signature = await SmsRetrieved.getAppSignature();
    //("signature $signature");
  }

  // ignore: unused_element
  _onSubmitOtp() {
    setState(() {
      _isLoadingButton = !_isLoadingButton;
      _verifyOtpCode();
    });
  }

  _onOtpCallBack(String otpCode, bool isAutofill) {
    setState(() {
      this._otpCode = otpCode;
      if (otpCode.length == _otpCodeLength && isAutofill) {
        _isLoadingButton = true;
        _verifyOtpCode();
      } else if (otpCode.length == _otpCodeLength && !isAutofill) {
        _isLoadingButton = false;
      } else {}
    });
  }

  _verifyOtpCode() {
    FocusScope.of(context).requestFocus(new FocusNode());
    Timer(Duration(milliseconds: 4000), () {
      setState(() {
        _isLoadingButton = false;
      });

      // ignore: deprecated_member_use
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text("Verification OTP Code $_otpCode Success")));
    });
  }

  // ignore: unused_element
  Widget _setUpButtonChild() {
    if (_isLoadingButton) {
      return Container(
        width: 19,
        height: 19,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    } else {
      return Text(
        "Verify",
        style: TextStyle(color: Colors.white),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _onLoginButtonPressed() {
      if (this._otpCode != null && _usernameController.text != null) {
        print(_token);
        if (country == "India") {
          BlocProvider.of<LoginBloc>(context).add(
            LoginSubmitEvent(
                phoneNumber: _phone,
                otp: this._otpCode,
                isforeign: false,
                deviceType: deviceType,
                deviceId: deviceId,
                token: _token,
                email: _emailController.text),
          );
        } else {
          BlocProvider.of<LoginBloc>(context).add(
            LoginSubmitEvent(
                phoneNumber: _phone,
                otp: this._otpCode,
                isforeign: true,
                deviceType: deviceType,
                deviceId: deviceId,
                token: _token,
                email: _emailController.text),
          );
        }
      } else {
        Fluttertoast.showToast(
            msg: "please enter OTP!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.red);
      }
    }

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginFailureState) {
          //  print(state);
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: Text('${state.error}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          return GestureDetector(
            onTap: () {
              //here
              FocusScope.of(context).unfocus();
            },
            child: Scaffold(
                backgroundColor: Color(0xff3289a0),
                resizeToAvoidBottomInset: false,
                body: Center(
                    child: Form(
                  child: SingleChildScrollView(
                    child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width / 3.4,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                  'assets/images/Onboarding.png',
                                ),
                                fit: BoxFit.cover)),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    bottom: 50.0, left: 20, right: 20),
                                child: Column(
                                  children: <Widget>[
                                    FadeAnimation(
                                        1.8,
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.2,
                                                  decoration: new BoxDecoration(
                                                    borderRadius:
                                                        new BorderRadius
                                                            .circular(10.0),
                                                    color: Color(0xff5A96AC),
                                                  ),
                                                  child: country != "India"
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 0),
                                                          child: Container(
                                                            width: 100,
                                                            child:
                                                                TextFormField(
                                                              keyboardType:
                                                                  TextInputType
                                                                      .emailAddress,
                                                              controller:
                                                                  _emailController,
                                                              decoration:
                                                                  InputDecoration(
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    "Email Id",
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xff5A96AC),
                                                                  ),
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          50.0),
                                                                ),
                                                                suffixIcon:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    _otpRequest(
                                                                        context);
                                                                    FocusScope.of(
                                                                            context)
                                                                        .unfocus();
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .mail,
                                                                      color: Color(
                                                                          0xff212962)),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xff5A96AC),
                                                                  ),
                                                                ),
                                                                hintStyle: TextStyle(
                                                                    fontSize:
                                                                        15,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily:
                                                                        "Roboto"),
                                                              ),
                                                            ),
                                                          ))
                                                      : Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 0),
                                                          child: Container(
                                                            alignment: Alignment
                                                                .center,
                                                            width: 100,
                                                            child:
                                                                IntlPhoneField(
                                                              initialCountryCode:
                                                                  countryCode,
                                                              validator:
                                                                  (value) {
                                                                if (!phoneRegex
                                                                    .hasMatch(
                                                                        value)) {
                                                                  return 'Please enter valid phone number';
                                                                }
                                                                return null;
                                                              },
                                                              inputFormatters: [
                                                                new LengthLimitingTextInputFormatter(
                                                                    10)
                                                              ],
                                                              keyboardType:
                                                                  TextInputType
                                                                      .phone,
                                                              controller:
                                                                  _usernameController,
                                                              decoration:
                                                                  new InputDecoration(
                                                                labelText:
                                                                    'Phone Number',
                                                                errorText: _validate
                                                                    ? 'Please fill the correct number!'
                                                                    : null,
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                suffixIcon:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {
                                                                      !phoneRegex.hasMatch(
                                                                              _phone)
                                                                          ? _validate =
                                                                              true
                                                                          : _validate =
                                                                              false;
                                                                    });
                                                                    if (_validate ==
                                                                        false) {
                                                                      _otpRequest(
                                                                          context);
                                                                      FocusScope.of(
                                                                              context)
                                                                          .unfocus();
                                                                    }
                                                                  },
                                                                  icon: Icon(
                                                                      Icons
                                                                          .send_to_mobile,
                                                                      color: Color(
                                                                          0xff212962)),
                                                                ),
                                                                enabledBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xff5A96AC),
                                                                  ),
                                                                  borderRadius:
                                                                      new BorderRadius
                                                                              .circular(
                                                                          50.0),
                                                                ),
                                                                focusedBorder:
                                                                    UnderlineInputBorder(
                                                                  borderSide:
                                                                      BorderSide(
                                                                    color: Color(
                                                                        0xff5A96AC),
                                                                  ),
                                                                ),
                                                                labelStyle: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontFamily:
                                                                        "Roboto"),
                                                              ),
                                                              onChanged:
                                                                  (phone) {
                                                                //when phone number country code is changed
                                                                setState(() {
                                                                  _phone = phone
                                                                      .completeNumber
                                                                      .replaceAll(
                                                                          '+',
                                                                          '');
                                                                });

                                                                //get complete number
                                                                /* print(phone
                                                                  .countryCode); */ // get country code only
                                                                // only phone number
                                                              },
                                                            ),
                                                          ))),
                                              showDiv == false
                                                  ? new Container()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 10,
                                                                      top: 10),
                                                              child: Text(
                                                                "One Time Password",
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
                                                              )),
                                                          Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right: 0,
                                                                      top: 10),
                                                              child:
                                                                  TextFieldPin(
                                                                filled: true,
                                                                filledColor: Color(
                                                                    0xff5A96AC),
                                                                codeLength:
                                                                    _otpCodeLength,
                                                                boxSize: 40,
                                                                filledAfterTextChange:
                                                                    false,
                                                                textStyle:
                                                                    TextStyle(
                                                                        fontSize:
                                                                            16),
                                                                borderStyle: OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide
                                                                            .none,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10)),
                                                                onOtpCallback: (code,
                                                                        isAutofill) =>
                                                                    _onOtpCallBack(
                                                                        code,
                                                                        isAutofill),
                                                              ))
                                                        ]),
                                            ],
                                          ),
                                        )),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    /*  FadeAnimation(
                                  2,
                                  Container(
                                    height: 50,
                                    width: 300.0,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: [
                                          Color.fromRGBO(143, 148, 251, 1),
                                          Color.fromRGBO(143, 148, 251, .6),
                                        ])),
                                    child: (ElevatedButton(
                                      onPressed: state is! LoginLoadingState
                                          ? _onLoginButtonPressed
                                          : null,
                                      style: ElevatedButton.styleFrom(
                                        primary:
                                            Colors.lightBlue[200], // background
                                        onPrimary: Colors.white,
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      child: state is LoginLoadingState
                                          ? CircularProgressIndicator()
                                          : Text(
                                              "Log In",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 20.0,
                                                  color: Colors.white),
                                            ),
                                    )),
                                  )), */
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0, top: 10),
                                        child: Container(
                                          height: 40,
                                          width: 207.0,
                                          decoration: const BoxDecoration(
                                              gradient: LinearGradient(
                                                colors: <Color>[
                                                  Color(0xFF2E879A),
                                                  Color(0xFF314498),
                                                ],
                                              ),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0))),
                                          child: RaisedButton(
                                            elevation: 0,
                                            onPressed:
                                                state is! LoginLoadingState
                                                    ? _onLoginButtonPressed
                                                    : null,
                                            textColor: Colors.white,
                                            padding: const EdgeInsets.all(0.0),
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        80.0)),
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: <Color>[
                                                      Color(0xFF2E879A),
                                                      Color(0xFF314498),
                                                    ],
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              10.0))),
                                              child: state is LoginLoadingState
                                                  ? CircularProgressIndicator()
                                                  : Center(
                                                      child: Text(
                                                        "LOG IN",
                                                        textScaleFactor: 1.0,
                                                        style: TextStyle(
                                                            fontSize: 15.0,
                                                            fontFamily:
                                                                "Roboto",
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .normal),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: 50,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                  ),
                ))),
          );
        },
      ),
    );
  }
}
