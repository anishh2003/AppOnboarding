import 'package:flutter/material.dart';

class Terms extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Merchant Terms'),
        backgroundColor: Theme.of(context).primaryColor,
        //automaticallyImplyLeading: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Hi! This is Merchant Terms page !',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class Policy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Policy'),
        backgroundColor: Theme.of(context).primaryColor,
        //automaticallyImplyLeading: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Text(
              'Hi! This is Privacy policy page !',
              style: TextStyle(fontSize: 15.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
