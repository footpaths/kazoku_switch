import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_switch/helper/DatabaseHelper.dart';
import 'package:kazoku_switch/model/colorModel.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/view/WriteExcelScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiengviet/tiengviet.dart';

import 'AttendaceScreen.dart';
import 'DetailTodoScreen.dart';
import 'FeeScreen.dart';

class ListStudent extends StatefulWidget {
  ListStudent({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<ListStudent> {
  Future<List<RegisterData>> _futureOfList;

  @override
  void initState() {
    super.initState();
    getData();
  }

  TextEditingController controller = new TextEditingController();
  List<RegisterData> _listSearch = new List();
  List<RegisterData> _listSearchTemp = new List();
  List<String> list = new List();

  getData() {
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) {
      _listSearch = value;
    });
  }

  _ConvertMonth(String month) {
    var fee = month.replaceAll('[', '');
    var fees = fee.replaceAll(']', '');
    var feesa = fees.replaceAll('"', '');
    return feesa;
  }

  _convertVietnameToEnglish(String str) {
    final strs = TiengViet.parse(str);
    return strs;
  }

  getDataTemp(String text) {
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) {
      for (int i = 0; i < value.length; i++) {
        RegisterData registerData = new RegisterData();
        if (_convertVietnameToEnglish(value[i].name.toLowerCase())
            .contains(text.toLowerCase())) {
          registerData.name = value[i].name;
          registerData.dob = value[i].dob;
          registerData.phone = value[i].phone;
          registerData.phone2 = value[i].phone2;
          registerData.address = value[i].address;
          registerData.note = value[i].note;
          registerData.listHP = value[i].listHP;
          registerData.listcolor = value[i].listcolor;
          registerData.listca = value[i].listca;
          registerData.time = value[i].time;
          registerData.id = value[i].id;
          _listSearch.add(registerData);
        }
      }

      setState(() {});
    });
  }

  onSearchTextChanged(String text) async {
    _listSearch.clear();
    if (text.isEmpty) {
      getData();
      setState(() {});
      return;
    }

    // _userDetails.forEach((userDetail) {
    //   if (userDetail.firstName.contains(text) || userDetail.lastName.contains(text))
    //     _searchResult.add(userDetail);

    // });
    getDataTemp(text);
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
      case 'Xuất excel':
        _createExcel();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    print('quaaaaaa');
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách võ sinh"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Điểm danh', 'Học phí', 'Xuất excel'}
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
      body: FutureBuilder<List<RegisterData>>(
        future: _futureOfList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: Column(
                children: [
                  new Card(
                    child: new ListTile(
                      leading: new Icon(Icons.search),
                      title: new TextField(
                        controller: controller,
                        decoration: new InputDecoration(
                            hintText: 'Vui lòng tìm không dấu', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                          getData();
                          setState(() {});
                        },
                      ),
                    ),
                    margin: EdgeInsets.all(10.0),
                  ),
                  Container(
                    alignment: Alignment.centerRight,
                    margin: EdgeInsets.only(right: 18.0),
                    child: Text(
                      "${_listSearch.length}",
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  new Expanded(
                    child: ListView.builder(
                      itemCount: _listSearch.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 6,
                          child: InkWell(
                            child:   Container(
                              padding: EdgeInsets.only(left: 15,top: 10,bottom: 10),
                              child: Row(
                                children: <Widget>[
                                  Flexible(
                                    child: Container(

                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Họ tên: " +
                                                  _listSearch[index].name,
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
                                                  _listSearch[index].dob,
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
                                                  _listSearch[index].phone,
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
                                                  _listSearch[index].phone2,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              "Học phí: " +
                                                  _ConvertMonth(
                                                      _listSearch[index]
                                                          .listHP
                                                          .toString()),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                          Container(
                                            alignment: Alignment.topLeft,
                                            child: Text(
                                              "Địa chỉ: " +
                                                  _listSearch[index].address,
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
                                                  _listSearch[index].note,
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
                                                  _listSearch[index].time,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.blueGrey),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                        ],
                                      ),
                                    )

                                  ),
                                  SizedBox(
                                    width: 5.0,
                                  ),
                                  Container(

                                    child: IconButton(
                                        alignment: Alignment.center,
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.green,
                                        ),
                                        onPressed: () async {
                                          _deleteTodo(_listSearch[index]);
                                        }),
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              var result = await Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                      new DetailTodoScreen(
                                        todo: _listSearch[index],
                                      )));
                              //print('aaaajjjjjjj $result');
                              if (result != null) {
                                if (result) {
                                  setState(() {
                                    getData();
                                  });
                                }
                              }
                            },
                          )
                        );


                      },
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text("Oops!");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _deleteTodo(RegisterData todo) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    list = (prefs.getStringList('deletesave') ?? List<String>());
    var json = jsonEncode(todo.toMap());

    list.add(json);

    await prefs.setStringList("deletesave", list);
    DatabaseHelper.instance.deleteStudent(todo.id);
    getData();
    setState(() {});
  }

  _gotoAttendace() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new AttendaceScreen(
                  listSearch: _listSearch,
                )));
    //print('aaaajjjjjjj $result');
  }

  _gotoFee() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new FeeScreen(
                  listSearch: _listSearch,
                )));
    //print('aaaajjjjjjj $result');
  }

  _createExcel() {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new WriteExcelScreen(
                  listSearch: _listSearch,
                )));
    //print('aaaajjjjjjj $result');
  }
}
