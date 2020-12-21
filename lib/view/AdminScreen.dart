import 'dart:convert';
import 'dart:wasm';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kazoku_switch/model/ca.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/presenter/Presenter.dart';
import 'package:kazoku_switch/view/AdminListStudent.dart';
import 'package:kazoku_switch/view/Background.dart';
import 'package:kazoku_switch/view/HomePage.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';

class AdminScreen extends StatefulWidget {
  static const routeName = '/adminScreen';
  final List<String>listKeyName;

  const AdminScreen({Key key, this.listKeyName}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState(listKeyName);
}

class _CreateTodoState extends State<AdminScreen> {
  _CreateTodoState(this.listKeyName);
  List<String>listKeyName;
  // List<String> listKeyName = new List();

  @override
  void initState() {
   // getRecord();
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Quản lý CLB"),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body:   Container(
          width: double.infinity,
          height: double.infinity,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: listKeyName.length,
            itemBuilder: (context, index) {
              return ListTile(

                title: Center(
                  child: Card(

                    child: Padding(
                      padding: EdgeInsets.all(5),
                      child: Container(
                        width: double.infinity,
                        height: 40.0,
                        alignment: Alignment.center,
                        child:  Text('${listKeyName[index]}'),
                      ),
                    ),
                    elevation: 5,
                    shape: new RoundedRectangleBorder(
                        side: new BorderSide(color: Colors.blue, width: 2.0),
                        borderRadius: BorderRadius.circular(4.0)
                    ),

                  ),

                ),
                onTap: () async {
                  print('click : ${listKeyName[index]}');
                  var result = await Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (BuildContext context) =>
                          new AdminListStudent(
                            keyName: listKeyName[index],
                          )));
                  //print('aaaajjjjjjj $result');

                },
              );
            },

          ),

        )
    );
  }
}
