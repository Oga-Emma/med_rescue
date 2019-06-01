import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';

class ThirdScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
              child: Container(
                padding: EdgeInsets.all(54),
            child: Image.asset(
              "assets/images/onboarding_3.png",
              fit: BoxFit.contain,
            ),
          )),
          gap(height: 16),
          new RichText(
            text: new TextSpan(
              text: 'Anywhere you are',
              style:
                  DefaultTextStyle.of(context).style.copyWith(fontSize: 24.0),
              children: <TextSpan>[
                /*new TextSpan(
                    text: 'MedRescue',
                    style: new TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: primaryColor)),*/
              ],
            ),
          ),
          gap(height: 16),
          Text(
            "With MedRescue you do not need to panic.\nYou’re one button away from help.",
            textAlign: TextAlign.center,
            style: TextStyle(height: 1.3, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
