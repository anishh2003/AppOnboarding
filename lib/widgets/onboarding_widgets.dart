import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

MaterialButton signUpButton(BuildContext context) {
  return MaterialButton(
    height: 48,
    minWidth: 320,
    color: Theme.of(context).buttonColor,
    child: Text(
      'SIGN UP',
      style: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
    ),
    //elevation: 8.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
    onPressed: () {
      Navigator.pushNamed(context, '/register');
    },
  );
}

Widget loginOption(BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(top: 20),
    child: RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 14.0, color: Colors.black),
        children: <TextSpan>[
          TextSpan(
              text: 'Already have an account? ',
              style: TextStyle(fontSize: 15)),
          TextSpan(
            text: 'LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Navigator.pushReplacementNamed(context, '/login');
              },
          )
        ],
      ),
    ),
  );
}

class SocialButtons extends StatelessWidget {
  final Color color;
  final String logo;
  final double logoScale;
  final double logoDistance;
  final String company;
  final VoidCallback login;

  SocialButtons(
      {this.color,
      this.logo,
      this.logoScale,
      this.logoDistance,
      this.company,
      this.login});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 50.0,
        child: FlatButton(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                logo,
                scale: logoScale,
              ),
              SizedBox(width: logoDistance),
              Text(
                'SIGN IN WITH $company',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          onPressed: login,
        ),
      ),
    );
  }
}
