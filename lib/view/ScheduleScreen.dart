import 'dart:async';
import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kazoku_switch/choices.dart';
import 'package:kazoku_switch/helper/DatabaseHelper.dart';
import 'package:kazoku_switch/model/colorModel.dart';
import 'package:kazoku_switch/model/month.dart';
import 'package:kazoku_switch/model/registerData.dart';
 import 'package:kazoku_switch/model/ca.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'contant.dart';
// import 'package:time_machine/time_machine.dart';

class ScheduleScreen extends StatefulWidget {
  ScheduleScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ScheduleScreen> {

  @override
  void initState() {
    super.initState();


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Đồng bộ dữ liệu"),
        centerTitle: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(),
          child: Container(
    child: Text("")
    ),
    )
    );
  }
}


