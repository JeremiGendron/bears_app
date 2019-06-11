import 'package:flutter/material.dart';

Widget horizontalRule({ double margin = 10, Color color, double height = 2}) {
  if (color == null) color = Colors.grey[400];

  return SizedBox.fromSize(
    child: Container(
      height: height,
      margin: EdgeInsets.symmetric(horizontal: margin),
      color: color,
    )
  );
} 