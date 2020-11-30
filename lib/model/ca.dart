import 'package:kazoku_switch/model/month.dart';

class Ca {

  String name;
  bool isSelect;
  String monthName;

  Ca({this.name, this.isSelect,this.monthName});
  Map toJson() => {
    'name': name,
    'isSelect': isSelect,
    'monthName': monthName,
  };
  Ca.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        isSelect = json['isSelect'],
        monthName = json['monthName'];

}
