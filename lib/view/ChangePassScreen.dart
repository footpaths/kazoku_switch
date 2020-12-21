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

class ChangePassScreen extends StatefulWidget {
  static const routeName = '/changePassScreen';

  const ChangePassScreen({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<ChangePassScreen> {
  _CreateTodoState();

  TextEditingController passCurrentController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController rePassController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  var hostEmail = "@gmail.com";

  Future<void> _changePass() async {
    // try {
    //   var pass = passController.text.toString();
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User user = auth.currentUser;
    //   UserCredential userCredential = await FirebaseAuth.instance
    //       .signInWithEmailAndPassword(email: user.email, password: passCurrentController.text.toString());
    //
    //
    // } on FirebaseAuthException catch (e) {
    //   if (e.code == 'user-not-found') {
    //     _showDialogError("Error", "Tài khoản không tồn tại.");
    //   } else if (e.code == 'wrong-password') {
    //     _showDialogError("Error", "Mật khẩu không đúng.");
    //     print('Wrong password provided for that user.');
    //   } else if (e.code == 'network-request-failed') {
    //     _showDialogError("Error", "Vui lòng kiểm tra kết nối.....");
    //   }
    // }
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: user.email, password: passCurrentController.text);
      userCredential.user
          .updatePassword(passController.text)
          .then((value) {
        AwesomeDialog(
            context: context,
            animType: AnimType.LEFTSLIDE,
            headerAnimationLoop: false,
            keyboardAware: true,
            dismissOnBackKeyPress: false,
            dialogType: DialogType.SUCCES,
            title: 'Success',
            desc:
            'Đổi mật khẩu thành công',
            btnOkOnPress: () {
              Navigator.pop(context);
            },
            btnOkIcon: Icons.check_circle,
            onDissmissCallback: () {
              debugPrint('Dialog Dissmiss from callback');
            }).show();
      })
          .catchError((onError) {
        print('loi: $onError');
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showDialogError("Error", "Tài khoản không tồn tại.");
      } else if (e.code == 'wrong-password') {
        _showDialogError("Error", "Mật khẩu hiện tại không đúng.");
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
        appBar: AppBar(
          title: Text("Đổi mật khẩu"),
          centerTitle: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Stack(
          children: <Widget>[
           Container(
             alignment: Alignment.topCenter,
             child:  Image.asset(
               'assets/logo.png',
               width: MediaQuery.of(context).size.width / 1.5,
             ),
           ),
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
                            controller: passCurrentController,
                            autofocus: false,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mật khẩu hiện tại không được rỗng!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mật khẩu hiện tại: '),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: passController,
                            autofocus: false,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Mật khẩu mới không được trống!';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Mật khẩu mới: '),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: rePassController,
                            autofocus: false,
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value.isEmpty ) {
                                return 'Nhập lại mật khẩu không được trống!';
                              }if(value != passController.text)
                                return 'Not Match';
                              return null;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Nhập lại mật khẩu: '),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              // If the form is valid, display a Snackbar.
                              _changePass();
                            }
                          },
                          child: Text(
                            'Đổi mật khẩu',
                            style:
                                TextStyle(color: Colors.white.withOpacity(1.0)),
                          ),
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
