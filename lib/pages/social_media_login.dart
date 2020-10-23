import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:wrangle/widgets/widgets.dart';
import 'dart:io' show Platform;
import 'globals.dart' as globals;
import 'package:flutter/widgets.dart';

class ShowLoginWithPlatform extends StatefulWidget {
  final String redirectPageName;

  ShowLoginWithPlatform({this.redirectPageName});

  @override
  _ShowLoginWithPlatformState createState() => _ShowLoginWithPlatformState();
}

class _ShowLoginWithPlatformState extends State<ShowLoginWithPlatform> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SocialButtons(
            color: Color(0xFF3A559F),
            logo: 'assets/facebook_logo.png',
            logoScale: 2.6,
            logoDistance: 0.0,
            company: 'FACEBOOK',
            login: () {
              _loginFacebook();
            },
          ),
          Visibility(
            visible: _androidPlatformCheck(),
            child: SocialButtons(
              color: Colors.black,
              logo: 'assets/apple_logo.png',
              logoScale: 11.0,
              logoDistance: 35.0,
              company: 'APPLE',
              login: () {
                _loginApple();
              },
            ),
          ),
          SocialButtons(
            color: Colors.red,
            logo: 'assets/google_logo.png',
            logoScale: 11.0,
            logoDistance: 20.0,
            company: 'GOOGLE',
            login: () {
              _loginGoogle();
            },
          ),
        ],
      ),
    );
  }

  void _loginGoogle() async {
    try {
      GoogleSignIn _googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        hostedDomain: "",
        clientId: "",
      );
      _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
        GoogleSignInAuthentication auth = await acc.authentication;
        print(acc.id);
        print(acc.email);
        print(acc.displayName);
        print(acc.photoUrl);

        acc.authentication.then((GoogleSignInAuthentication auth) async {
          print(auth.idToken);
          print(auth.accessToken);

          globals.emailSignedInWith = (acc.email);
          _socialRedirectUser(widget.redirectPageName);
        });
      });
    } catch (error) {
      print('Google Sign in error is :' + error);
    }
  }

  void _loginFacebook() async {
    final facebookLogin = FacebookLogin();
    final facebookLoginResult = await facebookLogin.logIn(['email']);
    try {
      print(facebookLoginResult.accessToken);
      print(facebookLoginResult.accessToken.token);
      print(facebookLoginResult.accessToken.expires);
      print(facebookLoginResult.accessToken.permissions);
      print(facebookLoginResult.accessToken.userId);
      print(facebookLoginResult.accessToken.isValid());

      print(facebookLoginResult.errorMessage);
      print(facebookLoginResult.status);

      final token = facebookLoginResult.accessToken.token;

      /// for profile details also use the below code
//    final graphResponse = await http.get(
//        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
      final graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
      final profile = json.decode(graphResponse.body);
      print(profile);
      /*
    from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }
   */

      //  _redirectUser();
      //RedirectPage();
      _socialRedirectUser(widget.redirectPageName);
      globals.emailSignedInWith = profile['email'];
      print(globals.emailSignedInWith);
    } catch (error) {
      print('Facebook Sign in error is :' + error);
    }
  }

  void _loginApple() async {
    String errorMessage;
    final AuthorizationResult result = await AppleSignIn.performRequests([
      AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
    ]);

    //globals.emailSignedInWith = Scope.email;
    print('RESULT IS :$result');

    switch (result.status) {
      case AuthorizationStatus.authorized:

        // Store user ID
        // await FlutterSecureStorage()
        //     .write(key: "userId", value: result.credential.user);

        // _redirectUser();
        _socialRedirectUser(widget.redirectPageName);
//        // Navigate to secret page (shhh!)
//        Navigator.of(context).pushReplacement(MaterialPageRoute(
//            builder: (_) =>
//                SecretMembersOnlyPage(credential: result.credential)));
        break;

      case AuthorizationStatus.error:
        print("Sign in failed: ${result.error.localizedDescription}");
        setState(() {
          errorMessage = "Sign in failed 😿";
        });
        break;

      case AuthorizationStatus.cancelled:
        print('User cancelled');
        break;
    }
  }

  bool _androidPlatformCheck() {
    bool val = false;
    if (Platform.isIOS) {
      //val = true;
      val = false;
    } else if (Platform.isAndroid) {
      val = false;
    }
    return val;
  }

  void _socialRedirectUser(String reDirectPage) {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, reDirectPage);
    });
  }
}
