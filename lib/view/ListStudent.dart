import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_switch/helper/DatabaseHelper.dart';
import 'package:kazoku_switch/model/colorModel.dart';
import 'package:kazoku_switch/model/month.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:kazoku_switch/model/ca.dart';

import 'AttendaceScreen.dart';
import 'DetailTodoScreen.dart';

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

  getData() {
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) {
      _listSearch = value;
    });
  }
  getDataTemp(String text) {
    _futureOfList = DatabaseHelper.instance.retrieveDataStudent();
    _futureOfList.then((value) {
      for(int i = 0; i< value.length;i++){
        RegisterData registerData = new RegisterData();
        if(value[i].name.toLowerCase().contains(text.toLowerCase())){
          registerData.name = value[i].name;
          registerData.dob = value[i].dob;
          registerData.phone = value[i].phone;
          registerData.address = value[i].address;
          registerData.note = value[i].note;
          registerData.listHP = value[i].listHP;
          registerData.listcolor = value[i].listcolor;
          registerData.listca = value[i].listca;
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
      setState(() {

      });
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
        print(value);
        break;
    }
  }
  @override
  Widget build(BuildContext context) {
    print('quaaaaaa');
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách võ sinh"),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Điểm danh', 'Học phí'}.map((String choice) {
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
                            hintText: 'Search', border: InputBorder.none),
                        onChanged: onSearchTextChanged,
                      ),
                      trailing: new IconButton(
                        icon: new Icon(Icons.cancel),
                        onPressed: () {
                          controller.clear();
                         getData();
                          setState(() {

                          });
                        },
                      ),
                    ),
                    margin: EdgeInsets.all(10.0),
                  ),
                  new Expanded(
                    child: ListView.builder(
                      itemCount: _listSearch.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 10,
                          child: InkWell(
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
                                                  _listSearch[index].name,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),
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
                                                  color: Colors.black),
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
                                                  color: Colors.black),
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
                                                  color: Colors.black),
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
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(height: 3),
                                        ],
                                      ),
                                    ),
                                    Spacer(),
                                    IconButton(
                                        alignment: Alignment.center,
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.green,
                                        ),
                                        onPressed: () async {
                                          _deleteTodo(_listSearch[index]);

                                        })
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
            );
          } else if (snapshot.hasError) {
            return Text("Oops!");
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  _deleteTodo(RegisterData todo) {
    DatabaseHelper.instance.deleteStudent(todo.id);
    getData();
    setState(() {});
  }
  _gotoAttendace()  {
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) =>
            new AttendaceScreen(
            listSearch: _listSearch,
            )));
    //print('aaaajjjjjjj $result');

  }
}


