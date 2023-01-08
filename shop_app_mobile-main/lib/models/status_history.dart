class StatusHistory {
  int? id;
  String? title;
  String? message;
  DateTime? time;

  StatusHistory({this.title, this.message, this.time});

  bool get isCompleted => time != null;

  StatusHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = id;
    data['title'] = title;
    data['time'] = time;

    return data;
  }
}
