import 'package:bears_flutter/components/post/header/header.dart';
import 'package:flutter/material.dart';

import 'body/body.dart';
import 'common.dart';
import 'footer/footer.dart';

class Post extends StatelessWidget {

  final String name;
  final String group;
  final int created;
  final String postId;
  final bool sponsored;
  final String image;
  final Audience audience;
  final String creatorId;

  Post({
    @required this.name,
    @required this.group,
    @required this.created,
    @required this.postId,
    @required this.sponsored,
    @required this.image,
    @required this.audience,
    @required this.creatorId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 12),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          PostHeader(
            name: name,
            group: group,
            created: created,
            creatorId: creatorId,
            postId: postId,
            sponsored: sponsored,
            image: image,
            audience: audience,
          ),
          PostBody(
            name: name,
            group: group,
            created: created,
            creatorId: creatorId,
            postId: postId,
            sponsored: sponsored,
            image: image,
            audience: audience,
          ),
          PostFooter(
            name: name,
            group: group,
            created: created,
            creatorId: creatorId,
            postId: postId,
            sponsored: sponsored,
            image: image,
            audience: audience,
            comments: 777,
            likes: 22333,
            shares: 232344,
            reactions: {
              PostReaction.up: 12,
              PostReaction.down: 12,
              PostReaction.mad: 12,
              PostReaction.sad: 12,
              PostReaction.left: 12,
              PostReaction.right: 12
            },
          ),
        ],
      ),
    );
  }
}