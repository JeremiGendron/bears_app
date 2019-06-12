import 'dart:convert';

import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

import '../model.dart';

class ChatInput extends StatefulWidget {

  final String friendUsername;

  ChatInput({
    @required this.friendUsername,
  });

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {


  String friendId;
  String chatToken;


  final int maxLength = 280;
  bool tooLong = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    controller.addListener(() {
      if (controller.text.length > maxLength - 1) {
        setState(() => tooLong = true);
      }
      else if (tooLong) setState(() => tooLong = false);
    });

    super.initState();
  }


  void _send(BuildContext context, String value) async {
    final UserModel userModel = ScopedModel.of<UserModel>(context, rebuildOnChange: false).userId;
    final String userId = userModel.userId;
    final String loginToken = userModel.loginToken;

    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();

    var response = await http.post(
      '$baseEventUrl/chat/message',
      body: JsonEncoder().convert({
        "chatToken": chatToken,
        "loginToken": loginToken,
        "from": userId,
        "to": friendId,
        "timestamp": timestamp
      }),
      headers: {
        "Content-Type" : "application/json"
      }  
    );

    switch (response.statusCode) {
      case 200 :
        
        break;
      default:
    }
  }

  void _error(int code) {

  }

  @override
  Widget build(BuildContext context) {
    ChatModel chatModel = ScopedModel.of<ChatModel>(context, rebuildOnChange: false);
    chatToken = chatModel.chatToken;
    friendId = chatModel.friendId;

    return Container(
      padding: EdgeInsets.all(4),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.send,
        maxLength: maxLength,
        maxLengthEnforced: true,
        onSubmitted: (String value) {
          _send(context, value);
          controller.clear();
        },
        decoration: InputDecoration(
          errorText: tooLong ? 'Character limit reached.' : null,
          counterText: '',
          hintText: 'Say something to ${widget.friendUsername}... ',
        ),
        
      ),
    );
  }

}