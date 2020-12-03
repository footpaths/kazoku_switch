import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kazoku_switch/model/ca.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/presenter/Presenter.dart';
import 'package:kazoku_switch/view/HomePage.dart';
import 'package:kazoku_switch/view/LoginFormScreen.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';

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

  @override
  void initState() {
    super.initState();
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


                if (user == null) {
                  return LoginFormScreen();
                } else {

                  return HomePage(new BasicCounterPresenter(), title: 'Flutter MVP Demo');
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
            child: Text("connact to app ..."),
          ),
        );
      },
    );
  }
}
