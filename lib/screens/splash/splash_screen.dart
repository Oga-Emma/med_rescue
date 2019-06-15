import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/home/home_screen.dart';
import 'package:med_rescue/screens/location/get_location_screen.dart';
import 'package:med_rescue/screens/onboarding/onbording_page.dart';
import 'package:med_rescue/screens/util/Navigator.dart';
import 'package:med_rescue/service/signup_data_dao.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
      Future.delayed(Duration(seconds: 3), (){
        SvNavigate(context, GetLocationScreen(), rootNavigator: true);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
//    checkPermission();
    checkPhonePermission();

    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(image: AssetImage("assets/images/splash_bg.png"), fit: BoxFit.cover)
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
      ),
    );
  }

  static const callChannel = MethodChannel("app.med_rescue/callChannel");

  Future checkPermission() async{
    if (Platform.isAndroid) {
      final bool result = await callChannel.invokeMethod('requestPermission');
    }
  }

  Future checkPhonePermission() async {
    if (Platform.isAndroid) {
    Future checkState(PermissionStatus perm) async {
      if(perm == PermissionStatus.denied){
        /*Fluttertoast.showToast(
            msg: "Permission denied, application might not work as expected!!.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );*/
        var permissions = await PermissionHandler().requestPermissions([PermissionGroup.phone]);
        if(permissions[0] != PermissionStatus.granted){
//          await checkState(permissions[0]);
        //denied twice
          Fluttertoast.showToast(
              msg: "Permission denied, application might not work as expected!!.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 3,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 14.0
          );
        }

      }else{
        //permanently disabled go to settings
        Fluttertoast.showToast(
            msg: "Call permission has been permanently denied for this app, to enable, go to settings.",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 3,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0
        );
      }
    }

    PermissionStatus permission = await PermissionHandler().checkPermissionStatus(PermissionGroup.phone);

    if(permission != PermissionStatus.granted){
      await checkState(permission);
    }
    }
  }
}
