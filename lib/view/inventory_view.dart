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
import 'package:smalll_business_bestie/provider/material_view_provider.dart';
import 'package:smalll_business_bestie/routes.dart';

import '../globals.dart';
import 'base_view.dart';

class InventoryView extends StatelessWidget {
  final String? from;

  const InventoryView({super.key, this.from});

  @override
  Widget build(BuildContext context) {
    return BaseView<MaterialViewProvider>(
      builder: (context, provider, _) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: CommonFunction.appBarWithButtons(
                'inventory_list'.tr(), context,
                showBack: (from != null && from == "ADD_PRODUCT"),
                onBackPress: () {
                  context.pop();
                },
                showAdd: (from != null && from == "ADD_PRODUCT") ? false : true,
                onAddPress: () {
                  context.pushNamed(AppPaths.addMaterial);
                }),
            body: Padding(
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
                        hintText: 'Search by name...', fillColor: kWhiteColor),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                        stream: Globals.materialsReference
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

                          provider.materialDocuments.clear();

                          List<DocumentSnapshot> tempDocuments = [];

                          tempDocuments.addAll(snapshot.data!.docs);

                          provider.materialDocuments.addAll(tempDocuments
                              .where((element) => element['stockStatus'] == 0)
                              .toList());
                          provider.materialDocuments.addAll(tempDocuments
                              .where((element) => element['stockStatus'] == 2)
                              .toList());
                          provider.materialDocuments.addAll(tempDocuments
                              .where((element) => element['stockStatus'] == 1)
                              .toList());

                          if (provider.searchText.isNotEmpty) {
                            provider.materialDocuments =
                                provider.materialDocuments.where((element) {
                              return (element
                                  .get('name')
                                  .toString()
                                  .toLowerCase()
                                  .contains(provider.searchText.toLowerCase()));
                            }).toList();
                          }

                          return ListView.separated(
                              shrinkWrap: true,
                              padding: EdgeInsets.only(bottom: 18.h),
                              itemBuilder: (context, index) {
                                MaterialModel materialModel =
                                    MaterialModel.fromSnapshot(
                                        provider.materialDocuments[index].data()
                                            as Map<String, dynamic>);

                                materialModel.docId =
                                    provider.materialDocuments[index].id;
                                return _itemBuilder(
                                    context, index, materialModel, provider);
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 24.h,
                                );
                              },
                              itemCount:
                                  provider.materialDocuments.length ?? 0);
                        }),
                  ),
                ],
              ),
            )),
      ),
    );
  }

  _itemBuilder(BuildContext context, int index, MaterialModel materialModel,
      MaterialViewProvider provider) {
    return GestureDetector(
      onTap: (from != null && from == "ADD_PRODUCT")
          ? () {
              context.pop(materialModel);
            }
          : () {
              context.pushNamed(AppPaths.addMaterial, extra: materialModel);
            },
      child: Column(
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
                _tableCell(
                    context,
                    BorderRadius.zero,
                    kPinkColor.withOpacity(.8),
                    kWhiteColor,
                    "${materialModel.cost} USD"),
                _tableCell(context, BorderRadius.zero, kWhiteColor,
                    Theme.of(context).primaryColor, "insold_value".tr()),
                _tableCell(
                    context,
                    BorderRadius.zero,
                    kPinkColor.withOpacity(.8),
                    kWhiteColor,
                    "${provider.getInSoldValue(materialModel)}",
                    verticalAlignment: TableCellVerticalAlignment.fill),
              ]),
              TableRow(children: [
                _tableCell(context, BorderRadius.zero, kWhiteColor,
                    Theme.of(context).primaryColor, "min_quantity".tr()),
                _tableCell(
                    context,
                    BorderRadius.zero,
                    kPinkColor.withOpacity(.8),
                    kWhiteColor,
                    "${materialModel.minQty}",
                    verticalAlignment: TableCellVerticalAlignment.fill),
                _tableCell(context, BorderRadius.zero, kWhiteColor,
                    Theme.of(context).primaryColor, "stock_value".tr(),
                    verticalAlignment: TableCellVerticalAlignment.fill),
                _tableCell(
                    context,
                    BorderRadius.zero,
                    kPinkColor.withOpacity(.8),
                    kWhiteColor,
                    "${materialModel.stockValue}",
                    verticalAlignment: TableCellVerticalAlignment.fill),
              ]),
              TableRow(children: [
                _tableCell(
                    context,
                    BorderRadius.only(bottomLeft: Radius.circular(18.r)),
                    kWhiteColor,
                    Theme.of(context).primaryColor,
                    "quantity_in_stock".tr()),
                _tableCell(
                    context,
                    BorderRadius.zero,
                    kPinkColor.withOpacity(.8),
                    kWhiteColor,
                    "${materialModel.qtyInStock}",
                    verticalAlignment: TableCellVerticalAlignment.fill),
                _tableCell(context, BorderRadius.zero, kWhiteColor,
                    Theme.of(context).primaryColor, "Status in stock"),
                _tableCell(
                    context,
                    BorderRadius.only(bottomRight: Radius.circular(18.r)),
                    kPinkColor.withOpacity(.8),
                    kWhiteColor,
                    materialModel.stockStatusString ?? '',
                    verticalAlignment: TableCellVerticalAlignment.bottom),
              ])
            ],
          )
        ],
      ),
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
            overflow: TextOverflow.clip,
            style: ViewDecoration.textStyleSemiBoldPoppins(textColor, 12.sp),
          ),
        ),
      ),
    );
  }
}
