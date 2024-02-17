import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/models/income_model.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../enums/viewstate.dart';
import '../globals.dart';
import '../helpers/dialog_helper.dart';

class AddIncomeProvider extends BaseProvider {
  DateTime? _selectedDate;

  DateTime? get selectedDate => _selectedDate;

  set selectedDate(DateTime? value) {
    _selectedDate = value;
    notifyListeners();
  }

  Future<void> addIncome(BuildContext context, String title, String desc,
      String tax, String netIncome) async {
    setState(ViewState.busy);
    IncomeModel incomeModel = IncomeModel();
    incomeModel.userId = Globals.firebaseUser?.uid;
    incomeModel.date = Timestamp.fromDate(selectedDate!);
    incomeModel.title = title;
    incomeModel.desc = desc;
    incomeModel.tax = tax;
    incomeModel.netIncome = double.parse(netIncome);

    await Globals.incomeReference
        .doc()
        .set(incomeModel.toMap(incomeModel))
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
