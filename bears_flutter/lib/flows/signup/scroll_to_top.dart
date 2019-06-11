import 'package:flutter/material.dart';

import 'scroll_controller.dart';

void scrollToTopOfSignupView() {
  SignupViewScrollController.controller.animateTo(0, duration: Duration(milliseconds: 250), curve: Curves.linear);
}