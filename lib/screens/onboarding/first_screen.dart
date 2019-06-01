import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';

class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
            child: Image.asset(
              "assets/images/onboarding_1.png",
              fit: BoxFit.cover,
            ),
          )),
          gap(height: 16),
          new RichText(
            text: new TextSpan(
              text: 'Welcome to  ',
              style:
                  DefaultTextStyle.of(context).style.copyWith(fontSize: 24.0),
              children: <TextSpan>[
                new TextSpan(
                    text: 'MedRescue',
                    style: new TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),
              ],
            ),
          ),
          gap(height: 16),
          Text(
            "A 24/7 Medical Emergency Response Service",
            style: TextStyle(color: primaryColor),
          ),
          gap(height: 16),
          Text("Help is on the way.", style: TextStyle(color: Colors.grey),),
        ],
      ),
    );
  }
}
