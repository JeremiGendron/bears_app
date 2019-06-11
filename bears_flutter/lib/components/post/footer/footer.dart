import 'dart:convert';
import 'dart:math';

import 'package:bears_flutter/components/misc/dot.dart';
import 'package:bears_flutter/data.dart';
import 'package:bears_flutter/models/user/user.dart';
import 'package:bears_flutter/utils/format_number.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../common.dart';

class PostFooter extends StatelessWidget {

  final String postId;
  final String name;
  final String group;
  final int created;
  final Audience audience;
  final bool sponsored;
  final String image;
  final String creatorId;
  final int likes;
  final int comments;
  final int shares;
  final Map<PostReaction, int> reactions;

  PostFooter({
    @required this.postId,
    @required this.name,
    @required this.group,
    @required this.created,
    @required this.audience,
    @required this.sponsored,
    @required this.image,
    @required this.creatorId,
    @required this.likes,
    @required this.comments,
    @required this.shares,
    @required this.reactions,
  });

  List<Widget> _children() => [
    FooterStats(
      likes: likes,
      comments: comments,
      shares: shares,
      reactions: reactions,
    ),
    Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Divider(
        height: 4,
        color: Colors.grey[400],
      ),
    ),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        FooterActionLike(postId: postId,),
        FooterAction(actionType: FooterActionType.comment,),
        FooterAction(actionType: FooterActionType.share,)
      ],
    ),
  ];
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: _children()
      ),
    );
  }
}

class FooterStats extends StatelessWidget {

  final int likes;
  final int comments;
  final int shares;
  final Map<PostReaction, int> reactions;

  FooterStats({
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    @required this.reactions,
  });

  List<Widget> _children() {
    List<Widget> children = [];

    if (likes > 0) children.add(
      FooterReactions(likes: likes, reactions: reactions)
    );

    if (shares > 0 || comments > 0) children.add(FooterNotes(comments: 1000000, shares: 10));

    if (children.length == 0) children.add(Container());

    return children;
  }

  void _statsPressed(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => _statsPressed(context),
      color: Colors.transparent,
      splashColor: Colors.grey[300],
      highlightColor: Colors.grey[200],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _children()
      ),
    );
  }
}



class FooterReactions extends StatelessWidget {

  final int likes;
  final Map<PostReaction, int> reactions;

  FooterReactions({
    this.likes = 5,
    this.reactions,
  });

  Widget _children(Map<PostReaction, int> reactions) {
    Widget children = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 14,
          height: 14,
          margin: EdgeInsets.only(right: 3.5),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('lib/assets/img/hearts/red_heart.png'),
              fit: BoxFit.contain
            )
          )
        ),
        Container(child: _textElement('${formatNumber(likes)}')),
      ],
    );

    return children;
  }

  @override
  Widget build(BuildContext context) {
    Map<PostReaction, int> reactionsToUse = reactions;
    List<PostReaction> keys = reactionsToUse.keys.toList();

    while (reactionsToUse.length > 3) {
      reactionsToUse.remove(keys[Random().nextInt(reactionsToUse.length)]);
    }
    
    return Expanded(
      child: Container(
        height: 20,
        child: _children(reactionsToUse)
      ),
    );
  }
}

class FooterNotes extends StatelessWidget {

  final int comments;
  final int shares;

  FooterNotes({
    this.comments = 0,
    this.shares = 0,
  });
  
  List<Widget> _children() {
    List<Widget> children = [];
    if (comments > 0) children.add(_textElement('${formatNumber(comments)} Comments'));
    if (comments > 0 && shares > 0) children.add(dot(color: Colors.black));
    if (shares > 0) children.add(_textElement("${formatNumber(shares)} Shares"));
    if (children.length == 0) children.add(Container());
    return children;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: _children()
      ),
    );
  }
}

Text _textElement(String text) => Text(text, style: TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w400
),);

enum FooterActionType {
  like,
  comment,
  share
}

Map<FooterActionType, dynamic> actionData = {
  FooterActionType.like: {
    "callback": (BuildContext context) {}
  },
  FooterActionType.comment: {
    "icon": Icon(Icons.comment, color: Colors.grey, size: 18,),
    "callback": (BuildContext context) {}
  },
  FooterActionType.share: {
    "icon": Icon(Icons.share, color: Colors.grey, size: 18,), 
    "callback": (BuildContext context) {}
  },
};

class FooterActionLike extends StatefulWidget {

  final String postId;

  FooterActionLike({
    @required this.postId,
  });

  @override
  _FooterActionLikeState createState() => _FooterActionLikeState();
}

class _FooterActionLikeState extends State<FooterActionLike> {

  bool liked = false;
  UserModel userModel;

  void _pressed() {
    setState(() => liked = !liked);
    http.post(
      "$baseEventUrl/like",
      headers: {
        "Content-Type": "application/json"
      },
      body: JsonEncoder().convert({
        "postId": widget.postId,
        "liked": liked,
        "userId": userModel.userId,
      })
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        color: Colors.transparent,
        splashColor: liked ? 
          Colors.grey[300] :
          Colors.red,
        highlightColor: Colors.grey[200],
        onPressed: _pressed,
        child: Container(
          child: Image(
            image: liked ?
              AssetImage('lib/assets/img/hearts/red_heart.png') :
              AssetImage('lib/assets/img/hearts/grey_heart.png'),
            width: 14,
            height: 14
          )
        ),
      )
    );
  }
}

class FooterAction extends StatelessWidget {
  
  final FooterActionType actionType;

  FooterAction({
    @required this.actionType,
  });
  
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlatButton(
        color: Colors.transparent,
        splashColor: Colors.grey[300],
        highlightColor: Colors.grey[200],
        onPressed: () => actionData[actionType]["callback"](context),
        child: actionData[actionType]["icon"],
      )
    );
  }
}