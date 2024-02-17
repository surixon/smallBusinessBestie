import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/enums/viewstate.dart';
import 'package:smalll_business_bestie/helpers/dialog_helper.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../globals.dart';

class AddMaterialProvider extends BaseProvider {
  Future<void> addMaterial(
      BuildContext context,
      String name,
      String cost,
      String minQty,
      String qtyInStock,
      String inSold,
      String stockValue) async {
    setState(ViewState.busy);
    MaterialModel materialModel = MaterialModel();
    materialModel.userId = Globals.firebaseUser?.uid;
    materialModel.name = name;
    materialModel.minQty = minQty;
    materialModel.qtyInStock = qtyInStock;
    materialModel.inSoldValue = inSold;
    materialModel.stockValue = stockValue;
    materialModel.cost = cost;

    await Globals.materialsReference
        .doc()
        .set(materialModel.toMap(materialModel))
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
