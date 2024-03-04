import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/models/expenses_model.dart';
import 'package:smalll_business_bestie/provider/expenses_provider.dart';
import 'package:smalll_business_bestie/routes.dart';

import '../constants/colors_constants.dart';
import '../globals.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import 'base_view.dart';

class ExpensesView extends StatelessWidget {
  const ExpensesView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<ExpensesProvider>(
      onModelReady: (provider) async {
        await provider.getTotalExpenses();
      },
      builder: (context, provider, _) => Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: CommonFunction.appBarWithButtons('expenses'.tr(), context,
            showAdd: true, onAddPress: () {
          context.pushNamed(AppPaths.addExpense).then((value) async {
            if (value != null && value is bool) {
              await provider.getTotalExpenses();
            }
          });
        }),
        body: provider.isLoader
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
          padding: EdgeInsets.only(left: 24.w, right: 24.w, top: 18.h),
              child: Column(
                  children: [
                    TextFormField(
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      onChanged: (value) {
                        provider.searchText = value;
                      },
                      style: ViewDecoration.textStyleMediumPoppins(
                          kBlackColor, 16.sp),
                      decoration: ViewDecoration.textFiledDecoration(
                          hintText: "Search by title...", fillColor: kWhiteColor),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Text(
                      '${NumberFormat.currency(symbol: NumberFormat.simpleCurrency().simpleCurrencySymbol('USD')).format(provider.totalExpenses)} ',
                      style: ViewDecoration.textStyleBoldPoppins(
                          kOrangeColor, 25.sp),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                          stream: Globals.expensesReference
                              .where('userId',
                                  isEqualTo: Globals.firebaseUser?.uid)
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

                            provider.expensesDocuments.clear();

                            provider.expensesDocuments
                                .addAll(snapshot.data!.docs);

                            if (provider.searchText.isNotEmpty) {
                              provider.expensesDocuments =
                                  provider.expensesDocuments.where((element) {
                                return (element
                                    .get('title')
                                    .toString()
                                    .toLowerCase()
                                    .contains(provider.searchText.toLowerCase()));
                              }).toList();
                            }

                            return ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.only(
                                    bottom: 18.h),
                                itemBuilder: (context, index) {
                                  ExpensesModel expensesModel =
                                      ExpensesModel.fromSnapshot(provider
                                          .expensesDocuments[index]
                                          .data() as Map<String, dynamic>);

                                  expensesModel.docId =
                                      provider.expensesDocuments[index].id;

                                  return _itemBuilder(
                                      context, index, expensesModel);
                                },
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: 24.h,
                                  );
                                },
                                itemCount:
                                    provider.expensesDocuments.length ?? 0);
                          }),
                    ),
                  ],
                ),
            ),
      ),
    );
  }

  _itemBuilder(BuildContext context, int index, ExpensesModel expensesModel) {
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
                  expensesModel.date!.toDate(), "yyyy"),
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
                      expensesModel.date!.toDate(), "yyyy-MM-dd")),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "desc".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${expensesModel.desc}",
                  verticalAlignment: TableCellVerticalAlignment.fill),
            ]),
            TableRow(children: [
              _tableCell(
                  context,
                  BorderRadius.only(bottomLeft: Radius.circular(18.r)),
                  kWhiteColor,
                  Theme.of(context).primaryColor,
                  "title".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${expensesModel.title}"),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "total".tr()),
              _tableCell(
                  context,
                  BorderRadius.only(bottomRight: Radius.circular(18.r)),
                  kPinkColor.withOpacity(.8),
                  kWhiteColor,
                  "${expensesModel.total}",
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
        decoration:
            BoxDecoration(color: kWhiteColor, borderRadius: radiusGeometry),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: ViewDecoration.textStyleSemiBoldPoppins(textColor, 12.sp),
            ),
          ),
        ),
      ),
    );
  }
}
