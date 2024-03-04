import 'package:smalll_business_bestie/enums/viewstate.dart';
import 'package:smalll_business_bestie/models/expenses_model.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../globals.dart';
import '../models/income_data_model.dart';
import '../models/income_model.dart';

class HomeProvider extends BaseProvider {
  double totalIncome = 0;
  double totalExpenses = 0;
  double totalInventory = 0;
  double totalProfit = 0;

  DateTime dateTime = DateTime.now();

  List<IncomeModel> incomeList = [];

  List<IncomeData> data = [];

  String _inventoryStatus = '1';

  String get inventoryStatus => _inventoryStatus;

  set inventoryStatus(String value) {
    _inventoryStatus = value;
    notifyListeners();
  }

  Future<void> getTotalIncome() async {
    setState(ViewState.busy);

    await Globals.incomeReference
        .where('userId', isEqualTo: Globals.firebaseUser?.uid)
        .get()
        .then((value) async {
      totalIncome = 0;
      await Future.forEach(value.docs, (element) {
        IncomeModel incomeModel = IncomeModel.fromSnapshot(element.data());
        totalIncome = totalIncome + incomeModel.netIncome!;
        incomeList.add(incomeModel);
      });
    });

    for (int i = 1; i <= 4; i++) {
      var quarterlyIncome = 0.0;
      if (i == 1) {
        incomeList
            .where((element) =>
                element.date!.toDate().year == dateTime.year &&
                element.date!.toDate().month <= 3)
            .toList()
            .forEach((element) {
          quarterlyIncome = quarterlyIncome + element.netIncome!;
        });
      } else if (i == 2) {
        incomeList
            .where((element) =>
                element.date!.toDate().year == dateTime.year &&
                element.date!.toDate().month > 3 &&
                element.date!.toDate().month <= 6)
            .toList()
            .forEach((element) {
          quarterlyIncome = quarterlyIncome + element.netIncome!;
        });
      } else if (i == 3) {
        incomeList
            .where((element) =>
                element.date!.toDate().year == dateTime.year &&
                element.date!.toDate().month > 6 &&
                element.date!.toDate().month <= 9)
            .toList()
            .forEach((element) {
          quarterlyIncome = quarterlyIncome + element.netIncome!;
        });
      } else if (i == 4) {
        incomeList
            .where((element) =>
                element.date!.toDate().year == dateTime.year &&
                element.date!.toDate().month > 9 &&
                element.date!.toDate().month <= 12)
            .toList()
            .forEach((element) {
          quarterlyIncome = quarterlyIncome + element.netIncome!;
        });
      }

      data.add(IncomeData('Qtr $i', quarterlyIncome));
    }

    await Globals.expensesReference
        .where('userId', isEqualTo: Globals.firebaseUser?.uid)
        .get()
        .then((value) async {
      totalExpenses = 0;
      await Future.forEach(value.docs, (element) {
        ExpensesModel expensesModel =
            ExpensesModel.fromSnapshot(element.data());
        totalExpenses = totalExpenses + expensesModel.total!;
      });
    });

    await Globals.materialsReference
        .where('userId', isEqualTo: Globals.firebaseUser?.uid)
        .get()
        .then((value) async {
      totalInventory = 0;
      await Future.forEach(value.docs, (element) {
        MaterialModel materialModel =
            MaterialModel.fromSnapshot(element.data());
        totalInventory = totalInventory + double.parse(materialModel.cost!);
      });
    });

    totalProfit = totalIncome - totalExpenses;

    setState(ViewState.idle);
  }
}
