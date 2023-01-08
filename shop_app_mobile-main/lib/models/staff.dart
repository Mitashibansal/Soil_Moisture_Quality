class Staff {
  int? id;
  String? name;
  String? phone;

  Staff({this.id, this.name, this.phone});

  Staff.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['name'] = name;
    data['phone'] = phone;
    return data;
  }
}
