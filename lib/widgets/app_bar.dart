import 'package:flutter/material.dart';

var appBar = AppBar(
  elevation: 0,
  centerTitle: true,
  title: const Text("Food Radar"),
);

var bottomBar = const BottomAppBar(
  shape: CircularNotchedRectangle(),
  notchMargin: 5,
  child: Padding(
    padding: EdgeInsets.all(16.0),
    child: Text(""),
  ),
);
