import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:smalll_business_bestie/constants/colors_constants.dart';
import 'package:smalll_business_bestie/routes.dart';
import 'package:smalll_business_bestie/widgets/image_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/image_constants.dart';
import '../constants/string_constants.dart';
import '../globals.dart';
import '../models/app_data_singleton_model.dart';
import 'decoration.dart';

class CommonFunction {
  static PreferredSizeWidget appBar(
    String title,
    BuildContext context, {
    bool showBack = false,
    bool showSave = false,
    VoidCallback? onBackPress,
    VoidCallback? onSavePress,
  }) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      leading: showBack
          ? GestureDetector(
              onTap: onBackPress,
              child: Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                  color: kBlackColor,
                ),
              ),
            )
          : Container(),
      title: Text(
        title,
        style: ViewDecoration.textStyleBold(kBlackColor, 16.sp),
      ),
      centerTitle: true,
      actions: [
        showSave
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
                child: SizedBox(
                  height: 36.h,
                  child: TextButton(
                      onPressed: onSavePress,
                      child: Text(
                        'save'.tr(),
                        style: ViewDecoration.textStyleMedium(
                            Theme.of(context).primaryColor, 14.sp),
                      )),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  static PreferredSizeWidget appBarWithButtons(
    String title,
    BuildContext context, {
    bool showBack = false,
    bool showAdd = false,
    bool showSetting = false,
    VoidCallback? onBackPress,
    VoidCallback? onAddPress,
    VoidCallback? onSettingPress,
  }) {
    return AppBar(
      elevation: 1,
      backgroundColor: Theme.of(context).primaryColor,
      leading: showBack
          ? GestureDetector(
              onTap: onBackPress,
              child: Padding(
                padding: EdgeInsets.only(top: 12.h, bottom: 12.h),
                child: const Icon(
                  Icons.arrow_back_ios,
                  size: 24,
                  color: kWhiteColor,
                ),
              ),
            )
          : Container(),
      title: Text(
        title,
        style: ViewDecoration.textStyleBoldPoppins(kWhiteColor, 24.sp),
      ),
      centerTitle: true,
      actions: [
        showAdd
            ? GestureDetector(
                onTap: onAddPress,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  child: ImageView(
                    path: addIcon,
                    width: 32.w,
                    height: 32.w,
                  ),
                ),
              )
            : const SizedBox(),
        showSetting
            ? GestureDetector(
                onTap: onSettingPress,
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  child: Icon(
                    Icons.settings,
                    size: 32.w,
                  ),
                ),
              )
            : const SizedBox()
      ],
    );
  }

  static Future<void> openUrl(String url, {LaunchMode? launchMode}) async {
    if (!await launchUrl(Uri.parse(url),
        mode: launchMode ?? LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  static String getDateFromTimeStamp(DateTime date, String format) {
    return DateFormat(format, 'en').format(date).toString();
  }

  static Future<void> checkSubscription(BuildContext context) async {
    try {
      await Purchases.getCustomerInfo().then((customerInfo) {
        if (customerInfo.entitlements.all[kPremium] != null &&
            customerInfo.entitlements.all[kPremium]!.isActive) {
          appData.entitlementIsActive = true;
        } else {
          appData.entitlementIsActive = false;
        }
      }).then((value) async {
        await updateSubscription();
      });
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      debugPrint("Error fetching purchaser info ${e.message}");
    }
  }

  static Future<void> updateSubscription() async {
    Map<String, dynamic> data = {'subscription': appData.entitlementIsActive};
    await Globals.userReference.doc(Globals.firebaseUser?.uid).update(data);
  }
}
