import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/models/income_model.dart';
import 'package:smalll_business_bestie/provider/income_provider.dart';
import 'package:smalll_business_bestie/routes.dart';
import 'package:smalll_business_bestie/view/base_view.dart';

import '../constants/colors_constants.dart';
import '../globals.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';

class IncomeView extends StatelessWidget {
  const IncomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<IncomeProvider>(
        onModelReady: (provider) async {
          await provider.getTotalIncome();
        },
        builder: (context, provider, _) => Scaffold(
              appBar: CommonFunction.appBarWithButtons('income'.tr(), context,
                  showAdd: true, onAddPress: () {
                context.pushNamed(AppPaths.addIncome).then((value) async {
                  if (value != null && value is bool) {
                    await provider.getTotalIncome();
                  }
                });
              }),
              body: provider.isLoader
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : StreamBuilder<QuerySnapshot>(
                      stream: Globals.incomeReference
                          .where('userId', isEqualTo: Globals.firebaseUser?.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const SizedBox.shrink();
                        }

                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        if (snapshot.data!.size == 0) {
                          return Center(
                            child: Text(
                              'no_data_yet'.tr(),
                              style: ViewDecoration.textStyleMediumPoppins(
                                  kBlackColor, 15.sp),
                            ),
                          );
                        }

                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12.h,
                              ),
                              Text(
                                '${NumberFormat.currency(symbol: NumberFormat.simpleCurrency().simpleCurrencySymbol('USD')).format(provider.totalIncome)} ',
                                style: ViewDecoration.textStyleBoldPoppins(
                                    kOrangeColor, 25.sp),
                              ),
                              ListView.separated(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24.w, vertical: 12.h),
                                  itemBuilder: (context, index) {
                                    IncomeModel incomeModel =
                                        IncomeModel.fromSnapshot(
                                            snapshot.data?.docs[index].data()
                                                as Map<String, dynamic>);
                                    return _itemBuilder(
                                        context, index, incomeModel);
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 24.h,
                                    );
                                  },
                                  itemCount: snapshot.data?.docs.length ?? 0),
                            ],
                          ),
                        );
                      }),
            ));
  }

  _itemBuilder(BuildContext context, int index, IncomeModel incomeModel) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(18.r),
              topRight: Radius.circular(18.r),
            ),
          ),
          height: 34.h,
          child: Center(
            child: Text(
              CommonFunction.getDateFromTimeStamp(
                  incomeModel.date!.toDate(), "yyyy"),
              style: ViewDecoration.textStyleBoldPoppins(kWhiteColor, 20.sp),
            ),
          ),
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          },
          border: TableBorder.all(
            color: Theme.of(context).primaryColor,
            width: 1.5,
            borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(18.r),
                bottomLeft: Radius.circular(18.r)),
          ),
          children: [
            TableRow(children: [
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "date".tr()),
              _tableCell(
                  context,
                  BorderRadius.zero,
                  kPinkColor.withOpacity(.8),
                  kWhiteColor,
                  CommonFunction.getDateFromTimeStamp(
                      incomeModel.date!.toDate(), "yyyy-MM-dd")),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "total".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${incomeModel.netIncome} USD",
                  verticalAlignment: TableCellVerticalAlignment.fill),
            ]),
            TableRow(children: [
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "title".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${incomeModel.title}"),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "tax".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${incomeModel.tax}",
                  verticalAlignment: TableCellVerticalAlignment.fill),
            ]),
            TableRow(children: [
              _tableCell(
                  context,
                  BorderRadius.only(bottomLeft: Radius.circular(18.r)),
                  kWhiteColor,
                  Theme.of(context).primaryColor,
                  "desc".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${incomeModel.desc}"),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "desc".tr()),
              _tableCell(
                  context,
                  BorderRadius.only(bottomRight: Radius.circular(18.r)),
                  kPinkColor.withOpacity(.8),
                  kWhiteColor,
                  "3",
                  verticalAlignment: TableCellVerticalAlignment.fill),
            ])
          ],
        )
      ],
    );
  }

  _tableCell(BuildContext context, BorderRadiusGeometry? radiusGeometry,
      Color kWhiteColor, Color textColor, String text,
      {TableCellVerticalAlignment? verticalAlignment}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.top,
      child: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: kWhiteColor, borderRadius: radiusGeometry),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: ViewDecoration.textStyleSemiBoldPoppins(textColor, 12.sp),
          ),
        ),
      ),
    );
  }
}
