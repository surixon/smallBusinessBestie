import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../enums/viewstate.dart';
import '../globals.dart';
import '../helpers/dialog_helper.dart';
import 'base_provider.dart';

class ForgotPasswordProvider extends BaseProvider{


  Future<bool> resetPassword( String email) async {
    try {
      setState(ViewState.busy);
      await Globals.auth.sendPasswordResetEmail(email: email);
      setState(ViewState.idle);
      DialogHelper.showMessage( 'emailSent'.tr());
      return true;
    } on FirebaseAuthException catch (e) {
      setState(ViewState.idle);
      DialogHelper.showErrorMessage( e.message ?? '');
      return false;
    }
  }

}