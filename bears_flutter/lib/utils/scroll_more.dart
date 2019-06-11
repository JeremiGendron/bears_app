import 'package:flutter/material.dart';

void scrollMore(ScrollController controller, double amount) {
  controller.animateTo(controller.offset + amount, duration: Duration(milliseconds: 250), curve: Curves.easeOut);
}