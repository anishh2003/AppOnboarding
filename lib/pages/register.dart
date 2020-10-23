import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'social_media_login.dart';

class RegisterPage extends StatefulWidget {
  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  bool _isSubmitting;

  String _username, _email, _password;

  Widget _showTitleText() {
    return Padding(
        padding: EdgeInsets.only(top: 80),
        child: Text(
          'Not a Wrangler yet?            ',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ));
  }

  Widget _showSubTitleText() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Text(
          'Create an account.                                       ',
          style: TextStyle(
            fontSize: 20,
            color: Colors.grey,
          ),
        ));
  }

  Widget _showUsernameInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          onSaved: (val) => _username = val,
          validator: (val) => val.length < 6 ? 'Username too short' : null,
          decoration: InputDecoration(
            labelText: 'Full Name',
            hintText: 'Enter username, min length 6',
          ),
        ));
  }

  Widget _showEmailInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
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
            labelText: 'Email',
            hintText: 'Enter a valid email',
          ),
        ));
  }

  Widget _showPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          onSaved: (val) => _password = val,
          validator: (val) => val.length < 6 ? 'Username too short' : null,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter password, min length 6',
          ),
        ));
  }

  Widget _showConfirmPasswordInput() {
    return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          //onSaved: (val) => _password = val,
          validator: (val) => val.length < 6 ? 'Username too short' : null,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Confirm Password',
            hintText: 'Enter password, min length 6',
          ),
        ));
  }

  Widget _showSignUpPolicyText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, bottom: 20),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14.0, color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: 'By creating an account you agree to Wrangle\'s ',
                style: TextStyle(fontSize: 14)),
            TextSpan(
              text: 'Terms & Conditions',
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(context, '/terms');
                },
            ),
            TextSpan(text: ' and ', style: TextStyle(fontSize: 14)),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyle(
                //fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).primaryColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.pushReplacementNamed(context, '/policy');
                },
            )
          ],
        ),
      ),
    );
  }

  Widget _showFormActions() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: _isSubmitting == true
          ? CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor))
          : SizedBox(
              width: 310.0,
              height: 45.0,
              child: OutlineButton(
                  child: Text('GET STARTED',
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
        'http://3.10.233.244:1337/auth/local/register',
        body: {"username": _username, "email": _email, "password": _password});

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
        content: Text('User $_username successfully created!',
            style: TextStyle(color: Colors.purple)));
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

  void _showErrorSnack(String errorMsg) {
    final snackbar = SnackBar(
        content: Text(errorMsg, style: TextStyle(color: Colors.purple)));
    _scaffoldKey.currentState.showSnackBar(snackbar);
    throw Exception('Error registering: $errorMsg');
  }

  void _redirectUser() {
    Future.delayed(Duration(seconds: 2), () {
      Navigator.pushReplacementNamed(context, '/animation');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        key: _scaffoldKey,
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Center(
                    child: Column(
                      children: <Widget>[
                        _showTitleText(),
                        _showSubTitleText(),
                        _showUsernameInput(),
                        _showEmailInput(),
                        _showPasswordInput(),
                        _showConfirmPasswordInput(),
                        _showSignUpPolicyText(context),
                        _showFormActions(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('or login with'),
                        ),
                        _showSignUpPolicyText(context),
                        ShowLoginWithPlatform(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
