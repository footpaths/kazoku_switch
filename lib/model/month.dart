class Month {

  String nameMonth;
  bool isSelect;


  Month({this.nameMonth, this.isSelect});
  Map toJson() => {
    'nameMonth': nameMonth,
  };
  Month.fromJson(Map<String, dynamic> json): nameMonth = json['nameMonth'];
}
