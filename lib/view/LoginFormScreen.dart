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

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

 Future<void> _createUser() async{
    // try {
    //    UserCredential userCredential =  await FirebaseAuth.instance.signInAnonymously();
    // }on FirebaseAuthException catch(e) {
    //   print('error: $e');
    // } catch  (e){
    //   print('error:  $e');
    // }
   try {
     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
         email: "barryLuan.allen@example.com",
         password: "SuperSecretPassword!"
     );

   } on FirebaseAuthException catch (e) {
     if (e.code == 'weak-password') {
       print('The password provided is too weak.');
     } else if (e.code == 'email-already-in-use') {
       print('The account already exists for that email.');
     }
   } catch (e) {
     print(e);
   }
 }
 Future<void> _LoginUser() async{
    // try {
    //    UserCredential userCredential =  await FirebaseAuth.instance.signInAnonymously();
    // }on FirebaseAuthException catch(e) {
    //   print('error: $e');
    // } catch  (e){
    //   print('error:  $e');
    // }
   try {
     UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
         email: "test@gmail.com",
         password: "123456"
     );
   } on FirebaseAuthException catch (e) {
     if (e.code == 'user-not-found') {
       print('No user found for that email.');
     } else if (e.code == 'wrong-password') {
       print('Wrong password provided for that user.');
     }else if (e.code == 'network-request-failed') {
       AwesomeDialog(
           context: context,
           dialogType: DialogType.ERROR,
           animType: AnimType.RIGHSLIDE,
           headerAnimationLoop: false,
           title: 'Error',
           desc:
           'Vui lòng kiểm tra kết nối.....',
           btnOkOnPress: () {},
           btnOkIcon: Icons.cancel,
           btnOkColor: Colors.red).show();
     }
   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: MaterialButton(
          child: Text("create new acount"),
          onPressed: _LoginUser,
        ),
      ),
    );
  }
}
