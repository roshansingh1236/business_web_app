import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bussiness_web_app/ui/pages/home/home_page.dart';

class ConfirmationPopupWidget extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<ConfirmationPopupWidget> {
  // ignore: non_constant_identifier_names
  Future<void> _CupertinoDialog() async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Vendor'),
            content: Text(
              'Please Select Option',
              textScaleFactor: 1.0,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                onPressed: () {},
                child: const Text(
                  'New',
                  textScaleFactor: 1.0,
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {},
                child: const Text(
                  'Existing',
                  textScaleFactor: 1.0,
                ),
              ),
            ],
          );
        })) {
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text(
            "Vendor Type",
            textScaleFactor: 1.0,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w300,
            ),
          ),
          backgroundColor: Color(0xff3d74c9),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage()),
              );
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Powered by ",
                  textScaleFactor: 1.0,
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.black,
                    fontWeight: FontWeight.w300,
                  )),
              Image.asset(
                'assets/images/briclay.png',
                width: 50.0,
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(15.0),
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                SizedBox(
                    width: 200,
                    height: 60, // specific value
                    child: RaisedButton(
                      elevation: 30,
                      onPressed: _CupertinoDialog,
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          side: BorderSide(color: Colors.red)),
                      highlightColor: Colors.black38,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/Vendor.png',
                            height: 40.0,
                          ),
                          Text(
                            "Create Vendor",
                            textScaleFactor: 1.0,
                            style:
                                TextStyle(fontSize: 17.0, color: Colors.black),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ));
  }
}
