import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kazoku_switch/helper/DatabaseHelper.dart';
import 'package:kazoku_switch/model/ca.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/presenter/Presenter.dart';
import 'package:kazoku_switch/view/HomePage.dart';
import 'package:kazoku_switch/view/LoginFormScreen.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/loginScreen';
  final Presenter presenter;
  final String title;

  const LoginScreen(this.presenter, {Key key, this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<LoginScreen> {
  _CreateTodoState();

  Future<List<RegisterData>> _futureOfList;
  List<RegisterData> _listSearch = new List();


  @override
  void initState() {
    super.initState();
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) {
      _listSearch = value;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                User user = snapshot.data;
                if (snapshot.data != null) {
                    saveUser(user, context, _listSearch);
                }
                if (user == null) {
                  return LoginFormScreen();
                } else {

                  return HomePage(new BasicCounterPresenter(),
                      title: 'Kazoku Karate Club');
                }
              }
              return Scaffold(
                body: Center(
                  child: Text("Đang tiến hành kiểm tra tài khoản ..."),
                ),
              );
            },
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return Scaffold(
          body: Center(
            child: Text("connect to app ..."),
          ),
        );
      },
    );
  }
}
Future<void> saveUser(User user, BuildContext context, List<RegisterData> listSearch) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final databaseReference = FirebaseDatabase.instance.reference();
  List<RegisterData> _listSearchTemp = new List();
  var name = user.email;
  try {
    var result = name.substring(0, name.indexOf('@'));
    print(result);
    await prefs.setString('name', result);
  } catch (e) {
    print('name: $e');
  }


  //   await prefs.setBool('checkSignout', false);
  // }
}
