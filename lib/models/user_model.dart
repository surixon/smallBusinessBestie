import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? userId;
  String? nickname;
  String? gender;
  String? description;
  List<dynamic>? deliveryMedia;
  String? tag;
  String? fcmToken;
  String? profile;
  String? coverPic;
  bool? isProfileCompleted;
  bool? subscription;
  Timestamp? createdAt;
  List<dynamic>? likedBy;
  List<dynamic>? blockedUser;



  UserModel();

  Map<String, dynamic> toMap(UserModel user) {
    var data = <String, dynamic>{};
    data["userId"] = user.userId;
    data["nickname"] = user.nickname;
    data["gender"] = user.gender;
    data["description"] = user.description;
    data["deliveryMedia"] = user.deliveryMedia??[];
    data["tag"] = user.tag;
    data["fcmToken"] = user.fcmToken;
    data["profile"] = user.profile;
    data["createdAt"] = user.createdAt;
    data["isProfileCompleted"] = user.isProfileCompleted;
    data["subscription"] = user.subscription;
    data["blockedUser"] = user.blockedUser;
    data["coverPic"] = user.coverPic;
    return data;
  }

  UserModel.fromSnapshot(Map<String, dynamic> data) {
    nickname = data["nickname"];
    userId = data["userId"];
    gender = data["gender"];
    description = data["description"];
    tag = data["tag"];
    deliveryMedia = data["deliveryMedia"];
    fcmToken = data["fcmToken"];
    profile = data["profile"];
    coverPic = data["coverPic"];
    createdAt = data["createdAt"];
    isProfileCompleted = data["isProfileCompleted"];
    subscription = data["subscription"];
    likedBy = data["likedBy"]??[];
    blockedUser = data["blockedUser"]??[];
  }
}
