import 'package:flutter/material.dart';

Container standardBadge(IconData icon, Color color) => Container(
  padding: EdgeInsets.all(1),
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: color,
  ),
  child: Icon(icon, color: Colors.white, size: 12,),
);