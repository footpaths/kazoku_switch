class RegisterData {
  int id;
  String name;
  String dob;
  String phone;
  String address;
  String note;
  String listHP;
  String listcolor;
  String listca;
  static const String TABLENAME = "register";

  RegisterData(
      {this.id,
      this.name,
      this.dob,
      this.phone,
      this.address,
      this.note,
      this.listHP,
      this.listca,
      this.listcolor});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dob': dob,
      'phone': phone,
      'address': address,
      'note': note,
      'listHP': listHP,
      'listca': listca,
      'listcolor': listcolor,
    };
  }


}
