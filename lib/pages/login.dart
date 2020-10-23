import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:apple_sign_in/apple_sign_in.dart';
import 'dart:io' show Platform;
import 'social_media_login.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting;

  String _email, _password;

  Widget _showTitleText() {
    return Padding(
        padding: EdgeInsets.only(top: 30),
        child: Text(
          'Let\'s get ready to Wrangle!',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ));
  }

  Widget _showSubTitleText() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          'Please login to your account.       ',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ));
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          style: TextStyle(
            color: Colors.black,
          ),
          onSaved: (val) => _email = val,
          validator: (String value) {
            if (value.isEmpty ||
                !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                    .hasMatch(value)) {
              return 'Enter valid email';
            }
            return null;
          },
          decoration: InputDecoration(
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),

            labelText: 'Email Address',
            labelStyle: TextStyle(color: Colors.black),
            //hintText: 'Enter a valid email',
          ),
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          style: TextStyle(
            color: Colors.black,
          ),
          onSaved: (val) => _password = val,
          validator: (val) => val.length < 6 ? 'Username too short' : null,
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white),
            ),
            // focusedBorder: UnderlineInputBorder(
            //   borderSide: BorderSide(color: Colors.white),
            // ),

            //  border: OutlineInputBorder(),
            labelText: 'Password',
            labelStyle: TextStyle(color: Colors.black),
            //hintText: 'Enter password, min length 6',
          ),
        ));
  }

  Widget _forgotPassword() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 14.0, color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'Forgot Password?',
                  style: TextStyle(fontSize: 15),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushReplacementNamed(context, '/register');
                    },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _passwordDivider() {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Divider(
        color: Colors.white,
        height: 1.0,
        thickness: 1.5,
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          _isSubmitting == true
              ? CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).primaryColor))
              : SizedBox(
                  width: 310.0,
                  height: 45.0,
                  child: OutlineButton(
                      child: Text('LOGIN',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          )),
                      borderSide: BorderSide(
                        width: 3.0,
                        color: Theme.of(context).primaryColor,
                        style: BorderStyle.solid,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      onPressed: _submit),
                ),
          /*  FlatButton(
            
            child: Text('New user? Register'),
            onPressed: () => Navigator.pushReplacementNamed(context, '/register')
          ) */
        ],
      ),
    );
  }

  Widget _showLogwithText() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Text(
          'OR',
          style: TextStyle(
            color: Colors.black,
          ),
        ));
  }

  Widget _showFormActions2() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(fontSize: 15)),
            TextSpan(
              text: 'SIGN UP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
            )
          ],
        ),
      ),
    );
  }

  void _submit() {
    final form = _formKey.currentState;

    if (form.validate()) {
      form.save();
      _registerUser();
    }
  }

  void _registerUser() async {
    setState(() => _isSubmitting = true);
    http.Response response = await http.post(
        'http://3.10.233.244:1337/auth/local',
        body: {"identifier": _email, "password": _password});

    final responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      setState(() => _isSubmitting = false);
      _storeUserData(responseData);
      _showSuccessSnack();
      _redirectUser();

      print(responseData);
    } else {
      setState(() => _isSubmitting = false);
      final String errorMsg = responseData['message'];
      _showErrorSnack(errorMsg);
    }
  }

  void _storeUserData(responseData) async {
    final prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> user = responseData['user'];
    user.putIfAbsent('jwt', () => responseData['jwt']);
    prefs.setString('user', json.encode(user));
  }

  void _showSuccessSnack() {
    final snackbar = SnackBar(
        content: Text('User successfully logged in!',
            style: TextStyle(color: Colors.purple)));
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar =
        SnackBar(content: Text(errorMsg, style: TextStyle(color: Colors.red)));
    _scaffoldKey.currentState.showSnackBar(snackbar);
    throw Exception('Error logging in: $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/animation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        //backgroundColor: Theme.of(context).primaryColor,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: <Widget>[
                            _showTitleText(),
                            _showSubTitleText(),
                            _showEmailInput(),
                            _showPasswordInput(),
                            _forgotPassword(),
                            _passwordDivider(),
                            _showFormActions(),
                            _showLogwithText(),
                            ShowLoginWithPlatform(),
                            _showFormActions2(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
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
      });
    });
  } catch (error) {
    print('Google Sign in error is :' + error);
  }
}

Future<Null> _loginFacebook() async {
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
  } catch (error) {
    print('Facebook Sign in error is :' + error);
  }
}

// Future<Null> logOut() async {
//   final facebookLogin = FacebookLogin();
//   GoogleSignIn _googleSignIn = GoogleSignIn();

//   await facebookLogin.logOut();
//   await _googleSignIn.disconnect();
//   // _showMessage('Logged out.');
// }

// Widget _tempLogoutbutton() {
//   return Padding(
//     padding: const EdgeInsets.all(0.0),
//     child: Container(
//       child: FlatButton(
//         onPressed: () => logOut(),
//         child: Text('Logout', style: TextStyle(color: Colors.white)),
//       ),
//     ),
//   );
// }

void _loginApple() async {
  final AuthorizationResult result = await AppleSignIn.performRequests([
    AppleIdRequest(requestedScopes: [Scope.email, Scope.fullName])
  ]);

  // switch (result.status) {
  //   case AuthorizationStatus.authorized:

  //     // Store user ID
  //     await FlutterSecureStorage()
  //         .write(key: "userId", value: result.credential.user);

  //     // Navigate to secret page (shhh!)
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (_) =>
  //             SecretMembersOnlyPage(credential: result.credential)));
  //     break;

  //   case AuthorizationStatus.error:
  //     print("Sign in failed: ${result.error.localizedDescription}");
  //     setState(() {
  //       errorMessage = "Sign in failed 😿";
  //     });
  //     break;

  //   case AuthorizationStatus.cancelled:
  //     print('User cancelled');
  //     break;
  // }
}

bool _androidPlatformCheck() {
  bool val = false;
  if (Platform.isIOS) {
    val = true;
  } else if (Platform.isAndroid) {
    val = false;
  }
  return val;
}
