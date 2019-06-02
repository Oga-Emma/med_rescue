import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/bloc/user_bloc.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';
import 'package:quiver/async.dart';
import 'package:url_launcher/url_launcher.dart'  as UrlLauncher;
import 'package:firebase_database/firebase_database.dart';
import 'package:uuid/uuid.dart';

class AlarmSendingPage extends StatefulWidget {
  AlarmSendingPage(this.bloc);
  UserBloc bloc;
  @override
  _AlarmSendingPageState createState() => _AlarmSendingPageState();
}

class _AlarmSendingPageState extends State<AlarmSendingPage> {
  int _start = 10;
  int _current = 10;
  bool alarmSent = false;

  @override
  void initState() {
    startTimer();
    super.initState();
  }

  @override
  void dispose() {
    if(countDownTimer.isRunning) {
      countDownTimer.cancel();
      sub.cancel();
    }
    super.dispose();
  }

  CountdownTimer countDownTimer;
  StreamSubscription<CountdownTimer> sub;
  void startTimer() {
    countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() { _current = _start - duration.elapsed.inSeconds; });
    });

    sub.onDone(() {
      print("Done");
      if(mounted) {
        setState(() {
          alarmSent = true;
        });
      }
      sub.cancel();
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(24.0),
          alignment: Alignment.center,
          child: alarmSent ? alarmSentScreen() : countDownScreen(),
        ),
      ),
    );
  }

  countDownScreen() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Stay Calm.\nHelp is on the way.",
            textAlign: TextAlign.center, style: TextStyle(height: 1.4, fontSize: 24, color: Colors.white),),

          gap(height: 16),
          Text("We’re contacting emergency services",
            textAlign: TextAlign.center, style: TextStyle(height: 1.4, color: Colors.white),),

          gap(height: 50),
          Center(
            child: Text("00:${_current.toString().padLeft(2, '0')}",
              style: Theme.of(context).textTheme.headline.copyWith(fontSize: 80, color: Colors.white),
            ),
          ),

          gap(height: 50),
          FlatButton(onPressed: (){
            countDownTimer.cancel();
            sub.cancel();
            setState(() {
              alarmSent = true;
            });
          }, child: Text("Skip",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.white),),
          ),

          gap(height: 16),
          Text("You cannot cancel this alarm after the countdown expires",
            textAlign: TextAlign.center, style: TextStyle(height: 1.4, color: Colors.white),),

          gap(height: 50),
          SizedBox(
              width: double.maxFinite,
              height: 52.0,
              child: RaisedButton(onPressed: (){

                countDownTimer.cancel();
                sub.cancel();
                Navigator.of(context).pop();
              },
                textColor: Colors.white,
                color: primaryColor,
                child: Text("Cancel Alarm"),
                shape: RoundedRectangleBorder(side: BorderSide(color: Colors.white)),
              ))
        ],
      ),
    );
  }

  var emergencyNumber = "07006332879";

  bool callMade = false;
  alarmSentScreen() {
    //handle sending of alarm here

    if(!callMade) {
      Future.delayed(Duration(seconds: 2), () {
        callMade = true;
        dialNumber(emergencyNumber);
      });
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text("Stay Calm.\nHelp is on the way.",
            textAlign: TextAlign.center, style: TextStyle(height: 1.4, fontSize: 24, color: Colors.white),),

          gap(height: 16),
          Text("We’re contacting emergency services",
            textAlign: TextAlign.center, style: TextStyle(height: 1.4, color: Colors.white),),

          gap(height: 100),
          Center(
            child: Image.asset("assets/icons/alarm.png", height: 150, width: 150, color: Colors.grey[300],)
          ),

          gap(height: 100),
          Text("Contacting Emergency Services...",
            textAlign: TextAlign.center, style: TextStyle(height: 1.4, color: Colors.white),),

        ],
      ),
    );
  }

  static const callChannel = MethodChannel("app.med_rescue/callChannel");

  Future dialNumber(String number) async{
    makeDatabaseEntry();
    if (Platform.isAndroid) {
      try {
        final bool result = await callChannel.invokeMethod('makeCall',{"number": number});
        if(!result){
          launchWithUrlLauncher();
        }
      } on PlatformException catch (e) {
        launchWithUrlLauncher();
      }
    }else{
      launchWithUrlLauncher();/*else if (Platform.isIOS) {
      // iOS-specific code

    }*/
    }
  }

  void launchWithUrlLauncher() {
    UrlLauncher.launch('tel:$emergencyNumber');
  }

  void makeDatabaseEntry(){
    var uuid = new Uuid();

    var emergency = FirebaseDatabase.instance.reference().child('emergencies');
    //Name, company, email. Phone. Lat and longitude a
    var data = widget.bloc.userSessionData;
    try{
      emergency.child(uuid.v1()).update({
        "name": "${data.user.firstName} ${data.user.lastName}",
        "company": data.user.organizationName,
        "email": data.user.email,
        "phone": data.user.phoneNumber,
        "lontitude": data.longitude,
        "latitude": data.latitude,
        "timestamp": ServerValue.timestamp
      });
    }catch(e){
      print(e);
    }
  }
}
