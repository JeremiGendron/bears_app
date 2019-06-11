import 'package:bears_flutter/data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

GestureDetector webLink(String url, String text, { BuildContext context }) {
  return GestureDetector(
    child: Text(text, style: TextStyle(
      color: primaryColor,
      fontSize: 12
    ),),
    onTap: () async {
      print('tapped');
      if (await canLaunch(url)) await launch(url);
    },
  );
}