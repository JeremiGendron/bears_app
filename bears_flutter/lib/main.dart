import 'package:bears_flutter/flows/feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import 'flows/chat/chat.dart';
import 'models/user/user.dart';

void main() {
  //debugPaintSizeEnabled=true;
  runApp(App());
} 

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        cursorColor: Colors.deepPurple,
      ),
      home: ScopedModel<UserModel>(
        model: UserModel(),
        child: ChatView(friendUsername: 'someone', friendProfilePic: 'https://static-cdn.jtvnw.net/jtv_user_pictures/neace-profile_image-d77145881ab325c6-70x70.jpeg',)
      )
    );
  }
}
//SignupConfirmView(
      //  token: '',
      //  email: '',
      //  dateOfBirth: '',
      //  username: '',
      //),