import 'package:bears_flutter/components/post/common.dart';
import 'package:bears_flutter/components/post/post.dart';
import 'package:flutter/material.dart';

class FeedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 50),
              child: Post(
                name: 'A Good Developer',
                group: 'REAL ONES ONLY',
                audience: Audience.group,
                created: DateTime(2018).millisecondsSinceEpoch,
                creatorId: 'me',
                postId: "1",
                image: 'https://static-cdn.jtvnw.net/jtv_user_pictures/neace-profile_image-d77145881ab325c6-70x70.jpeg',
                sponsored: false,
              ),
            )
          ],
        ),
      )
    );
  }
}