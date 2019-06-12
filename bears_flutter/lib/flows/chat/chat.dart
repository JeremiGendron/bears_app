import 'package:bears_flutter/components/app_bars/standard_app_bar.dart';
import 'package:bears_flutter/components/post/header/header.dart';
import 'package:bears_flutter/components/spacing/right_spacer.dart';
import 'package:bears_flutter/components/spacing/top_spacer.dart';
import 'package:bears_flutter/models/user/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:scoped_model/scoped_model.dart';

class ChatView extends StatelessWidget {

  static ScrollController controller = ScrollController();

  final String friendUsername;
  final String friendProfilePic;

  ChatView({
    @required this.friendUsername,
    @required this.friendProfilePic,
  }) {
    ChatModel.friendIcon = ProfileIcon(image: friendProfilePic, margin: false,);
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: standardAppBar(friendUsername),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ScopedModel<ChatModel>(
          model: ChatModel(),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ChatBox(friendUsername: friendUsername, friendProfilePic: friendProfilePic,),
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

class ChatBox extends StatelessWidget {

  final ScrollController controller = ScrollController();

  final String friendUsername;
  final String friendProfilePic;

  ChatBox({
    @required this.friendUsername,
    @required this.friendProfilePic,
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

class ChatMessage extends StatelessWidget {

  final Map<String, dynamic> message;

  ChatMessage({
    @required this.message,
  });

  List<Widget> _children() => message["friend"] ? _friendMessage() : _userMessage();

  List<Widget> _friendMessage() => [
    ChatModel.friendIcon,
    rightSpacer(7),
    _chatMessageBody(message["message"], true),
    Expanded(child: Container())
  ];

  List<Widget> _userMessage() => [
    Expanded(child: Container()),
    _chatMessageBody(message["message"], false),
    rightSpacer(7),
    UserModel.profilePic
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        
        children: _children()
      ),
    );
  }
}

Widget _chatMessageBody(String message, bool friend,) => Flexible(
  fit: FlexFit.loose,
  flex: 3,
  child: Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      borderRadius: new BorderRadius.all(Radius.circular(12.0)),
      color: friend ? Colors.grey[300] : Colors.deepPurple,
    ),
    child: Text(
      message,
      textAlign: friend ? TextAlign.left : TextAlign.right,
      style: TextStyle(
        color: friend ? Colors.black : Colors.white,
      ),
    ),
  )
);

class ChatModel extends Model {
  int messageCount = 2;
  List<Map<String, dynamic>> messages = [
    {
      "message": "Message that is quite long to test whether or not it can span mutliple lines in the ui",
      "friend": false
    },
    {
      "message": "HELLO SIR, HOW ARE YOU DIONG TODAY",
      "friend": true
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

  String friendUsername;
  String friendProfilePic;

  static Widget friendIcon;
}

class ChatInput extends StatefulWidget {

  final String friendUsername;

  ChatInput({
    @required this.friendUsername,
  });

  @override
  _ChatInputState createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {


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


  void _send(String value) async {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.send,
        maxLength: maxLength,
        maxLengthEnforced: true,
        onSubmitted: (String value) {
          _send(value);
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