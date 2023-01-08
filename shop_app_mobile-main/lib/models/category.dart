class Category {
  int? id;
  String? name;
  String? description;
  String? imageUrl;
  int? totalCount = 0;
  int? nearbyCount = 0;
  int? onlineCount = 0;

  Category(
      {this.id,
      this.name,
      // this.shortTitle,
      this.imageUrl,
      this.totalCount,
      this.nearbyCount,
      this.onlineCount});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
    description = json['description'];
    totalCount = json['total_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['description'] = description;
    data['imageUrl'] = imageUrl;
    data['id'] = id;
    return data;
  }
}
