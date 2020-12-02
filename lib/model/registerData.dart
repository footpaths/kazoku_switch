class RegisterData {
  int id;
  String name;
  String dob;
  String phone;
  String phone2;
  String address;
  String note;
  String listHP;
  String listcolor;
  String listca;
  String time;
  static const String TABLENAME = "register";

  RegisterData(
      {this.id,
      this.name,
      this.dob,
      this.phone,
      this.phone2,
      this.address,
      this.note,
      this.listHP,
      this.listca,
      this.listcolor,
        this.time});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'phone': phone,
      'phone2': phone2,
      'address': address,
      'note': note,
      'listHP': listHP,
      'listca': listca,
      'listcolor': listcolor,
      'time': time,
    };
  }


}
