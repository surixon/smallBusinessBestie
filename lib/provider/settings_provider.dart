import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/enums/viewstate.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../dialog/withdraw_dialog.dart';
import '../globals.dart';
import '../helpers/dialog_helper.dart';
import '../helpers/shared_pref.dart';
import '../routes.dart';

class SettingsProvider extends BaseProvider {
  List<String> list = ['Clear Data', 'Delete Account', 'Logout'];

  void logout(BuildContext context) {
    DialogHelper.showDialogWithTwoButtons(
        context, "Confirm", "No", "Logout", "Are you sure want to logout?",
        positiveButtonPress: () async {
      Globals.auth.signOut();
      SharedPref.prefs?.clear();
      context.go(AppPaths.login);
    }, negativeButtonPress: () {
      context.pop();
    });
  }

  void showDelete(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const WithdrawDialog(
                description: "Are you sure you want delete account?",
              ),
            )).then((value) async {
      if (value != null && value) {
        await deleteAccount().then((value) {
          SharedPref.prefs?.clear();
          context.go(AppPaths.login);
        });
      }
    });
  }

  void clearData(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: const WithdrawDialog(
                description: "Are you sure you want clear data?",
              ),
            )).then((value) async {
      if (value != null && value) {
        await clear().then((value) {
          DialogHelper.showMessage("Data deleted successfully");
        });
      }
    });
  }

  Future<void> deleteAccount() async {
    Map<String, dynamic> data = {'isDeleted': true};
    await Globals.userReference.doc(Globals.firebaseUser?.uid).update(data);
    await Globals.deletedUsersReference
        .doc(Globals.firebaseUser?.uid)
        .set({"deletedAt": DateTime.now()});
  }

  Future<void> clear() async {
    setState(ViewState.busy);
    await Globals.productsReference
        .where('userId', isEqualTo: Globals.firebaseUser?.uid)
        .get()
        .then((value) async {
      await Future.forEach(value.docs, (element) async {
        await Globals.productsReference.doc(element.id).delete();
      });
    });

    await Globals.incomeReference
        .where('userId', isEqualTo: Globals.firebaseUser?.uid)
        .get()
        .then((value) async {
      await Future.forEach(value.docs, (element) async {
        await Globals.incomeReference.doc(element.id).delete();
      });
    });

    await Globals.expensesReference
        .where('userId', isEqualTo: Globals.firebaseUser?.uid)
        .get()
        .then((value) async {
      await Future.forEach(value.docs, (element) async {
        await Globals.expensesReference.doc(element.id).delete();
      });
    });

    setState(ViewState.idle);
  }
}
