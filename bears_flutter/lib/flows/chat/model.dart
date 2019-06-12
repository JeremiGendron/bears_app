import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;

class ChatModel extends Model {
  int messageCount = 2;
  List<Map<String, dynamic>> messages = [
    {
      "message": "Message that is quite long to test whether or not it can span mutliple lines in the ui",
      "friend": false,
      "timestamp": "1 w"
    },
    {
      "message": "HELLO SIR, ",
      "friend": true,
      "timestamp": "1 w"
    }
  ];

  void newMessage(String message, bool friend) {
    messages.add({
      "message": message,
      "friend": bool
    });
    messageCount ++;
    notifyListeners();
  }

  void clear() {
    messageCount = 0;
    messages = [];
    friendIcon = null;
    friendId = null;
  }

  Widget friendIcon;

  String friendId;

  String chatToken;

}