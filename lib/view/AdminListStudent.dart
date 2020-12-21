import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_switch/helper/DatabaseHelper.dart';
import 'package:kazoku_switch/model/colorModel.dart';
 import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/view/WriteExcelScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AttendaceScreen.dart';
import 'DetailTodoScreen.dart';
import 'FeeScreen.dart';

class AdminListStudent extends StatefulWidget {
  AdminListStudent({Key key, this.keyName}) : super(key: key);

  final String keyName;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<AdminListStudent> {
  List<RegisterData> _listData = new List();

  final databaseReference = FirebaseDatabase.instance.reference();
  bool isShow = false;
  bool isLoading = false;
  bool isGetData = false;
  var count =0;
  @override
  void initState() {
    super.initState();
    getRecord();
  }
  Future<void> getRecord() async {
    isShow = false;
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    databaseReference.keepSynced(true);
      databaseReference.child(widget.keyName).once().then((DataSnapshot snapshot) {
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
                RegisterData registerData = new RegisterData();
                registerData.name = name;
                registerData.dob = dob;
                registerData.id = id;
                registerData.phone = phone;
                registerData.phone2 = phone2;
                registerData.address = address;
                registerData.note = note;
                registerData.time = time;
                registerData.listHP = listHP;
                registerData.listca = listca;
                registerData.listcolor = listcolor;
                _listData.add(registerData);
              }
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
              RegisterData registerData = new RegisterData();
              registerData.name = name;
              registerData.dob = dob;
              registerData.id = id;
              registerData.phone = phone;
              registerData.phone2 = phone2;
              registerData.address = address;
              registerData.note = note;
              registerData.time = time;
              registerData.listHP = listHP;
              registerData.listca = listca;
              registerData.listcolor = listcolor;
              _listData.add(registerData);
            });

          }
        }
        setState(() {
          count =  _listData.length;
        });
      });

  }
  _gotoAttendace() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new AttendaceScreen(
              listSearch: _listData,
            )));
    //print('aaaajjjjjjj $result');
  }

  _gotoFee() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new FeeScreen(
              listSearch: _listData,
            )));
    //print('aaaajjjjjjj $result');
  }
  void handleClick(String value) {
    switch (value) {
      case 'Điểm danh':
        print(value);
        _gotoAttendace();
        break;
      case 'Học phí':
        _gotoFee();
        break;

    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Ds CLB: ${widget.keyName}"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Điểm danh', 'Học phí'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],

      ),
      body: Container(
        child: Column(
          children: [
            Container(alignment: Alignment.centerRight,
            margin: EdgeInsets.only(top: 10.0,right: 10.0),
            child: Text("Số lượng: $count",style: TextStyle(color: Colors.red, fontWeight:FontWeight.bold),),
            ),
            Expanded(
              child: ListView.builder(
              itemCount: _listData.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  elevation: 10,
                  child: InkWell(
                    onTap: () async {

                    },
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 8),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10.0),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Họ tên: " +
                                          _listData[index].name,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Năm sinh: " +
                                          _listData[index].dob,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Số điện thoại: " +
                                          _listData[index].phone,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "Số điện thoại 2: " +
                                          _listData[index].phone2,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Địa chỉ: " +
                                          _listData[index].address,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Ghi chú: " +
                                          _listData[index].note,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    alignment: Alignment.topLeft,
                                    child: Text(
                                      "Ngày nhập học: " +
                                          _listData[index].time,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                ],
                              ),
                            ),

                          ],
                        )),
                  ),
                  margin: EdgeInsets.all(10.0),
                );
              },
            ),)


          ],
        ),
      )
    );
  }

}
