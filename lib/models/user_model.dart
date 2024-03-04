import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? nickname;
  String? description;
  String? fcmToken;
  String? profile;
  bool? isDeleted;
  Timestamp? createdAt;
  List<dynamic>? likedBy;
  List<dynamic>? blockedUser;

  UserModel();

  Map<String, dynamic> toMap(UserModel user) {
    var data = <String, dynamic>{};
    data["userId"] = user.userId;
    data["nickname"] = user.nickname;
    data["description"] = user.description;
    data["fcmToken"] = user.fcmToken;
    data["profile"] = user.profile;
    data["createdAt"] = user.createdAt;
    data["isDeleted"] = user.isDeleted;
    data["blockedUser"] = user.blockedUser;
    return data;
  }

  UserModel.fromSnapshot(Map<String, dynamic> data) {
    nickname = data["nickname"];
    userId = data["userId"];
    isDeleted = data["isDeleted"];
    description = data["description"];
    fcmToken = data["fcmToken"];
    profile = data["profile"];
    createdAt = data["createdAt"];
    likedBy = data["likedBy"] ?? [];
    blockedUser = data["blockedUser"] ?? [];
  }
}
