import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' as locationPackage;
import 'package:location_permissions/location_permissions.dart';
import 'package:med_rescue/resources/color.dart';
import 'package:med_rescue/screens/bloc/user_bloc.dart';
import 'package:med_rescue/screens/home/home_screen.dart';
import 'package:med_rescue/screens/onboarding/onbording_page.dart';
import 'package:med_rescue/screens/splash/splash_screen.dart';
import 'package:med_rescue/screens/util/Navigator.dart';
import 'package:med_rescue/screens/util/loading_spinner.dart';
import 'package:med_rescue/screens/widgets/helper_widgets.dart';
import 'package:med_rescue/service/signup_data_dao.dart';
import 'package:permission_handler/permission_handler.dart' as PermissionHandle;

class GetLocationScreen extends StatefulWidget {
  @override
  _GetLocationScreenState createState() => _GetLocationScreenState();
}

class _GetLocationScreenState extends State<GetLocationScreen>
    with WidgetsBindingObserver {
  StreamController<bool> _controller = StreamController<bool>();
  locationPackage.Location _locationService = locationPackage.Location();
  bool _permission = false;
  static const LOADING = 0;
  static const PERMISSION_DENIED = 1;
  static const GET_LOCATION_SERVICE = 2;

  int current = LOADING;
  int tap = 0;
  bool userPermanentlyDisableLocation = false;

  UserBloc bloc;

  @override
  void dispose() {
    _controller.close();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    checkLocationPermisions();
    //    fetchCurrentLocation();

//    checkLocationPermisions();
  }

  void addIfNotNull(List list, var entry){
    if(entry != null){
      list.add(entry);
    }
  }

  fetchCurrentLocation() async {
    await _locationService.changeSettings(
        accuracy: locationPackage.LocationAccuracy.BALANCED, interval: 1000);

    locationPackage.LocationData location;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      location = await _locationService.getLocation();
      if (location != null) {
        print("LONGITUDE => ${location.longitude}");
        print("LONGITUDE => ${location.latitude}");

        bloc.setLonLat(
            latitue: location.latitude, longitude: location.longitude);

        try {
          final coordinates =
          new Coordinates(location.latitude, location.longitude);
          var addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinates);
          print("Address => $addresses");
          var first = addresses.first;
//        print("FIRST ADDRESS => ${first.featureName} : ${first.addressLine}");
        print("STATE => ${first.toMap()}");
//        print("STATE => ${first.subAdminArea}");
          print("STATE => ${first.adminArea}");
//        print("STATE => ${first.countryName}");
          var list = <String>[];
          addIfNotNull(list, first.featureName);
//          list.add(first.featureName);
          addIfNotNull(list, first.subLocality);
//          list.add(first.subLocality);
          if(first.locality != first.subAdminArea) {

            addIfNotNull(list, first.locality);
//            list.add(first.locality);
          }

          addIfNotNull(list, first.subAdminArea);
//          list.add(first.subAdminArea);

          addIfNotNull(list, first.adminArea);
//          list.add(first.adminArea);
          print("Constructed Address => ${list.join(", ")}");

          bloc.setAddress(list.join(", "));

        }catch(e){
          bloc.setAddress("");
        }
//        routes.splashScreen(context);
//        SvNavigate(context, SplashScreen(), rootNavigator: true);

        try{
          SignUpDataDAO.getUserInfo()
              .then((user){
            if(user != null){
              bloc.setUserDTO(user);
              SvNavigate(context, HomeScreen(), rootNavigator: true);
            }else{
              SvNavigate(context, OnboardingPage(), rootNavigator: true);
            }
          });
        }catch(e){
          SvNavigate(context, OnboardingPage(), rootNavigator: true);
        }
      }
      /*bool serviceStatus = await _locationService.serviceEnabled();
      print("Service status: $serviceStatus");
      if (serviceStatus) {
        _permission = await _locationService.requestPermission();
        print("Permission: $_permission");
        if (_permission) {
          print("Fetching location....");
          location = await _locationService.getLocation();

          print("Location: ${location.latitude}");
        } else {
          setState(() {
            print(
                "PERMISSION NOT GIVEN ========================================");
            current = PERMISSION_DENIED;
          });
        }
      } else {
        bool serviceStatusResult = await _locationService.requestService();
        print("Service status activated after request: $serviceStatusResult");
        if (serviceStatusResult) {
          fetchCurrentLocation();
        } else {
          setState(() {
            print(
                "PERMISSION NOT GIVEN ========================================");
            current = PERMISSION_DENIED;
          });
        }
      }*/
    } on PlatformException catch (e) {
      print("Error ==> $e");
      setState(() {
        current = PERMISSION_DENIED;
      });
      if (e.code == 'PERMISSION_DENIED') {
        //error = e.message;
      } else if (e.code == 'SERVICE_STATUS_ERROR') {
        //error = e.message;
      }
      location = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    bloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(body: getScreen(current));
  }

  Widget getScreen(int screen) {
    print("SCREEN TO DISPLAY => $screen");
    switch (screen) {
      case PERMISSION_DENIED:
        return getPermissionDialog();
      case GET_LOCATION_SERVICE:
        return getErrorDialog(); //Container(child: Center(child: Text("Get Location")));
      default:
        return Container(child: Center(child: LoadingSpinner()));
    }
  }

  Widget getPermissionDialog() {
    return Container(
      alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          height: 300.0,
          width: MediaQuery.of(context).size.width - 50.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "LOCATION PERMISSION DENIED",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: primaryColor),
              ),

              Text(
                "Cerchy requires your location data, for a better experience.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: primaryColor),
              ),
              gap(height: 16),
              Text(
                userPermanentlyDisableLocation
                    ? "You have permanently disable location services for this app, please go to app settings to enable permission"
                        "\nthen click access granted below to continue"
                    : "Please grant Cerchy access to your location by accepting location permission\n"
                        "press accept permission and select allow on the dialog that pops up",
                textAlign: TextAlign.center,
              ),

              userPermanentlyDisableLocation
                  ? FlatButton(
                      onPressed: () => checkLocationPermisions(),
                      child: Text("ACCESS GRANTED",
                          style: TextStyle(color: Colors.green)))
                  : SizedBox(),
//              RaisedButton(
//                  child: Text("Open Settings"), onPressed: _jumpToSetting),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: primaryColor,
                    shape: StadiumBorder(),
                    child: Text(
                      userPermanentlyDisableLocation
                          ? "GOTO SETTINGS"
                          : "ACCEPT PERMISSION",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (userPermanentlyDisableLocation) {
                        await LocationPermissions().openAppSettings();
                        return;
                      }
//                      await LocationPermissions().shouldShowRequestPermissionRationale();
                      await requestPermission(
                          LocationPermissionLevel.locationWhenInUse);
                      if (tap == 3) {
                        userPermanentlyDisableLocation = true;
                        setState(() {});
                      } else {
                        tap++;
                      }
//                      fetchUser();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getErrorDialog() {
    return Container(
      alignment: Alignment.center,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16.0))),
        child: Container(
          padding: EdgeInsets.all(16.0),
          alignment: Alignment.center,
          height: 200.0,
          width: MediaQuery.of(context).size.width - 50.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                "ERROR GETTING DEVICE LOCATION",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: primaryColor),
              ),

              Text(
                "Cerchy requires your location data, for a better experience.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: primaryColor),
              ),

              gap(height: 16),
              Text(
                "Please turn on device location from settings, grant Cerchy and relaunch app",
                textAlign: TextAlign.center,
              ),

//              RaisedButton(
//                  child: Text("Open Settings"), onPressed: _jumpToSetting),
              SizedBox(
                width: double.infinity,
                child: RaisedButton(
                    color: primaryColor,
                    shape: StadiumBorder(),
                    child: Text(
                      "TURN ON LOCATION",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      bool isOpened =
                          await LocationPermissions().openAppSettings();
//                      fetchUser();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future checkCallPermissions() async{
    PermissionHandle.PermissionStatus permission = await PermissionHandle.PermissionHandler().checkPermissionStatus(PermissionHandle.PermissionGroup.phone);

    if(permission != PermissionHandle.PermissionStatus.granted){
      Map<PermissionHandle.PermissionGroup, PermissionHandle.PermissionStatus> permissions = await PermissionHandle.PermissionHandler()
          .requestPermissions([PermissionHandle.PermissionGroup.phone]);
    }
  }

  Future checkLocationPermisions() async {
    setState(() {
      current = LOADING;
    });
    print("CHECKING SERVICE STATUC");
    ServiceStatus serviceStatus =
        await LocationPermissions().checkServiceStatus();
    print("CHECKING SERVICE PERMISION => $serviceStatus");
    if (serviceStatus == ServiceStatus.enabled) {
      PermissionStatus permission =
          await LocationPermissions().checkPermissionStatus();
      if (permission != PermissionStatus.granted) {
        print("PERMISSION => $permission");
        print("REQUESTING PERMISION");
        requestPermission(LocationPermissionLevel.locationWhenInUse);
      } else {
        print("PERMISSION GRANTED");
        current = LOADING;
        fetchCurrentLocation();
      }
    } else {
      current = GET_LOCATION_SERVICE;
    }

    setState(() {});
  }

  PermissionStatus _permissionStatus = PermissionStatus.unknown;

  Future<void> requestPermission(
      LocationPermissionLevel permissionLevel) async {
    final PermissionStatus permissionRequestResult = await LocationPermissions()
        .requestPermissions(permissionLevel: permissionLevel);

    setState(() {
      print(permissionRequestResult);
      _permissionStatus = permissionRequestResult;
      if (permissionRequestResult == PermissionStatus.granted) {
        fetchCurrentLocation();
        current = LOADING;
      } else {
        current = PERMISSION_DENIED;
      }
      setState(() {});
//      print(_permissionStatus);
    });
  }

  AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
//    setState(() { _notification = state; });
    if (state == AppLifecycleState.resumed && current != PERMISSION_DENIED) {
      checkLocationPermisions();
    }
  }
}
