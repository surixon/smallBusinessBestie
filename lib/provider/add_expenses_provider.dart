import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../enums/viewstate.dart';
import '../globals.dart';
import '../helpers/dialog_helper.dart';
import '../models/expenses_model.dart';

class AddExpenseProvider extends BaseProvider {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  Future<void> addExpense(
      BuildContext context, String title, String desc, String total) async {
    setState(ViewState.busy);
    ExpensesModel expensesModel = ExpensesModel();
    expensesModel.userId = Globals.firebaseUser?.uid;
    expensesModel.date = Timestamp.fromDate(selectedDate!);
    expensesModel.title = title;
    expensesModel.desc = desc;
    expensesModel.total = double.parse(total);

    await Globals.expensesReference
        .doc()
        .set(expensesModel.toMap(expensesModel))
        .then((value) {
      setState(ViewState.idle);
      DialogHelper.showMessage('successfully_added'.tr());
      context.pop(true);
    }).onError((error, stackTrace) {
      setState(ViewState.idle);
      DialogHelper.showErrorMessage(error.toString());
    });
  }

  Future<DateTime?> showDobPicker(BuildContext context) async {
    return await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime(2100));
  }
}
