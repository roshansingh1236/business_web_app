import 'package:bussiness_web_app/ui/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:bussiness_web_app/data/repositories/user_repository.dart';
import 'package:flutter/services.dart';
import 'package:bussiness_web_app/ui/widgets/common_widgets.dart';

class TermsPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<TermsPage> {
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
                              'assets/images/T&C.png',
                              width: 70.0,
                              height: 42.0,
                            ),
                            new Image.asset(
                              'assets/images/Vector (9).png',
                              width: 57.0,
                              height: 65.0,
                            ),
                          ])),
                  Padding(
                      padding: EdgeInsets.only(right: 20, left: 10),
                      child: Container(
                          height: MediaQuery.of(context).size.height / 1.5,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Color(0xffE2F0FC)),
                          child: Container(
                              padding: const EdgeInsets.all(10.0),
                              child: Padding(
                                padding: EdgeInsets.only(top: 20, left: 10),
                                child: Text(
                                  "These Terms and Conditions constitute a legally binding agreement made between you, whether personally or on behalf of an entity (“you”) and [business entity name] (“we,” “us” or “our”), concerning your access to and use of the [website name.com] website as well as any other media form, media channel, mobile website or mobile application related, linked, or otherwise connected thereto (collectively, the “Site”).\n\n You agree that by accessing the Site,you have read, understood, and agree to be bound by all of these Terms and Conditions. If you do not agree with all of these Terms and Conditions, then you are expressly prohibited from using the Site and you must discontinue use immediately.\n\nSupplemental terms and conditions or documents that may be posted on the Site from time to time are hereby expressly incorporated herein by reference. We reserve the right, in our sole discretion, to make changes or modifications to these Terms and Conditions at any time and for any reason.\n\nWe will alert you about any changes by updating the “Last updated” date of these Terms and Conditions, and you waive any right to receive specific notice of each such change.",
                                  textScaleFactor: 1.0,
                                  style: TextStyle(
                                      color: Color(0xff545454), fontSize: 10),
                                ),
                              ))))
                ])),
              ])),
        ));
  }
}
