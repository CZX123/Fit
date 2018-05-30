import 'package:flutter/material.dart';

bool isLight = true;

List<ThemeData> themeList = [
  new ThemeData(
    brightness: isLight ? Brightness.light : Brightness.dark,
    primarySwatch: Colors.blue,
    accentColor: Colors.deepOrangeAccent,
  ),
  new ThemeData(
    brightness: isLight ? Brightness.light : Brightness.dark,
    primarySwatch: Colors.green,
    accentColor: Colors.amberAccent,
  ),
  new ThemeData(
    brightness: isLight ? Brightness.light : Brightness.dark,
    primarySwatch: Colors.blueGrey,
    accentColor: Colors.blueGrey,
  ),
];
