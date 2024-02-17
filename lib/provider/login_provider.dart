import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../enums/viewstate.dart';
import '../globals.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/shared_pref.dart';
import '../models/user_model.dart';
import '../routes.dart';
import 'base_provider.dart';

class LoginProvider extends BaseProvider {
  bool _showPassword = false;

  bool get showPassword => _showPassword;

  set showPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  Future<void> login(BuildContext context, String email, String password,
      String fcmToken) async {
    setState(ViewState.busy);
    try {
      await Globals.auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        if (!user.user!.emailVerified) {
          DialogHelper.showErrorMessage('verify_your_email'.tr());
          setState(ViewState.idle);
        } else {
          await getUser(context, user.user?.uid, fcmToken);
        }
      });
    } on FirebaseAuthException catch (e) {
      debugPrint("FirebaseAuthException ${e.code}");
      debugPrint("FirebaseAuthException ${e.message}");
      setState(ViewState.idle);
      if (e.code == 'user-not-found') {
        DialogHelper.showErrorMessage('no_user_found'.tr());
      } else if (e.code == 'invalid-credential') {
        DialogHelper.showErrorMessage('invalid_credential'.tr());
      } else if (e.code == 'wrong-password') {
        DialogHelper.showErrorMessage('wrong_password'.tr());
      } else {
        DialogHelper.showErrorMessage('something_wrong'.tr());
      }
    }
  }

  Future<void> getUser(
      BuildContext context, String? userId, String fcmToken) async {
    await Globals.userReference.doc(userId).get().then((value) async {
      if (value.exists) {
        Map<String, dynamic>? data = value.data();
        var user = UserModel.fromSnapshot(data!);
        debugPrint("isCompleted ${user.isProfileCompleted}");
        await updateFcmToken(userId, fcmToken).then((value) {
          SharedPref.prefs?.setBool(SharedPref.isLoggedIn, true);
          context.go(AppPaths.dashboard);
        });

        setState(ViewState.idle);
      }
    });
  }

  Future<void> updateFcmToken(String? userId, String? fcmToken) async {
    Map<String, dynamic> data = {'fcmToken': fcmToken};
    await Globals.userReference.doc(userId).update(data);
  }
}
