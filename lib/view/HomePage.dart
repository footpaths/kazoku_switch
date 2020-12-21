import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_switch/helper/DatabaseHelper.dart';
import 'package:kazoku_switch/model/CounterModel.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/presenter/Presenter.dart';
import 'package:kazoku_switch/view/ChangePassScreen.dart';
import 'package:kazoku_switch/view/Counter.dart';
import 'package:kazoku_switch/view/ListStudent.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';
import 'package:kazoku_switch/view/contant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminDirectScreen.dart';
import 'AdminScreen.dart';
import 'Background.dart';
import 'ScheduleScreen.dart';
import 'SyscScreen.dart';

class HomePage extends StatefulWidget {
  final Presenter presenter;

  HomePage(this.presenter, {Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HomePage> implements Counter {
  CounterModel _viewModel;
  List<RegisterData> _listSearch = new List();
  Future<List<RegisterData>> _futureOfList;
  final databaseReference = FirebaseDatabase.instance.reference();
  List<String> fridges = new List();
  bool isDelete = false;
  bool isShow = false;
  bool isLoading = false;
  bool isGetData = false;
  var name;
  @override
  void initState() {
    super.initState();
    this.widget.presenter.counterView = this;
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) async {
      _listSearch = value;
        name = await Contants.getUserName();
      if(name.toString().contains("admin")){

      } else{
        _getDataFromServer();
      }

    });
  }

  _getDataFromServer() async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // bool isCheckOut = prefs.getBool("checkSignout") ?? false;
    // var name = prefs.getString("name");
    // print('lalala $isCheckOut');
    // if (!isCheckOut) {

    if (_listSearch.length == 0) {
      FirebaseDatabase.instance.setPersistenceEnabled(true);
      databaseReference.keepSynced(true);
      databaseReference.child(name).once().then((DataSnapshot snapshot) {

        try {
          List<dynamic> resultList = snapshot.value;
          if (resultList != null) {
            for (var i = 0; i < resultList.length; i++) {
              if (resultList[i] != null) {
                Map<dynamic, dynamic> map = Map.from(resultList[i]);
                var name = map['name'];
                var id = map['id'];
                var dob = map['dob'];
                var phone = map['phone'];
                var phone2 = map['phone2'];
                var address = map['address'];
                var note = map['note'];
                var time = map['time'];
                var listHP = map['listHP'];
                var listca = map['listca'];
                var listcolor = map['listcolor'];
                DatabaseHelper.instance.insertDataStudent(RegisterData(
                    id: id,
                    dob: dob,
                    name: name,
                    phone: phone,
                    phone2: phone2,
                    address: address,
                    note: note,
                    listHP: listHP,
                    listca: listca,
                    listcolor: listcolor,
                    time: time));
              }
            }
          }
        } catch (e) {
          print(e);
          Map<dynamic, dynamic> values = snapshot.value;
          if (values != null) {
            values.forEach((key, values) {
              print(values["name"]);
              var name = values['name'];
              var id = values['id'];
              var dob = values['dob'];
              var phone = values['phone'];
              var phone2 = values['phone2'];
              var address = values['address'];
              var note = values['note'];
              var time = values['time'];
              var listHP = values['listHP'];
              var listca = values['listca'];
              var listcolor = values['listcolor'];
              DatabaseHelper.instance.insertDataStudent(RegisterData(
                  id: id,
                  dob: dob,
                  name: name,
                  phone: phone,
                  phone2: phone2,
                  address: address,
                  note: note,
                  listHP: listHP,
                  listca: listca,
                  listcolor: listcolor,
                  time: time));
            });
          }
        }
      });
    }
  }

  Future<void> createRecord() async {
    var name = await Contants.getUserName();
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) {
      _listSearch = value;

      isShow = false;
      if (_listSearch.length > 0) {
        for (int i = 0; i < _listSearch.length; i++) {
          databaseReference
              .child(name)
              .child(_listSearch[i].id.toString())
              .set({
                'id': _listSearch[i].id,
                'name': _listSearch[i].name,
                'dob': _listSearch[i].dob,
                'phone': _listSearch[i].phone,
                'phone2': _listSearch[i].phone2,
                'address': _listSearch[i].address,
                'note': _listSearch[i].note,
                'listHP': _listSearch[i].listHP,
                'listca': _listSearch[i].listca,
                'time': _listSearch[i].time,
                'listcolor': _listSearch[i].listcolor,
              })
              .then((value) => {
                    if (!isGetData) {getData()}
                  })
              // ignore: missing_return
              .timeout(Duration(seconds: 10), onTimeout: () {
                print('aaaaa');
                if (!isShow) {
                  isShow = true;
                  setState(() {
                    isLoading = false;
                    gotoDialog(context);
                  });
                }
              });
        }
      } else {
        setState(() {
          isLoading = false;
          _setSignOut();
        });
      }
    });
  }

  _setSignOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var listdelete = (prefs.getStringList('deletesave') ?? List<String>());

    var name = await Contants.getUserName();
    if (listdelete != null) {
      List jsonresponse = json.decode(listdelete.toString());
      var listd = jsonresponse.map((job) => new RegisterData.fromJson(job)).toList();
      var listDeleteConvert = listd;
      for (int i = 0; i < listdelete.length; i++) {
        databaseReference.child(name).child(listDeleteConvert[i].id.toString()).remove();
        // move to delete node
      }
      listdelete.clear();
      await prefs.setStringList("deletesave", listdelete);
    }

    await FirebaseAuth.instance.signOut();
  }

  Future<void> getData() async {
    isLoading = false;
    isGetData = true;
    var name = await Contants.getUserName();
    SharedPreferences prefs = await SharedPreferences.getInstance();


    var listdelete = (prefs.getStringList('deletesave') ?? List<String>());
    List jsonresponse = json.decode(listdelete.toString());

    var listd = jsonresponse.map((job) => new RegisterData.fromJson(job)).toList();
    var listDeleteConvert = listd;
    var listdeleteold = (prefs.getStringList('deletesaveold') ?? List<String>());
    if (listdelete != null) {
      for (int i = 0; i < listDeleteConvert.length; i++) {
        databaseReference.child(name).child(listDeleteConvert[i].id.toString()).remove();
        databaseReference
            .child(name+"delete")
            .child(listDeleteConvert[i].id.toString())
            .set({
          'id': listDeleteConvert[i].id,
          'name': listDeleteConvert[i].name,
          'dob': listDeleteConvert[i].dob,
          'phone': listDeleteConvert[i].phone,
          'phone2': listDeleteConvert[i].phone2,
          'address': listDeleteConvert[i].address,
          'note': listDeleteConvert[i].note,
          'listHP': listDeleteConvert[i].listHP,
          'listca': listDeleteConvert[i].listca,
          'time': listDeleteConvert[i].time,
          'listcolor': listDeleteConvert[i].listcolor,
        })
            .then((value) => {
        print('xong')
        })
        // ignore: missing_return
            .timeout(Duration(seconds: 10), onTimeout: () {

        });
      }
      listdelete.clear();

      await prefs.setStringList("deletesave", listdelete);
    }
    if(listdeleteold.length > 0){
      for (int i = 0; i < listdeleteold.length; i++) {
        databaseReference.child(name).child(listdeleteold[i]).remove();
      }
      listdeleteold.clear();
      await prefs.setStringList("deletesaveold", listdelete);
    }
    setState(() {
      isLoading = false;
      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          keyboardAware: true,
          dismissOnBackKeyPress: false,
          dialogType: DialogType.SUCCES,
          title: 'Success',
          desc: 'Up dữ liệu thành công .............',
          btnOkOnPress: () async {
            for (int i = 0; i < _listSearch.length; i++) {
              await DatabaseHelper.instance.deleteStudent(_listSearch[i].id);
            }
            await prefs.setBool('checkSignout', true);
           await FirebaseAuth.instance.signOut();
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: () {
            debugPrint('Dialog Dissmiss from callback');
          }).show();
    });
  }

  @override
  void refreshCounter(CounterModel viewModel) {
    setState(() {
      this._viewModel = viewModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        centerTitle: true,
      ),
      body: Container(
          height: MediaQuery.of(context).size.height,

          child: isLoading
              ? Center(
            child: CircularProgressIndicator(),
          )
              : new Container(
            width: double.infinity,
            height: double.infinity,
            child: GridView.count(
              crossAxisCount: 2,
              physics: ScrollPhysics(),
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RegisterStudent()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Ghi Danh",
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  margin: EdgeInsets.all(12.0),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.red],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        print('hihihihi');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ListStudent()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Danh sách",
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        print('hihihihi');

                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => SyscScreen()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Đồng bộ dữ liệu",
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.red],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ScheduleScreen()));
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Bài tập",
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.red, Colors.blue],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () async {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        var name = prefs.getString("name");
                        if (name.contains("admin") || name.contains("qc")) {
                          print('admin');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AdminDirectScreen()));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ChangePassScreen()));
                        }
                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Quản lý",
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [Colors.blue, Colors.red],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.5, 0.0),
                        stops: [0.0, 1.0],
                        tileMode: TileMode.clamp),
                  ),
                  child: Card(
                    child: InkWell(
                      onTap: () async {

                        if(name.toString().contains("admin") || name.toString().contains("qc")){
                          await FirebaseAuth.instance.signOut();
                        }else{
                          AwesomeDialog(
                            context: context,
                            keyboardAware: true,
                            dismissOnBackKeyPress: false,
                            dialogType: DialogType.WARNING,
                            animType: AnimType.BOTTOMSLIDE,
                            btnCancelText: "Huỷ",
                            btnOkText: "Up dữ liệu",
                            title: 'Đăng xuất?',
                            padding: const EdgeInsets.all(16.0),
                            desc:
                            'Vui lòng up dữ liệu trước khi đăng xuất..',
                            btnCancelOnPress: () {
                              print('cancellll');
                            },
                            btnOkOnPress: () {
                              setState(() {
                                isLoading = true;
                                createRecord();
                              });

                              //await FirebaseAuth.instance.signOut();
                            },
                          ).show();
                        }

                      },
                      splashColor: Colors.green,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Đăng xuất",
                              style: new TextStyle(
                                  fontSize: 17.0, color: Colors.white),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    color: Colors.blue,
                  ),
                  margin: EdgeInsets.all(8.0),
                ),
              ],
            ),
            alignment: Alignment.center,
            margin: EdgeInsets.only(top: 10.0),
          )),




    );
  }
}
