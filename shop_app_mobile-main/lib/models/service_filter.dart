import 'package:uia_app/models/category.dart';
import 'package:uia_app/models/location.dart';

class ServiceFilter {
  Category? category;
  String? search_term;
  Location? location;

  ServiceFilter({
    this.category,
    this.search_term,
    this.location,
  });

  // Category.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   title = json['title'];
  //   shortTitle = json['shortTitle'];
  //   thumbnail = json['thumbnail'];
  //   totalCount = json['totalCount'];
  //   nearbyCount = json['nearbyCount'];
  //   onlineCount = json['onlineCount'];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['latitude'] = location?.latitude;
    data['longitude'] = location?.longitude;
    data['category_id'] = category?.id;
    data['search_term'] = search_term;
    return data;
  }
}
