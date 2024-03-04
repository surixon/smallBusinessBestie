import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/models/labor_cost_model.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/models/other_expenses_model.dart';
import 'package:smalll_business_bestie/models/product_model.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../enums/viewstate.dart';
import '../globals.dart';
import '../helpers/dialog_helper.dart';

class AddProductProvider extends BaseProvider {
  final roeController = TextEditingController(text: '0.000');
  final quantityController = TextEditingController(text: '3');
  final overheadController = TextEditingController(text: "10.00");
  final discountPerController = TextEditingController(text: "0");
  final profitMarginController = TextEditingController(text: "3.00");
  final hourlyRateController = TextEditingController(text: "20.00");
  final salesTaxController = TextEditingController(text: "7.00");

  String materials = "0.00";
  String laborCost = "0.00";
  String otherExpenses = "0.00";
  String overhead = "0.00";
  String discountAmount = "0.00";
  String saleTax = "0.00";
  String totalCostToMake = "0.00";

  String retailPrice = "0.00";
  String salePrice = "0.00";
  String wholesalePrice = "0.00";
  String retailProfit = "0.00";
  String saleProfit = "0.00";
  String wholesaleProfit = "0.00";

  List<MaterialModel> materialList = [];
  List<LaborCostModel> laborCostList = [];
  List<OtherExpensesModel> otherExpensesList = [];

  Map<String, dynamic>? _currency;
  Map<String, dynamic>? _currencyCovertTo;

  Map<String, dynamic>? get currency => _currency;

  set currency(Map<String, dynamic>? value) {
    _currency = value;
    notifyListeners();
  }

  Map<String, dynamic>? get currencyCovertTo => _currencyCovertTo;

  set currencyCovertTo(Map<String, dynamic>? value) {
    _currencyCovertTo = value;
    notifyListeners();
  }

  void addMaterial(MaterialModel value) {
    materialList.add(value);
    notifyListeners();
  }

  void calculateCost(String unit, MaterialModel? materialModel, int index) {
    if (unit.isEmpty) {
      materialModel?.howManyUnit = '';
      materialModel?.totalCost = '';
    } else {
      materialModel?.howManyUnit = unit;
      materialModel?.totalCost = (double.parse(materialModel.cost!) *
              double.parse(materialModel.howManyUnit!))
          .toStringAsFixed(2);
    }

    materialList[index] = materialModel!;
    materials = '0';
    for (int i = 0; i < materialList.length; i++) {
      materials =
          (double.parse(materials) + double.parse(materialList[i].totalCost!))
              .toStringAsFixed(2);
    }
    calculateOverhead();
    customNotify();
  }

  void addlaborCost() {
    laborCostList.add(LaborCostModel("", "", ""));
    notifyListeners();
  }

  void addOtherExpense() {
    otherExpensesList.add(OtherExpensesModel("", "", "", ''));
    notifyListeners();
  }

  void calculatelabor(int? index) {
    if (hourlyRateController.text.isNotEmpty &&
        laborCostList[index!].mintsToComplete.isNotEmpty) {
      laborCostList[index].laborCost =
          (double.parse(hourlyRateController.text) *
                  (double.parse(laborCostList[index].mintsToComplete) / 60))
              .toStringAsFixed(2);
    } else {
      laborCostList[index!].laborCost = '';
    }

    laborCost = '0';
    for (int i = 0; i < laborCostList.length; i++) {
      laborCost =
          (double.parse(laborCost) + double.parse(laborCostList[i].laborCost))
              .toStringAsFixed(2);
    }
    calculateOverhead();
    customNotify();
  }

  void calculateOtherExpenses(int? index) {
    if (otherExpensesList[index!].units.isNotEmpty &&
        otherExpensesList[index].cost.isNotEmpty) {
      otherExpensesList[index].totalPerExpense =
          (double.parse(otherExpensesList[index].units) *
                  (double.parse(otherExpensesList[index].cost)))
              .toStringAsFixed(2);
    } else {
      otherExpensesList[index].totalPerExpense = '';
    }

    otherExpenses = '0';
    try {
      for (int i = 0; i < otherExpensesList.length; i++) {
        otherExpenses = (double.parse(otherExpenses) +
                double.parse(otherExpensesList[i].totalPerExpense))
            .toStringAsFixed(2);
      }
    } on Exception catch (e) {
      debugPrint("Error $e");
    }

    calculateOverhead();
    customNotify();
  }

  String getRetailPrice() {
    return (double.parse(totalCostToMake) *
                double.parse(profitMarginController.text.isEmpty
                    ? '0.00'
                    : profitMarginController.text) +
            double.parse(saleTax))
        .toStringAsFixed(2);
  }

  String getSalePrice() {
    return (double.parse(getRetailPrice()) - double.parse(discountAmount))
        .toStringAsFixed(2);
  }

  String getWholesalePrice() {
    return ((double.parse(totalCostToMake) * 1.5) + double.parse(saleTax))
        .toStringAsFixed(2);
  }

  String getConvertedPrice(String value) {
    return (double.parse(value) *
            double.parse(
                roeController.text.isEmpty ? '0.00' : roeController.text))
        .toStringAsFixed(2);
  }

  String getRetailProfit() {
    return (double.parse(getRetailPrice()) - double.parse(totalCostToMake))
        .toStringAsFixed(2);
  }

  String getSaleProfit() {
    return (double.parse(getSalePrice()) - double.parse(totalCostToMake))
        .toStringAsFixed(2);
  }

  String getWholesaleProfit() {
    return (double.parse(getWholesalePrice()) - double.parse(totalCostToMake))
        .toStringAsFixed(2);
  }

  void calculateOverhead() {
    overhead = ((double.parse(materials) +
                double.parse(laborCost) +
                double.parse(otherExpenses)) *
            (double.parse(overheadController.text.isEmpty
                    ? '0.00'
                    : overheadController.text) /
                100))
        .toStringAsFixed(2);

    totalCostToMake = ((double.parse(materials) +
                double.parse(laborCost) +
                double.parse(otherExpenses) +
                double.parse(overhead)) /
            double.parse(quantityController.text.isEmpty
                ? '0.00'
                : quantityController.text))
        .toStringAsFixed(2);

    discountAmount = (double.parse(getRetailPrice()) *
            (double.parse(discountPerController.text.isEmpty
                    ? '0.00'
                    : discountPerController.text) /
                100))
        .toStringAsFixed(2);

    saleTax = (double.parse(totalCostToMake) *
            (double.parse(salesTaxController.text.isEmpty
                    ? '0.00'
                    : salesTaxController.text) /
                100))
        .toStringAsFixed(2);
  }

  Future<void> addProduct(
    BuildContext context,
    String name,
  ) async {
    setState(ViewState.busy);
    ProductModel productModel = ProductModel();

    productModel.userId = Globals.firebaseUser?.uid;
    productModel.name = name;
    productModel.createdAt = Timestamp.now();
    productModel.retailPrice = getRetailPrice();
    productModel.salePrice = getSalePrice();
    productModel.wholesalePrice = getWholesalePrice();

    await Future.forEach(materialList, (element) async {
      await Globals.materialsReference
          .doc(element.docId!)
          .get()
          .then((value) async {
        var data = value.data() as Map<String, dynamic>;
        var inSoldQty = data['inSoldQty'] ?? 0;
        inSoldQty = inSoldQty + double.parse(element.howManyUnit ?? '0');
        await Globals.materialsReference
            .doc(element.docId!)
            .update({'inSoldQty': inSoldQty});
      });
    });

    await Globals.productsReference
        .doc()
        .set(productModel.toMap(productModel))
        .then((value) {
      setState(ViewState.idle);
      DialogHelper.showMessage('successfully_added'.tr());
      context.pop();
    }).onError((error, stackTrace) {
      setState(ViewState.idle);
      DialogHelper.showErrorMessage(error.toString());
    });
  }
}
