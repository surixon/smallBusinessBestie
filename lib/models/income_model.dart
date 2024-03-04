import 'package:cloud_firestore/cloud_firestore.dart';

class IncomeModel {
  String? docId;
  String? userId;
  Timestamp? date;
  String? title;
  String? desc;
  String? tax;
  double? netIncome;
  Timestamp? createdAt;

  IncomeModel();

  Map<String, dynamic> toMap(IncomeModel user) {
    var data = <String, dynamic>{};
    data["userId"] = user.userId;
    data["date"] = user.date;
    data["title"] = user.title;
    data["desc"] = user.desc;
    data["tax"] = user.tax;
    data["netIncome"] = user.netIncome;
    data["createdAt"] = user.createdAt;
    return data;
  }

  IncomeModel.fromSnapshot(Map<String, dynamic> data) {
    userId = data["userId"];
    date = data["date"];
    title = data["title"];
    desc = data["desc"];
    tax = data["tax"];
    netIncome = data["netIncome"];
    createdAt = data["createdAt"];
  }
}
