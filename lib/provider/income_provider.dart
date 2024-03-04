import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

import '../globals.dart';
import '../models/income_model.dart';

class IncomeProvider extends BaseProvider {


  List<DocumentSnapshot> incomeDocuments = [];

  String _searchText = '';

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }
  double totalIncome = 0;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  set isLoader(bool value) {
    _isLoader = value;
    notifyListeners();
  }

  Future<void> getTotalIncome() async {
    isLoader = true;
    await Globals.incomeReference
        .where('userId', isEqualTo: Globals.firebaseUser?.uid)
        .get()
        .then((value) async {
      totalIncome = 0;
      await Future.forEach(value.docs, (element) {
        IncomeModel incomeModel = IncomeModel.fromSnapshot(element.data());
        totalIncome = totalIncome + incomeModel.netIncome!;
      });
      isLoader = false;
    });
  }
}
