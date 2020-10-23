import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class WrangleAnimation extends StatefulWidget {
  @override
  _WrangleAnimationState createState() => _WrangleAnimationState();
}

class _WrangleAnimationState extends State<WrangleAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ClipPath(
            clipper: ClippingClass(),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 650, //MediaQuery.of(context).size.height,
              child: Stack(
                children: <Widget>[
                  Positioned(
                    left: 40,
                    top: 20,
                    child: Container(
                      width: 400, //MediaQuery.of(context).size.width,
                      height: 400,
                      child: FlareActor(
                        "assets/Rocket.flr",
                        //"assets/New File 13.flr",
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Animations",
                      ),
                    ),
                  ),
                  Positioned(
                    left: 140,
                    top: 100,
                    child: Image.asset(
                      'assets/splash1.png',
                      scale: 1.5,
                    ),
                  ),
                  Positioned(
                    left: 80,
                    top: 200,
                    child: Text(
                      'You\'re top of the ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Positioned(
                    left: 120,
                    top: 250,
                    child: Text(
                      'waiting list',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 380,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Container(
                width: 320,
                child: Text(
                  'As soon as we launch you\'ll be the first in line to start combining deals.'
                  'We expect this to be ready by August',
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            top: 480.0,
            child: Column(children: <Widget>[
              Text(
                '0',
                style: TextStyle(color: Colors.orange, fontSize: 60.0),
              ),
              Text(
                'People ahead of you',
                style: TextStyle(color: Colors.white),
              ),
            ]),
          ),
          Positioned(
            //left: 120,
            top: 620,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              child: FlareActor(
                "assets/Rocket.flr",
                alignment: Alignment.center,
                fit: BoxFit.contain,
                animation: "Untitled",
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 250);
    path.quadraticBezierTo(
        size.width / 4, size.height / 2, size.width / 2, size.height / 2);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height / 2,
        size.width, size.height - 250);
//    path.quadraticBezierTo(
//        size.width / 4, size.height, size.width / 2, size.height);
//    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
//        size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
