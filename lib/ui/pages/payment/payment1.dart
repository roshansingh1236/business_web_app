import 'package:flutter/material.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';

class Payment1Page extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Payment1Page> {
  UserRepository userRepository;
  bool _hasBeenPressed = false;
  String _date = 'Day';
  String _tabText = "Balance Payment";

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
  }

  Widget _balancepaymentTab(BuildContext context) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/Group 4 (1).png',
                  width: 26.0,
                  height: 25.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Text(
                        'Date\n',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '13/10/2020',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff2E809A),
                            fontWeight: FontWeight.w500),
                      ),
                    ]))
              ])),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/Group 84 (1).png',
                  width: 25.0,
                  height: 17.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Text(
                        'Due',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹ 1820',
                        style: TextStyle(
                            fontSize: 36,
                            color: Color(0xffA51717),
                            fontWeight: FontWeight.bold),
                      ),
                    ]))
              ])),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/Group 146.png',
                  width: 26.0,
                  height: 26.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Text(
                        'Reported Problem\n',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '0',
                        style: TextStyle(
                            fontSize: 35,
                            color: Color(0xff2E809A),
                            fontWeight: FontWeight.bold),
                      ),
                    ]))
              ])),
      Center(
        child: Padding(
            padding: EdgeInsets.all(30.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.asset(
                    'assets/images/Group 35 (1).png',
                    width: 32.0,
                    height: 32.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 0.0),
                      child: Column(children: [
                        Text(
                          'Set Remainder/\n    AutoCredit\n',
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff314498),
                              fontWeight: FontWeight.w500),
                        ),
                      ]))
                ])),
      ),
      SizedBox(
        width: 284,
        height: 54,
        child: RaisedButton(
          onPressed: () {},
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Make the payment     ',
                  style: TextStyle(fontSize: 20)),
              Icon(
                Icons.arrow_right_alt,
                color: Colors.white,
                size: 33.0,
                semanticLabel: 'Text to announce in accessibility modes',
              )
            ]),
          ),
        ),
      )
    ]);
  }

  Widget _pastbalancepaymentTab(BuildContext context) {
    return Column(children: [
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/Group 4 (1).png',
                  width: 26.0,
                  height: 25.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Text(
                        'Paid Date\n',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '13/10/2020',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff2E809A),
                            fontWeight: FontWeight.w500),
                      ),
                    ]))
              ])),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/Group 84 (1).png',
                  width: 25.0,
                  height: 17.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Text(
                        'Amount Paid',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '₹ 1820',
                        style: TextStyle(
                            fontSize: 36,
                            color: Color(0xffA51717),
                            fontWeight: FontWeight.bold),
                      ),
                    ]))
              ])),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/Group 146.png',
                  width: 26.0,
                  height: 26.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Text(
                        'Reported Problem\n',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '1',
                        style: TextStyle(
                            fontSize: 35,
                            color: Color(0xff2E809A),
                            fontWeight: FontWeight.bold),
                      ),
                    ]))
              ])),
      Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/Vector (13) copy 3.png',
                  width: 30.0,
                  height: 20.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 20.0, top: 10),
                    child: Column(children: [
                      Text(
                        'Responce\n',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: FontWeight.bold),
                      ),
                    ]))
              ])),
      Padding(
          padding: EdgeInsets.only(top: 60.0),
          child: SizedBox(
            width: 284,
            height: 54,
            child: RaisedButton(
              onPressed: () {},
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Make the payment     ',
                      style: TextStyle(fontSize: 20)),
                  Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                    size: 34.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  )
                ]),
              ),
            ),
          ))
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
                InkWell(
                  onTap: () {},
                  child: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(left: 20, top: 0),
                              child: Text("Select Vendor",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: Color(0xff314498),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Roboto")),
                            ),
                            Padding(
                                padding: EdgeInsets.only(right: 20, top: 0),
                                child: new Image.asset(
                                  'assets/images/Group 6 (1).png',
                                  width: 14.0,
                                  height: 14.0,
                                )),
                          ])),
                ),
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: new DropdownButton<String>(
                        isExpanded: true,
                        iconSize: 0,
                        items: <String>['A', 'B', 'C', 'D'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 20, top: 0),
                              child: Text(
                                "Product",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Color(0xff314498),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 20, top: 0),
                              child: new Image.asset(
                                'assets/images/Group 6 (1).png',
                                width: 14.0,
                                height: 14.0,
                              )),
                        ])),
                InkWell(
                  child: Padding(
                      padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                      child: new DropdownButton<String>(
                        isExpanded: true,
                        iconSize: 0,
                        items: <String>['A', 'B', 'C', 'D'].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {},
                      )),
                ),
                Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 20, top: 0),
                              child: Text(
                                "Total Business",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Color(0xff314498),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 20, top: 0),
                              child: Text(
                                "₹ 28L",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: Color(0xff314498),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              )),
                        ])),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 20, top: 0),
                              child: Text(
                                "Problems faced",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Color(0xff314498),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 20, top: 0),
                              child: Text(
                                "3",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff314498),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              )),
                        ])),
                Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 20, top: 0),
                              child: Text(
                                "Problems Resolved",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 12.0,
                                    color: Color(0xff314498),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              )),
                          Padding(
                              padding: EdgeInsets.only(right: 20, top: 0),
                              child: Text(
                                "3",
                                textScaleFactor: 1.0,
                                style: TextStyle(
                                    fontSize: 18.0,
                                    color: Color(0xff314498),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Roboto"),
                              )),
                        ])),
              ])),
      Padding(
          padding: EdgeInsets.only(top: 60.0),
          child: SizedBox(
            width: 284,
            height: 54,
            child: RaisedButton(
              onPressed: () {},
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
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  const Text('Make the payment     ',
                      style: TextStyle(fontSize: 20)),
                  Icon(
                    Icons.arrow_right_alt,
                    color: Colors.white,
                    size: 34.0,
                    semanticLabel: 'Text to announce in accessibility modes',
                  )
                ]),
              ),
            ),
          ))
    ]);
  }

  Widget _tabSection2(BuildContext context) {
    return Column(
      children: [
        new Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 21,
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
                          _tabText = "Balance Payment";
                        });
                      },
                      child: Text(
                        'Balance Payment',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: _tabText == "Balance Payment"
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
                          //  _hasBeenPressed = !_hasBeenPressed;
                          _tabText = "Past Payment";
                        });
                      },
                      child: Text(
                        'Past Payment',
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff314498),
                            fontWeight: _tabText == "Past Payment"
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 5.0),
                  child: SizedBox(
                    height: 21,
                    width: 75,
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
                          _hasBeenPressed = !_hasBeenPressed;
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
            ]),
        _tabText == "Balance Payment"
            ? _balancepaymentTab(context)
            : new Container(),
        _tabText == "Past Payment"
            ? _pastbalancepaymentTab(context)
            : new Container(),
        _tabText == "Details"
            ? _detailsbalancepaymentTab(context)
            : new Container()
      ],
    );
  }

  Widget _tabSection(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            child: TabBar(
                indicatorColor: Colors.blueGrey[50],
                labelStyle: TextStyle(
                  fontSize: 14,
                  color: Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Roboto",
                ), //For Selected tab
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Roboto",
                  color: Colors.blueAccent,
                ), //For Un-selected Tabs
                tabs: [
                  Tab(
                    text: "Recurring orders",
                  ),
                  Tab(text: "Single order"),
                ]),
          ),
          Container(
            //Add this to give height
            height: MediaQuery.of(context).size.height / 1.8,
            child: TabBarView(children: [
              Padding(
                padding: EdgeInsets.only(top: 0),
                child: Column(
                  children: <Widget>[
                    Flexible(child: RecurringCardList()),
                  ],
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 0),
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(child: SingleOrderCardList()),
                      ])),
            ]),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget RecurringCardList() {
    return SingleChildScrollView(
      child: Card(
        color: Color(0xffE2F0FC),
        elevation: 0,
        child: ExpansionTile(
          trailing: Image.asset(
            'assets/images/Group 6 (1).png',
            width: 11.0,
            height: 11.0,
          ),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/Vector (13).png',
                          width: 35.0,
                          height: 25.0,
                        ))),
                Container(
                  width: MediaQuery.of(context).size.width / 2.1,
                  child: Text("Shree Complex",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Color(0xff314498),
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                ),
                Image.asset(
                  'assets/images/Vector (13) copy.png',
                  width: 11.0,
                  height: 11.0,
                ),
                Padding(
                    padding: EdgeInsets.only(left: 5, top: 1),
                    child: Text("5",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Color(0xff314498),
                            fontSize: 14,
                            fontWeight: FontWeight.w500))),
              ]),
          children: <Widget>[
            ListTile(
              title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                        child: Padding(
                            padding: EdgeInsets.only(right: 20, left: 10),
                            child: Image.asset(
                              'assets/images/Vector (13) copy.png',
                              width: 12.0,
                              height: 11.0,
                            ))),
                    Container(
                      width: 130,
                      child: Text("G1, Subramanian",
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              color: Color(0xff314498),
                              fontSize: 14,
                              fontWeight: FontWeight.w500)),
                    ),
                    Text("128 liters",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Color(0xff314498),
                            fontSize: 12,
                            fontWeight: FontWeight.normal)),
                    Padding(
                        padding: EdgeInsets.only(right: 10, left: 10),
                        child: Image.asset(
                          'assets/images/Group 148.png',
                          width: 16.0,
                          height: 16.0,
                        )),
                    new Icon(
                      Icons.more_horiz_rounded,
                      color: Color(0xff314498),
                      size: 20.0,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget SingleOrderCardList() {
    return SingleChildScrollView(
      child: Card(
        color: Color(0xffE2F0FC),
        elevation: 0,
        child: ExpansionTile(
          trailing: Image.asset(
            'assets/images/Group 6 (2).png',
            width: 12.0,
            height: 12.0,
          ),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                    child: Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Image.asset(
                          'assets/images/Vector (13) copy 2.png',
                          width: 35.0,
                          height: 25.0,
                        ))),
                Container(
                  width: MediaQuery.of(context).size.width / 2.2,
                  child: Text("Ramaswamy",
                      textScaleFactor: 1.0,
                      style: TextStyle(
                          color: Color(0xff314498),
                          fontSize: 14,
                          fontWeight: FontWeight.normal)),
                ),
                Padding(
                    padding: EdgeInsets.only(left: 0, top: 1),
                    child: Text("+120",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Color(0xff19A517),
                            fontSize: 15,
                            fontWeight: FontWeight.bold))),
              ]),
          children: <Widget>[],
        ),
      ),
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
        resizeToAvoidBottomInset: false,
        body: Container(
          padding: const EdgeInsets.only(top: 60, left: 10),
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
                              'assets/images/Payment.png',
                              width: 144.0,
                              height: 42.0,
                            ),
                            new Image.asset(
                              'assets/images/Group (3).png',
                              width: 25.0,
                              height: 29.0,
                            ),
                          ])),
                  new Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 21,
                              child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                elevation: 0,
                                color: Color(0xffF0F6FB),
                                /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed = !_hasBeenPressed;
                                    _date = "Day";
                                  });
                                },
                                child: Text(
                                  'Customer',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _date == "Day"
                                          ? Color(0xff2E809A)
                                          : Colors.grey),
                                ),
                              ),
                            )),
                        Padding(
                            padding: EdgeInsets.all(5.0),
                            child: SizedBox(
                              height: 21,
                              child: RaisedButton(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                ),
                                color: Color(0xffF0F6FB),
                                /*    disabledColor:
                                                    Color(0xff2E809A),
                                                disabledTextColor: Colors.white, */
                                onPressed: () {
                                  setState(() {
                                    _hasBeenPressed = !_hasBeenPressed;
                                    _date = "Week";
                                  });
                                },
                                child: Text(
                                  'Merchant',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: _date == "Week"
                                          ? Color(0xff2E809A)
                                          : Colors.grey),
                                ),
                              ),
                            )),
                      ]),
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xffE2F0FC)),
                          child: _date == "Day"
                              ? _tabSection(context)
                              : _tabSection2(context)))
                ])),
              ])),
        ));
  }
}
