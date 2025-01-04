import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';


import 'controller/colors.dart';
import 'local/sharedprefencevalues.dart';
import 'main.dart';
import 'view/account/account.dart';
import 'view/btmbar/btmbr.dart';

class Splash extends StatefulWidget {
  Splash({required this.tokenpush});
  String tokenpush;
  @override
  _SplashState createState() => _SplashState(tokenpush: tokenpush);
}

class _SplashState extends State<Splash> {
  _SplashState({required this.tokenpush});
  String tokenpush;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
    Timer(Duration(seconds: 3), () {
      if (wheretogo(context)) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => WillPopScope(
                  onWillPop: () async => false, child: TeacherBtmbar()),
            ));
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => WillPopScope(
                  onWillPop: () async => false,
                  child: AccountLoginOrRegister(
                    home_or_login:true,
                      tokenpush: tokenpush,
                      pushtoken_or_null:
                          MySharedPrefrence().get_push_token() == null ||
                              MySharedPrefrence().get_push_token() == "" ||
                              tokenpush == "" ||
                              tokenpush == null?false:true))),
        );
      }
    });
  }

  Future<void> checkLoginStatus() async {
    bool isLoggedIn = await MySharedPrefrence().getUserLoginStatus();
    setState(() {
      _isLoggedIn = isLoggedIn;
    });
    Timer(Duration(seconds: 5), () {
      navigateToScreen();
    });
  }

  void navigateToScreen() {
    if (_isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TeacherBtmbar()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colorController.normalgreenbtnclr,
                    colorController.lightgreensplash,
                    colorController.normalgreenbtnclr,
                  ],
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 30, right: 30),
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/splash.png',
                        ),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Certified Literacy Teacher',
                        textStyle: const TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                        ),
                        speed: const Duration(milliseconds: 70),
                      ),
                    ],
                    totalRepeatCount: 2,
                    pause: const Duration(milliseconds: 2000),
                    displayFullTextOnTap: true,
                    stopPauseOnTap: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

bool wheretogo(BuildContext context) {
  return MySharedPrefrence().getUserLoginStatus();
}
