import 'package:flutter/material.dart';
import 'package:wrangle/pages/animation.dart';
import 'package:wrangle/pages/register.dart';
import 'pages/login.dart';
import 'pages/terms_and_privacy.dart';
import 'package:wrangle/pages/onboarding.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (BuildContext context) => OnboardingScreen(),
        '/login': (BuildContext context) => Login(),
        '/register': (BuildContext context) => RegisterPage(),
        '/terms': (BuildContext context) => Terms(),
        '/policy': (BuildContext context) => Policy(),
        '/animation': (BuildContext context) => WrangleAnimation(),
      },
      theme: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: new Color(0xFF6600CC),
          primaryColorLight: new Color(0xFF9933FF),
          //  scaffoldBackgroundColor: const Color(0xFF6600CC),
          //buttonColor: new Color(0xFF5500B0),
          buttonColor: new Color(0xFFFFCC00),
          textTheme: TextTheme(
              headline6: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
              headline2: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
              bodyText1: TextStyle(fontSize: 18.0))),
    );
  }
}
