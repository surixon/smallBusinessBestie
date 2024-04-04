import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../constants/colors_constants.dart';
import '../constants/image_constants.dart';
import '../constants/string_constants.dart';
import '../enums/viewstate.dart';
import '../globals.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../helpers/shared_pref.dart';
import '../provider/subscription_provider.dart';
import '../routes.dart';
import '../widgets/image_view.dart';
import '../widgets/primary_button.dart';
import '../widgets/round_corner_shape.dart';
import 'base_view.dart';

class SubscriptionView extends StatelessWidget {
  final bool? isBackDisabled;

  const SubscriptionView({Key? key, this.isBackDisabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<SubscriptionProvider>(
        onModelReady: (provider) async {
          await provider.loadProduct();
        },
        builder: (context, provider, _) => PopScope(
              canPop: isBackDisabled == null,
              child: Scaffold(
                extendBodyBehindAppBar: true,
                appBar: CommonFunction.appBarWithButtons(
                    'Subscription', context,
                    showClose: isBackDisabled != null,
                    showBack: isBackDisabled == null, onBackPress: () {
                  if (isBackDisabled == null) {
                    context.pop();
                  } else {
                    Globals.auth.signOut();
                    SharedPref.prefs?.clear();
                    context.go(AppPaths.login);
                  }
                }),
                body: Container(
                  child: provider.loader
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: kOrangeColor,
                          ),
                        )
                      : Stack(
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 115.h,
                                  ),
                                  Text(
                                    'Premium features',
                                    style: ViewDecoration.textStyleBold(
                                        kBlackColor, 22.sp),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 19.h),
                                    child: const ImageView(
                                      path: subscription,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.w),
                                    child: Column(
                                      children: [
                                        featureItem(
                                            'With your subscription you get access to the entire app free for first 3 days. After the 3 days it will charge the monthly at ${provider.packageList.firstWhere((element) => element.packageType.name == 'monthly').storeProduct.priceString} or annually at ${provider.packageList.firstWhere((element) => element.packageType.name == 'annual').storeProduct.priceString}. You are free to cancel at any time.'),
                                        SizedBox(
                                          height: 24.h,
                                        ),
                                        provider.introductoryList.isNotEmpty
                                            ? Text(
                                                'Try it now for free for 3 day',
                                                style: ViewDecoration
                                                    .textStyleBold(
                                                        kBlackColor, 18.sp),
                                              )
                                            : const SizedBox(),
                                        SizedBox(
                                          height: 24.h,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  provider.subscriptionPlan = 0;
                                                },
                                                child: RoundCornerShape(
                                                  strokeColor:
                                                      provider.subscriptionPlan ==
                                                              0
                                                          ? kOrangeColor
                                                          : kDarkGrey,
                                                  radius: 10.r,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                        16.0, 16.0, 16.0, 20.0),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '12 months',
                                                          style: ViewDecoration
                                                              .textStyleBold(
                                                                  provider.subscriptionPlan ==
                                                                          0
                                                                      ? kOrangeColor
                                                                      : kBlackColor,
                                                                  24),
                                                        ),
                                                        SizedBox(
                                                          height: 20.0.h,
                                                        ),
                                                        Text(
                                                          provider.packageList
                                                              .firstWhere((element) =>
                                                                  element
                                                                      .packageType
                                                                      .name ==
                                                                  'annual')
                                                              .storeProduct
                                                              .priceString,
                                                          style: ViewDecoration
                                                              .textStyleRegular(
                                                                  provider.subscriptionPlan ==
                                                                          0
                                                                      ? kOrangeColor
                                                                      : kBlackColor,
                                                                  14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 15.0.w,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  provider.subscriptionPlan = 1;
                                                },
                                                child: RoundCornerShape(
                                                  strokeColor:
                                                      provider.subscriptionPlan ==
                                                              1
                                                          ? kOrangeColor
                                                          : kDarkGrey,
                                                  radius: 10.r,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 22.0,
                                                            right: 22.0,
                                                            top: 16,
                                                            bottom: 20),
                                                    child: Column(
                                                      children: [
                                                        Text(
                                                          '1 Month',
                                                          style: ViewDecoration
                                                              .textStyleBold(
                                                                  provider.subscriptionPlan ==
                                                                          1
                                                                      ? kOrangeColor
                                                                      : kBlackColor,
                                                                  24),
                                                        ),
                                                        SizedBox(
                                                          height: 20.0.h,
                                                        ),
                                                        Text(
                                                          provider.packageList
                                                              .firstWhere((element) =>
                                                                  element
                                                                      .packageType
                                                                      .name ==
                                                                  'monthly')
                                                              .storeProduct
                                                              .priceString,
                                                          style: ViewDecoration
                                                              .textStyleRegular(
                                                                  provider.subscriptionPlan ==
                                                                          1
                                                                      ? kOrangeColor
                                                                      : kBlackColor,
                                                                  14),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 34,
                                        ),
                                        provider.state == ViewState.busy
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : PrimaryButton(
                                                color: kOrangeColor,
                                                height: 52.h,
                                                title: provider.introductoryList
                                                        .isNotEmpty
                                                    ? '3-day free trial'
                                                    : 'Buy Now',
                                                onPressed: () {
                                                  provider
                                                      .makePurchase(context);
                                                },
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                radius: 20.r,
                                              ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              provider.restorePurchase(context);
                                            },
                                            child: Text(
                                              'Restore',
                                              style: ViewDecoration
                                                  .textStyleMedium(
                                                      kOrangeColor, 13.sp),
                                            )),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                        GestureDetector(
                                            onTap: () {
                                              CommonFunction.openUrl(
                                                  privacyUrl);
                                            },
                                            child: RichText(
                                                textAlign: TextAlign.center,
                                                text: TextSpan(children: [
                                                  TextSpan(
                                                      text:
                                                          "After the free trial ends, your store account will be charged. You may cancel at any time during the term.You agree to the ",
                                                      style: ViewDecoration
                                                          .textStyleRegular(
                                                              kBlackColor,
                                                              11.sp),
                                                      children: [
                                                        TextSpan(
                                                            recognizer:
                                                                TapGestureRecognizer()
                                                                  ..onTap = () {
                                                                    CommonFunction
                                                                        .openUrl(
                                                                            termOfUseUrl);
                                                                  },
                                                            text:
                                                                'Terms of Use',
                                                            style: ViewDecoration
                                                                .textStyleRegular(
                                                                    Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    11.sp,
                                                                    true),
                                                            children: [
                                                              TextSpan(
                                                                  text: " and ",
                                                                  style: ViewDecoration
                                                                      .textStyleRegular(
                                                                          kBlackColor,
                                                                          11.sp),
                                                                  children: [
                                                                    TextSpan(
                                                                      recognizer:
                                                                          TapGestureRecognizer()
                                                                            ..onTap =
                                                                                () {
                                                                              CommonFunction.openUrl(privacyUrl);
                                                                            },
                                                                      text:
                                                                          "Privacy Policy.",
                                                                      style: ViewDecoration.textStyleRegular(
                                                                          Theme.of(context)
                                                                              .primaryColor,
                                                                          11.sp,
                                                                          true),
                                                                    ),
                                                                  ]),
                                                            ]),
                                                      ]),
                                                ]))),
                                        SizedBox(
                                          height: 16.h,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            provider.restoreLoader
                                ? const Center(
                                    child: CircularProgressIndicator(
                                      color: kOrangeColor,
                                    ),
                                  )
                                : const SizedBox()
                          ],
                        ),
                ),
              ),
            ));
  }

  featureItem(String title) {
    return Text(
      title,
      style: ViewDecoration.textStyleMedium(kBlackColor, 16.sp),
    );
  }
}
