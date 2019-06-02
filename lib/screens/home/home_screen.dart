import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/bloc/user_bloc.dart';
import 'package:med_rescue/screens/util/Navigator.dart';
import 'package:med_rescue/screens/util/loading_spinner.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'alarm_sending_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserBloc bloc;

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: StreamBuilder<UserSessionData>(
          stream: bloc.userStream,
          builder: (context, stream){

        if(stream.hasData){
          var userdata = stream.data;
          return SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  width: double.maxFinite,
                  height: 52,
                  child: Material(
                    color: Colors.white,
                    elevation: 16.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Image.asset("assets/icons/med_logo.png", width: 32, fit: BoxFit.contain,)
                      ],),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(32.0),
                  color: Color(0xFFF7F7F7),
                  child: Column(
                    children: <Widget>[
                      Text("Location", style: Theme.of(context).textTheme.title),
                      gap(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(Icons.my_location, size: 20, color: Colors.grey[600]),
                          gap(width: 8),
                          Text("Lat: ${userdata.latitude}"),
                          gap(width: 8),
                          Text("Lon: ${userdata.longitude}")
                        ],
                      ),
                      gap(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Icon(Icons.location_on, size: 18, color: Colors.grey[600]),
                          Expanded(child: Text("${userdata.address}", maxLines: 3, softWrap: true,
                            textAlign: TextAlign.center,)),
                        ],
                      )
                    ],
                  ),
                ),
                Expanded(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: primaryColor.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(125.0),
                            ),
                            height: 250,
                            width: 250,
                            alignment: Alignment.center,
                            child: Stack(
                              children: <Widget>[
                                Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 200,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: primaryColor,
                                      borderRadius: BorderRadius.circular(100.0),
                                    ),
                                  ),
                                ),
                                Positioned(
                              height: 250,
                              width: 250,
                              child: SpinKitPulse(
                                duration: Duration(seconds: 4),
                                size: 250,
                                color: primaryColor,
                              ),
                            ),
                                Center(child: Image.asset("assets/icons/med_logo_white.png", height: 100, width: 100, color: Colors.white,)),
                              ],
                            ),
                          ),
                          InkWell(
                            child: SizedBox(
                              height: 250,
                              width: 250,
                            ),
                            onTap: (){
//                          print("Alarm trigger tapped");
                              showAlarmConfirmDialog();
                            },
                          )
                        ],
                      ),
                    ),
                    gap(height: 16),
                    Text("Tap to trigger the Alarm in case of\nMedical Emergency", style: TextStyle(height: 1.4), textAlign: TextAlign.center,)
                  ],
                )),
              ],
            ),
          );
        }

        return Center(child: LoadingSpinner());

      })
    );
  }

  Future showAlarmConfirmDialog() async {
    bool sendAlarm = await showDialog<bool>(context: context,
        barrierDismissible: false,
        builder: (context){
      return AlertDialog(
        title: Text("Alert"),
        content: Text("Are you sure you want to trigger the Alarm?"),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.grey[700],
            child: new Text("YES"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          FlatButton(
            color: Colors.grey[300],
            child: new Text("NO"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),

        ],
      );
    });

    if(sendAlarm){
//      print("Sending alarm now...");
      SvNavigate(context, AlarmSendingPage(bloc), rootNavigator: true);
    }else{
      print("Canceled");
    }
  }
}
