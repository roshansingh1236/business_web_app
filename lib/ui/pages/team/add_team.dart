import 'dart:async';
import 'dart:typed_data';

import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/pages/about/profile.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';

class TeamPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TeamPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final _businessUrl = _baseUrl + '/vendor-team';
  static final configUrl = _baseUrl + '/global-config';
  static final _s3Url1 = _baseUrl + '/core/s3signature';
  final formKey = GlobalKey<FormState>();
  String token = '';
  String _s3VehicleUrl = "No Image";
  String _s3VehicleUrl2 = "No Image";
  File _pickedImage;
  String _s3URL = "No Image";
  // ignore: deprecated_member_use
  List _configList1 = [];
  String _fileName;
  File _pickedImage2;
  File _pickedImage3;
  bool showProgressloading = false;
  String _role1;
  String _titleValue;
  String _docValue;
  String _fileName3;
  var document = [];
  Map data = {
    'name': String,
    'address': String,
    'gstin': String,
    'pan': String
  };
  String name1 = '';
  Uint8List data1;
  Uint8List data2;
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

  TextEditingController textEditingController = new TextEditingController();
  var name = TextEditingController();
  var address = TextEditingController();
  var email = TextEditingController();
  var gst = TextEditingController();
  var pan = TextEditingController();

  Future<String> getConfigRoleData() async {
    var res = await http.get(
        Uri.encodeFull(configUrl + "?filter[key]=DSIGNATION"),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['globalConfigs'];
    resBody.forEach((value) {
      _configList1 = value['value'];
    });
    // loop through the json object
    // loop through the json object
    print(_configList1);
    setState(() {});
    return "Sucess";
  }

  // upload image to s3
  Future<String> getS3DataForDocument2() async {
    var res = await http.get(
        Uri.encodeFull(_s3Url1 +
            "?_organisationId=5d147d1dfb6fc00e79b12fdc&folder=Team_Member" +
            "&fileName=$_fileName3&fileType=image/jpeg"),
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
      showProgressloading = true;
      _s3VehicleUrl2 = url;
    });
    document.add({"path": _s3VehicleUrl2, "name": _docValue});
    print(document);
    setState(() {
      showProgressloading = false;
    });
    return "Sucess";
  }

  // upload image to s3
  Future<String> getS3DataForVehicle() async {
    var res = await http.get(
        Uri.encodeFull(_s3Url1 +
            "?_organisationId=5d147d1dfb6fc00e79b12fdc&folder=Team_Member" +
            "&fileName=$_fileName3&fileType=image/jpeg"),
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
      showProgressloading = true;
      _s3VehicleUrl = url;
      showProgressloading = false;
    });
    document.add({"path": _s3VehicleUrl, "name": "Adhaar Card"});
    print(document);
    return "Sucess";
  }

  void _pickImage3(int number) async {
    final html.InputElement input = html.document.createElement('input');
    input
      ..type = 'file'
      ..accept = 'image/csv/pdf/doc/*';

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
              _fileName3 = name1;
            });
            //calling api for s3
            this.getS3DataForDocument2();
          } else {
            setState(() {
              showProgressloading = true;
              _fileName = name1;
            });
            //calling api for s3
            this.getS3DataForVehicle();
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
            "?_organisationId=5d147d1dfb6fc00e79b12fdc&folder=Team_Member" +
            "&fileName=$_fileName&fileType=image/jpeg"),
        headers: {"Authorization": token});
    var url = json.decode(res.body)["url"];
    print(res.body);
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
      showProgressloading = true;
      _s3URL = url;
      showProgressloading = false;
    });
    print(_s3URL);
    return "Sucess";
  }

  _addBusinessRequest(BuildContext context) async {
    // set up POST request arguments
    var date = new DateTime.now().toString();
    // make POST request
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token
    };
    final msg1 = jsonEncode({
      "serviceType": _role1,
      "designation": _role1,
      "gender": _titleValue,
      "name": name.text,
      "photo": _s3URL,
      "phone": address.text,
      "documents": document,
      "joiningDate": date,
      "email": email.text
    });
    final msg = jsonEncode({
      "serviceType": _role1,
      "designation": _role1,
      "gender": _titleValue,
      "name": name.text,
      "photo": _s3URL,
      "phone": address.text,
      "joiningDate": date,
      "email": email.text
    });
    print(document);
    print(_businessUrl);
    Response response = await post(_businessUrl,
        body: document.length != 0 ? msg1 : msg, headers: headers);

    // check the status code for the result
    int statusCode = response.statusCode;
    print(statusCode);
    print(response.body);
    if (statusCode == 201) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.
      //Cache.storage.setInt('isProfileCompleted', 1);
      Fluttertoast.showToast(
          msg: "Team Member Added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      NavigationUtil.pushToNewScreen(context, ProfilePage());
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
          if (number == 2) {
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

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });
    this.getConfigRoleData();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffF0F6FB),
      systemNavigationBarDividerColor: Colors.black,
    ));
    return Scaffold(
        backgroundColor: Color(0xffF0F6FB),
        resizeToAvoidBottomInset: false,
        appBar: CommonWidgets1.getAppBar(context),
        body: SingleChildScrollView(
            child: Container(
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
                                InkWell(
                                    onTap: () {
                                      _pickImage(2);
                                    },
                                    child: Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          _pickedImage != null
                                              ? new Container(
                                                  height: 150,
                                                  width: 150,
                                                  decoration: new BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color:
                                                        const Color(0xff7c94b6),
                                                    image: new DecorationImage(
                                                      image: FileImage(
                                                          _pickedImage),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                )
                                              : Container(
                                                  decoration: new BoxDecoration(
                                                    color: Colors.grey,
                                                    shape: BoxShape.circle,
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
                      new SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Container(
                              height: MediaQuery.of(context).size.height / 1.8,
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
                                                      1.20,
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0,
                                                        right: 3.0,
                                                        top: 2.0),
                                                    child: TextFormField(
                                                      controller: name,
                                                      validator: (input) {
                                                        if (input.isEmpty) {
                                                          return 'Please enter Name';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Name',
                                                      ),
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
                                                      keyboardType:
                                                          TextInputType.phone,
                                                      controller: address,
                                                      validator: (input) {
                                                        if (input.isEmpty) {
                                                          return 'Please enter phone';
                                                        }
                                                        return null;
                                                      },
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Phone',
                                                      ),
                                                      onSaved: (input) =>
                                                          data['phone'] = input,
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
                                                      decoration:
                                                          InputDecoration(
                                                        labelText: 'Email',
                                                      ),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10.0,
                                                            right: 0),
                                                    child: Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.2,
                                                        decoration:
                                                            new BoxDecoration(
                                                          borderRadius:
                                                              new BorderRadius
                                                                      .circular(
                                                                  10.0),
                                                        ),
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0,
                                                                    right: 0),
                                                            child:
                                                                DropdownButton(
                                                              isExpanded: true,
                                                              iconEnabledColor:
                                                                  Colors.black,
                                                              hint: _role1 ==
                                                                      null
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
                                                                            'Select Member Role',
                                                                            textScaleFactor:
                                                                                1.0,
                                                                            style:
                                                                                TextStyle(fontSize: 18),
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
                                                                            _role1,
                                                                            textScaleFactor:
                                                                                1.0,
                                                                            style:
                                                                                TextStyle(
                                                                              color: Colors.black,
                                                                            ),
                                                                          )
                                                                        ]),
                                                              iconSize: 30.0,
                                                              icon: Icon(
                                                                Icons
                                                                    .arrow_drop_down,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                              items: _configList1
                                                                  .map(
                                                                      (location) {
                                                                return new DropdownMenuItem(
                                                                  child: new Text(
                                                                      location),
                                                                  value:
                                                                      location,
                                                                );
                                                              }).toList(),
                                                              onChanged: (val) {
                                                                setState(
                                                                  () {
                                                                    _role1 =
                                                                        val;
                                                                  },
                                                                );
                                                              },
                                                              value: _role1,
                                                            )))),
                                              ),
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
                                                    child: DropdownButton(
                                                      iconEnabledColor:
                                                          Colors.black,
                                                      hint: _titleValue == null
                                                          ? Text(
                                                              'Gender',
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                  fontSize: 18),
                                                            )
                                                          : Text(
                                                              _titleValue,
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                            ),
                                                      isExpanded: true,
                                                      iconSize: 30.0,
                                                      style: TextStyle(
                                                          color: Colors.blue),
                                                      items: [
                                                        'male',
                                                        'female',
                                                        'na'
                                                      ].map(
                                                        (val) {
                                                          //  _flatList.add(val);

                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: val,
                                                            child: Text(
                                                              val,
                                                              textScaleFactor:
                                                                  1.0,
                                                            ),
                                                          );
                                                        },
                                                      ).toList(),
                                                      onChanged: (val) {
                                                        setState(
                                                          () {
                                                            _titleValue = val;
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  )),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.45,
                                                        child: Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5.0,
                                                                    right: 10.0,
                                                                    top: 0.0),
                                                            child:
                                                                TextFormField(
                                                              enabled: false,
                                                              controller:
                                                                  textEditingController,
                                                              decoration:
                                                                  InputDecoration(
                                                                labelText:
                                                                    'Adhaar Card',
                                                              ),
                                                            ))),
                                                    _pickedImage2 == null
                                                        ? Material(
                                                            child: InkWell(
                                                            onTap: () {
                                                              _pickImage3(1);
                                                            },
                                                            child: Container(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                child: Image.asset(
                                                                    'assets/images/download.png',
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0),
                                                              ),
                                                            ),
                                                          ))
                                                        : Material(
                                                            child: InkWell(
                                                            onTap: () {
                                                              _pickImage3(1);
                                                            },
                                                            child:
                                                                new Container(
                                                              height: 50.0,
                                                              width: 60.0,
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: const Color(
                                                                    0xff7c94b6),
                                                                image:
                                                                    new DecorationImage(
                                                                  image: FileImage(
                                                                      _pickedImage2),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                borderRadius:
                                                                    new BorderRadius
                                                                        .all(const Radius
                                                                            .circular(
                                                                        5.0)),
                                                              ),
                                                            ),
                                                          ))
                                                  ]),
                                              Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceEvenly,
                                                  children: <Widget>[
                                                    Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width /
                                                            1.45,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5.0,
                                                                  right: 10.0,
                                                                  top: 12.0),
                                                          child: DropdownButton(
                                                            hint: _docValue ==
                                                                    null
                                                                ? Text(
                                                                    'Select Document 2',
                                                                    textScaleFactor:
                                                                        1.0,
                                                                  )
                                                                : Text(
                                                                    _docValue,
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                  ),
                                                            isExpanded: true,
                                                            iconSize: 30.0,
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue),
                                                            items: [
                                                              "Pan Card",
                                                              "Voter ID",
                                                              "Driving Lnc.",
                                                              "BPL Card"
                                                            ].map(
                                                              (val) {
                                                                //_flatList.addAll({"flat":"val"});
                                                                return DropdownMenuItem<
                                                                    String>(
                                                                  value: val,
                                                                  child: Text(
                                                                    val,
                                                                    textScaleFactor:
                                                                        1.0,
                                                                  ),
                                                                );
                                                              },
                                                            ).toList(),
                                                            onChanged: (val) {
                                                              setState(
                                                                () {
                                                                  _docValue =
                                                                      val;
                                                                },
                                                              );
                                                            },
                                                          ),
                                                        )),
                                                    _pickedImage3 == null
                                                        ? Material(
                                                            child: InkWell(
                                                            onTap: () {
                                                              if (_docValue !=
                                                                  null) {
                                                                _pickImage3(2);
                                                              } else {
                                                                Fluttertoast.showToast(
                                                                    msg:
                                                                        "Select Document Type First",
                                                                    toastLength:
                                                                        Toast
                                                                            .LENGTH_SHORT,
                                                                    gravity:
                                                                        ToastGravity
                                                                            .CENTER);
                                                              }
                                                            },
                                                            child: Container(
                                                              child: ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                child: Image.asset(
                                                                    'assets/images/download.png',
                                                                    width: 50.0,
                                                                    height:
                                                                        50.0),
                                                              ),
                                                            ),
                                                          ))
                                                        : Material(
                                                            child: InkWell(
                                                            onTap: () {
                                                              _pickImage3(2);
                                                            },
                                                            child:
                                                                new Container(
                                                              height: 50.0,
                                                              width: 60.0,
                                                              decoration:
                                                                  new BoxDecoration(
                                                                color: const Color(
                                                                    0xff7c94b6),
                                                                image:
                                                                    new DecorationImage(
                                                                  image: FileImage(
                                                                      _pickedImage3),
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                                borderRadius:
                                                                    new BorderRadius
                                                                        .all(const Radius
                                                                            .circular(
                                                                        5.0)),
                                                              ),
                                                            ),
                                                          ))
                                                  ]),
                                            ]),
                                      ]))))
                    ])),
                    Center(
                      child: Padding(
                          padding: const EdgeInsets.only(left: 0, top: 10),
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
