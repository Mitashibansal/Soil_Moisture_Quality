import 'package:uia_app/models/location.dart';
import 'package:uia_app/utils/settings.dart';

import 'category.dart';

enum ServiceStatus { pending, approved, rejected }

enum ServiceType { regular, onsite }

class Service {
  int? id;
  String? name;
  String? productName;
  String? description;
  ServiceStatus? status;
  double? price;
  int? quantity;
  String? unitTitle;
  int? unitId;
  String? imageUrl;
  ServiceType? type;
  Category? category;
  String? readableLocation;
  int? distance;

  Location? location;
  int? providerId;

  Service(
      {this.id,
      this.name,
      this.productName,
      this.description,
      this.status,
      this.price,
      this.quantity,
      this.unitTitle,
      this.imageUrl,
      this.type,
      this.location});

  Service.fromMap(Map<String, dynamic> json) {
    category = Category();
    id = json['id'];
    name = json['name'];
    productName = json['product_name'];
    description = json['description'];
    status = ServiceStatus.values[json['status']];
    price = json['starting_price'];
    quantity = json['quantity'];
    unitTitle = json['unit_id'] != null
        ? Settings.units.firstWhere(
            (element) => element['id'] == json['unit_id'],
          )['title']
        : null;
    imageUrl = json['image_url'];
    type = ServiceType.values[json['is_onsite']];
    location = Location(
        latitude: json['latitude'],
        longitude: json['longitude'],
        readableLocation: json['location_readable']);

    category?.name = json['category_name'];
    category?.id = json['category_id'];
    distance = json['distance'];
    providerId = json['user_id'];
  }

  Map<String, dynamic> toJsonForCreate() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['product_name'] = productName;
    data['description'] = description;
    data['starting_price'] = price;
    data['quantity'] = quantity;
    data['unit_id'] = unitId;
    data['is_onsite'] = type?.index;
    data['image_url'] = imageUrl;
    data['latitude'] = location?.latitude;
    data['longitude'] = location?.longitude;
    data['location_readable'] = location?.readableLocation;
    return data;
  }
}
