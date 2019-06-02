import 'dart:convert';

import 'package:med_rescue/model/signup_dto.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpDataDAO{
  static Future<bool> saveUserInfo(UserDTO data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var userData = json.encode(data.toMap());
    print(userData);
    return await prefs.setString('userData', userData);
  }
  
  static Future<UserDTO> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var data = "";
    data = prefs.getString('userData');
    if(data == null ?? data.isEmpty){
      return null;
    }
    var userData = UserDTO.fromJson(json.decode(data));
    print(userData.toMap());
    return userData;
  }
}