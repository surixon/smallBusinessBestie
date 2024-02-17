import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/constants/colors_constants.dart';
import 'package:smalll_business_bestie/helpers/common_function.dart';
import 'package:smalll_business_bestie/helpers/decoration.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/routes.dart';

import '../globals.dart';

class MaterialsView extends StatelessWidget {
  const MaterialsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CommonFunction.appBarWithButtons('material_list'.tr(), context,
            showAdd: true, onAddPress: () {
          context.pushNamed(AppPaths.addMaterial);
        }),
        body: StreamBuilder<QuerySnapshot>(
            stream: Globals.materialsReference
                .where('userId', isEqualTo: Globals.firebaseUser?.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const SizedBox.shrink();
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
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

              return ListView.separated(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.w, vertical: 18.h),
                  itemBuilder: (context, index) {
                    MaterialModel materialModel = MaterialModel.fromSnapshot(
                        snapshot.data?.docs[index].data()
                            as Map<String, dynamic>);
                    return _itemBuilder(context, index, materialModel);
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: 24.h,
                    );
                  },
                  itemCount: snapshot.data?.docs.length ?? 0);
            }));
  }

  _itemBuilder(BuildContext context, int index, MaterialModel materialModel) {
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
              "${materialModel.name}",
              style: ViewDecoration.textStyleBoldPoppins(kWhiteColor, 20.sp),
            ),
          ),
        ),
        Table(
          columnWidths: const {
            0: FlexColumnWidth(3),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(3),
            3: FlexColumnWidth(2),
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
                  Theme.of(context).primaryColor, "cost".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${materialModel.cost} USD"),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "insold_value".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${materialModel.inSoldValue} USD"),
            ]),
            TableRow(children: [
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "min_quantity".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${materialModel.minQty}",
                  verticalAlignment: TableCellVerticalAlignment.fill),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "stock_value".tr(),
                  verticalAlignment: TableCellVerticalAlignment.fill),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${materialModel.stockValue}",
                  verticalAlignment: TableCellVerticalAlignment.fill),
            ]),
            TableRow(children: [
              _tableCell(
                  context,
                  BorderRadius.only(bottomLeft: Radius.circular(18.r)),
                  kWhiteColor,
                  Theme.of(context).primaryColor,
                  "quantity_in_stock".tr()),
              _tableCell(context, BorderRadius.zero, kPinkColor.withOpacity(.8),
                  kWhiteColor, "${materialModel.qtyInStock}",
                  verticalAlignment: TableCellVerticalAlignment.fill),
              _tableCell(context, BorderRadius.zero, kWhiteColor,
                  Theme.of(context).primaryColor, "Status in stock"),
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
