import 'package:flutter/material.dart';

void showErrorSnackBar(BuildContext context, Duration duration, String content) {
  Scaffold.of(context).showSnackBar(SnackBar(
    duration: duration,
    backgroundColor: Colors.red,
    content: Text(content),
  ));
}
