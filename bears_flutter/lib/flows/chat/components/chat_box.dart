import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../model.dart';
import 'chat_message.dart';

class ChatBox extends StatelessWidget {

  final ScrollController controller = ScrollController();

  final String friendUsername;

  ChatBox({
    @required this.friendUsername,
  });

  @override
  Widget build(BuildContext context) {
    ChatModel chatModel = ScopedModel.of<ChatModel>(context, rebuildOnChange: true);
    int messageCount = chatModel.messageCount;

    return ListView.builder(
      controller: controller,
      scrollDirection: Axis.vertical,
      reverse: true,
      itemCount: messageCount,
      itemBuilder: (BuildContext context, int index) => ChatMessage(
        message: chatModel.messages[index]

      )
    );
  }
}
