import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kazoku_switch/helper/DatabaseHelper.dart';
import 'package:kazoku_switch/model/colorModel.dart';
import 'package:kazoku_switch/model/month.dart';
import 'package:kazoku_switch/model/registerData.dart';
import 'package:multiselect_formfield/multiselect_formfield.dart';
import 'package:kazoku_switch/model/ca.dart';
// import 'package:time_machine/time_machine.dart';

class RegisterStudent extends StatefulWidget {
  RegisterStudent({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<RegisterStudent> {
  // Future example() async {
  //   await TimeMachine.initialize();
  //   var now = Instant.now();
  //   print('UTC Time: ${now.toString('dddd yyyy-MM-dd HH:mm')}');
  //
  // }
  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
    _myActivities = [];
    _myActivitiesResult = '';
   // example();
  }
  void _onFocusChange(){
    debugPrint("Focus: "+_focus.hasFocus.toString());
  }
  List<String> months = new List();
  final TextStyle textstyle =
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  final InputDecoration decoration =
      InputDecoration(border: OutlineInputBorder(), labelText: 'Họ tên: ');
  final _formKey = GlobalKey<FormState>();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController doBController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  List _myActivities;
  String _myActivitiesResult;
  final formKey = new GlobalKey<FormState>();
  String _fruit = '';
  int possion;
  String status;
  bool isListcaStt = false;
  bool isListColorStt = false;
  _saveForm() {
    var form = formKey.currentState;
    if (form.validate()) {
      form.save();
      setState(() {
        _myActivitiesResult = _myActivities.toString();

      });
    }
  }

  List<Month> listCaOfWeek;
  List<Ca> listCa = [
    Ca(name: 'T2', isSelect: false, monthName: ""),
    Ca(name: 'T3', isSelect: false, monthName: ""),
    Ca(name: 'T4', isSelect: false, monthName: ""),
    Ca(name: 'T5', isSelect: false, monthName: ""),
    Ca(name: 'T6', isSelect: false, monthName: ""),
    Ca(name: 'T7', isSelect: false, monthName: ""),
    Ca(name: 'CN', isSelect: false, monthName: ""),
  ];
  List<colorModel> colorsModelList = [
    colorModel(colors:Colors.white,isSelect: false ),
    colorModel(colors:Colors.yellow,isSelect: false ),
    colorModel(colors:Colors.orange,isSelect: false ),
    colorModel(colors:Colors.green,isSelect: false ),
    colorModel(colors:Colors.blue[900],isSelect: false ),
    colorModel(colors:Colors.red,isSelect: false ),
    colorModel(colors:Colors.deepPurpleAccent,isSelect: false ),
    colorModel(colors:Colors.brown[300],isSelect: false ),
    colorModel(colors:Colors.brown[400],isSelect: false ),
    colorModel(colors:Colors.brown[600],isSelect: false ),
    colorModel(colors:Colors.black,isSelect: false ),
  ];
  _onSelected(int index) {
    setState(() {
      if (!listCa[index].isSelect) {
        listCa[index].isSelect = true;
        _addChooseCa(index);
      } else {
        listCa[index].isSelect = false;
        _removeChooseCa(index);
      }
    });
  }
  _onSelectedColor(int index) {
    possion = index;
    for(int i = 0; i<colorsModelList.length;i++){
        if(i ==  index){
          colorsModelList[i].isSelect = true;
        }else{
          colorsModelList[i].isSelect = false;
        }
    }
    setState(() {

    });
  }
  _addChooseCa(int index) {
    showAlertDialog(context, index);
    FocusScope.of(context).unfocus();
  }

  _removeChooseCa(int index) {
    listCa[index].monthName = "";
    isListcaStt = false;
    isListColorStt = false;
  }

  showAlertDialog(BuildContext context, int index) {
    // set up the list options
    Widget optionOne = SimpleDialogOption(
      child: const Text('Ca 1'),
      onPressed: () {
        setState(() {
          listCa[index].monthName = "Ca 1";
        });
        Navigator.of(context).pop();
      },
    );
    Widget optionTwo = SimpleDialogOption(
      child: const Text('Ca 2'),
      onPressed: () {
        print('cow');
        setState(() {
          listCa[index].monthName = "Ca 2";
        });
        Navigator.of(context).pop();
      },
    );
    Widget optionThree = SimpleDialogOption(
      child: const Text('Ca 3'),
      onPressed: () {
        print('camel');
        setState(() {
          listCa[index].monthName ="Ca 3";
        });
        Navigator.of(context).pop();
      },
    );
    Widget optionFour = SimpleDialogOption(
      child: const Text('Ca 4'),
      onPressed: () {
        print('sheep');
        setState(() {
          listCa[index].monthName ="Ca 4";
        });
        Navigator.of(context).pop();
      },
    );
    Widget optionFive = SimpleDialogOption(
      child: const Text('Ca 5'),
      onPressed: () {
        print('goat');
        setState(() {
          listCa[index].monthName = "Ca 5";
        });
        Navigator.of(context).pop();
      },
    );
    Widget optionSix = SimpleDialogOption(
      child: const Text('Ca 6'),
      onPressed: () {
        print('goat');
        setState(() {
          listCa[index].monthName ="Ca 6";
        });
        Navigator.of(context).pop();
      },
    );

    // set up the SimpleDialog
    SimpleDialog dialog = SimpleDialog(
      title: const Text('Chọn ca'),

      children: <Widget>[
        optionOne,
        optionTwo,
        optionThree,
        optionFour,
        optionFive,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
      barrierDismissible: false,
    );
  }
  FocusNode _focus = new FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Second Route"),

        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),

            child: Center(
                child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Đăng ký võ sinh",
                    style: textstyle,
                    textAlign: TextAlign.center,
                  ),
                  TextFormField(
                    controller: fullNameController,
                    focusNode: _focus,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Vui lòng nhập họ tên!';
                      }
                      return null;
                    },
                    decoration: decoration,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: doBController,
                    autofocus: false,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                      if (value.isEmpty) {
                        return 'Vui lòng nhập năm sinh!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Năm sinh: '),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: phoneController,
                    autofocus: false,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Vui lòng nhập số điện thoaị!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Số điện thoại phụ huynh: '),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: addressController,
                    autofocus: false,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Vui lòng nhập địa chỉ!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Địa chỉ: '),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 10.0,
                  ),
                  TextFormField(
                    controller: noteController,
                    autofocus: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Ghi chú '),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text("Học phí tháng: "),
                    margin: EdgeInsets.only(top: 10.0),
                  ),
                  Container(
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            child: MultiSelectFormField(
                              autovalidate: false,
                              chipBackGroundColor: Colors.red,
                              chipLabelStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              dialogTextStyle:
                                  TextStyle(fontWeight: FontWeight.bold),
                              checkBoxActiveColor: Colors.red,
                              checkBoxCheckColor: Colors.green,
                              dialogShapeBorder: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              title: Text(
                                "Vui lòng chọn tháng.",
                                style: TextStyle(fontSize: 16),
                              ),
                              validator: (value) {
                                if (value == null || value.length == 0) {
                                  status = "Chưa có tháng nào được chọn.";
                                  return 'Chưa có tháng nào được chọn.';
                                }else{
                                  status = "";
                                }
                                return null;
                              },
                              dataSource: [
                                {
                                  "display": "Tháng 1",
                                  "value": "Tháng 1",
                                },
                                {
                                  "display": "Tháng 2",
                                  "value": "Tháng 2",
                                },
                                {
                                  "display": "Tháng 3",
                                  "value": "Tháng 3",
                                },
                                {
                                  "display": "Tháng 4",
                                  "value": "Tháng 4",
                                },
                                {
                                  "display": "Tháng 5",
                                  "value": "Tháng 5",
                                },
                                {
                                  "display": "Tháng 6",
                                  "value": "Tháng 6",
                                },
                                {
                                  "display": "Tháng 7",
                                  "value": "Tháng 7",
                                },
                                {
                                  "display": "Tháng 8",
                                  "value": "Tháng 8",
                                },
                                {
                                  "display": "Tháng 9",
                                  "value": "Tháng 9",
                                },
                                {
                                  "display": "Tháng 10",
                                  "value": "Tháng 10",
                                },
                                {
                                  "display": "Tháng 11",
                                  "value": "Tháng 11",
                                },
                                {
                                  "display": "Tháng 12",
                                  "value": "Tháng 12",
                                },
                                {
                                  "display": "Nữa tháng",
                                  "value": "Nữa tháng",
                                },
                                {
                                  "display": "Miễn phí",
                                  "value": "Miễn phí",
                                },
                              ],
                              textField: 'display',
                              valueField: 'value',
                              okButtonLabel: 'OK',
                              cancelButtonLabel: 'CANCEL',
                              hintWidget: Text('Bấm vào để chọn.'),
                              initialValue: _myActivities,
                              onSaved: (value) {
                                if (value == null) return;
                                setState(() {
                                  _myActivities = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                        // Horizontal ListView
                        height: 50.0,
                        child: Center(
                          child: ListView.builder(
                            itemCount: listCa.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                color: listCa[index].isSelect == true
                                    ? Colors.red
                                    : Colors.greenAccent,
                                margin: EdgeInsets.all(5.0),
                                child: FlatButton(
                                  child: Text(listCa[index].name.toString()),
                                  onPressed: () {
                                    _onSelected(index);
                                    print('aaaaaa:' + listCa[index].name.toString());
                                  },
                                ),
                              );
                            },
                          ),
                        )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                        // Horizontal ListView
                        height: 50.0,
                        child: Center(
                          child: ListView.builder(
                            itemCount: listCa.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(5.0),
                                child: listCa[index].isSelect ? Text(listCa[index].name + " - "+listCa[index].monthName) : new Container()

                              );
                            },
                          ),
                        )),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: SizedBox(
                      // Horizontal ListView
                        height: 50.0,
                        child: Center(
                          child: ListView.builder(
                            itemCount: colorsModelList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return colorsModelList[index].isSelect ? Stack(
                                children: [
                                  FlatButton(
                                    child: Container(
                                    width: 80.0,
                                      margin: EdgeInsets.only(top: 5.0,bottom: 5.0,left:0.0),
                                    color: colorsModelList[index].colors,
                                    child: Center(
                                      child: SizedBox(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.cyan[900],
                                          size: 30.0,
                                        ),
                                      )
                                    ),
                                  ),
                                    onPressed: () {
                                      _onSelectedColor(index);
                                    },
                                  ),

                                ],
                              ):  FlatButton(
                                child:  Container(
                                  margin: EdgeInsets.only(top: 5.0,bottom: 5.0,left:0.0),
                                  child: Container(
                                    width: 80.0,
                                    color: colorsModelList[index].colors,
                                  ),
                                ),
                                onPressed: () {
                                  _onSelectedColor(index);
                                },
                              );

                              /*Container(
                                margin: EdgeInsets.all(5.0),
                                child: Container(
                                width: 100.0,
                                  color: colorsModelList[index].colors,
                              ),
                              );*/
                              //   Container(
                              //     margin: EdgeInsets.all(5.0),
                              //     child:  Container(
                              //       width: 100.0,
                              //       color: colorsModelList[index].colors,
                              //     )
                              // );
                            },
                          ),
                        )),
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),

                    child: RaisedButton(

                      onPressed: () {
                        // Validate returns true if the form is valid, or false
                        // otherwise.
                        String jsonUser = jsonEncode(listCa);
                       // String jsoncolof = jsonEncode(colorsModelList);
                        //print("listtttttt"+jsoncolof);
                        _saveForm();
                        if(status.isNotEmpty){
                          return;
                        }

                        if (_formKey.currentState.validate()) {
                          // If the form is valid, display a Snackbar.
                          for(int i = 0; i< listCa.length;i++){
                            if(listCa[i].isSelect){
                              isListcaStt = true;
                            }
                          }
                          if(!isListcaStt){
                            return;
                          }
                          for(int i = 0; i< colorsModelList.length;i++){
                            if(colorsModelList[i].isSelect){
                              isListColorStt = true;
                            }
                          }
                          if(!isListColorStt){
                            return;
                          }
                          print('aaaaaa ' + fullNameController.text.toString());
                          _saveTodo(fullNameController.text.toString(),doBController.text.toString());
                        }
                      },
                      child: Text('Ghi danh',style: TextStyle(color: Colors.white.withOpacity(1.0)),),
                      color: Colors.blue,


                    ),
                  ),
                ],
              ),
            ))),backgroundColor: Colors.white,
    );
  }
  _saveTodo(String fullName, String dob) async {

      DatabaseHelper.instance.insertDataStudent(RegisterData(
          dob: dob,
          name: fullName,
          phone:phoneController.text.toString(),
          address: addressController.text.toString(),
          note: noteController.text.toString(),
          listHP: jsonEncode(_myActivities),
          listca: jsonEncode(listCa),
          listcolor: possion.toString(),
          time: ""
      ));
      print('save thanh cong');
  }
}


