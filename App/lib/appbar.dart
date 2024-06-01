import 'package:flutter/material.dart';

AppBar buildAppBar(BuildContext context) {
  return AppBar(
    title: const Text('LazyController',
        style: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
    centerTitle: true,
    backgroundColor: Colors.blue,
    iconTheme: const IconThemeData(color: Colors.white, size: 30),
  );
}
