import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';

Widget gap({double height = 0, double width = 0}){
  return SizedBox(height: height, width: width);
}


Widget dot([bool colored = false]) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 4.0),
    width: 8,
    height: 8,
    decoration: BoxDecoration(
        color: colored ? primaryColor : primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(10)),
  );
}