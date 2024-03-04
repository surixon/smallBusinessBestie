import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../enums/viewstate.dart';
import '../globals.dart';
import '../helpers/dialog_helper.dart';
import '../models/user_model.dart';
import 'base_provider.dart';

class CreateAccountProvider extends BaseProvider {
  UserModel userModel = UserModel();

  bool _showPassword = false;

  bool get showPassword => _showPassword;

  set showPassword(bool value) {
    _showPassword = value;
    notifyListeners();
  }

  bool _showConfirmPassword = false;

  bool get showConfirmPassword => _showConfirmPassword;

  set showConfirmPassword(bool value) {
    _showConfirmPassword = value;
    notifyListeners();
  }

  Future<bool> signUp(String email, String password, String fcmToken) async {
    try {
      setState(ViewState.busy);
      await Globals.auth
          .createUserWithEmailAndPassword(email: email, password: password);
      await addUserToDB(Globals.firebaseUser?.uid, fcmToken);

      if (Globals.firebaseUser != null &&
          Globals.firebaseUser?.emailVerified == false) {
        await Globals.firebaseUser?.sendEmailVerification();
        DialogHelper.showMessage(
            '${'verification_link_has_been_sent'.tr()} $email');
      }
      await Globals.auth.signOut();
      setState(ViewState.idle);

      return true;
    } on FirebaseAuthException catch (e) {
      setState(ViewState.idle);
      if (e.code == 'weak-password') {
        DialogHelper.showErrorMessage('week_password'.tr());
      } else if (e.code == 'email-already-in-use') {
        DialogHelper.showErrorMessage('account_already_exists'.tr());
      } else {
        DialogHelper.showErrorMessage('something_wrong'.tr());
      }
      return false;
    } catch (e) {
      setState(ViewState.idle);
      DialogHelper.showErrorMessage(e.toString());
      return false;
    }
  }

  Future<void> addUserToDB(String? uid, String fcmToken) async {
    userModel.userId = uid;
    userModel.fcmToken = fcmToken;
    userModel.createdAt = Timestamp.now();
    await Globals.userReference.doc(uid).set(userModel.toMap(userModel));
  }

}
