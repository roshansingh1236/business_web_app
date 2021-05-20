import 'package:flutter/material.dart';
import 'package:bussiness_web_app/utils/animations/fade_animation.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 9, 23, 1),
      body: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  FadeAnimation(
                      1,
                      Image.asset(
                        'assets/images/Briclay.png',
                        height: 200.0,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  FadeAnimation(
                      1.3,
                      Text(
                        "Simplify The Complex",
                        textScaleFactor: 1.0,
                        style: TextStyle(
                            color: Colors.white.withOpacity(.7),
                            height: 1.4,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      )),
                  SizedBox(
                    height: 180,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
