import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
        Container(
          height: 3,
          color: Colors.black,
            child: Container(
              color: primaryColor,
          margin: EdgeInsets.only(
            right: MediaQuery.of(context).size.width / 4,
          ),
        )),
      ],
    );
  }
}
