import 'package:cloud_firestore/cloud_firestore.dart';

class ExpensesModel {
  String? userId;
  Timestamp? date;
  String? title;
  String? desc;
  double? total;
  Timestamp? createdAt;

  ExpensesModel();

  Map<String, dynamic> toMap(ExpensesModel user) {
    var data = <String, dynamic>{};
    data["userId"] = user.userId;
    data["date"] = user.date;
    data["title"] = user.title;
    data["desc"] = user.desc;
    data["total"] = user.total;
    data["createdAt"] = user.createdAt;
    return data;
  }

  ExpensesModel.fromSnapshot(Map<String, dynamic> data) {
    userId = data["userId"];
    date = data["date"];
    title = data["title"];
    desc = data["desc"];
    total = data["total"];
    createdAt = data["createdAt"];
  }
}
