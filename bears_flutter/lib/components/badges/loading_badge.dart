import 'package:bears_flutter/data.dart';
import 'package:flutter/material.dart';

Container loadingBadge() => Container(
  padding: EdgeInsets.all(3),
  alignment: Alignment.center,
  child: SizedBox(
    width: 10,
    height: 10,
    child: CircularProgressIndicator(
      value: null,
      strokeWidth: 2,
      valueColor: AlwaysStoppedAnimation(primaryColor),
    ),
  ),
);