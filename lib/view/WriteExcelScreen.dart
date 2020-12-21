import 'dart:convert';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_file/flutter_share_file.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:intl/intl.dart';

import 'package:kazoku_switch/model/registerData.dart';
 import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

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



  void requestPermission() {
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
  }

  @override
  void initState() {
    requestPermission();
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
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Container(
            child: Center(
          child: RaisedButton(
            onPressed: () {
              _createExcel();
            },
            child: Text(
              'Xuất file',
              style: TextStyle(color: Colors.black54.withOpacity(1.0)),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.greenAccent),
            ),
            color: Colors.greenAccent,
          ),
        )));
  }



  Future<void> _createExcel() async {
    var count = 3;
    final Workbook workbook = Workbook();

    final Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByIndex(1, 1).text = 'Danh Sách võ sinh';
    final Range range9 = sheet.getRangeByName('A1:E1');
    range9.cellStyle.backColor = '#ACB9CA';
    range9.merge();
    range9.cellStyle.hAlign = HAlignType.center;
    range9.cellStyle.vAlign = VAlignType.center;
    sheet.getRangeByIndex(1, 1).cellStyle.fontSize = 16;

    sheet.getRangeByName('A2').setText('Tên');
    sheet.getRangeByName('B2').setText('Ngày Vào Học');
    sheet.getRangeByName('C2').setText('Phone');
    sheet.getRangeByName('D2').setText('Ghi chú');
    sheet.getRangeByName('E2').setText('Học phí');

    for (int i = 0; i < _listSearchs.length; i++) {
      var name = "A" + count.toString();
      var date = "B" + count.toString();
      var phone = "C" + count.toString();
      var note = "D" + count.toString();
      var fee = "E" + count.toString();
      sheet.getRangeByName(name).setText(_listSearchs[i].name);
      sheet.getRangeByName(date).setText(_listSearchs[i].time);
      sheet.getRangeByName(phone).setText(_listSearchs[i].phone);
      sheet.getRangeByName(note).setText(_listSearchs[i].note);
      sheet.getRangeByName(fee).setText(_listSearchs[i].listHP);
      count++;
    }

    final List<int> bytes = workbook.saveAsStream();
    if (Platform.isAndroid) {
      //FOR Android
      //final directory = await getExternalStorageDirectory();

      //final path = directory.path;
      String paths = await ExtStorage.getExternalStoragePublicDirectory(
          ExtStorage.DIRECTORY_DOWNLOADS);
      print(paths);
     DateTime now = DateTime.now();
     var formattedDates = DateFormat('yyyy-MM-dd kk:mm').format(now);
     var name  =  "danh_sach_vo_sinh"+"_"+formattedDates.toString()+".xlsx";
      File file = File('$paths/$name');

      await file.writeAsBytes(bytes, flush: true);

// Open the Excel document in mobile
     // OpenFile.open('$paths/Output.xlsx');


      AwesomeDialog(
          context: context,
          animType: AnimType.LEFTSLIDE,
          headerAnimationLoop: false,
          dialogType: DialogType.SUCCES,
          title: 'Success',
          desc:
          'Xuất file thành công. Vui lòng vào thư mục download(Tải về) để lấy file',
          btnOkOnPress: () {
            debugPrint('OnClcik');
          },
          btnOkIcon: Icons.check_circle,
          onDissmissCallback: () {
            debugPrint('Dialog Dissmiss from callback');
          }).show();
    } else if (Platform.isIOS) {
      Directory documents = await getApplicationDocumentsDirectory();
     // Directory documentss = await getExternalStorageDirectory();
      //print('a'+documentss.path);
      print('bb'+documents.path);

      // var dir = await getExternalStorageDirectory();
       var paths = documents.path;
      DateTime now = DateTime.now();
      var formattedDates = DateFormat('yyyy-MM-dd kk:mm').format(now);
      var name  =  "danh_sach_vo_sinh"+"_"+formattedDates.toString()+".xlsx";
      File file = File('$paths/$name');
      //
       await file.writeAsBytes(bytes, flush: true);
     // OpenFile.open('$paths/Output.xlsx');
      FlutterShareFile.share(paths, name, ShareFileType.file);

      print('success');
    }
    workbook.dispose();
  }
}
