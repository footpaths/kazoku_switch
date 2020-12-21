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
import 'package:kazoku_switch/view/AdminScreen.dart';
import 'package:kazoku_switch/view/Background.dart';
import 'package:kazoku_switch/view/HomePage.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';

class AdminDirectScreen extends StatefulWidget {
  static const routeName = '/adminScreen';

  const AdminDirectScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<AdminDirectScreen> {
  _CreateTodoState();

  List<String> listKeyName = new List();
  List<String> listKeyNameDelete = new List();
  bool isLoading = false;
  @override
  void initState() {
    getRecord();
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }




  Future<void> getRecord()  {
    final databaseReference = FirebaseDatabase.instance.reference();
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    databaseReference.keepSynced(true);
     databaseReference.once().then((DataSnapshot snapshot) {
      

      Map<dynamic, dynamic> values = snapshot.value;
      values.forEach((key, values) {

        if (key.toString().contains("delete") ||
            key.toString().contains("monney") ||
            key.toString().contains("link")) {
          if(key.toString().contains("delete")){
            listKeyNameDelete.add(key);
          }

        } else {
          listKeyName.add(key);

        }
      });

      setState(() {
      isLoading = true;
      });
    });


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
        body: !isLoading ? Center(
          child: CircularProgressIndicator(),
        ) : Container(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[

                  Transform.scale(
                      scale: 1.0,
                      child: ButtonTheme(
                        minWidth: 200.0,
                        height: 40.0,
                        child: RaisedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            setState(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminScreen(listKeyName: listKeyName,)));
                            });
                          },
                          child: Text(
                            'Danh sách võ sinh',
                            style: TextStyle(
                                color: Colors.white.withOpacity(1.0)),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.cyan),
                          ),
                          color: Colors.cyan,
                        ),
                      )),


                  SizedBox(
                    height: 10.0,
                  ),
                  Transform.scale(
                      scale: 1.0,
                      child: ButtonTheme(
                        minWidth: 200.0,
                        height: 40.0,
                        child: RaisedButton(
                          onPressed: () {
                            // Validate returns true if the form is valid, or false
                            // otherwise.
                            setState(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => AdminScreen(listKeyName: listKeyNameDelete,)));
                            });
                          },
                          child: Text(
                            'Danh sách bị xoá',
                            style: TextStyle(
                                color: Colors.white.withOpacity(1.0)),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.cyan),
                          ),
                          color: Colors.cyan,
                        ),
                      )),
                ],
              )),
        )
    );
  }
}
