import 'dart:convert';

import 'package:bears_flutter/components/post/header/header.dart';
import 'package:bears_flutter/data.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:bears_flutter/shared_preferences.dart';

class UserModel extends Model {

  String _userId;
  set userId(String value) {
    SharedPreferencesInstance.sharedPreferences.then((SharedPreferences sharedPreferences) =>
      sharedPreferences.setString("userId", value)
    );
  }
  get userId => _userId;

  String _loginToken;
  set loginToken(String value) {
    SharedPreferencesInstance.sharedPreferences.then((SharedPreferences sharedPreferences) =>
      sharedPreferences.setString("loginToken", value)
    );
  }
  get loginToken => _loginToken;

  String _username;
  set username(String value) {
    SharedPreferencesInstance.sharedPreferences.then((SharedPreferences sharedPreferences) =>
      sharedPreferences.setString("username", value)
    );
  }
  get username => _username;

  String _profilePicture;
  set profilePicture(String value) {
    UserModel.profilePic = ProfileIcon(image: value, margin: false,);
    SharedPreferencesInstance.sharedPreferences.then((SharedPreferences sharedPreferences) =>
      sharedPreferences.setString("profilePicture", value)
    );
  }
  get profilePicture => _profilePicture;
 
  // = "https://static-cdn.jtvnw.net/jtv_user_pictures/neace-profile_image-d77145881ab325c6-70x70.jpeg";
  

  static Widget profilePic = ProfileIcon(image: "https://static-cdn.jtvnw.net/jtv_user_pictures/neace-profile_image-d77145881ab325c6-70x70.jpeg", margin: false,);

  bool loggedIn = false;

  final BuildContext context;

  UserModel({
    @required this.context,
  }) {
    _initUserModel();
  }

  void _initUserModel() async {
    SharedPreferences sharedPreferencesInstance = await SharedPreferencesInstance.sharedPreferences;
    userId = sharedPreferencesInstance.containsKey("userId") ? 
      sharedPreferencesInstance.getString("userId") :
      null;
 
    loggedIn = userId == null ? false : true;

    if (loggedIn) _getUserData(); 
  }

  Future<dynamic> getChatToken(String friendId) async {
    if (!loggedIn) return 410; // not logged in

    var response = await http.post("$baseDataUrl",
      body: JsonEncoder().convert({
        "userId": userId,
        "friendId": friendId,
        "token": loginToken
      }),
      headers: {
        "Content-Type": "application/json"
      }
    );

    switch (response.statusCode) {
      case 200 :
        return response.body;
        break;
      case 411 :
        return 411; // not friends
      default:
        return null;
    }
  }

  void _getUserData() async {
    SharedPreferences sharedPreferencesInstance = await SharedPreferencesInstance.sharedPreferences;
    
    userId = sharedPreferencesInstance.getString("userId");
    loginToken = sharedPreferencesInstance.getString("loginToken");
    username = sharedPreferencesInstance.getString("username");
    
    if (sharedPreferencesInstance.containsKey("profilePicture")) profilePicture = 
      sharedPreferencesInstance.getString("profilePicture");
    
    //if (!await checkConnectivity(context)) return;
//
    //var response = await http.get('$baseDataUrl/user/$userId');
//
    //switch (response.statusCode) {
    //  case 200 :
    //    Map<String, dynamic> json = JsonDecoder().convert(response.body);
    //    if (json.containsKey('tokens')) _saveTokens(json["tokens"]);
    //    break;
    //  default:
    //    showErrorSnackBar(
    //      context,
    //      Duration(seconds: 10),
    //      'Unable to fetch your profile, you may need to sign out and log back in.'
    //    );
    //}
  }

  void _saveTokens(dynamic) {}

  Future<void> loginUser(String userId, String loginToken, String username) async {
    SharedPreferences sharedPreferencesInstance = await SharedPreferencesInstance.sharedPreferences;

    sharedPreferencesInstance.setString("userId", userId);
    sharedPreferencesInstance.setString("loginToken", loginToken);
    sharedPreferencesInstance.setString("username", username);
  }
}

