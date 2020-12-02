import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';
import 'package:kazoku_switch/model/ca.dart';
import 'package:kazoku_switch/model/month.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:kazoku_switch/view/RegisterStudent.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:url_launcher/url_launcher.dart';

class WriteExcelScreen extends StatefulWidget {
  static const routeName = '/riteExcelScreen';

  final List<RegisterData> listSearch;

  const WriteExcelScreen({Key key, this.listSearch}) : super(key: key);


  @override
  State<StatefulWidget> createState() => _CreateTodoState(listSearch);
}

class _CreateTodoState extends State<WriteExcelScreen> {
  final List<RegisterData> _listSearchs;


  _CreateTodoState(this._listSearchs);




  @override
  void initState() {
    super.initState();

   }
  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
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

          child: RaisedButton(

            onPressed: () {
              _createExcel();

            },
            child: Text('Xuất file',style: TextStyle(color: Colors.black54.withOpacity(1.0)),),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.greenAccent),
            ),
            color: Colors.greenAccent,


          )
        ));
  }

  Future<void> _createExcel() async {
     final Workbook workbook = Workbook();

     final Worksheet sheet = workbook.worksheets[0];

     sheet.getRangeByName('A1').setText('Hello World!');

     final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();

     final directory = await getExternalStorageDirectory();

     final path = directory.path;

     File file = File('$path/Output.xlsx');

     await file.writeAsBytes(bytes, flush: true);

// Open the Excel document in mobile
    OpenFile.open('$path/Output.xlsx');

  }
}
