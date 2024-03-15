import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smalll_business_bestie/helpers/dialog_helper.dart';
import 'package:smalll_business_bestie/routes.dart';
import '../constants/string_constants.dart';
import '../enums/viewstate.dart';
import '../models/app_data_singleton_model.dart';
import 'base_provider.dart';

class SubscriptionProvider extends BaseProvider {
  List<Package> packageList = [];
  List<Package> introductoryList = [];
  List<String> productIds = [];

  int _subscriptionPlan = 0;

  bool _loader = false;

  bool _restoreLoader = false;

  bool get restoreLoader => _restoreLoader;

  set restoreLoader(bool value) {
    _restoreLoader = value;
    notifyListeners();
  }

  bool get loader => _loader;

  set loader(bool value) {
    _loader = value;
    notifyListeners();
  }

  int get subscriptionPlan => _subscriptionPlan;

  set subscriptionPlan(int value) {
    _subscriptionPlan = value;
    notifyListeners();
  }

  Future<void> loadProduct() async {
    try {
      loader = true;
      Offerings offerings = await Purchases.getOfferings();

      if (offerings.current != null &&
          offerings.current!.availablePackages.isNotEmpty) {
        packageList = offerings.current!.availablePackages;
      }
      await Future.forEach(packageList, (Package package) {
        print('identifier ${package.packageType.name}');
        productIds.add(package.storeProduct.identifier);
      });
      if (Platform.isIOS) {
        await checkFreeTrialEligibility();
      } else {
        await checkFreeTrialEligibilityAndroid(packageList[0]);
      }
      loader = false;
    } on PlatformException catch (e) {
      loader = false;
      print(e.message);
    }
  }

  Future<void> makePurchase(
    BuildContext context,
  ) async {
    try {
      setState(ViewState.busy);
      Package selectedPackage;
      if (subscriptionPlan == 0) {
        selectedPackage = packageList
            .where((element) => element.packageType == PackageType.annual)
            .first;
      } else {
        selectedPackage = packageList
            .where((element) => element.packageType == PackageType.monthly)
            .first;
      }
      await Purchases.purchasePackage(selectedPackage).then((purchaserInfo) {
        setState(ViewState.idle);
        if (purchaserInfo.entitlements.all[kPremium]!.isActive) {
          appData.entitlementIsActive = true;

          context.pop();
        } else {
          appData.entitlementIsActive = false;
          DialogHelper.showErrorMessage("Something went wrong!");
        }
      });
    } on PlatformException catch (e) {
      setState(ViewState.idle);
      var errorCode = PurchasesErrorHelper.getErrorCode(e);
      if (errorCode == PurchasesErrorCode.productAlreadyPurchasedError) {
      } else if (errorCode == PurchasesErrorCode.purchaseCancelledError) {
      } else {
        DialogHelper.showErrorMessage(e.message ?? '');
      }
    }
  }

  Future<void> restorePurchase(BuildContext context) async {
    try {
      restoreLoader = true;
      await Purchases.restorePurchases().then((restoredInfo) {
        restoreLoader = false;
        if (restoredInfo.activeSubscriptions.isNotEmpty) {
          appData.entitlementIsActive = true;

          context.pop();
        } else {
          DialogHelper.showErrorMessage('no_subscription'.tr());
        }
      });
    } on PlatformException catch (e) {
      restoreLoader = false;
      print("Restore ${e.message}");
      DialogHelper.showErrorMessage(e.message ?? '');
    }
  }

  Future<void> checkFreeTrialEligibilityAndroid(Package package) async {
    try {
      CustomerInfo customerInfo = await Purchases.getCustomerInfo();
      if (customerInfo.entitlements.all.isNotEmpty) {
        // user has had access to an entitlement which means they're not eligible for the offer
        // remove offer messaging
      } else {
        // user has never had access to any entitlements
        // show intro offer
        introductoryList.add(package);
      }
    } on PlatformException catch (e) {
      // Error fetching purchaser info
    }
  }

  Future<void> checkFreeTrialEligibility() async {
    Map<String, IntroEligibility?>? introEligibilityData =
        await Purchases.checkTrialOrIntroductoryPriceEligibility(productIds);

    introEligibilityData.forEach((key, value) {
      if (value?.status ==
          IntroEligibilityStatus.introEligibilityStatusEligible) {
        introductoryList.addAll(packageList
            .where((element) => element.storeProduct.identifier == key));
      }
    });
  }
}
