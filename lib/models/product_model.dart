import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  String? userId;
  String? docId;
  String? name;
  String? wholesalePrice;
  String? salePrice;
  String? retailPrice;
  Timestamp? createdAt;

  ProductModel();

  Map<String, dynamic> toMap(ProductModel user) {
    var data = <String, dynamic>{};
    data["userId"] = user.userId;
    data["name"] = user.name;
    data["wholesalePrice"] = user.wholesalePrice;
    data["salePrice"] = user.salePrice;
    data["retailPrice"] = user.retailPrice;
    data["createdAt"] = user.createdAt;
    return data;
  }

  ProductModel.fromSnapshot(Map<String, dynamic> data) {
    userId = data["userId"];
    name = data["name"];
    wholesalePrice = data["wholesalePrice"];
    salePrice = data["salePrice"];
    retailPrice = data["retailPrice"];
    createdAt = data["createdAt"];
  }
}
