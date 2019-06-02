import 'dart:async';

import 'package:flutter/material.dart';
import 'package:med_rescue/model/signup_dto.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/home/home_screen.dart';
import 'package:med_rescue/screens/sign_up/singup_stage_2.dart';
import 'package:med_rescue/screens/onboarding/third_screen.dart';
import 'package:med_rescue/screens/sign_up/singup_stage_3.dart';
import 'package:med_rescue/screens/util/Navigator.dart';
import 'package:med_rescue/screens/util/snackbar.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';
import 'package:med_rescue/service/signup_data_dao.dart';

import 'singup_stage_1.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  final controller = PageController(initialPage: 0);
  final UserDTO signUpDTO = UserDTO();
  int currentPage = 0;
  List<Widget> pages;

  @override
  void initState() {
    pages = <Widget>[
      SignUpStage1(onNext: onNext, signUpDTO: signUpDTO),
      SignUpStage2(onNext: onNext, signUpDTO: signUpDTO),
      SignUpStage3(onNext: onNext, signUpDTO: signUpDTO),
//      SignUpStage1(),
//      SignUpStage1(),
    ];
    super.initState();
  }

  void onNext(bool last){
    print("Onnext called");
    if(last){
      print("saving changes");
      saveChanges();
    }else{
      controller.nextPage(duration: Duration(milliseconds: 500), curve: Curves.easeOutQuart);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Sign UP", style: TextStyle(color: Colors.black)),
          leading: Icon(Icons.arrow_back, color: primaryColor),
      ),
      body: PageView(
        controller: controller,
        children: pages,
        onPageChanged: (int page) {
          setState(() {
            currentPage = ++page;
          });
        },
      ),
    );
  }

  Future saveChanges() async {
    var snackBar = MkSnackBar.ofKey(scaffoldKey);

    snackBar.loading();

    try {
      var success = await SignUpDataDAO.saveUserInfo(signUpDTO);

      print("SUCCESS => ${success.toString()}");
      if(success){
        Future.delayed(Duration(seconds: 2), (){
          snackBar.success("Signup completed");
          Future.delayed(Duration(seconds: 2), (){
            SvNavigate(context, HomeScreen(), rootNavigator: true);
          });
        });
      }else{
        snackBar.error("Error saving changes, please check that informations you entered are valid and try again", duration: Duration(seconds: 4));
      }

    }catch (e){
      print(e);
      snackBar.error("Error saving changes, please check that informations you entered are valid and try again", duration: Duration(seconds: 4));
    }

    /*Future.delayed(Duration(seconds: 3), (){
      snackBar.success("Signup completed");
    });*/

  }
}