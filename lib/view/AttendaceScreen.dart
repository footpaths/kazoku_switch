import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kazoku_switch/model/registerData.dart';

class AttendaceScreen extends StatefulWidget {
  static const routeName = '/attendaceScreen';

  final List<RegisterData> listSearch;

  const AttendaceScreen({Key key, this.listSearch}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CreateTodoState(listSearch);
}

class _CreateTodoState extends State<AttendaceScreen> {
  final List<RegisterData> _listSearch;
    List<RegisterData> _listSearchTemp;

  _CreateTodoState(this._listSearch);

  @override
  void initState() {
    super.initState();
    getListAttendance(_listSearch);
  }

  getListAttendance(List<RegisterData> listSearch) {
    _listSearchTemp = new List();
    for (int i = 0; i < listSearch.length; i++) {

    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Danh sách nợ phí'),
        ),
        body: Container(
          child: Text("hi"),
        ));
  }
}
