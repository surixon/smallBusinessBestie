import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/enums/viewstate.dart';
import 'package:smalll_business_bestie/helpers/decoration.dart';
import 'package:smalll_business_bestie/models/income_data_model.dart';
import 'package:smalll_business_bestie/provider/home_provider.dart';
import 'package:smalll_business_bestie/routes.dart';
import 'package:smalll_business_bestie/view/base_view.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../constants/colors_constants.dart';
import '../globals.dart';
import '../helpers/common_function.dart';
import '../models/material_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<HomeProvider>(
        onModelReady: (provider) async {
          await provider.getTotalIncome();
        },
        builder: (context, provider, _) => Scaffold(
            appBar: CommonFunction.appBarWithButtons('dashboard'.tr(), context,
                showAdd: false, showSetting: true, onSettingPress: () {
              context.pushNamed(AppPaths.settings).then((value) async {
                await provider.getTotalIncome();
              });
            }),
            body: provider.state == ViewState.busy
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'total_income'.tr(),
                              style: ViewDecoration.textStyleMedium(
                                  kGrey626262.withOpacity(.5), 15.sp),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Center(
                            child: Text(
                              NumberFormat.currency(symbol: '\$')
                                  .format(provider.totalIncome),
                              style: ViewDecoration.textStyleSemiBold(
                                  kOrangeColor, 40.sp),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          Center(
                            child: Text(
                              'quarterly_income'.tr(),
                              style: ViewDecoration.textStyleMedium(
                                  kGrey626262.withOpacity(.5), 15.sp),
                            ),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          SfCartesianChart(
                              tooltipBehavior: TooltipBehavior(enable: false),
                              primaryXAxis: CategoryAxis(
                                axisLine: const AxisLine(
                                  width: 0,
                                ),
                                majorGridLines: const MajorGridLines(width: 0),
                                labelStyle: ViewDecoration.textStyleMedium(
                                    kBlackColor, 12.sp),
                              ),
                              primaryYAxis: NumericAxis(
                                minimum: 0,
                                maximum: 40000,
                                interval: 5000,
                                axisLine: const AxisLine(
                                  width: 0,
                                ),
                                majorGridLines: const MajorGridLines(
                                  width: 1,
                                ),
                                labelStyle: ViewDecoration.textStyleMedium(
                                    kBlackColor, 12.sp),
                                labelFormat: '\$ {value}',
                              ),
                              plotAreaBorderWidth: 0,
                              series: <CartesianSeries<IncomeData, String>>[
                                ColumnSeries<IncomeData, String>(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(4.r),
                                        topRight: Radius.circular(4.r)),
                                    dataSource: provider.data,
                                    xValueMapper: (IncomeData data, _) =>
                                        data.year,
                                    yValueMapper: (IncomeData data, _) =>
                                        data.income,
                                    color: kPinkColor)
                              ]),
                          SizedBox(
                            height: 16.h,
                          ),
                          Row(
                            children: [
                              _incomeTab(
                                  kColorFFD07A,
                                  'total_expenses'.tr(),
                                  NumberFormat.currency(symbol: '\$')
                                      .format(provider.totalExpenses)),
                              SizedBox(
                                width: 8.w,
                              ),
                              _incomeTab(
                                  kColorFC5B2D,
                                  'total_profit'.tr(),
                                  NumberFormat.currency(symbol: '\$')
                                      .format(provider.totalProfit)),
                              SizedBox(
                                width: 8.w,
                              ),
                              _incomeTab(
                                  kColor0294EA,
                                  'cost_of_inventory'.tr(),
                                  NumberFormat.currency(symbol: '\$')
                                      .format(provider.totalInventory)),
                            ],
                          ),
                          SizedBox(
                            height: 24.h,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 8.h),
                            decoration:
                                BoxDecoration(border: Border.all(width: 1)),
                            child: Column(
                              children: [
                                Center(
                                  child: Text(
                                    "Status of Inventory",
                                    style: ViewDecoration.textStyleSemiBold(
                                        kBlackColor, 16.sp),
                                  ),
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                CustomRadioButton(
                                  buttonTextStyle: ButtonTextStyle(
                                      selectedColor: Colors.white,
                                      unSelectedColor: Colors.black,
                                      textStyle:
                                          ViewDecoration.textStyleSemiBold(
                                              kBlackColor, 14.sp)),
                                  unSelectedColor:
                                      Theme.of(context).canvasColor,
                                  buttonLables: const [
                                    "OUT OF STOCK",
                                    "RE-ORDER REQUIRED",
                                  ],
                                  buttonValues: const [
                                    "1",
                                    "2",
                                  ],
                                  autoWidth: true,
                                  defaultSelected: "1",
                                  spacing: 0,
                                  horizontal: false,
                                  enableButtonWrap: true,
                                  absoluteZeroSpacing: false,
                                  selectedColor: Theme.of(context).primaryColor,
                                  padding: 10,
                                  radioButtonValue: (value) {
                                    provider.inventoryStatus = value;
                                  },
                                ),
                                SizedBox(
                                  height: 12.h,
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: provider.inventoryStatus == '1'
                                        ? Globals.materialsReference
                                            .where('stockStatus', isEqualTo: 0)
                                            .where('userId',
                                                isEqualTo:
                                                    Globals.firebaseUser?.uid)
                                            .snapshots()
                                        : Globals.materialsReference
                                            .where('stockStatus', isEqualTo: 2)
                                            .where('userId',
                                                isEqualTo:
                                                    Globals.firebaseUser?.uid)
                                            .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasError) {
                                        return const SizedBox.shrink();
                                      }

                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const SizedBox();
                                      }

                                      return ListView.separated(
                                          shrinkWrap: true,
                                          padding:
                                              EdgeInsets.only(bottom: 18.h),
                                          itemBuilder: (context, index) {
                                            MaterialModel materialModel =
                                                MaterialModel.fromSnapshot(
                                                    snapshot.data!.docs[index]
                                                            .data()
                                                        as Map<String,
                                                            dynamic>);

                                            materialModel.docId =
                                                snapshot.data!.docs[index].id;
                                            return _itemBuilder(
                                                context, index, materialModel);
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider();
                                          },
                                          itemCount:
                                              snapshot.data!.docs.length ?? 0);
                                    }),
                              ],
                            ),
                          )
                        ]))));
  }

  _incomeTab(Color color, String text, String amount) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10.r),
                topLeft: Radius.circular(10.r)),
            border: Border.all(color: color, width: 2)),
        child: Column(
          children: [
            Container(
              height: 30.h,
              decoration: BoxDecoration(
                  color: color.withOpacity(.5),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      topLeft: Radius.circular(8.r))),
              child: Center(
                  child: Text(
                text,
                style: ViewDecoration.textStyleMedium(kBlackColor, 10.sp),
              )),
            ),
            Container(
              height: 66.h,
              child: Center(
                  child: Text(
                amount,
                style: ViewDecoration.textStyleBold(kBlackColor, 15.sp),
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemBuilder(
      BuildContext context, int index, MaterialModel materialModel) {
    return Text(
      materialModel.name ?? '',
      style: ViewDecoration.textStyleRegular(kBlackColor, 13.sp),
    );
  }
}
