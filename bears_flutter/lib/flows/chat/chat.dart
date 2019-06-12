import 'package:bears_flutter/components/post/header/header.dart';
import 'package:bears_flutter/components/spacing/right_spacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

import 'components/chat_box.dart';
import 'components/chat_input.dart';
import 'model.dart';

class ChatView extends StatelessWidget {

  static ScrollController controller = ScrollController();

  final String friendUsername;
  final String friendId;
  final String friendProfilePic;
  final String chatToken;

  ChatView({
    @required this.friendUsername,
    @required this.friendProfilePic,
    @required this.friendId,
    @required this.chatToken,
  });
  
  @override
  Widget build(BuildContext context) {
    ChatModel chatModel = ChatModel();
    chatModel.friendIcon = ProfileIcon(image: friendProfilePic, margin: false,);
    chatModel.friendId = friendId;
    chatModel.chatToken = chatToken;

    return Scaffold(
      appBar: AppBar(
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.chat),
              rightSpacer(7),
              Container(
                margin: EdgeInsets.only(bottom: 5),
                child: Text('$friendUsername'))
            ],
          ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ScopedModel<ChatModel>(
          model: chatModel,
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ChatBox(friendUsername: friendUsername,),
                ),
              ),
              ChatInput(friendUsername: friendUsername)
            ],
          ),
        )
      )
    );
  }
}


