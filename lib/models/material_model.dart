import 'package:cloud_firestore/cloud_firestore.dart';

class MaterialModel {
  String? userId;
  String? name;
  String? cost;
  String? minQty;
  String? qtyInStock;
  String? inSoldValue;
  String? stockValue;
  Timestamp? createdAt;

  MaterialModel();

  Map<String, dynamic> toMap(MaterialModel user) {
    var data = <String, dynamic>{};
    data["userId"] = user.userId;
    data["name"] = user.name;
    data["cost"] = user.cost;
    data["minQty"] = user.minQty;
    data["qtyInStock"] = user.qtyInStock;
    data["inSoldValue"] = user.inSoldValue;
    data["stockValue"] = user.stockValue;
    data["createdAt"] = user.createdAt;
    return data;
  }

  MaterialModel.fromSnapshot(Map<String, dynamic> data) {
    userId = data["userId"];
    name = data["name"];
    cost = data["cost"];
    minQty = data["minQty"];
    qtyInStock = data["qtyInStock"];
    inSoldValue = data["inSoldValue"];
    stockValue = data["stockValue"];
    createdAt = data["createdAt"];
  }
}
