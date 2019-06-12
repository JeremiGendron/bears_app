import 'package:bears_flutter/components/post/header/header.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  String userId = "1";
  String username = "some_developer";
  String profilePicture = "https://static-cdn.jtvnw.net/jtv_user_pictures/neace-profile_image-d77145881ab325c6-70x70.jpeg";

  static Widget profilePic = ProfileIcon(image: "https://static-cdn.jtvnw.net/jtv_user_pictures/neace-profile_image-d77145881ab325c6-70x70.jpeg", margin: false,);

  bool loggedIn = false;
}