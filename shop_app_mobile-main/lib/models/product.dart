import 'package:uia_app/models/location.dart';
import 'package:uia_app/utils/settings.dart';

import 'category.dart';

class Product {
  int? id;
  String? name;
  String? description;
  double? price;
  String? imageUrl;
  Category? category;

  int? quantity;

  Product(
      {this.id,
      this.name,
      this.description,
      this.price,
      this.imageUrl,
      this.quantity});

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    price = json['price'];
    imageUrl = json['imageUrl'];
    id = json['id'];
    // createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['description'] = description;
    data['price'] = price;
    data['imageUrl'] = imageUrl;
    data['id'] = id;
    return data;
  }
}
