import 'dart:convert';
import 'dart:wasm';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kazoku_switch/model/ca.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/presenter/Presenter.dart';
import 'package:kazoku_switch/view/Background.dart';
import 'package:kazoku_switch/view/HomePage.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';

class LoginFormScreen extends StatefulWidget {
  static const routeName = '/loginFormScreen';

  const LoginFormScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<LoginFormScreen> {
  _CreateTodoState();

  TextEditingController userController = TextEditingController();
  TextEditingController passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var hostEmail = "@gmail.com";



  Future<void> _LoginUser() async {

    try {
      var email = userController.text.toString() + hostEmail;
      var pass = passController.text.toString();
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: pass);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showDialogError("Error", "Tài khoản không tồn tại.");
      } else if (e.code == 'wrong-password') {
        _showDialogError("Error", "Mật khẩu không đúng.");
        print('Wrong password provided for that user.');
      } else if (e.code == 'network-request-failed') {
       _showDialogError("Error", "Vui lòng kiểm tra kết nối.....");
      }
    }
  }

  _showDialogError(String title, String desc) {
    AwesomeDialog(
            context: context,
            dialogType: DialogType.ERROR,
            animType: AnimType.RIGHSLIDE,
            headerAnimationLoop: false,
            title: title,
            desc: desc,
            btnOkOnPress: () {},
            btnOkIcon: Icons.cancel,
            btnOkColor: Colors.red)
        .show();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
      body:  Stack(
        children: <Widget>[
          Background(),
          Center(
              child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: userController,
                          autofocus: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Tên đăng nhập không được trống!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Tên đăng nhập: '),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(10.0),
                        child: TextFormField(
                          controller: passController,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'Mật khẩu không được trống!';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Mật khẩu: '),
                        ),
                      ),
                      SizedBox(height: 10.0,),


                      RaisedButton(

                        onPressed: () {

                          if (_formKey.currentState.validate()) {
                            // If the form is valid, display a Snackbar.
                            _LoginUser();
                          }
                        },
                        child: Text('Đăng nhập',style: TextStyle(color: Colors.white.withOpacity(1.0)),),
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.cyan),
                        ),
                        color: Colors.cyan,


                      ),
                    ],
                  ))),
        ],
      )

    );
  }
}
