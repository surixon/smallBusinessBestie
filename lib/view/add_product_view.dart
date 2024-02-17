import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/provider/add_material_provider.dart';
import 'package:smalll_business_bestie/view/base_view.dart';
import 'package:smalll_business_bestie/widgets/image_view.dart';

import '../constants/colors_constants.dart';
import '../constants/image_constants.dart';
import '../enums/viewstate.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../helpers/keyboard_helper.dart';
import '../widgets/primary_button.dart';

class AddProductView extends StatefulWidget {
  const AddProductView({super.key});

  @override
  AddProductViewState createState() => AddProductViewState();
}

class AddProductViewState extends State<AddProductView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseView<AddMaterialProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: CommonFunction.appBarWithButtons('add_product'.tr(), context,
            showBack: true, onBackPress: () {
          context.pop();
        }),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'required'.tr();
                    } else {
                      return null;
                    }
                  },
                  style:
                      ViewDecoration.textStyleMediumPoppins(kBlackColor, 16.sp),
                  decoration: ViewDecoration.textFiledDecoration(
                      hintText: 'enter_product_name'.tr(),
                      fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'set_up'.tr(),
                    style: ViewDecoration.textStyleBoldPoppins(
                        Theme.of(context).primaryColor, 20.sp),
                  ),
                ),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(4),
                    1: FlexColumnWidth(2),
                  },
                  border: TableBorder.all(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                    borderRadius: BorderRadius.all(
                      Radius.circular(18.r),
                    ),
                  ),
                  children: [
                    TableRow(children: [
                      _setupKeyCell(context, 'currency'.tr()),
                      _setupValueCell(context, 'USD')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'convert_to'.tr()),
                      _setupValueCell(context, 'USD')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'roe'.tr()),
                      _setupValueCell(context, '0.00')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'quantity'.tr()),
                      _setupValueCell(context, '3')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'overhead'.tr()),
                      _setupValueCell(context, '10%')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'discount_percentage'.tr()),
                      _setupValueCell(context, '0%')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'profit_margin'.tr()),
                      _setupValueCell(context, '3.00%')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'hourly_rate'.tr()),
                      _setupValueCell(context, '20.00%%')
                    ]),
                    TableRow(children: [
                      _setupKeyCell(context, 'sales_tax'.tr()),
                      _setupValueCell(context, '7.00%')
                    ]),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Column(
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 20.w, height: 20.w),
                            Text(
                              "Material",
                              style: ViewDecoration.textStyleBoldPoppins(
                                  kWhiteColor, 20.sp),
                            ),
                            ImageView(
                              path: addIcon,
                              width: 20.w,
                              height: 20.w,
                            )
                          ],
                        ),
                      ),
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(3),
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
                          _tableCellKey(context, BorderRadius.zero, kWhiteColor,
                              Theme.of(context).primaryColor, "material".tr()),
                          _tableCellKey(
                              context,
                              BorderRadius.zero,
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              "how_many_units".tr()),
                          _tableCellKey(
                              context,
                              BorderRadius.zero,
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "total_cost".tr(),
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                        TableRow(children: [
                          _tableCellValue(
                              context,
                              BorderRadius.zero,
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              'cup'),
                          _tableCellValue(context, BorderRadius.zero,
                              kWhiteColor, Theme.of(context).primaryColor, "3"),
                          _tableCellValue(
                              context,
                              BorderRadius.zero,
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "9.00 USD",
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                        TableRow(children: [
                          _tableCellValue(
                              context,
                              BorderRadius.only(
                                  bottomLeft: Radius.circular(18.r)),
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              'pipe'),
                          _tableCellValue(context, BorderRadius.zero,
                              kWhiteColor, Theme.of(context).primaryColor, "3"),
                          _tableCellValue(
                              context,
                              BorderRadius.only(
                                  bottomRight: Radius.circular(18.r)),
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "5.00 USD",
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Column(
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 20.w, height: 20.w),
                            Text(
                              "Labour Cost",
                              style: ViewDecoration.textStyleBoldPoppins(
                                  kWhiteColor, 20.sp),
                            ),
                            ImageView(
                              path: addIcon,
                              width: 20.w,
                              height: 20.w,
                            )
                          ],
                        ),
                      ),
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(3),
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
                          _tableCellKey(context, BorderRadius.zero, kWhiteColor,
                              Theme.of(context).primaryColor, "activity".tr()),
                          _tableCellKey(
                              context,
                              BorderRadius.zero,
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              "minutes_to_compare".tr()),
                          _tableCellKey(
                              context,
                              BorderRadius.zero,
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "labor_cost_per".tr(),
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                        TableRow(children: [
                          _tableCellValue(
                              context,
                              BorderRadius.zero,
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              'cup'),
                          _tableCellValue(context, BorderRadius.zero,
                              kWhiteColor, Theme.of(context).primaryColor, "3"),
                          _tableCellValue(
                              context,
                              BorderRadius.zero,
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "9.00 USD",
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                        TableRow(children: [
                          _tableCellValue(
                              context,
                              BorderRadius.only(
                                  bottomLeft: Radius.circular(18.r)),
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              'pipe'),
                          _tableCellValue(context, BorderRadius.zero,
                              kWhiteColor, Theme.of(context).primaryColor, "3"),
                          _tableCellValue(
                              context,
                              BorderRadius.only(
                                  bottomRight: Radius.circular(18.r)),
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "5.00 USD",
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Column(
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
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(width: 20.w, height: 20.w),
                            Text(
                              "Other Expenses",
                              style: ViewDecoration.textStyleBoldPoppins(
                                  kWhiteColor, 20.sp),
                            ),
                            ImageView(
                              path: addIcon,
                              width: 20.w,
                              height: 20.w,
                            )
                          ],
                        ),
                      ),
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(3),
                        2: FlexColumnWidth(3),
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
                          _tableCellKey(context, BorderRadius.zero, kWhiteColor,
                              Theme.of(context).primaryColor, "activity".tr()),
                          _tableCellKey(
                              context,
                              BorderRadius.zero,
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              "minutes_to_compare".tr()),
                          _tableCellKey(
                              context,
                              BorderRadius.zero,
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "total_per_expenses".tr(),
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                        TableRow(children: [
                          _tableCellValue(
                              context,
                              BorderRadius.zero,
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              'cup'),
                          _tableCellValue(context, BorderRadius.zero,
                              kWhiteColor, Theme.of(context).primaryColor, "3"),
                          _tableCellValue(
                              context,
                              BorderRadius.zero,
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "9.00 USD",
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                        TableRow(children: [
                          _tableCellValue(
                              context,
                              BorderRadius.only(
                                  bottomLeft: Radius.circular(18.r)),
                              kWhiteColor,
                              Theme.of(context).primaryColor,
                              'pipe'),
                          _tableCellValue(context, BorderRadius.zero,
                              kWhiteColor, Theme.of(context).primaryColor, "3"),
                          _tableCellValue(
                              context,
                              BorderRadius.only(
                                  bottomRight: Radius.circular(18.r)),
                              kPinkColor.withOpacity(.8),
                              kWhiteColor,
                              "5.00 USD",
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill),
                        ]),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'overview'.tr(),
                        style: ViewDecoration.textStyleBoldPoppins(
                            Theme.of(context).primaryColor, 20.sp),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(3),
                      },
                      border: TableBorder.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.r),
                        ),
                      ),
                      children: [
                        TableRow(children: [
                          _setupKeyCell(context, 'materials'.tr()),
                          _setupValueCell(context, 'USD'),
                          _setupValueCell(context, '0.00',
                              radiusGeometry: BorderRadius.only(
                                  topRight: Radius.circular(18.r)),
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'labor_cost'.tr()),
                          _setupValueCell(context, 'USD'),
                          _setupValueCell(context, '0.00',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'other_expenses'.tr()),
                          _setupValueCell(context, 'USD'),
                          _setupValueCell(context, '0.00',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'overhead'.tr()),
                          _setupValueCell(context, 'USD'),
                          _setupValueCell(context, '0.00',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'discount_amount'.tr()),
                          _setupValueCell(context, 'USD',verticalAlignment: TableCellVerticalAlignment.fill),
                          _setupValueCell(
                            context,
                            '0.00',
                            bgColor: kPinkColor.withOpacity(.8),
                            textColor: kWhiteColor,
                            verticalAlignment: TableCellVerticalAlignment.fill,
                          )
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'sale_tax'.tr()),
                          _setupValueCell(context, 'USD'),
                          _setupValueCell(context, '0.00',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'total_cost_to_make'.tr()),
                          _setupValueCell(context, 'USD',verticalAlignment: TableCellVerticalAlignment.fill),
                          _setupValueCell(context, '0.00',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor,
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              radiusGeometry: BorderRadius.only(
                                  bottomRight: Radius.circular(18.r)))
                        ]),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'summary'.tr(),
                        style: ViewDecoration.textStyleBoldPoppins(
                            Theme.of(context).primaryColor, 20.sp),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(3),
                      },
                      border: TableBorder.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.r),
                        ),
                      ),
                      children: [
                        TableRow(children: [
                          _setupKeyCell(context, 'info'.tr()),
                          _setupKeyCell(context, 'amount'.tr()),
                          _setupKeyCell(context, 'convert_to_usd'.tr()),

                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'retail_price'.tr()),
                          _setupValueCell(context, '3.00'),
                          _setupValueCell(context, '9.00 USD',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),

                        TableRow(children: [
                          _setupKeyCell(context, 'sale_price'.tr()),
                          _setupValueCell(context, '5.00'),
                          _setupValueCell(context, '9.00 USD',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'wholesale_price'.tr()),
                          _setupValueCell(context, '5.00'),
                          _setupValueCell(context, '9.00 USD',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor,
                              verticalAlignment:
                              TableCellVerticalAlignment.fill,
                              radiusGeometry: BorderRadius.only(
                                  bottomRight: Radius.circular(18.r)))
                        ]),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 16.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        'profit'.tr(),
                        style: ViewDecoration.textStyleBoldPoppins(
                            Theme.of(context).primaryColor, 20.sp),
                      ),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Table(
                      columnWidths: const {
                        0: FlexColumnWidth(4),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(3),
                      },
                      border: TableBorder.all(
                        color: Theme.of(context).primaryColor,
                        width: 1.5,
                        borderRadius: BorderRadius.all(
                          Radius.circular(18.r),
                        ),
                      ),
                      children: [
                        TableRow(children: [
                          _setupKeyCell(context, 'info'.tr()),
                          _setupKeyCell(context, 'amount'.tr()),
                          _setupKeyCell(context, 'convert_to_usd'.tr()),

                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'retail_profit'.tr()),
                          _setupValueCell(context, '3.00'),
                          _setupValueCell(context, '9.00 USD',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),

                        TableRow(children: [
                          _setupKeyCell(context, 'sale_profit'.tr()),
                          _setupValueCell(context, '5.00'),
                          _setupValueCell(context, '9.00 USD',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor)
                        ]),
                        TableRow(children: [
                          _setupKeyCell(context, 'wholesale_profit'.tr()),
                          _setupValueCell(context, '5.00',verticalAlignment: TableCellVerticalAlignment.fill),
                          _setupValueCell(context, '9.00 USD',
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor,
                              verticalAlignment:
                              TableCellVerticalAlignment.fill,
                              radiusGeometry: BorderRadius.only(
                                  bottomRight: Radius.circular(18.r)))
                        ]),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 32.h,
                ),
                provider.state == ViewState.busy
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : PrimaryButton(
                        width: MediaQuery.of(context).size.width,
                        height: 52.h,
                        title: 'add_product'.tr(),
                        radius: 20.r,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            KeyboardHelper.hideKeyboard(context);
                          }
                        },
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  _setupKeyCell(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: ViewDecoration.textStyleMediumPoppins(
            Theme.of(context).primaryColor, 15.sp),
      ),
    );
  }

  _setupValueCell(
    BuildContext context,
    String text, {
    Color? bgColor,
    TableCellVerticalAlignment? verticalAlignment,
    BorderRadiusGeometry? radiusGeometry,
    Color? textColor,
  }) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.top,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor ?? kWhiteColor, borderRadius: radiusGeometry),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: ViewDecoration.textStyleBoldPoppins(
                  textColor ?? Theme.of(context).primaryColor, 15.sp),
            ),
          ),
        ),
      ),
    );
  }

  _tableCellKey(BuildContext context, BorderRadiusGeometry? radiusGeometry,
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
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: ViewDecoration.textStyleMediumPoppins(textColor, 15.sp),
            ),
          ),
        ),
      ),
    );
  }

  _tableCellValue(BuildContext context, BorderRadiusGeometry? radiusGeometry,
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
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: ViewDecoration.textStyleBoldPoppins(textColor, 15.sp),
            ),
          ),
        ),
      ),
    );
  }
}
