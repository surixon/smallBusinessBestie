import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smalll_business_bestie/models/expenses_model.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';
import '../globals.dart';

class ExpensesProvider extends BaseProvider {
  double totalExpenses = 0;

  bool _isLoader = false;

  bool get isLoader => _isLoader;

  set isLoader(bool value) {
    _isLoader = value;
    notifyListeners();
  }

  Future<void> getTotalExpenses() async {
    isLoader = true;
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
      isLoader = false;
    });
  }

  List<DocumentSnapshot> expensesDocuments = [];

  String _searchText = '';

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }
}
