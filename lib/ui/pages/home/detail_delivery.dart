import 'package:flutter/material.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';
import 'package:bussiness_web_app/utils/navigation_util.dart';
import 'package:slider_button/slider_button.dart';

class DeliveryDetailsPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<DeliveryDetailsPage> {
  UserRepository userRepository;

  @override
  void initState() {
    super.initState();
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
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 60, left: 0),
          height: MediaQuery.of(context).size.height,
          child: new SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: new Column(children: <Widget>[
                Container(
                    child: new Column(children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.only(bottom: 0.0, left: 15, right: 25),
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(left: 10, bottom: 0),
                                child: new Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      new Container(
                                          height: 80,
                                          width: 80,
                                          padding: new EdgeInsets.all(2.0),
                                          decoration: new BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: new BorderRadius.all(
                                                new Radius.circular(100.0)),
                                            border: new Border.all(
                                              color: Color(0xff2E809A),
                                              width: 1.0,
                                            ),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(300.0),
                                            child: Image.asset(
                                              'assets/images/Ellipse 1.png',
                                              width: 79,
                                              height: 79,
                                            ),
                                          ))
                                    ])),
                            Padding(
                                padding: EdgeInsets.only(bottom: 0.0),
                                child: Container(
                                    height: 42,
                                    width: 132,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff026D00)),
                                    child: Center(
                                        child: Text(
                                      "₹  1105 /-",
                                      textScaleFactor: 1.0,
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Roboto"),
                                    )))),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(bottom: 0),
                      child: Container(
                          height: 176,
                          width: MediaQuery.of(context).size.width / 1.13,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xffF0F6FB)),
                          child: Padding(
                            padding:
                                EdgeInsets.only(left: 10.0, right: 10, top: 10),
                            child: new Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image.asset(
                                    'assets/images/Today’s delivery.png',
                                    width: 135.0,
                                    height: 85.0,
                                  ),
                                  new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Image.asset(
                                          'assets/images/Group 4 (1).png',
                                          width: 18.0,
                                          height: 17.0,
                                        ),
                                        Text(
                                          "16 Oct",
                                          textScaleFactor: 1.0,
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Color(0xff2E809A),
                                              fontWeight: FontWeight.w700,
                                              fontFamily: "Roboto"),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 10),
                                            child: Text(
                                              "<  1 / 143  >",
                                              textScaleFactor: 1.0,
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  color: Color(0xff2E809A),
                                                  fontWeight: FontWeight.w700,
                                                  fontFamily: "Roboto"),
                                            )),
                                      ]),
                                ]),
                          ))),
                  Container(
                    padding: const EdgeInsets.only(top: 0, left: 10),
                    height: 420,
                    child: new SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: new Column(children: <Widget>[
                          Container(
                              child: new Column(children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(right: 20, left: 10),
                                child: Container(
                                    height: 400,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Color(0xffE2F0FC)),
                                    child: new Column(children: <Widget>[
                                      Container(
                                          height: 360,
                                          child: new Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            'assets/images/Vector (13).png',
                                                            width: 21.0,
                                                            height: 28.0,
                                                          ),
                                                          Padding(
                                                              padding:
                                                                  EdgeInsets.only(
                                                                      left: 15,
                                                                      top: 1),
                                                              child: Text(
                                                                  "G1, Shree Complex",
                                                                  textScaleFactor:
                                                                      1.0,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xff314498),
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500))),
                                                        ])),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        top: 10),
                                                    child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: <Widget>[
                                                          Image.asset(
                                                            'assets/images/Polygon 1.png',
                                                            width: 10.0,
                                                            height: 10.0,
                                                          ),
                                                          new Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Image.asset(
                                                                  'assets/images/Vector (13) copy.png',
                                                                  width: 16.0,
                                                                  height: 15.0,
                                                                ),
                                                                Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            15,
                                                                        top: 10,
                                                                        right:
                                                                            15),
                                                                    child: Text(
                                                                        "G1, Subramanian",
                                                                        textScaleFactor:
                                                                            1.0,
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xff314498),
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500))),
                                                              ]),
                                                          Image.asset(
                                                            'assets/images/Polygon 2.png',
                                                            width: 10.0,
                                                            height: 10.0,
                                                          ),
                                                        ])),
                                                Container(
                                                  height: 250,
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: ListView.separated(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 8,
                                                            left: 8,
                                                            right: 8,
                                                            bottom: 8),
                                                    itemCount: 4,
                                                    reverse: false,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      return InkWell(
                                                          onTap: () {
                                                            NavigationUtil
                                                                .pushToNewScreen(
                                                                    context,
                                                                    DeliveryDetailsPage());
                                                          },
                                                          child: ListTile(
                                                            title: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Image.asset(
                                                                    'assets/images/Ellipse 45.png',
                                                                    width: 27.0,
                                                                    height:
                                                                        27.0,
                                                                  ),
                                                                  Container(
                                                                    width: 150,
                                                                    child: Text(
                                                                        "  Curd",
                                                                        textScaleFactor:
                                                                            1.0,
                                                                        style: TextStyle(
                                                                            color: Color(
                                                                                0xff314498),
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.w500)),
                                                                  ),
                                                                  Container(
                                                                      width: 50,
                                                                      child: Text(
                                                                          "-",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style: TextStyle(
                                                                              color: Color(0xff314498),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500))),
                                                                  Padding(
                                                                      padding: EdgeInsets.only(
                                                                          left:
                                                                              5,
                                                                          top:
                                                                              1),
                                                                      child: Text(
                                                                          "1 liter",
                                                                          textScaleFactor:
                                                                              1.0,
                                                                          style: TextStyle(
                                                                              color: Color(0xff314498),
                                                                              fontSize: 14,
                                                                              fontWeight: FontWeight.w500))),
                                                                ]),
                                                          ));
                                                    },
                                                    separatorBuilder:
                                                        (BuildContext context,
                                                                int index) =>
                                                            Divider(
                                                      thickness: 0,
                                                      color: Color(0xffE2F0FC),
                                                    ),
                                                  ),
                                                ),
                                              ])),
                                      Padding(
                                          padding: EdgeInsets.only(
                                              left: 35, right: 35),
                                          child: Container(
                                              child: new Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                Container(
                                                    child: new Row(
                                                        children: <Widget>[
                                                      Image.asset(
                                                        'assets/images/Group 148.png',
                                                        width: 27.0,
                                                        height: 27.0,
                                                      ),
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5,
                                                                  top: 1),
                                                          child: Text(
                                                              "Regular Token\nOrders",
                                                              textScaleFactor:
                                                                  1.0,
                                                              style: TextStyle(
                                                                  color: Color(
                                                                      0xff314498),
                                                                  fontSize: 10,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))),
                                                    ])),
                                                Container(
                                                    child: new Row(
                                                        children: <Widget>[
                                                      Image.asset(
                                                        'assets/images/Group 111.png',
                                                        width: 86.0,
                                                        height: 27.0,
                                                      ),
                                                    ])),
                                              ])))
                                    ]))),
                          ])),
                        ])),
                  ),
                  SliderButton(
                    action: () {
                      ///Do something here OnSlide
                    },

                    ///Put label over here
                    label: Text(
                      "Complete Cycle !",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                    icon: Center(
                        child: Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                      size: 40.0,
                      semanticLabel: 'Text to announce in accessibility modes',
                    )),

                    ///Change All the color and size from here.
                    width: 284,
                    radius: 12,
                    buttonColor: Color(0xff305699),
                    backgroundColor: Color(0xff305699),
                    highlightedColor: Colors.white,
                    baseColor: Colors.white,
                  )
                ])),
              ])),
        ));
  }
}
