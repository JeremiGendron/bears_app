import 'package:bears_flutter/flows/feed/feed.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
      home: FeedView()
    );
  }
}
//SignupConfirmView(
      //  token: '',
      //  email: '',
      //  dateOfBirth: '',
      //  username: '',
      //),