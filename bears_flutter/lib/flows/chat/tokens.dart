import 'package:flutter/material.dart';

class ChatTokens extends ChangeNotifier {
  Map<String, String> data;

  void addChatToken(String friendId, String token) {
    data[friendId] = token;
  }

  void addChatTokens(List<List<String>> tokens) {
    tokens.forEach((List<String> items) => data[items[0]] = items[1]);
  }
}