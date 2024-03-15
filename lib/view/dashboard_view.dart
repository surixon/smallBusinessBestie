import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smalll_business_bestie/constants/image_constants.dart';
import 'package:smalll_business_bestie/enums/viewstate.dart';
import '../constants/colors_constants.dart';
import '../dialog/exit_popup.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../provider/dashboard_provider.dart';
import '../widgets/image_view.dart';
import 'base_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  DashboardViewState createState() => DashboardViewState();
}

class DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<DashboardProvider>(
        onModelReady: (provider) async {
          await provider.initPlatformState().then((value) async {
            await provider.checkSubscription(context);
          });
        },
        builder: (context, provider, _) => WillPopScope(
              onWillPop: () async {
                if (provider.selectedIndex != 0) {
                  return await provider.setHome(context, provider);
                } else {
                  return showExitPopup(context);
                }
              },
              child:  Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: kBgColor,
                      body:
                          provider.widgetList.elementAt(provider.selectedIndex),
                      bottomNavigationBar: BottomNavigationBar(
                        showUnselectedLabels: true,
                        backgroundColor: Theme.of(context).primaryColor,
                        type: BottomNavigationBarType.fixed,
                        unselectedLabelStyle:
                            ViewDecoration.textStyleMedium(kWhiteColor, 8.sp),
                        selectedLabelStyle:
                            ViewDecoration.textStyleMedium(kYellowColor, 10.sp),
                        selectedItemColor: kYellowColor,
                        unselectedItemColor: kWhiteColor,
                        currentIndex: provider.selectedIndex,
                        onTap: (index) {
                          provider.selectedIndex = index;
                        },
                        items: [
                          BottomNavigationBarItem(
                              activeIcon: ImageView(
                                path: materials,
                                color: kYellowColor,
                                width: 20.w,
                                height: 20.w,
                              ),
                              icon: ImageView(
                                path: materials,
                                width: 20.w,
                                height: 20.w,
                              ),
                              label: 'inventory'.tr()),
                          BottomNavigationBarItem(
                              activeIcon: ImageView(
                                path: products,
                                color: kYellowColor,
                                width: 20.w,
                                height: 20.w,
                              ),
                              icon: ImageView(
                                path: products,
                                width: 20.w,
                                height: 20.w,
                              ),
                              label: 'products'.tr()),
                          BottomNavigationBarItem(
                              activeIcon: ImageView(
                                path: incomeSelected,
                                width: 20.w,
                                height: 20.w,
                              ),
                              icon: ImageView(
                                path: income,
                                width: 20.w,
                                height: 20.w,
                              ),
                              label: 'income'.tr()),
                          BottomNavigationBarItem(
                              activeIcon: ImageView(
                                path: expensesSelected,
                                width: 20.w,
                                height: 20.w,
                              ),
                              icon: ImageView(
                                path: expenses,
                                width: 20.w,
                                height: 20.w,
                              ),
                              label: 'expenses'.tr()),
                          BottomNavigationBarItem(
                              activeIcon: ImageView(
                                path: dashboard,
                                color: kYellowColor,
                                width: 20.w,
                                height: 20.w,
                              ),
                              icon: ImageView(
                                path: dashboard,
                                width: 20.w,
                                height: 20.w,
                              ),
                              label: 'dashboard'.tr())
                        ],
                      ),
                    ),
            ));
  }
}
