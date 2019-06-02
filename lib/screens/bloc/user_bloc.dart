import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:med_rescue/model/signup_dto.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends Bloc{
  final UserSessionData userSessionData = UserSessionData();

  var userSessionController = BehaviorSubject<UserSessionData>();
  Sink<UserSessionData> get userSink => userSessionController.sink;
  Observable<UserSessionData> get userStream => userSessionController.stream;

  @override
  void dispose() {
    userSessionController.close();
  }

  void setUserDTO(UserDTO user){
    userSessionData.user = user;
    userSink.add(userSessionData);
  }

  void setIdDTO(String uuid){
    userSessionData.uuid = uuid;
    userSink.add(userSessionData);
  }

  void setLonLat({double longitude, double latitue}){
    userSessionData.longitude = longitude;
    userSessionData.latitude = latitue;

    userSink.add(userSessionData);
  }

  void setAddress(String address) {
    userSessionData.address = address;
    userSink.add(userSessionData);
  }

}

class UserSessionData{
  UserDTO user;
  String uuid;
  double longitude;
  double latitude;
  String address;
}