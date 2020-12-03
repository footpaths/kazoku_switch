import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:kazoku_switch/model/ca.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';

class AttendaceScreen extends StatefulWidget {
  static const routeName = '/attendaceScreen';

  final List<RegisterData> listSearch;

  const AttendaceScreen({Key key, this.listSearch}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState(listSearch);
}

class _CreateTodoState extends State<AttendaceScreen> {
  final List<RegisterData> _listSearchs;
  List<RegisterData> _listSearchTemp   = new List();

  _CreateTodoState(this._listSearchs);

  @override
  void initState() {
    super.initState();
   }

  List<String> recipents = ["1234567890", "5556787676"];
  @override
  void dispose() {
    super.dispose();
  }

  int dayofweek = 2;
  int valueCa = 1;
  String valueDOWConvert = "";
  String valueCaConvert = "";
  int valueTotal = 0;
  List<Ca> listCa;
  _convertCa(){
    if(valueCa == 1){
      valueCaConvert = "Ca 1";
    }if(valueCa == 2){
      valueCaConvert = "Ca 2";
    }if(valueCa == 3){
      valueCaConvert = "Ca 3";
    }if(valueCa == 4){
      valueCaConvert = "Ca 4";
    }if(valueCa == 5){
      valueCaConvert = "Ca 5";
    }if(valueCa == 6){
      valueCaConvert = "Ca 6";
    }
    return valueCaConvert.toString();
  }
  _convertDayofweek(){

    if(dayofweek == 2){
      valueDOWConvert = "T2";
    }if(dayofweek == 3){
      valueDOWConvert = "T3";
    }if(dayofweek == 4){
      valueDOWConvert = "T4";
    }if(dayofweek == 5){
      valueDOWConvert = "T5";
    }if(dayofweek == 6){
      valueDOWConvert = "T6";
    }if(dayofweek == 7){
      valueDOWConvert = "T7";
    }if(dayofweek == 8){
      valueDOWConvert = "CN";
    }
    return valueDOWConvert.toString();
  }
  
  searchFuntion(List<RegisterData> _listSearchs) {

    _listSearchTemp.clear();
    for (int i = 0; i < _listSearchs.length; i++) {
      listCa = new List();
      List jsonresponse = json.decode(_listSearchs[i].listca);

      listCa = jsonresponse.map((job) => new Ca.fromJson(job)).toList();

      for(int j =0; j < listCa.length; j++){
        if(listCa[j].name == _convertDayofweek()){

          if(listCa[j].isSelect){
            if(listCa[j].monthName == _convertCa()){
              RegisterData  registerData = new RegisterData();

              registerData.id =  _listSearchs[i].id;
              registerData.name =  _listSearchs[i].name;
              registerData.dob =  _listSearchs[i].dob;
              registerData.phone =  _listSearchs[i].phone;
              registerData.phone2 =  _listSearchs[i].phone2;
              registerData.address =  _listSearchs[i].address;
              registerData.note =  _listSearchs[i].note;
              registerData.time =  _listSearchs[i].time;
              registerData.listca =  _listSearchs[i].listca;
              registerData.listcolor =  _listSearchs[i].listcolor;
              registerData.listHP =  _listSearchs[i].listHP;
              _listSearchTemp.add(registerData);
            }

          }
        }
      }

      setState(() {
        valueTotal = _listSearchTemp.length;
      });

    }

  }
  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Điểm danh'),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                child: Text(
                  "Tổng số: $valueTotal",
                  style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red),
                ),
                margin: EdgeInsets.only(top: 10.0, right: 20.0),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.all(30),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 5),
                      child: new DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: dayofweek,
                          isExpanded: true,
                          iconEnabledColor: Colors.blueGrey,
                          iconDisabledColor: Colors.blueGrey,
                          items: [
                            DropdownMenuItem(
                              child: Text("Thứ 2"),
                              value: 2,
                            ),
                            DropdownMenuItem(
                              child: Text("Thứ 3"),
                              value: 3,
                            ),
                            DropdownMenuItem(child: Text("Thứ 4"), value: 4),
                            DropdownMenuItem(child: Text("Thứ 5"), value: 5),
                            DropdownMenuItem(child: Text("Thứ 6"), value: 6),
                            DropdownMenuItem(child: Text("Thứ 7"), value: 7),
                            DropdownMenuItem(child: Text("Chủ nhật"), value: 8),
                          ],
                          onChanged: (value) {
                            setState(() {
                              dayofweek = value;
                            });
                          },
                        ),
                      ))),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.greenAccent,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  margin: EdgeInsets.only(left: 30.0, right: 30.0),
                  child: Padding(
                      padding: const EdgeInsets.only(
                          left: 30, right: 30, top: 5, bottom: 5),
                      child: new DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: valueCa,
                          isExpanded: true,
                          iconEnabledColor: Colors.blueGrey,
                          iconDisabledColor: Colors.blueGrey,
                          items: [
                            DropdownMenuItem(
                              child: Text("Ca 1"),
                              value: 1,
                            ),
                            DropdownMenuItem(
                              child: Text("Ca 2"),
                              value: 2,
                            ),
                            DropdownMenuItem(child: Text("Ca 3"), value: 3),
                            DropdownMenuItem(child: Text("Ca 4"), value: 4),
                            DropdownMenuItem(child: Text("Ca 5"), value: 5),
                            DropdownMenuItem(child: Text("Ca 6"), value: 6)
                          ],
                          onChanged: (value) {
                            setState(() {
                              valueCa = value;
                            });
                          },
                        ),
                      ))),
              Container(
                child: new RaisedButton(
                  color: Colors.greenAccent,
                  padding: EdgeInsets.only(left: 20, right: 20),
                  onPressed: () => {searchFuntion(_listSearchs)},
                  child: new Text("Tìm Kiếm"),
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.greenAccent),
                  ),
                ),
                margin: EdgeInsets.only(top: 30.0),
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

                          String message = "CLB Karatedo Xin Thông Báo. Vsinh: " + _listSearchTemp[index].name + " Hôm nay vắng mặt. " + "Quý phụ huynh vui lòng xác nhận cho HLV. Xin cảm ơn.";
                          _sendSMS(message, recipents);
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
