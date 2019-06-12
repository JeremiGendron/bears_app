import 'package:bears_flutter/components/spacing/right_spacer.dart';
import 'package:bears_flutter/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model.dart';

class ChatMessage extends StatelessWidget {

  final Map<String, dynamic> message;

  ChatMessage({
    @required this.message,
  });

  List<Widget> _children(Widget friendIcon) => message["friend"] ? _friendMessage(friendIcon) : _userMessage();

  List<Widget> _friendMessage(Widget friendIcon) => [
    Container(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          friendIcon,
          Text(message["timestamp"], style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),)
        ],
      ),
    ),
    rightSpacer(7),
    _chatMessageBody(message["message"], true),
    Expanded(child: Container())
  ];

  List<Widget> _userMessage() => [
    Expanded(child: Container()),
    _chatMessageBody(message["message"], false),
    rightSpacer(7),
    Container(
      height: 60,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          UserModel.profilePic,
          Text(message["timestamp"], style: TextStyle(
            color: Colors.grey,
            fontSize: 12,
            fontWeight: FontWeight.bold
          ),)
        ],
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Widget friendIcon = ScopedModel.of<ChatModel>(context, rebuildOnChange: false).friendIcon;
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _children(friendIcon)
      ),
    );
  }
}

Widget _chatMessageBody(String message, bool friend,) => Flexible(
  fit: FlexFit.loose,
  flex: 3,
  child: Container(
    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 15),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.all(Radius.circular(12.0)),
      color: friend ? Colors.grey[300] : Colors.deepPurple,
    ),
    child: Text(
      message,
      textAlign: TextAlign.justify,
      style: TextStyle(
        color: friend ? Colors.black : Colors.white,
        height: 1.15,
        fontSize: 16
      ),
    ),
  )
);