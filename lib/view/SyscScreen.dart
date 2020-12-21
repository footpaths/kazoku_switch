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

class SyscScreen extends StatefulWidget {
  SyscScreen({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<SyscScreen> {
  Future<List<RegisterData>> _futureOfList;
  List<RegisterData> _listSearch = new List();
  List<RegisterData> _listSearchTemp = new List();
  List<String> fridges = new List();
  bool isDelete = false;
  bool isShow = false;
  bool isLoading = false;
  bool isGetData = false;
  List _myActivities;
  List<Ca> listCa;
  List<String> listDeleteOld = new List();
  @override
  void initState() {
    super.initState();

    listCa = [];
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) {
      _listSearch = value;
    });
  }

  final databaseReference = FirebaseDatabase.instance.reference();

  Future<void> getRecordOld() async {
    isShow = false;

    FirebaseDatabase.instance.setPersistenceEnabled(true);
    databaseReference.keepSynced(true);
    var name = await Contants.getUserName();
    databaseReference.child(name).once().then((DataSnapshot snapshot) async {
      try {
        Map<dynamic, dynamic> values = snapshot.value;
        if (values != null) {

          values.forEach((key, values) {
            listDeleteOld.add(key);
            print("$key");
            _myActivities = [];
            listCa = [];
            var address = values['address'];

            //var beltColorsModel = values['beltColorsModel'];
            var buoiTapModels = values['buoiTapModels'] as List<dynamic>;
            var dateStudy = values['dateStudy'];
            var dob = values['dob'];
            var id = values['id'];
            var monthModels = values['monthModels'] as List<dynamic>;
            var name = values['name'];
            var note = values['note'];
            var phone = values['phone'];

            for(int i =0; i< monthModels.length;i++){
              Map<dynamic, dynamic> map = Map.from(monthModels[i]);
              var isSelect = map['select'];
              var monthName = map['monthsName'];
              print('$isSelect');
              if(isSelect){
                _myActivities.add(_getMonthConvert(monthName));
              }
            }
            for(int i =0; i< buoiTapModels.length;i++){
              Map<dynamic, dynamic> map = Map.from(buoiTapModels[i]);
              var isSelect = map['select'];
              var cahoc = map['cahoc'];
              var dayOfWeek = map['dayOfWeek'];
              Ca ca = new Ca();
              ca.isSelect = isSelect;
              ca.name =dayOfWeek;
              ca.monthName = cahoc;
              listCa.add(ca);

            }
            // var time = values['time'];
            // var listHP = values['listHP'];
            // var listca = values['listca'];
            // var listcolor = values['listcolor'];

            DatabaseHelper.instance.insertDataStudent(RegisterData(
                id: id,
                dob: dob,
                name: name,
                phone: phone,
                phone2: "",
                address: address,
                note: note,
                listHP: jsonEncode(_myActivities),
                listca: jsonEncode(listCa),
                listcolor: "0",
                time: dateStudy));
          });
          if (!isShow) {
            isShow = true;
            setState(() {
              isLoading = false;
              AwesomeDialog(
                  context: context,
                  animType: AnimType.LEFTSLIDE,
                  headerAnimationLoop: false,
                  dialogType: DialogType.SUCCES,
                  title: 'Success',
                  desc: 'Lấy liệu thành công .............',
                  btnOkOnPress: () {
                    debugPrint('OnClcik');
                  },
                  btnOkIcon: Icons.check_circle,
                  onDissmissCallback: () {
                    debugPrint('Dialog Dissmiss from callback');
                  }).show();

            });
          }
        }

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setStringList("deletesaveold", listDeleteOld);
      }catch (e) {
        setState(() {
          isLoading = false;
          listDeleteOld.clear();
          AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: false,
              title: 'Error',
              desc: 'Lấy dữ liệu thất bại .................',
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              btnOkColor: Colors.red)
              .show();
        });
      }



    });
  }

    _getMonthConvert(String mon){
    var nameMonth;
    if(mon == "T1"){
      nameMonth =  "Tháng 1";
    }if(mon == "T2"){
      nameMonth =  "Tháng 2";
    }if(mon == "T3"){
      nameMonth =  "Tháng 3";
    }if(mon == "T4"){
      nameMonth =  "Tháng 4";
    }if(mon == "T5"){
      nameMonth =  "Tháng 5";
    }if(mon == "T6"){
      nameMonth =  "Tháng 6";
    }if(mon == "T7"){
      nameMonth =  "Tháng 7";
    }if(mon == "T8"){
      nameMonth =  "Tháng 8";
    }if(mon == "T9"){
      nameMonth =  "Tháng 9";
    }if(mon == "T10"){
      nameMonth =  "Tháng 10";
    }if(mon == "T11"){
      nameMonth =  "Tháng 11";
    }if(mon == "T12"){
      nameMonth =  "Tháng 12";
    }if(mon == "Miễn phí"){
      nameMonth =  "Miễn phí";
    }if(mon == "Học thử"){
      nameMonth =  "Miễn phí";
    }
    return nameMonth;
  }
  Future<void> getRecord() async {
    isShow = false;
    if (_listSearch.length == 0) {
      var name = await Contants.getUserName();
      databaseReference.child(name).once().then((DataSnapshot snapshot) {
        print('Data : ${snapshot.value}');
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
            if (!isShow) {
              isShow = true;
              setState(() {
                isLoading = false;
                AwesomeDialog(
                    context: context,
                    animType: AnimType.LEFTSLIDE,
                    headerAnimationLoop: false,
                    dialogType: DialogType.SUCCES,
                    title: 'Success',
                    desc: 'Lấy liệu thành công .............',
                    btnOkOnPress: () {
                      debugPrint('OnClcik');
                    },
                    btnOkIcon: Icons.check_circle,
                    onDissmissCallback: () {
                      debugPrint('Dialog Dissmiss from callback');
                    }).show();
              });
            }
          } else {
            AwesomeDialog(
                    context: context,
                    dialogType: DialogType.ERROR,
                    animType: AnimType.RIGHSLIDE,
                    headerAnimationLoop: false,
                    title: 'Error',
                    desc: 'Không có dữ liệu tải về .......................',
                    btnOkOnPress: () {},
                    btnOkIcon: Icons.cancel,
                    btnOkColor: Colors.red)
                .show();
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
            if (!isShow) {
              isShow = true;
              setState(() {
                isLoading = false;
                AwesomeDialog(
                    context: context,
                    animType: AnimType.LEFTSLIDE,
                    headerAnimationLoop: false,
                    dialogType: DialogType.SUCCES,
                    title: 'Success',
                    desc: 'Lấy liệu thành công .............',
                    btnOkOnPress: () {
                      debugPrint('OnClcik');
                    },
                    btnOkIcon: Icons.check_circle,
                    onDissmissCallback: () {
                      debugPrint('Dialog Dissmiss from callback');
                    }).show();
              });
            }
          }
        }
      });
    } else {
      AwesomeDialog(
              context: context,
              dialogType: DialogType.ERROR,
              animType: AnimType.RIGHSLIDE,
              headerAnimationLoop: false,
              title: 'Thông báo',
              desc: 'Dữ liệu đã được tự động tải về...',
              btnOkOnPress: () {},
              btnOkIcon: Icons.cancel,
              keyboardAware: true,
              dismissOnBackKeyPress: false,
              btnOkColor: Colors.red)
          .show();
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> createRecord() async {
    isShow = false;
    if (_listSearch.length > 0) {
      var name = await Contants.getUserName();
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
      SharedPreferences prefs = await SharedPreferences.getInstance();
      AwesomeDialog(
          context: context,
          dialogType: DialogType.WARNING,
          headerAnimationLoop: false,
          animType: AnimType.TOPSLIDE,
          title: 'Cảnh báo!',
          keyboardAware: true,
          dismissOnBackKeyPress: false,
          desc:
              'Dữ liệu hiện tại trên máy đang rỗng. Nếu bạn đồng bộ thì dữ liệu trên server sẽ mất..',
          btnCancelOnPress: () {
            setState(() {
              isLoading = false;
            });
          },
          btnOkOnPress: () async {
            var name = await Contants.getUserName();
            var listdelete =
                (prefs.getStringList('deletesave') ?? List<String>());
            if (listdelete != null) {

              for (int i = 0; i < listdelete.length; i++) {
                databaseReference.child(name).child(listdelete[i]).remove();
              }
              listdelete.clear();
              await prefs.setStringList("deletesave", listdelete);
            }
            setState(() {
              isLoading = false;
            });
          }).show();
    }
  }

  Future<void> getData() async {
    isLoading = false;
    isGetData = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var name = await Contants.getUserName();

    // var listdelete = (prefs.getStringList('deletesave') ?? List<String>());
    // if (listdelete != null) {
    //   for (int i = 0; i < listdelete.length; i++) {
    //     databaseReference.child(name).child(listdelete[i]).remove();
    //   }
    //   listdelete.clear();
    //   await prefs.setStringList("deletesave", listdelete);
    // }
    var listdelete = (prefs.getStringList('deletesave') ?? List<String>());
    List jsonresponse = json.decode(listdelete.toString());

    var listd = jsonresponse.map((job) => new RegisterData.fromJson(job)).toList();
    var listDeleteConvert = listd;

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
    setState(() {
      isLoading = false;
      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.SUCCES,
          title: 'Success',
          desc: 'Up dữ liệu thành công .............',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: () {
            debugPrint('Dialog Dissmiss from callback');
          }).show();
    });
  }

  // void updateData() {
  //   databaseReference
  //       .child('link1')
  //       .update({'description': 'J2EE complete Reference'});
  // }
  //
  // void deleteData() {
  //   databaseReference.child('link1').remove();
  // }

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
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : new Container(
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
                                  isLoading = true;
                                  createRecord();
                                });
                              },
                              child: Text(
                                'Up dữ liệu',
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
                                  isLoading = true;
                                  getRecord();
                                });
                              },
                              child: Text(
                                'Lấy dữ liệu về máy',
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
                                  isLoading = true;
                                  getRecordOld();
                                });
                              },
                              child: Text(
                                'Đồng bộ từ dữ liệu cũ',
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
                )),
    );
  }
}

void gotoDialog(BuildContext context) {
  AwesomeDialog(
          context: context,
          dialogType: DialogType.ERROR,
          animType: AnimType.RIGHSLIDE,
          headerAnimationLoop: false,
          title: 'Error',
          desc: 'Vui lòng kiểm tra kết nối mạng .......................',
          btnOkOnPress: () {},
          btnOkIcon: Icons.cancel,
          keyboardAware: true,
          dismissOnBackKeyPress: false,
          btnOkColor: Colors.red)
      .show();
}
