import 'package:flutter/material.dart';

Expanded standardHint(String text, TextStyle style) => Expanded(
  child: RichText(
    softWrap: true,
    text: TextSpan(text: text, style: style),
  ),
);