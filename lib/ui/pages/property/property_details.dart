import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:bussiness_web_app/config/cache.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/pages/property/list_property.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/animations/fade_animation.dart';
import 'package:bussiness_web_app/utils/common_util.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';

import 'package:slider_button/slider_button.dart';

class PropertyDetailsPage extends StatefulWidget {
  var id;
  PropertyDetailsPage({Key key, this.id}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<PropertyDetailsPage> {
  static final _baseUrl = Env.apiBaseUrl;
  static final propertyUrl = _baseUrl + "/property";
  static final _s3Url1 = _baseUrl + '/core/s3signature';
  static final configUrl = _baseUrl + '/global-config';
  bool _hasBeenPressed = false;
  String _date = 'rent';
  String _zoomImage;
  String _tabText = "Details";
  var format2;
  var format3;
  bool readOnlyShow = true;
  var productName = TextEditingController();
  var name = TextEditingController();
  var ownerName = TextEditingController();
  var phone = TextEditingController();
  var callingcode = TextEditingController();
  var address1 = TextEditingController();
  var details = TextEditingController();
  var rentPrice = TextEditingController();
  var sellingPrice = TextEditingController();
  var priceName = TextEditingController();
  var sizeName = TextEditingController();
  var noOfBedroom = TextEditingController();
  var noOfBathroom = TextEditingController();
  var address = TextEditingController();
  var comment = TextEditingController();
  final dateController = TextEditingController();
  var postalcode = TextEditingController();
  var country = TextEditingController();
  var city = TextEditingController();
  var street = TextEditingController();
  var houseno = TextEditingController();
  var floorno = TextEditingController();
  var unitno = TextEditingController();
  var postalcode1 = TextEditingController();
  var country1 = TextEditingController();
  var city1 = TextEditingController();
  var street1 = TextEditingController();
  var houseno1 = TextEditingController();
  var floorno1 = TextEditingController();
  var unitno1 = TextEditingController();
  var constructedyear = TextEditingController();
  var minimumdeposit = TextEditingController();
  var qty1 = TextEditingController();
  String countryCode = "IN";
  var image1 = [];
  var image2 = [];
  var catalogue = [];
  List amenityList = [];
  File _pickedImage;
  String _fileName;
  String token = '';
  String _s3URL1 = "No Image";
  bool showProgressloading = false;
  List _configList = [];
  List _unitList = [];
  String _type;
  String _unitType;
  String name1 = '';
  Uint8List data;
  Future<String> getConfigData() async {
    var res = await http.get(Uri.encodeFull(configUrl + "?filter[key]=type"),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['globalConfigs'];
    // loop through the json object
    // loop through the json object
    resBody.forEach((value) {
      _configList = value['value'];
    });
    this.getUnitTypeData();
    setState(() {});
    return "Sucess";
  }

  Future<String> getUnitTypeData() async {
    var res = await http.get(
        Uri.encodeFull(configUrl + "?filter[key]=unit_type"),
        headers: {"Authorization": token});
    var resBody = json.decode(res.body)['globalConfigs'];
    // loop through the json object
    // loop through the json object
    resBody.forEach((value) {
      _unitList = value['value'];
    });
    setState(() {});
    return "Sucess";
  }

  _deleteProductRequest(BuildContext context) async {
    // set up POST request arguments

    // make POST request
    final response =
        await http.delete(propertyUrl + "?id=" + widget.id['_id'], headers: {
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
          msg: "Property deleted!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          backgroundColor: Colors.red);
      NavigationUtil.pushToNewScreen(context, PropertyListPage());
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

  _addPropertyRequest(BuildContext context) async {
    // set up POST request arguments
    final msg1 = sellingPrice.text != "" && rentPrice.text != ""
        ? jsonEncode({
            "name": productName.text,
            "classification": "both",
            "type": _type,
            "images": image1,
            "det_address": {
              "postal_code": postalcode.text,
              "country": country.text,
              "city": city.text,
              "street": street.text,
              "house_no": houseno.text,
              "floor_no": floorno.text,
              "unit_no": unitno.text
            },
            "selling_price": sellingPrice.text,
            "rent_price": rentPrice.text,
            "size": sizeName.text,
            "owner_details": {
              "name": ownerName.text,
              "address": {
                "postal_code": postalcode1.text,
                "country": country1.text,
                "city": city1.text,
                "street": street1.text,
                "house_no": houseno1.text,
                "floor_no": floorno1.text,
                "unit_no": unitno1.text
              },
              "availability_startTime": format2,
              "availability_endTime": format3,
              "phone": phone.text
            },
            "no_bedroom": _unitType,
            "no_bathroom": noOfBathroom.text,
            "availability_date": dateController.text,
            "description": comment.text,
            "catalogue": catalogue,
            "constructed_year": constructedyear.text,
            "minimum_deposit": minimumdeposit.text
          })
        : sellingPrice.text != ""
            ? jsonEncode({
                "name": productName.text,
                "classification": _date,
                "type": _type,
                "images": image1,
                "det_address": {
                  "postal_code": postalcode.text,
                  "country": country.text,
                  "city": city.text,
                  "street": street.text,
                  "house_no": houseno.text,
                  "floor_no": floorno.text,
                  "unit_no": unitno.text
                },
                "selling_price": sellingPrice.text,
                "size": sizeName.text,
                "owner_details": {
                  "name": ownerName.text,
                  "address": {
                    "postal_code": postalcode1.text,
                    "country": country1.text,
                    "city": city1.text,
                    "street": street1.text,
                    "house_no": houseno1.text,
                    "floor_no": floorno1.text,
                    "unit_no": unitno1.text
                  },
                  "availability_startTime": format2,
                  "availability_endTime": format3,
                  "phone": phone.text
                },
                "no_bedroom": _unitType,
                "no_bathroom": noOfBathroom.text,
                "availability_date": dateController.text,
                "description": comment.text,
                "catalogue": catalogue,
                "constructed_year": constructedyear.text,
                "minimum_deposit": minimumdeposit.text
              })
            : jsonEncode({
                "name": productName.text,
                "classification": _date,
                "type": _type,
                "images": image1,
                "det_address": {
                  "postal_code": postalcode.text,
                  "country": country.text,
                  "city": city.text,
                  "street": street.text,
                  "house_no": houseno.text,
                  "floor_no": floorno.text,
                  "unit_no": unitno.text
                },
                "rent_price": rentPrice.text,
                "size": sizeName.text,
                "owner_details": {
                  "name": ownerName.text,
                  "address": {
                    "postal_code": postalcode1.text,
                    "country": country1.text,
                    "city": city1.text,
                    "street": street1.text,
                    "house_no": houseno1.text,
                    "floor_no": floorno1.text,
                    "unit_no": unitno1.text
                  },
                  "availability_startTime": format2,
                  "availability_endTime": format3,
                  "phone": phone.text
                },
                "no_bedroom": _unitType,
                "no_bathroom": noOfBathroom.text,
                "availability_date": dateController.text,
                "description": comment.text,
                "catalogue": catalogue,
                "constructed_year": constructedyear.text,
                "minimum_deposit": minimumdeposit.text
              });
    // make POST request
    final response = await http
        .put(propertyUrl + "?id=" + widget.id['_id'], body: msg1, headers: {
      "Authorization": token,
      'Content-type': 'application/json',
      'Accept': 'application/json',
    });
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      // If the server did return a 201 CREATED response,
      // then parse the JSON.

      NavigationUtil.pushToNewScreen(context, PropertyListPage());
    } else if (statusCode == 201) {
      NavigationUtil.pushToNewScreen(context, PropertyListPage());
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
      countryCode = Cache.storage.getString('countryCode');
      callingcode.text = "+" + Cache.storage.getString('calling_code');
      productName.text = widget.id['name'];
      _unitType = widget.id['no_bedroom'].toString();
      _date = widget.id['classification'];
      _type = widget.id['type'];
      image1 = widget.id['images'];
      postalcode1.text = widget.id['owner_details']['address']['postal_code'];
      country1.text = widget.id['owner_details']['address']['country'];
      city1.text = widget.id['owner_details']['address']['city'];
      street1.text = widget.id['owner_details']['address']['street'];
      houseno1.text = widget.id['owner_details']['address']['house_no'];
      floorno1.text = widget.id['owner_details']['address']['floor_no'];
      unitno1.text = widget.id['owner_details']['address']['unit_no'];
      postalcode.text = widget.id['det_address']['postal_code'];
      country.text = widget.id['det_address']['country'];
      city.text = widget.id['det_address']['city'];
      street.text = widget.id['det_address']['street'];
      houseno.text = widget.id['det_address']['house_no'];
      floorno.text = widget.id['det_address']['floor_no'];
      unitno.text = widget.id['det_address']['unit_no'];
      rentPrice.text = widget.id['rent_price'] != null
          ? widget.id['rent_price'].toString()
          : "";
      sizeName.text = widget.id['size'].toString();
      sellingPrice.text = widget.id['selling_price'] != null
          ? widget.id['selling_price'].toString()
          : "";
      noOfBathroom.text = widget.id['no_bathroom'].toString();
      dateController.text = widget.id['availability_date'];
      comment.text = widget.id['description'];
      //catalogue = widget.id['catalogue'];
      catalogue = widget.id['catalogue'];
      ownerName.text = widget.id['owner_details']['name'];
      phone.text = widget.id['owner_details']['phone'];
      format2 = widget.id['owner_details']['availability_startTime'];
      format3 = widget.id['owner_details']['availability_endTime'];
      constructedyear.text = widget.id['constructed_year'];
      minimumdeposit.text = widget.id['minimum_deposit'].toString();
    });
    this.getConfigData();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed
    dateController.dispose();
    super.dispose();
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
          data = base64.decode(stripped);
        });

        if (input.files[0] != null) {
          if (number == 1) {
            setState(() {
              _fileName = name1;
            });
            //calling api for s3
            this.getS3DataForProductImage(1);
          } else {
            setState(() {
              _fileName = name1;
            });
            //calling api for s3
            this.getS3DataForProductImage(2);
          }
        }
      });
    });

    input.click();
  }

  // upload image to s3
  Future<String> getS3DataForProductImage(int number) async {
    var res = await http.get(
        Uri.encodeFull(_s3Url1 +
            "?_organisationId=5d147d1dfb6fc00e79b12fdc&folder=property" +
            "&fileName=$_fileName&fileType=image/jpeg/png/jpg"),
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
    if (number == 1) {
      setState(() {
        showProgressloading = true;
        _s3URL1 = url;
        image2.add(_s3URL1);
        showProgressloading = false;
      });
    } else {
      setState(() {
        showProgressloading = true;
        _s3URL1 = url;
        image1.add(_s3URL1);
        showProgressloading = false;
      });
    }
    print(url);
    return "Sucess";
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timePicked != null)
      setState(() {
        format2 = timePicked.format(context);
      });
  }

  Future<Null> _selectTime2(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (timePicked != null)
      setState(() {
        format3 = timePicked.format(context);
      });
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

  Widget _balancepaymentTab(BuildContext context) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            controller: productName,
            enabled: !readOnlyShow,
            validator: (input) {
              if (input.isEmpty) {
                return 'Please enter Name';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Property Name',
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  color: readOnlyShow == true ? Colors.grey : Color(0xff314498),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          )),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 180,
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                child: TextField(
                  enabled: !readOnlyShow,
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Pick availability Date',
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: readOnlyShow == true
                            ? Colors.grey
                            : Color(0xff314498),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                  onTap: () async {
                    var date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100));
                    dateController.text = date.toString().substring(0, 10);
                  },
                ))),
        Container(
            width: 150,
            child: Padding(
                padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 0.0),
                child: TextFormField(
                  enabled: !readOnlyShow,
                  controller: minimumdeposit,
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter Minimum Deposit';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Minimum Deposit',
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: readOnlyShow == true
                            ? Colors.grey
                            : Color(0xff314498),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                )))
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 180,
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
                child: TextFormField(
                  enabled: !readOnlyShow,
                  controller: rentPrice,
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter Rental Price';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: _date == 'rent'
                        ? 'Rental Price'
                        : 'Rental Price(optional)',
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: readOnlyShow == true
                            ? Colors.grey
                            : Color(0xff314498),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                )),
          ),
          Container(
              width: 150,
              child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 0.0, top: 10.0),
                  child: TextFormField(
                    enabled: !readOnlyShow,
                    controller: sellingPrice,
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter Saliing Price';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: _date == 'sale'
                          ? 'Selling Price'
                          : 'Selling Price(optional)',
                      labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: readOnlyShow == true
                              ? Colors.grey
                              : Color(0xff314498),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ))),
        ],
      ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
            width: 160,
            child: Padding(
                padding: EdgeInsets.only(left: 20.0, right: 0.0, top: 0.0),
                child: TextFormField(
                  enabled: !readOnlyShow,
                  controller: sizeName,
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter Size';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Size (in sqft.)',
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: readOnlyShow == true
                            ? Colors.grey
                            : Color(0xff314498),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                ))),
        Container(
            width: 170,
            child: Padding(
                padding: EdgeInsets.only(left: 30.0, right: 0.0, top: 0.0),
                child: TextFormField(
                  enabled: !readOnlyShow,
                  controller: constructedyear,
                  keyboardType: TextInputType.number,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'Please enter Constructed Year';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'Constructed Year',
                    labelStyle: TextStyle(
                        fontSize: 12.0,
                        color: readOnlyShow == true
                            ? Colors.grey
                            : Color(0xff314498),
                        fontWeight: FontWeight.bold,
                        fontFamily: "Roboto"),
                  ),
                ))),
      ]),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 180,
            child: Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
              child: DropdownButton(
                isExpanded: true,
                iconEnabledColor: Colors.black,
                hint: _type == null
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Text(
                              'Select Type',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: readOnlyShow == true
                                      ? Colors.grey
                                      : Color(0xff314498),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          ])
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                            Text(
                              _type,
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: readOnlyShow == true
                                      ? Colors.grey
                                      : Color(0xff314498),
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold),
                            )
                          ]),
                iconSize: 30.0,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black,
                ),
                style: TextStyle(color: Colors.black),
                items: _configList.map((location) {
                  return new DropdownMenuItem(
                    child: new Text(location),
                    value: location,
                  );
                }).toList(),
                onChanged: (val) {
                  setState(
                    () {
                      _type = val;
                    },
                  );
                },
                value: _type,
              ),
            ),
          ),
          Container(
              width: 150,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 10.0, top: _unitType == null ? 10 : 10),
                child: DropdownButton(
                  isExpanded: true,
                  iconEnabledColor: Colors.black,
                  hint: _unitType == null
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Text(
                                'No. of Bedroom',
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xff314498),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ])
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                              Text(
                                _unitType == "0" ? "Studio" : _unitType,
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    color: Color(0xff314498),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )
                            ]),
                  iconSize: 30.0,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: Colors.black,
                  ),
                  style: TextStyle(color: Colors.black),
                  items: _unitList.map((location) {
                    return new DropdownMenuItem(
                      child: new Text(
                        location == "0" ? "Studio" : location,
                      ),
                      value: location,
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(
                      () {
                        _unitType = val;
                      },
                    );
                  },
                  value: _unitType,
                ),
              ))
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: 320,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: TextFormField(
                    enabled: !readOnlyShow,
                    controller: noOfBathroom,
                    keyboardType: TextInputType.number,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter no. of Bathroom';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'No. of Bathroom',
                      labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: readOnlyShow == true
                              ? Colors.grey
                              : Color(0xff314498),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ))),
        ],
      ),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            enabled: !readOnlyShow,
            keyboardType: TextInputType.text,
            controller: country,
            validator: (input) {
              if (input.isEmpty) {
                return 'Please enter Country';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Enter Country',
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  color: readOnlyShow == true ? Colors.grey : Color(0xff314498),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            enabled: !readOnlyShow,
            keyboardType: TextInputType.text,
            controller: city,
            validator: (input) {
              if (input.isEmpty) {
                return 'Please enter City';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Enter City',
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  color: readOnlyShow == true ? Colors.grey : Color(0xff314498),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            enabled: !readOnlyShow,
            keyboardType: TextInputType.text,
            controller: street,
            validator: (input) {
              if (input.isEmpty) {
                return 'Please enter Block/Street Name';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Enter street',
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  color: readOnlyShow == true ? Colors.grey : Color(0xff314498),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.text,
            controller: houseno,
            enabled: !readOnlyShow,
            validator: (input) {
              if (input.isEmpty) {
                return 'Please enter Building/House Number';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Enter Building/House Number',
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  color: readOnlyShow == true ? Colors.grey : Color(0xff314498),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          )),
      new Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              width: 180,
              child: Padding(
                  padding: EdgeInsets.only(left: 20.0, right: 0.0, top: 0.0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    enabled: !readOnlyShow,
                    keyboardType: TextInputType.text,
                    controller: unitno,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter Unit';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Unit',
                      labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: readOnlyShow == true
                              ? Colors.grey
                              : Color(0xff314498),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ))),
          Container(
              width: 160,
              child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 20.0, top: 0.0),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    enabled: !readOnlyShow,
                    keyboardType: TextInputType.text,
                    controller: floorno,
                    validator: (input) {
                      if (input.isEmpty) {
                        return 'Please enter floor_no';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter Floor',
                      labelStyle: TextStyle(
                          fontSize: 12.0,
                          color: readOnlyShow == true
                              ? Colors.grey
                              : Color(0xff314498),
                          fontWeight: FontWeight.bold,
                          fontFamily: "Roboto"),
                    ),
                  ))),
        ],
      ),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child: TextFormField(
            keyboardType: TextInputType.number,
            controller: postalcode,
            enabled: !readOnlyShow,
            validator: (input) {
              if (input.isEmpty) {
                return 'Please enter Postal Code';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Enter Postal Code',
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  color: readOnlyShow == true ? Colors.grey : Color(0xff314498),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
          child: TextFormField(
            textCapitalization: TextCapitalization.words,
            enabled: !readOnlyShow,
            maxLines: 2,
            keyboardType: TextInputType.text,
            controller: comment,
            validator: (input) {
              if (input.isEmpty) {
                return 'Please enter Description';
              }
              return null;
            },
            decoration: InputDecoration(
              labelText: 'Enter Description',
              labelStyle: TextStyle(
                  fontSize: 12.0,
                  color: readOnlyShow == true ? Colors.grey : Color(0xff314498),
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto"),
            ),
          )),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              readOnlyShow == true
                  ? Container()
                  : InkWell(
                      onTap: () {
                        if (readOnlyShow == false) {
                          _pickImage(2);
                        }
                      },
                      child: Row(
                        children: [
                          new Icon(
                            Icons.add_circle_rounded,
                            color: Color(0xff314498),
                            size: 20.0,
                          ),
                          Text(" Add Image",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  color: Color(0xff314498),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        ],
                      )),
              SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                      children: image1
                          .map(
                            (item) => Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Container(
                                    height: 59,
                                    width: 60.0,
                                    child: Card(
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6.0),
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
                                                    _displayDialog1(
                                                        context, _zoomImage);
                                                  },
                                                  child: Image(
                                                      image: NetworkImage(item),
                                                      fit: BoxFit.cover,
                                                      width: 100,
                                                      height: 100)),
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
            ],
          )),
      Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 20),
          child: SizedBox(
            width: 284,
            height: 54,
            child: RaisedButton(
              onPressed: () {
                setState(() {
                  _tabText = "Catalogue";
                });
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
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('Next    ', style: TextStyle(fontSize: 20)),
                      Icon(
                        Icons.arrow_right_alt,
                        color: Colors.white,
                        size: 33.0,
                        semanticLabel:
                            'Text to announce in accessibility modes',
                      )
                    ]),
              ),
            ),
          ))
    ]);
  }

  Widget _pastbalancepaymentTab(BuildContext context) {
    return Column(children: [
      readOnlyShow == true
          ? new Container()
          : Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
              child: TextFormField(
                textCapitalization: TextCapitalization.words,
                enabled: !readOnlyShow,
                controller: name,
                validator: (input) {
                  if (input.isEmpty) {
                    return 'Please enter Name';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(
                      fontSize: 12.0,
                      color: readOnlyShow == true
                          ? Colors.grey
                          : Color(0xff314498),
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto"),
                ),
              )),
      readOnlyShow == true
          ? new Container()
          : Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                    width: 160,
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 20.0, right: 10.0, top: 0.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          enabled: !readOnlyShow,
                          controller: details,
                          keyboardType: TextInputType.text,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter Assets';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Assets',
                            labelStyle: TextStyle(
                                fontSize: 12.0,
                                color: readOnlyShow == true
                                    ? Colors.grey
                                    : Color(0xff314498),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"),
                          ),
                        ))),
                Container(
                    width: 150,
                    child: Padding(
                        padding:
                            EdgeInsets.only(left: 0.0, right: 10.0, top: 0.0),
                        child: TextFormField(
                          textCapitalization: TextCapitalization.words,
                          enabled: !readOnlyShow,
                          controller: qty1,
                          keyboardType: TextInputType.text,
                          validator: (input) {
                            if (input.isEmpty) {
                              return 'Please enter Quantity';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            labelStyle: TextStyle(
                                fontSize: 12.0,
                                color: readOnlyShow == true
                                    ? Colors.grey
                                    : Color(0xff314498),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"),
                          ),
                        ))),
                InkWell(
                    onTap: () {
                      amenityList
                          .add({"amenity": details.text, "qty": qty1.text});
                      setState(() {
                        qty1.clear();
                        details.clear();
                      });
                      print(amenityList);
                    },
                    child: Row(
                      children: [
                        new Icon(
                          Icons.add_circle_rounded,
                          color: Colors.green,
                          size: 25.0,
                        ),
                      ],
                    )),
              ],
            ),
      amenityList.length == 0
          ? new Container()
          : new Container(
              width: (MediaQuery.of(context).size.width) / 1.12,
              child: new SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(
                          label: Text('Assets',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13))),
                      DataColumn(
                          label: Text('Quantity',
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 13))),
                    ],
                    rows:
                        amenityList // Loops through dataColumnText, each iteration assigning the value to element
                            .map(
                              ((element) => DataRow(
                                    cells: <DataCell>[
                                      DataCell(Text(
                                          element["amenity"] != null
                                              ? element["amenity"]
                                              : "",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18))),
                                      //Extracting from Map element the value
                                      DataCell(Text(
                                          element["qty"] != null
                                              ? element["qty"]
                                              : "",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 18))),
                                    ],
                                  )),
                            )
                            .toList(),
                  )),
            ),
      Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    readOnlyShow == true
                        ? Container()
                        : InkWell(
                            onTap: () {
                              if (readOnlyShow == false) {
                                _pickImage(1);
                              }
                            },
                            child: Row(
                              children: [
                                new Icon(
                                  Icons.add_circle_rounded,
                                  color: new Color(0xFFE2E809A),
                                  size: 20.0,
                                ),
                                Text(" Add Image",
                                    textScaleFactor: 1.0,
                                    style: TextStyle(
                                        color: Color(0xff314498),
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500)),
                              ],
                            )),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 250,
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                            children: image2
                                .map(
                                  (item) => Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: 59,
                                          width: 60.0,
                                          child: Card(
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(6.0),
                                            ),
                                            elevation: 5,
                                            margin: EdgeInsets.all(8),
                                            child: Stack(
                                              children: <Widget>[
                                                image2 == null
                                                    ? Text("sss")
                                                    : InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            _zoomImage = item;
                                                          });
                                                          _displayDialog1(
                                                              context,
                                                              _zoomImage);
                                                        },
                                                        child: Image(
                                                          image: NetworkImage(
                                                              item),
                                                          fit: BoxFit.cover,
                                                          width: 100,
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
                                                      image2.remove(item);
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
                      : new Container(),
                ],
              ),
              catalogue.length != 0
                  ? SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(children: [
                        for (var item in catalogue)
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Container(
                                      width:
                                          (MediaQuery.of(context).size.width) /
                                              1.27,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(21),
                                        color: Colors.white,
                                      ),
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              right: 0, left: 10, top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item['name'],
                                                  textScaleFactor: 1.0,
                                                  style: TextStyle(
                                                      color: Color(0xff757575),
                                                      fontSize: 12,
                                                      decoration: TextDecoration
                                                          .underline,
                                                      fontWeight:
                                                          FontWeight.normal)),
                                              item['details'].length == 0
                                                  ? new Container()
                                                  : Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom: 5,
                                                                    top: 10),
                                                            child: Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                Text(
                                                                  "Assets",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff757575),
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                                Text("Quantity",
                                                                    textScaleFactor:
                                                                        1.0,
                                                                    style: TextStyle(
                                                                        color: Color(
                                                                            0xff757575),
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.normal)),
                                                                Text(
                                                                  "Image",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff757575),
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .normal),
                                                                ),
                                                              ],
                                                            )),
                                                        new Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right:
                                                                        10.0),
                                                            child:
                                                                new Divider()),
                                                        Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  for (var item
                                                                      in item[
                                                                          'details'])
                                                                    Padding(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                10,
                                                                            left:
                                                                                35.0,
                                                                            right:
                                                                                80),
                                                                        child:
                                                                            Row(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Container(
                                                                              width: 100,
                                                                              child: Text(item['amenity'] != null ? item['amenity'].toUpperCase() : "", textScaleFactor: 1.0, style: TextStyle(color: Color(0xff757575), fontSize: 10, fontWeight: FontWeight.normal)),
                                                                            ),
                                                                            Text(item['qty'] != null ? item['qty'] : '',
                                                                                textScaleFactor: 1.0,
                                                                                style: TextStyle(color: Color(0xff757575), fontSize: 10, fontWeight: FontWeight.normal)),
                                                                          ],
                                                                        )),
                                                                  new Padding(
                                                                      padding: EdgeInsets.only(
                                                                          right:
                                                                              0.0),
                                                                      child:
                                                                          new Divider()),
                                                                ],
                                                              ),
                                                              Container(
                                                                  width: 70,
                                                                  child: SingleChildScrollView(
                                                                      scrollDirection: Axis.horizontal,
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                                        for (var item1
                                                                            in item['photos'])
                                                                          Container(
                                                                            height:
                                                                                40,
                                                                            width:
                                                                                40.0,
                                                                            child:
                                                                                Card(
                                                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(6.0),
                                                                              ),
                                                                              elevation: 5,
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
                                                                                          child: Image(image: NetworkImage(item1), fit: BoxFit.fill, width: 100, height: 100)),
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
                                                                      ]))),
                                                            ]),
                                                      ],
                                                    )
                                            ],
                                          )),
                                    ))
                              ])
                      ]))
                  : new Container()
            ],
          )),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        readOnlyShow == true
            ? new Container()
            : Padding(
                padding: EdgeInsets.only(top: 20.0),
                child: SizedBox(
                  width: 135,
                  height: 50,
                  child: RaisedButton(
                    onPressed: () {
                      if (name.text != null) {
                        catalogue.add({
                          "name": name.text,
                          "details": amenityList,
                          "photos": image2
                        });
                        setState(() {
                          name.clear();
                          details.clear();
                          image2 = [];
                          amenityList = [];
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "please add Image first!",
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
                      decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Add   ',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 30.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            )
                          ]),
                    ),
                  ),
                )),
        Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: SizedBox(
              width: 140,
              height: 54,
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    _tabText = "Owner Details";
                  });
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
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Next   ', style: TextStyle(fontSize: 20)),
                        Icon(
                          Icons.arrow_right_alt,
                          color: Colors.white,
                          size: 34.0,
                          semanticLabel:
                              'Text to announce in accessibility modes',
                        )
                      ]),
                ),
              ),
            ))
      ]),
    ]);
  }

  Widget _detailsbalancepaymentTab(BuildContext context) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.all(20),
          child: new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      controller: ownerName,
                      enabled: !readOnlyShow,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            color: readOnlyShow == true
                                ? Colors.grey
                                : Color(0xff314498),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                    )),
                Row(children: [
                  Padding(
                      padding:
                          EdgeInsets.only(left: 20.0, right: 0.0, top: 0.0),
                      child: Container(
                          width: 80,
                          child: TextField(
                            enabled: false,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(14)
                            ],
                            controller: callingcode,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Country Code',
                              labelStyle: TextStyle(
                                  fontSize: 12.0,
                                  color: readOnlyShow == true
                                      ? Colors.grey
                                      : Color(0xff314498),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto"),
                            ),
                          ))),
                  Container(
                      width: 200,
                      child: Padding(
                          padding: EdgeInsets.only(
                              left: 10.0, right: 10.0, top: 0.0),
                          child: TextField(
                            enabled: !readOnlyShow,
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(14)
                            ],
                            controller: phone,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              labelStyle: TextStyle(
                                  fontSize: 12.0,
                                  color: readOnlyShow == true
                                      ? Colors.grey
                                      : Color(0xff314498),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto"),
                            ),
                          )))
                ]),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: country1,
                      enabled: !readOnlyShow,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter Country';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Country',
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            color: readOnlyShow == true
                                ? Colors.grey
                                : Color(0xff314498),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.words,
                      enabled: !readOnlyShow,
                      keyboardType: TextInputType.text,
                      controller: city1,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter City';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter City',
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            color: readOnlyShow == true
                                ? Colors.grey
                                : Color(0xff314498),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: TextFormField(
                      enabled: !readOnlyShow,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: street1,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter Block/Street Name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter street',
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            color: readOnlyShow == true
                                ? Colors.grey
                                : Color(0xff314498),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                    )),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: TextFormField(
                      enabled: !readOnlyShow,
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      controller: houseno1,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter Building/House Number';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Building/House Number',
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            color: readOnlyShow == true
                                ? Colors.grey
                                : Color(0xff314498),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                    )),
                new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: 160,
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 20.0, right: 0.0, top: 0.0),
                            child: TextFormField(
                              enabled: !readOnlyShow,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              controller: unitno1,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please enter Unit';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter Unit',
                                labelStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: readOnlyShow == true
                                        ? Colors.grey
                                        : Color(0xff314498),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                            ))),
                    Container(
                        width: 140,
                        child: Padding(
                            padding: EdgeInsets.only(
                                left: 8.0, right: 20.0, top: 0.0),
                            child: TextFormField(
                              enabled: !readOnlyShow,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.text,
                              controller: floorno1,
                              validator: (input) {
                                if (input.isEmpty) {
                                  return 'Please enter floor_no';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Enter Floor',
                                labelStyle: TextStyle(
                                    fontSize: 12.0,
                                    color: readOnlyShow == true
                                        ? Colors.grey
                                        : Color(0xff314498),
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Roboto"),
                              ),
                            ))),
                  ],
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 0.0),
                    child: TextFormField(
                      enabled: !readOnlyShow,
                      keyboardType: TextInputType.number,
                      controller: postalcode1,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'Please enter Postal Code';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Enter Postal Code',
                        labelStyle: TextStyle(
                            fontSize: 12.0,
                            color: readOnlyShow == true
                                ? Colors.grey
                                : Color(0xff314498),
                            fontWeight: FontWeight.bold,
                            fontFamily: "Roboto"),
                      ),
                    )),
              ])),
      Padding(
          padding: EdgeInsets.only(left: 40.0),
          child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text("Availability Time",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto"))
          ])),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Theme(
            data: ThemeData(primarySwatch: Colors.lightBlue),
            child: TextButton(
              onPressed: () {
                if (readOnlyShow == false) {
                  _selectTime(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    format2 != null
                        ? Text("   " + format2,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: readOnlyShow == true
                                    ? Colors.grey
                                    : Color(0xff314498),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"))
                        : Text("   Start Time",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: readOnlyShow == true
                                    ? Colors.grey
                                    : Color(0xff314498),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto")),
                    Icon(
                      Icons.timer,
                      color: Colors.green,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Theme(
            data: ThemeData(primarySwatch: Colors.lightBlue),
            child: TextButton(
              onPressed: () {
                if (readOnlyShow == false) {
                  _selectTime2(context);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    format3 != null
                        ? Text("   " + format3,
                            style: TextStyle(
                                fontSize: 12.0,
                                color: readOnlyShow == true
                                    ? Colors.grey
                                    : Color(0xff314498),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"))
                        : Text("End Time",
                            style: TextStyle(
                                fontSize: 12.0,
                                color: readOnlyShow == true
                                    ? Colors.grey
                                    : Color(0xff314498),
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto")),
                    Icon(
                      Icons.timer,
                      color: Colors.green,
                      size: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      readOnlyShow == false
          ? Padding(
              padding: EdgeInsets.only(top: 30.0),
              child: FadeAnimation(
                  0,
                  Center(
                      child: SliderButton(
                    action: () {
                      _addPropertyRequest(context);
                    },
                    backgroundColor: Color(0xff5A96AC),
                    label: Text(
                      "Slide to Update",
                      style: TextStyle(
                          color: Color(0xff5A96AC),
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    icon: new Icon(
                      Icons.apartment_outlined,
                      color: Color(0xff5A96AC),
                      size: 30,
                    ),
                    dismissible: false,
                  ))),
            )
          : Container()
    ]);
  }

  Widget _tabSection2(BuildContext context) {
    return Column(
      children: [
        new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 21,
                    width: 100,
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100.0),
                      ),
                      elevation: 0,
                      color: Color(0xffE2F0FC),
                      /*    disabledColor:
                                                      Color(0xff2E809A),
                                                  disabledTextColor: Colors.white, */
                      onPressed: () {
                        setState(() {
                          // _hasBeenPressed = !_hasBeenPressed;
                          _tabText = "Details";
                        });
                      },
                      child: Text(
                        'Details',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: _tabText == "Details"
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 21,
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      color: Color(0xffE2F0FC),
                      /*    disabledColor:
                                                      Color(0xff2E809A),
                                                  disabledTextColor: Colors.white, */
                      onPressed: () {
                        setState(() {
                          _tabText = "Catalogue";
                        });
                      },
                      child: Text(
                        'Catalogue',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: _tabText == "Catalogue"
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 21,
                    child: RaisedButton(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      color: Color(0xffE2F0FC),
                      /*    disabledColor:
                                                      Color(0xff2E809A),
                                                  disabledTextColor: Colors.white, */
                      onPressed: () {
                        setState(() {
                          _tabText = "Owner Details";
                        });
                      },
                      child: Text(
                        'Owner Details',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: _tabText == "Owner Details"
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  )),
            ]),
        _tabText == "Details" ? _balancepaymentTab(context) : new Container(),
        _tabText == "Catalogue"
            ? _pastbalancepaymentTab(context)
            : new Container(),
        _tabText == "Owner Details"
            ? _detailsbalancepaymentTab(context)
            : new Container()
      ],
    );
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
                            Text(
                              "Properties",
                              textScaleFactor: 1.0,
                              style: TextStyle(
                                  fontSize: 36.0,
                                  color: Color(0xff2E809A),
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Roboto"),
                            ),
                            new Image.asset(
                              'assets/images/Vector.png',
                              width: 60.0,
                              height: 55.0,
                            ),
                          ])),
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 21,
                              width: 70,
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
                                  });
                                },
                                child: Text(
                                  'Rent',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _date == "rent"
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 21,
                              width: 70,
                              child: RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: _date == "sale"
                                    ? Color(0xff2E809A)
                                    : Color(0xffE2F0FC),
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed = !_hasBeenPressed;
                                    _date = "sale";
                                  });
                                },
                                child: Text(
                                  'Sale',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _date == "sale"
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(10.0),
                            child: SizedBox(
                              height: 21,
                              width: 70,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                elevation: 0,
                                color: _date == "both"
                                    ? Color(0xff2E809A)
                                    : Color(0xffE2F0FC),
                                /*    disabledColor:
                                                      Color(0xff2E809A),
                                                  disabledTextColor: Colors.white, */
                                onPressed: () {
                                  setState(() {
                                    _date = "both";
                                  });
                                },
                                child: Text(
                                  'Both',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _date == "both"
                                          ? Colors.white
                                          : Colors.grey),
                                ),
                              ),
                            )),
                        readOnlyShow == true
                            ? Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: RawMaterialButton(
                                    fillColor: Colors.orange,
                                    onPressed: () {
                                      CommonUtils.showConfirmationDialog(
                                          context,
                                          "Do you want to Edit or Delete this\n property?",
                                          "Edit?",
                                          () async {
                                            setState(() {
                                              readOnlyShow = !readOnlyShow;
                                            });
                                          },
                                          "Delete?",
                                          () {
                                            _deleteProductRequest(context);
                                          });
                                    },
                                    shape: CircleBorder(),
                                    child: new Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20.0,
                                    )))
                            : Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: RawMaterialButton(
                                    fillColor: Colors.red,
                                    onPressed: () {
                                      setState(() {
                                        readOnlyShow = !readOnlyShow;
                                      });
                                    },
                                    shape: CircleBorder(),
                                    child: new Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                      size: 20.0,
                                    ))),
                      ]),
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xffE2F0FC)),
                          child: new SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: _tabSection2(context))))
                ])),
              ])),
        ));
  }
}
