import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/enums/viewstate.dart';
import 'package:smalll_business_bestie/helpers/dialog_helper.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../globals.dart';

class AddMaterialProvider extends BaseProvider {
  final nameController = TextEditingController();
  final costController = TextEditingController();
  final minQuantityController = TextEditingController();
  final quantityInStockController = TextEditingController();

  MaterialModel? materialModel;

  String _inSold = '';
  String _stockValue = '';
  String _stockStatusString = '';
  int stockStatus = 0;

  String get inSold => _inSold;

  set inSold(String value) {
    _inSold = value;
    notifyListeners();
  }

  String get stockValue => _stockValue;

  set stockValue(String value) {
    _stockValue = value;
    notifyListeners();
  }

  String get stockStatusString => _stockStatusString;

  set stockStatusString(String value) {
    _stockStatusString = value;
    notifyListeners();
  }

  Future<void> addMaterial(
    BuildContext context,
  ) async {
    setState(ViewState.busy);
    MaterialModel model = MaterialModel();
    model.userId = Globals.firebaseUser?.uid;
    model.name = nameController.text;
    model.minQty = minQuantityController.text;
    model.qtyInStock = quantityInStockController.text;
    model.inSoldValue = inSold;
    model.stockValue = stockValue;
    model.stockStatus = stockStatus;
    model.stockStatusString = stockStatusString;
    model.cost = costController.text;
    model.createdAt= Timestamp.now();

    if (materialModel != null) {
      await Globals.materialsReference
          .doc(materialModel!.docId!)
          .update(model.toMap(model))
          .then((value) {
        setState(ViewState.idle);
        DialogHelper.showMessage('successfully_added'.tr());
        context.pop();
      }).onError((error, stackTrace) {
        setState(ViewState.idle);
        DialogHelper.showErrorMessage(error.toString());
      });
    } else {
      await Globals.materialsReference
          .doc()
          .set(model.toMap(model))
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

  void getStockStatus() {
    //=IF([@[Product Cost]]="","",IF([@[Qty In Stock]]=0,"Out of Stock",IF([@[Qty In Stock]]<=[@[Min Qty]],"Re-Stock Req'd","Stock Level OK")))
    if (costController.text.isEmpty) {
      stockStatusString = '';
    } else if (quantityInStockController.text == '0' ||
        quantityInStockController.text.isEmpty) {
      stockStatusString = 'Out of Stock';
      stockStatus = 0;
    } else if (quantityInStockController.text.isNotEmpty &&
        minQuantityController.text.isNotEmpty &&
        double.parse(quantityInStockController.text) <=
            double.parse(minQuantityController.text)) {
      stockStatusString = 'Re-Stock Req\'d';
      stockStatus = 2;
    } else {
      stockStatusString = 'Stock Level OK';
      stockStatus = 1;
    }
  }

  void getStockValue() {
    //=[@[Qty In Stock]]*[@[Product Cost]]
    if (costController.text.isEmpty) {
      stockValue = '';
    } else if (quantityInStockController.text.isNotEmpty &&
        costController.text.isNotEmpty) {
      stockValue =
          "${double.parse(quantityInStockController.text) * double.parse(costController.text)}";
    }
  }

  void setData(MaterialModel? model) {
    if (model != null) {
      materialModel = model;
      nameController.text = model.name ?? '';
      costController.text = model.cost ?? '';
      minQuantityController.text = model.minQty ?? '';
      quantityInStockController.text = model.qtyInStock ?? '';

      if (model.inSoldQty != null && model.inSoldQty != 0) {
        inSold = (double.parse(model.cost ?? '0') * (model.inSoldQty ?? 0.0))
            .toString();
      }

      getStockStatus();
      getStockValue();
    }
  }
}
