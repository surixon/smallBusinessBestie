import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

class MaterialViewProvider extends BaseProvider {
  List<DocumentSnapshot> materialDocuments = [];

  String _searchText = '';

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  getInSoldValue(MaterialModel model) {
    String inSold = '';
    if (model.inSoldQty != null && model.inSoldQty != 0) {
      inSold =
          "${(double.parse(model.cost ?? '0') * (model.inSoldQty ?? 0.0)).toStringAsFixed(2)} USD";
    }

    return inSold;
  }
}
