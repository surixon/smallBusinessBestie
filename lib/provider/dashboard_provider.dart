import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smalll_business_bestie/enums/viewstate.dart';
import 'package:smalll_business_bestie/view/expenses_view.dart';
import 'package:smalll_business_bestie/view/home_view.dart';
import 'package:smalll_business_bestie/view/income_view.dart';
import 'package:smalll_business_bestie/view/inventory_view.dart';
import 'package:smalll_business_bestie/view/products_view.dart';
import '../constants/string_constants.dart';
import '../globals.dart';
import '../models/app_data_singleton_model.dart';
import '../routes.dart';
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

  Future<void> initPlatformState() async {
    await Purchases.setLogLevel(LogLevel.debug);

    PurchasesConfiguration? configuration;
    if (Platform.isAndroid) {
      configuration = PurchasesConfiguration(kPublicAndroidSdkKey)
        ..appUserID = Globals.firebaseUser?.uid;
    } else if (Platform.isIOS) {
      configuration = PurchasesConfiguration(kPublicIosSdkKey)
        ..appUserID = Globals.firebaseUser?.uid;
    }
    await Purchases.configure(configuration!);
  }

  Future<void> checkSubscription(BuildContext context) async {
    try {
      await Purchases.getCustomerInfo().then((customerInfo) {
        if (customerInfo.entitlements.all[kPremium] != null &&
            customerInfo.entitlements.all[kPremium]!.isActive) {
          appData.entitlementIsActive = true;
        } else {
          appData.entitlementIsActive = false;
          context
              .pushNamed(AppPaths.subscription, extra: {'disableBack': true});
        }

        debugPrint("SUBSCRIPTION ${appData.entitlementIsActive}");
      }).then((value) async {
        await updateSubscription();
      });
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      debugPrint("Error fetching purchaser info ${e.message}");
    }
  }

  Future<void> updateSubscription() async {
    Map<String, dynamic> data = {'subscription': appData.entitlementIsActive};
    await Globals.userReference.doc(Globals.firebaseUser?.uid).update(data);
  }
}
