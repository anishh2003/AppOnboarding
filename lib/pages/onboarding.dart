import 'package:flutter/material.dart';
import 'onboarding_data.dart';
import 'dart:io';
import 'package:wrangle/pages/onboarding_data.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:wrangle/widgets/onboarding_widgets.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  List<SliderModel> mySlides = new List<SliderModel>();
  int slideIndex = 0;
  PageController controller;

  Widget _buildPageIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 8.0,
      width: isCurrentPage ? 20.0 : 8.0,
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).primaryColor),
        color: isCurrentPage ? Theme.of(context).primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    mySlides = getSlides();
    controller = new PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
//                height: MediaQuery.of(context).size.height - 230,
                height: 650,
                child: PageView.builder(
                  itemCount: mySlides.length,
                  itemBuilder: (context, index) {
                    return SlideTile(
                      imagePath: mySlides[index].getImageAssetPath(),
                      title: mySlides[index].getTitle(),
                      desc: mySlides[index].getDesc(),
                      backgroundColor: mySlides[index].getBackgroundColor(),
                    );
                  },
                  controller: controller,
                  onPageChanged: (index) {
                    setState(() {
                      slideIndex = index;
                    });
                  },
                ),
              ),
              signUpButton(context),
              loginOption(context),
              Container(
                height: 100.0,
                color: Colors.white,
                //margin: EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < 3; i++)
                        i == slideIndex
                            ? _buildPageIndicator(true)
                            : _buildPageIndicator(false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SlideTile extends StatelessWidget {
  final String imagePath, title, desc;
  final Color backgroundColor;

  SlideTile({this.imagePath, this.title, this.desc, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipPath(
            clipper: ClippingClass(),
            child: Container(
              height: 400.0,
              width: double.infinity,
              color: backgroundColor, //Theme.of(context).primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 400.0,
                    child: FlareActor(
                      imagePath,
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Animations",
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w700, fontSize: 30, height: 1.2),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 70.0),
            child: Text(desc,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14)),
          )
        ],
      ),
    );
  }
}

class ClippingClass extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 40);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
