import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:kazoku_switch/model/ca.dart';
import 'package:kazoku_switch/model/month.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';
import 'package:url_launcher/url_launcher.dart';

class FeeScreen extends StatefulWidget {
  static const routeName = '/attendaceScreen';

  final List<RegisterData> listSearch;

  const FeeScreen({Key key, this.listSearch}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState(listSearch);
}

class _CreateTodoState extends State<FeeScreen> {
  final List<RegisterData> _listSearchs;
  List<RegisterData> _listSearchTemp = new List();
  List _myActivities;

  _CreateTodoState(this._listSearchs);

  bool isSuccessPayment;
  var mon;
  var monthFee;

  List<String> recipents = ["1234567890", "5556787676"];
  @override
  void initState() {
    super.initState();

    getListAttendance(_listSearchs);
  }
  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
  getListAttendance(List<RegisterData> listSearch) {
    // DateTime now = DateTime.now();
    // var formattedDates = DateFormat('MM').format(now);
    // print('dateeeee: $formattedDates');

    var before = DateTime.now();

    var month = before.month;
    var size = listSearch.length;

    for (int i = 0; i < size; i++) {
      List<dynamic> list = json.decode(listSearch[i].listHP);
      _myActivities = list;
      isSuccessPayment = false;


      if (_myActivities.length == 1) {
        mon = _myActivities[0];
        monthFee = mon.replaceAll("Tháng ", "");
        if (mon == "Nữa tháng" || mon == "Miễn phí") {
        } else {
          if (month >= int.parse(monthFee)) {
            RegisterData registerData = new RegisterData();

            registerData.id = _listSearchs[i].id;
            registerData.name = _listSearchs[i].name;
            registerData.dob = _listSearchs[i].dob;
            registerData.phone = _listSearchs[i].phone;
            registerData.address = _listSearchs[i].address;
            registerData.note = _listSearchs[i].note;
            registerData.time = _listSearchs[i].time;
            registerData.listca = _listSearchs[i].listca;
            registerData.listcolor = _listSearchs[i].listcolor;
            registerData.listHP = _listSearchs[i].listHP;
            _listSearchTemp.add(registerData);
          }
        }
      } else {
        for (int j = 0; j < _myActivities.length; j++) {
          mon = _myActivities[j];
          monthFee = mon.replaceAll("Tháng ", "");
          if (mon == "Nữa tháng" || mon == "Miễn phí") {
            isSuccessPayment = true;
          } else {
            if (int.parse(monthFee) < month) {

            } else{
              isSuccessPayment = true;
            }
          }
        }
        if (!isSuccessPayment) {
          RegisterData registerData = new RegisterData();

          registerData.id = _listSearchs[i].id;
          registerData.name = _listSearchs[i].name;
          registerData.dob = _listSearchs[i].dob;
          registerData.phone = _listSearchs[i].phone;
          registerData.address = _listSearchs[i].address;
          registerData.note = _listSearchs[i].note;
          registerData.time = _listSearchs[i].time;
          registerData.listca = _listSearchs[i].listca;
          registerData.listcolor = _listSearchs[i].listcolor;
          registerData.listHP = _listSearchs[i].listHP;
          _listSearchTemp.add(registerData);
        }
      }

    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  var valueTotal = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách nợ phí'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: Text(
                  "Tổng số: " + _listSearchTemp.length.toString(),
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                margin: EdgeInsets.only(top: 10.0, right: 20.0),
              ),
              new Expanded(
                child: ListView.builder(
                  itemCount: _listSearchTemp.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      elevation: 10,
                      child: InkWell(
                        onTap: () async {
                          recipents.clear();
                          recipents.add(_listSearchTemp[index].phone);

                          String message = "CLB Karatedo Xin Thông Báo. Vsinh: " +_listSearchTemp[index].name + " đã đến hạn thanh toán học phí. " + "Quý phụ huynh vui lòng thanh toán. Xin cảm ơn.";
                          _sendSMS(message, recipents);

                          // if(Platform.isAndroid){
                          //   //FOR Android
                          //   const uri = 'sms:0909894348?body=hello%20there';
                          //   if (await canLaunch(uri)) {
                          //     await launch(uri);
                          //   }
                          // }
                          // else if(Platform.isIOS){
                          //   //FOR IOS
                          //   const uri = 'sms:0909894347&body=hello%20there';
                          //   if (await canLaunch(uri)) {
                          //     await launch(uri);
                          //   }
                          // }
                            // Andro
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
                                              _listSearchTemp[index].name,
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
                                              _listSearchTemp[index].dob,
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
                                              _listSearchTemp[index].phone,
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
                                              _listSearchTemp[index].address,
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
                                              _listSearchTemp[index].note,
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
                                              _listSearchTemp[index].time,
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
                ),
              )
            ],
          ),
        ));
  }
}
