import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as prefix0;

import '../common.dart';

enum PostType {
  text
}

class PostBody extends StatelessWidget {

  final String postId;
  final String name;
  final String group;
  final int created;
  final Audience audience;
  final bool sponsored;
  final String image;
  final String creatorId;
  final PostType type = PostType.text;

  PostBody({
    @required this.postId,
    @required this.name,
    @required this.group,
    @required this.created,
    @required this.audience,
    @required this.sponsored,
    @required this.image,
    @required this.creatorId,
  });

  Widget _renderChild() {
    switch (type) {
      case PostType.text :
        return PostTextBody();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _renderChild(),
    );
  }
}

class PostTextBody extends StatelessWidget {

  /// TODO (BACKEND)
  /// format newlines as single space strings
  /// have show more inkwell inline
  /// validate text size on post, send all on request, only render up until show more
  /// if show more is clicked, expand text. If text is very long, sticky show less button as user
  /// starts scrolling.
  final List<String> postData = [
    "I want an honset aswer please, I have 4 questions:",
    " ",
    "1. how much are you able to earn a month on your shopify store and",
    "2. what do you sell( if you want to tell)....",
    "3. Are you able to make a living of your store",
    "4. What traffic source are you using?"
  ];

  Widget _textNodes() {
    return Wrap(
      children: postData.map((String content) =>
        Wrap(
          children: [
            Text(content, style: content != " " ? _textStyle : _newLineStyle,)
          ],
        )
      ).toList()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 12),
      color: Colors.white,
      child: _textNodes()
    );
  }
}

TextStyle _newLineStyle = TextStyle(
  height: 0.5
);
TextStyle _textStyle = TextStyle(
  fontSize: 16
);