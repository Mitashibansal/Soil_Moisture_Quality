import 'package:uia_app/models/location.dart';
import 'package:uia_app/models/service.dart';
import 'package:uia_app/utils/settings.dart';

import 'category.dart';

class Requirement {
  int? id;
  Service? service;

  String? requirementDetails;

  List<String>? imageUrls = [];

  Location? location;

  Requirement({
    this.id,
    this.requirementDetails,
    this.imageUrls,
  });

  Requirement.fromMap(Map<String, dynamic> json) {
    // category = Category();
    // id = json['id'];
    // name = json['name'];
    // productName = json['product_name'];
    // description = json['description'];
    // status = ServiceStatus.values[json['status']];
    // price = json['starting_price'];
    // quantity = json['quantity'];
    // unitTitle = json['unit_id'] != null
    //     ? Settings.units.firstWhere(
    //         (element) => element['id'] == json['unit_id'],
    //       )['title']
    //     : null;
    // imageUrl = json['image_url'];
    // type = ServiceType.values[json['is_onsite']];
    // latitude = json['latitude'];
    // longitude = json['longitude'];
    // readableLocation = json['location_readable'];
    // category?.title = json['category_name'];
    // category?.id = json['category_id'];
    // distance = json['distance'];
  }

  Map<String, dynamic> toJsonForCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['service_id'] = service?.id;
    data['requirement_details'] = requirementDetails;
    data['images'] = imageUrls;

    data['latitude'] = location?.latitude;
    data['longitude'] = location?.longitude;
    data['location_readable'] = location?.readableLocation;
    return data;
  }
}
