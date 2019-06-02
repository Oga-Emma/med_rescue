import 'dart:async';

import 'package:flutter/material.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';
import 'package:quiver/async.dart';

class AlarmSendingPage extends StatefulWidget {
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

  alarmSentScreen() {
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
}
