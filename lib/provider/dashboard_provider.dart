import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:smalll_business_bestie/view/expenses_view.dart';
import 'package:smalll_business_bestie/view/home_view.dart';
import 'package:smalll_business_bestie/view/income_view.dart';
import 'package:smalll_business_bestie/view/inventory_view.dart';
import 'package:smalll_business_bestie/view/products_view.dart';
import 'base_provider.dart';

class DashboardProvider extends BaseProvider {
  final List<Widget> widgetList = <Widget>[
    const InventoryView(),
    const ProductsView(),
    const IncomeView(),
    const ExpensesView(),
    const HomeView(),
  ];

  int _selectedIndex = 4;

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    _selectedIndex = value;
    notifyListeners();
  }

  Future<bool> setHome(context, DashboardProvider provider) async {
    provider.selectedIndex = 0;
    return false;
  }
}
