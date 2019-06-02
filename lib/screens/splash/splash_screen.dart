import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/home/home_screen.dart';
import 'package:med_rescue/screens/onboarding/onbording_page.dart';
import 'package:med_rescue/screens/util/Navigator.dart';
import 'package:med_rescue/service/signup_data_dao.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    try{
      Future.delayed(Duration(seconds: 3), (){
        SignUpDataDAO.getUserInfo()
            .then((user){
          if(user != null){
            SvNavigate(context, HomeScreen(), rootNavigator: true);
          }else{
            SvNavigate(context, OnboardingPage(), rootNavigator: true);
          }
        });
      });

    }catch(e){
      SvNavigate(context, OnboardingPage(), rootNavigator: true);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
}
