import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smalll_business_bestie/provider/base_provider.dart';

class ProductsViewProvider extends BaseProvider{


  List<DocumentSnapshot> productDocuments = [];

  String _searchText = '';

  String get searchText => _searchText;

  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }
}