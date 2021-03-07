import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:somos/view/default/my_const.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Size screenSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

EdgeInsets safeAreaSize(BuildContext context) {
  return MediaQuery.of(context).padding;
}

double deviceRatioDefault(BuildContext context,
    {Orientation orientation = Orientation.portrait}) {
  double result;

  if (orientation == Orientation.landscape) {
    result = (screenSize(context).height) / (screenSize(context).width);
  } else {
    result = screenSize(context).width / (screenSize(context).height);
  }

  return result;
}

//Create DATABASE
Future<Database> getDatabase() async {
  //TEST
  //deleteDatabase(join(await getDatabasesPath(), DATABASE_NAME));

  return openDatabase(
    join(await getDatabasesPath(), DATABASE_NAME),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE $TABLE_FAVORITE_USERS_NAME(id INTEGER PRIMARY KEY AUTOINCREMENT, login TEXT UNIQUE, email TEXT UNIQUE, bio TEXT, location TEXT, avatarUrl TEXT);",
      );
    },
    version: 1,
  );
}

flutterToastDefault(String message) {
  Fluttertoast.showToast(
    msg: message,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Color(0xFF636363),
    textColor: Colors.white,
    timeInSecForIosWeb: 5,
  );
}

Future<bool> checkConnectionInternet() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  } on SocketException catch (_) {
    return false;
  }
}
