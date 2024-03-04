import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';


import '../globals.dart';
import '../helpers/shared_pref.dart';
import '../models/user_model.dart';
import '../routes.dart';
import 'base_provider.dart';

class AccountReInStateProvider extends BaseProvider {

  Future<void> navigateToHome(
      BuildContext context, UserModel model, String fcmToken) async {
    await updateFcmToken(model.userId, fcmToken).then((value) {
      SharedPref.prefs?.setBool(SharedPref.isLoggedIn, true);
      Globals.navigatorKey.currentContext!.pop();
      Globals.navigatorKey.currentContext!.go(AppPaths.dashboard);
    });
  }

  Future<void> updateFcmToken(String? userId, String? fcmToken) async {
    Map<String, dynamic> data = { 'isDeleted': false};
    await Globals.userReference.doc(userId).update(data);
    await Globals.deletedUsersReference.doc(userId).delete();
  }

}
