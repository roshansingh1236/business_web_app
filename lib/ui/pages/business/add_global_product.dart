import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/ui/pages/home/home_page.dart';
import 'package:bussiness_web_app/utils/animations/fade_animation.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';

class NewProductPage extends StatefulWidget {
  @override
  _ServiceListPageState createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<NewProductPage> {
  static final _userURL = _baseUrl + '/products';
  static final _baseUrl = Env.apiBaseUrl;
  var myController = TextEditingController();
  List category = [];
  List category3 = [];
  String token = '';
  bool showProgressloading = false;
  //api calling for get Category
  //api calling for get User
  Future<String> getUserData() async {
    var res = await http.get(Uri.encodeFull(
        _userURL + "/template" + "?filter[brand_name]=" + myController.text));
    var resBody = json.decode(res.body)['product_template'];
    setState(() {
      category = resBody.toList();
    });
    category.sort((a, b) {
      return a['product_name']
          .toLowerCase()
          .compareTo(b['product_name'].toLowerCase());
    });

    return "Sucess";
  }

  // post api for create visitor
  _updateCategory(BuildContext context) async {
    // set up POST request arguments
    setState(() {
      showProgressloading = true;
    });
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': token
    };
    final msg = jsonEncode({"sku": category3.toSet().toList()});
    print(msg);
    // make POST request
    Response response =
        await post(_userURL + "/sku", headers: headers, body: msg);
    // check the status code for the result
    int statusCode = response.statusCode;
    if (statusCode == 201) {
      setState(() {
        showProgressloading = false;
      });
      NavigationUtil.clearAllAndAdd(context, HomePage());
      Fluttertoast.showToast(
          msg: "Product Added",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);

      // If the server did return a 201 CREATED response,
      // then parse the JSON.
    } else {
      // If the server did not return a 201 CREATED response,
      // then throw an exception.
      setState(() {
        showProgressloading = false;
      });
      var error = json.decode(response.body);
      Fluttertoast.showToast(
          msg: error["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM);
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      token = "JWTV" + " " + Cache.storage.getString('authToken');
    });
    this.getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ));
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Product List' +
            "                         " +
            "${category3.length}"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => NavigationUtil.clearAllAndAdd(context, HomePage()),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 0, top: 10),
          child: Container(
            height: 50,
            width: 207.0,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Color(0xFF2E879A),
                    Color(0xFF314498),
                  ],
                ),
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            child: RaisedButton(
              elevation: 20,
              onPressed: () {
                _updateCategory(context);
              },
              textColor: Colors.white,
              padding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(80.0)),
              child: Container(
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: <Color>[
                        Color(0xFF2E879A),
                        Color(0xFF314498),
                      ],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: showProgressloading == true
                    ? CircularProgressIndicator()
                    : Center(
                        child: Text(
                          "ADD PRODUCT",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontFamily: "Roboto",
                              color: Colors.white,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
              ),
            ),
          )),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Padding(
              padding:
                  EdgeInsets.only(right: 30, left: 30, bottom: 10, top: 10),
              child: FadeAnimation(
                  0,
                  Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.circular(11.0),
                      color: Colors.white,
                      border: Border.all(color: Color(0xffb4b7c6), width: 0.3),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Theme(
                          data: new ThemeData(
                            primaryColor: Colors.white,
                            primaryColorDark: Colors.white,
                          ),
                          child: TextFormField(
                            textCapitalization: TextCapitalization.words,
                            controller: myController,
                            textInputAction: TextInputAction.search,
                            //onChanged is called whenever we add or delete something on Text Field
                            onChanged: (String str) {},
                            onFieldSubmitted: (term) {
                              // process

                              getUserData();
                            },
                            // ignore: deprecated_member_use
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  myController.clear();

                                  getUserData();
                                },
                                icon:
                                    Icon(Icons.clear, color: Color(0xff212962)),
                              ),
                              hintText: 'Search product by brand name',
                            ),

                            style: new TextStyle(
                              fontFamily: "Poppins",
                            ),
                          ),
                        )),
                  ))),
          Container(
              color: Colors.white,
              child: Column(children: [
                Center(
                    child: category.length != 0
                        ? Container(
                            padding: const EdgeInsets.all(10.0),
                            height: MediaQuery.of(context).size.height,
                            child: ListView.separated(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 8, right: 8, bottom: 8),
                              itemCount: category.length,
                              reverse: false,
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                    onTap: () {
                                      category3.contains(category[index]['sku'])
                                          ? category3
                                              .remove(category[index]['sku'])
                                          : category3
                                              .add(category[index]['sku']);

                                      setState(() {});
                                      print(category3.toSet().toList());
                                    },
                                    child: ListTile(
                                      trailing: new Icon(
                                        Icons.check_circle,
                                        color: category3.contains(
                                                category[index]['sku'])
                                            ? Colors.green
                                            : Colors.grey,
                                        size: 25.0,
                                      ),
                                      title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            category[index]['main_image_url'] !=
                                                    null
                                                ? CircleAvatar(
                                                    backgroundColor:
                                                        Color(0xff212962),
                                                    radius: 25,
                                                    backgroundImage: AssetImage(
                                                        'assets/images/as.png'),
                                                    child: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      backgroundImage:
                                                          NetworkImage(category[
                                                                  index][
                                                              'main_image_url']),
                                                    ))
                                                : CircleAvatar(
                                                    radius: 25,
                                                    backgroundColor:
                                                        Color(0xff212962),
                                                    child: Text(
                                                      category[index][
                                                              'product_name'][0]
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 30),
                                                    ),
                                                  ),
                                            Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width /
                                                            2,
                                                    child: Text(
                                                      " " +
                                                          category[index]
                                                              ['product_name'] +
                                                          " (" +
                                                          category[index]
                                                                  ['brand_name']
                                                              .toUpperCase() +
                                                          " )",
                                                      textScaleFactor: 1.0,
                                                      style: TextStyle(
                                                          color:
                                                              Color(0xff212962),
                                                          fontSize: 15,
                                                          fontWeight: FontWeight
                                                              .normal),
                                                    ),
                                                  ),
                                                ])
                                          ]),
                                    ));
                              },
                              separatorBuilder:
                                  (BuildContext context, int index) => Divider(
                                thickness: 1,
                              ),
                            ),
                          )
                        : Padding(
                            padding: EdgeInsets.only(top: 200),
                            child: new Center(
                                child: Text(
                              "No Product",
                              textScaleFactor: 1.0,
                              style: TextStyle(color: Colors.black),
                            )))),
              ]))
        ],
      ))),
    );
  }
}
