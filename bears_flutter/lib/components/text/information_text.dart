import 'package:flutter/material.dart';

Text informationText(String text, { TextAlign alignment, int maxLines }) => Text(
  text,
  textAlign: alignment,
  style: TextStyle(
    color: Colors.grey[600],
    fontSize: 12,
  ),
  maxLines: maxLines,
);