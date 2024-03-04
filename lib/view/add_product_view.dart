import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/helpers/currencies.dart';
import 'package:smalll_business_bestie/models/labor_cost_model.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/provider/add_product_provider.dart';
import 'package:smalll_business_bestie/routes.dart';
import 'package:smalll_business_bestie/view/base_view.dart';
import 'package:smalll_business_bestie/widgets/image_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/colors_constants.dart';
import '../constants/image_constants.dart';
import '../constants/string_constants.dart';
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
    return BaseView<AddProductProvider>(onModelReady: (provider) {
      provider.currency = currencies[0];
      provider.currencyCovertTo = currencies[0];
    }, builder: (context, provider, _) {
      return GestureDetector(
        onTap: () {
          KeyboardHelper.hideKeyboard(context);
        },
        child: Scaffold(
          backgroundColor: kWhiteColor,
          appBar: CommonFunction.appBarWithButtons('add_product'.tr(), context,
              showBack: true, onBackPress: () {
            context.pop();
          }),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Form(
              key: _formKey,
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
                    style: ViewDecoration.textStyleMediumPoppins(
                        kBlackColor, 16.sp),
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
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
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
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 12.w),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Map<String, dynamic>>(
                              isExpanded: true,
                              isDense: true,
                              value: provider.currency,
                              items:
                                  currencies.map((Map<String, dynamic> value) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                    value: value,
                                    child: Text(
                                      value['code'],
                                      textAlign: TextAlign.center,
                                      style:
                                          ViewDecoration.textStyleBoldPoppins(
                                              Theme.of(context).primaryColor,
                                              15.sp),
                                    ));
                              }).toList(),
                              onChanged: (_) {
                                provider.currency = _;
                                provider.calculateOverhead();
                              },
                            ),
                          ),
                        )
                      ]),
                      TableRow(children: [
                        _setupKeyCell(context, 'convert_to'.tr()),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 12.w),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<Map<String, dynamic>>(
                              isExpanded: true,
                              isDense: true,
                              value: provider.currencyCovertTo,
                              items:
                                  currencies.map((Map<String, dynamic> value) {
                                return DropdownMenuItem<Map<String, dynamic>>(
                                    value: value,
                                    child: Text(
                                      value['code'],
                                      textAlign: TextAlign.center,
                                      style:
                                          ViewDecoration.textStyleBoldPoppins(
                                              Theme.of(context).primaryColor,
                                              15.sp),
                                    ));
                              }).toList(),
                              onChanged: (_) {
                                provider.currencyCovertTo = _;
                                provider.calculateOverhead();
                              },
                            ),
                          ),
                        )
                      ]),
                      TableRow(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _setupKeyCell(context, 'roe'.tr()),
                            SizedBox(
                              width: 8.w,
                            ),
                            GestureDetector(
                              onTap: () {
                                CommonFunction.openUrl(currencyConverterUrl,
                                    launchMode: LaunchMode.inAppBrowserView);
                              },
                              child: Text(
                                'Click here ROE table',
                                style: ViewDecoration.textStyleSemiBoldPoppins(
                                    Colors.blue, 14.sp, true),
                              ),
                            )
                          ],
                        ),
                        _setupValueCell(context, '',
                            isEditable: true,
                            controller: provider.roeController,
                            provider: provider)
                      ]),
                      TableRow(children: [
                        _setupKeyCell(context, 'quantity'.tr()),
                        _setupValueCell(context, '',
                            isEditable: true,
                            controller: provider.quantityController,
                            provider: provider)
                      ]),
                      TableRow(children: [
                        _setupKeyCell(context, "${'overhead'.tr()} (in %)"),
                        _setupValueCell(context, '',
                            isEditable: true,
                            controller: provider.overheadController,
                            provider: provider)
                      ]),
                      TableRow(children: [
                        _setupKeyCell(
                            context, "${'discount_percentage'.tr()} (in %)"),
                        _setupValueCell(context, '',
                            isEditable: true,
                            controller: provider.discountPerController,
                            provider: provider)
                      ]),
                      TableRow(children: [
                        _setupKeyCell(context, 'profit_margin'.tr()),
                        _setupValueCell(context, '3.00',
                            isEditable: true,
                            controller: provider.profitMarginController,
                            provider: provider)
                      ]),
                      TableRow(children: [
                        _setupKeyCell(context, 'hourly_rate'.tr()),
                        _setupValueCell(context, '',
                            isEditable: true,
                            controller: provider.hourlyRateController,
                            provider: provider)
                      ]),
                      TableRow(children: [
                        _setupKeyCell(context, "${'sales_tax'.tr()} (in %)"),
                        _setupValueCell(context, '',
                            isEditable: true,
                            controller: provider.salesTaxController,
                            provider: provider)
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
                                "Material ${provider.currency!['code']}",
                                style: ViewDecoration.textStyleBoldPoppins(
                                    kWhiteColor, 20.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  context.pushNamed(AppPaths.material, extra: {
                                    'from': "ADD_PRODUCT"
                                  }).then((value) {
                                    if (value != null) {
                                      provider
                                          .addMaterial(value as MaterialModel);
                                    }
                                  });
                                },
                                child: ImageView(
                                  path: addIcon,
                                  width: 20.w,
                                  height: 20.w,
                                ),
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
                            _tableCellKey(
                                context,
                                provider.materialList.isEmpty
                                    ? BorderRadius.only(
                                        bottomLeft: Radius.circular(18.r),
                                      )
                                    : BorderRadius.zero,
                                kWhiteColor,
                                Theme.of(context).primaryColor,
                                "inventory".tr()),
                            _tableCellKey(
                                context,
                                BorderRadius.zero,
                                kWhiteColor,
                                Theme.of(context).primaryColor,
                                "how_many_units".tr()),
                            _tableCellKey(
                                context,
                                provider.materialList.isEmpty
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(18.r),
                                      )
                                    : BorderRadius.zero,
                                kPinkColor.withOpacity(.8),
                                kWhiteColor,
                                "total_cost".tr(),
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill),
                          ]),
                          for (int i = 0; i < provider.materialList.length; i++)
                            TableRow(children: [
                              _tableCellValue(
                                  context,
                                  provider.materialList.length - 1 == i
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(18.r),
                                        )
                                      : BorderRadius.zero,
                                  kWhiteColor,
                                  Theme.of(context).primaryColor,
                                  '${provider.materialList[i].name}'),
                              _tableCellValue(
                                  context,
                                  BorderRadius.zero,
                                  kWhiteColor,
                                  Theme.of(context).primaryColor,
                                  "",
                                  isEditable: true,
                                  materialModel: provider.materialList[i],
                                  provider: provider,
                                  index: i),
                              _tableCellValue(
                                  context,
                                  provider.materialList.length - 1 == i
                                      ? BorderRadius.only(
                                          bottomRight: Radius.circular(18.r),
                                        )
                                      : BorderRadius.zero,
                                  kPinkColor.withOpacity(.8),
                                  kWhiteColor,
                                  provider.materialList[i].totalCost ?? '',
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
                                "${'labor_cost'.tr()} ${provider.currency!['code']}",
                                style: ViewDecoration.textStyleBoldPoppins(
                                    kWhiteColor, 20.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  provider.addlaborCost();
                                },
                                child: ImageView(
                                  path: addIcon,
                                  width: 20.w,
                                  height: 20.w,
                                ),
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
                            _tableCellKey(
                                context,
                                provider.laborCostList.isEmpty
                                    ? BorderRadius.only(
                                        bottomLeft: Radius.circular(18.r),
                                      )
                                    : BorderRadius.zero,
                                kWhiteColor,
                                Theme.of(context).primaryColor,
                                "activity".tr()),
                            _tableCellKey(
                                context,
                                BorderRadius.zero,
                                kWhiteColor,
                                Theme.of(context).primaryColor,
                                "minutes_to_complete".tr()),
                            _tableCellKey(
                                context,
                                provider.laborCostList.isEmpty
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(18.r),
                                      )
                                    : BorderRadius.zero,
                                kPinkColor.withOpacity(.8),
                                kWhiteColor,
                                "labor_cost_per".tr(),
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill),
                          ]),
                          for (int i = 0;
                              i < provider.laborCostList.length;
                              i++)
                            TableRow(children: [
                              _laborTableActivityCellValue(
                                  context,
                                  provider.laborCostList.length - 1 == i
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(18.r),
                                        )
                                      : BorderRadius.zero,
                                  kWhiteColor,
                                  Theme.of(context).primaryColor,
                                  '',
                                  laborCostModel: provider.laborCostList[i],
                                  provider: provider,
                                  index: i),
                              _laborTableMinsCellValue(context, kWhiteColor,
                                  Theme.of(context).primaryColor, "",
                                  isEditable: true,
                                  laborCostModel: provider.laborCostList[i],
                                  provider: provider,
                                  textInputType: const TextInputType.numberWithOptions(decimal: true),
                                  index: i),
                              _laborTablelaborCellValue(
                                  context,
                                  provider.laborCostList.length - 1 == i
                                      ? BorderRadius.only(
                                          bottomRight: Radius.circular(18.r),
                                        )
                                      : BorderRadius.zero,
                                  kPinkColor.withOpacity(.8),
                                  kWhiteColor,
                                  provider.laborCostList[i].laborCost ?? '',
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
                                "Other Expenses ${provider.currency!['code']}",
                                style: ViewDecoration.textStyleBoldPoppins(
                                    kWhiteColor, 20.sp),
                              ),
                              GestureDetector(
                                onTap: () {
                                  provider.addOtherExpense();
                                },
                                child: ImageView(
                                  path: addIcon,
                                  width: 20.w,
                                  height: 20.w,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Table(
                        columnWidths: const {
                          0: FlexColumnWidth(4),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(3),
                          3: FlexColumnWidth(3),
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
                            _tableCellKey(
                                context,
                                provider.otherExpensesList.isEmpty
                                    ? BorderRadius.only(
                                        bottomLeft: Radius.circular(18.r),
                                      )
                                    : BorderRadius.zero,
                                kWhiteColor,
                                Theme.of(context).primaryColor,
                                "item".tr()),
                            _tableCellKey(
                                context,
                                BorderRadius.zero,
                                kWhiteColor,
                                Theme.of(context).primaryColor,
                                "units".tr()),
                            _tableCellKey(
                                context,
                                BorderRadius.zero,
                                kWhiteColor,
                                Theme.of(context).primaryColor,
                                "cost".tr(),
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill),
                            _tableCellKey(
                                context,
                                provider.otherExpensesList.isEmpty
                                    ? BorderRadius.only(
                                        bottomRight: Radius.circular(18.r),
                                      )
                                    : BorderRadius.zero,
                                kPinkColor.withOpacity(.8),
                                kWhiteColor,
                                "total_per_expenses".tr(),
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill),
                          ]),
                          for (int i = 0;
                              i < provider.otherExpensesList.length;
                              i++)
                            TableRow(children: [
                              _otherExpensesTableItemCellKey(
                                  context,
                                  provider.otherExpensesList.length - 1 == i
                                      ? BorderRadius.only(
                                          bottomLeft: Radius.circular(18.r),
                                        )
                                      : BorderRadius.zero,
                                  kWhiteColor,
                                  Theme.of(context).primaryColor),
                              _otherExpensesTableUnitsCellKey(
                                  context,
                                  BorderRadius.zero,
                                  kWhiteColor,
                                  Theme.of(context).primaryColor,
                                  provider: provider,
                                  index: i),
                              _otherExpensesTableCostCellKey(
                                  context,
                                  BorderRadius.zero,
                                  kWhiteColor,
                                  Theme.of(context).primaryColor,
                                  provider: provider,
                                  index: i),
                              _otherExpensesTableCellKey(
                                  context,
                                  provider.otherExpensesList.length - 1 == i
                                      ? BorderRadius.only(
                                          bottomRight: Radius.circular(18.r),
                                        )
                                      : BorderRadius.zero,
                                  kPinkColor.withOpacity(.8),
                                  kWhiteColor,
                                  provider.otherExpensesList[i].totalPerExpense,
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
                            _setupKeyCell(context, 'inventory'.tr()),
                            _setupValueCell(
                                context, '${provider.currency!['code']}'),
                            _setupValueCell(context, provider.materials,
                                radiusGeometry: BorderRadius.only(
                                    topRight: Radius.circular(18.r)),
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'labor_cost'.tr()),
                            _setupValueCell(
                                context, '${provider.currency!['code']}'),
                            _setupValueCell(context, provider.laborCost,
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'other_expenses'.tr()),
                            _setupValueCell(
                                context, '${provider.currency!['code']}'),
                            _setupValueCell(context, provider.otherExpenses,
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'overhead'.tr()),
                            _setupValueCell(
                                context, '${provider.currency!['code']}'),
                            _setupValueCell(context, provider.overhead,
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'discount_amount'.tr()),
                            _setupValueCell(
                                context, '${provider.currency!['code']}',
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill),
                            _setupValueCell(
                              context,
                              provider.discountAmount,
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor,
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                            )
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'sale_tax'.tr()),
                            _setupValueCell(
                                context, '${provider.currency!['code']}'),
                            _setupValueCell(context, provider.saleTax,
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'total_cost_to_make'.tr()),
                            _setupValueCell(
                                context, '${provider.currency!['code']}',
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill),
                            _setupValueCell(context, provider.totalCostToMake,
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
                            _setupKeyCell(context,
                                "Convert to ${provider.currencyCovertTo!['code']}"),
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'retail_price'.tr()),
                            _setupValueCell(context, provider.getRetailPrice()),
                            _setupValueCell(
                                context,
                                provider.getConvertedPrice(
                                    provider.getRetailPrice()),
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor,
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'sale_price'.tr()),
                            _setupValueCell(context, provider.getSalePrice()),
                            _setupValueCell(
                                context,
                                provider
                                    .getConvertedPrice(provider.getSalePrice()),
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor,
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'wholesale_price'.tr()),
                            _setupValueCell(
                                context, provider.getWholesalePrice()),
                            _setupValueCell(
                              context,
                              provider.getConvertedPrice(
                                  provider.getWholesalePrice()),
                              bgColor: kPinkColor.withOpacity(.8),
                              textColor: kWhiteColor,
                              verticalAlignment:
                                  TableCellVerticalAlignment.fill,
                              radiusGeometry: BorderRadius.only(
                                  bottomRight: Radius.circular(18.r)),
                            )
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
                            _setupKeyCell(context,
                                "Convert to ${provider.currencyCovertTo!['code']}"),
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'retail_profit'.tr()),
                            _setupValueCell(
                                context, provider.getRetailProfit()),
                            _setupValueCell(
                                context,
                                provider.getConvertedPrice(
                                    provider.getRetailProfit()),
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor,
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'sale_profit'.tr()),
                            _setupValueCell(context, provider.getSaleProfit()),
                            _setupValueCell(
                                context,
                                provider.getConvertedPrice(
                                    provider.getSaleProfit()),
                                bgColor: kPinkColor.withOpacity(.8),
                                textColor: kWhiteColor,
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill)
                          ]),
                          TableRow(children: [
                            _setupKeyCell(context, 'wholesale_profit'.tr()),
                            _setupValueCell(
                                context, provider.getWholesaleProfit(),
                                verticalAlignment:
                                    TableCellVerticalAlignment.fill),
                            _setupValueCell(
                                context,
                                provider.getConvertedPrice(
                                    provider.getWholesaleProfit()),
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              KeyboardHelper.hideKeyboard(context);
                              await provider.addProduct(
                                  context, _nameController.text.trim());
                            }
                          },
                        ),
                ],
              ),
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

  _setupValueCell(BuildContext context, String text,
      {Color? bgColor,
      TableCellVerticalAlignment? verticalAlignment,
      BorderRadiusGeometry? radiusGeometry,
      Color? textColor,
      bool isEditable = false,
      TextEditingController? controller,
      AddProductProvider? provider}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.top,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: bgColor ?? kWhiteColor, borderRadius: radiusGeometry),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
          child: isEditable
              ? TextFormField(
                  onChanged: (value) {
                    provider?.calculateOverhead();
                  },
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  style: ViewDecoration.textStyleBoldPoppins(
                      Theme.of(context).primaryColor, 15.sp),
                  decoration: ViewDecoration.textFiledDecorationWithoutBorder(
                      fillColor: kWhiteColor),
                )
              : Center(
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

  _otherExpensesTableCellKey(
      BuildContext context,
      BorderRadiusGeometry? radiusGeometry,
      Color kWhiteColor,
      Color textColor,
      String text,
      {TableCellVerticalAlignment? verticalAlignment}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.top,
      child: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: kWhiteColor, borderRadius: radiusGeometry),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
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

  _otherExpensesTableItemCellKey(BuildContext context,
      BorderRadiusGeometry? radiusGeometry, Color kWhiteColor, Color textColor,
      {TableCellVerticalAlignment? verticalAlignment}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.top,
      child: TextFormField(
        textAlign: TextAlign.center,
        onChanged: (value) {},
        keyboardType: TextInputType.text,
        style: ViewDecoration.textStyleBoldPoppins(
            Theme.of(context).primaryColor, 15.sp),
        decoration: ViewDecoration.textFiledDecorationWithoutBorder(
            fillColor: kWhiteColor),
      ),
    );
  }

  _otherExpensesTableUnitsCellKey(BuildContext context,
      BorderRadiusGeometry? radiusGeometry, Color kWhiteColor, Color textColor,
      {TableCellVerticalAlignment? verticalAlignment,
      AddProductProvider? provider,
      int? index}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.top,
      child: TextFormField(
        textAlign: TextAlign.center,
        onChanged: (value) {
          provider?.otherExpensesList[index!].units = value;
          provider?.calculateOtherExpenses(index);
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: ViewDecoration.textStyleBoldPoppins(
            Theme.of(context).primaryColor, 15.sp),
        decoration: ViewDecoration.textFiledDecorationWithoutBorder(
            fillColor: kWhiteColor),
      ),
    );
  }

  _otherExpensesTableCostCellKey(BuildContext context,
      BorderRadiusGeometry? radiusGeometry, Color kWhiteColor, Color textColor,
      {TableCellVerticalAlignment? verticalAlignment,
      AddProductProvider? provider,
      int? index}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.top,
      child: TextFormField(
        textAlign: TextAlign.center,
        onChanged: (value) {
          provider?.otherExpensesList[index!].cost = value;
          provider?.calculateOtherExpenses(index);
        },
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        style: ViewDecoration.textStyleBoldPoppins(
            Theme.of(context).primaryColor, 15.sp),
        decoration: ViewDecoration.textFiledDecorationWithoutBorder(
            fillColor: kWhiteColor),
      ),
    );
  }

  _tableCellValue(BuildContext context, BorderRadiusGeometry? radiusGeometry,
      Color kWhiteColor, Color textColor, String text,
      {TableCellVerticalAlignment? verticalAlignment,
      bool isEditable = false,
      MaterialModel? materialModel,
      AddProductProvider? provider,
      int? index}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.middle,
      child: isEditable
          ? TextFormField(
              textAlign: TextAlign.center,
              onChanged: (value) {
                provider?.calculateCost(value, materialModel, index!);
              },
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: ViewDecoration.textStyleBoldPoppins(
                  Theme.of(context).primaryColor, 15.sp),
              decoration: ViewDecoration.textFiledDecorationWithoutBorder(
                  fillColor: kWhiteColor),
            )
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: kWhiteColor, borderRadius: radiusGeometry),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                child: Center(
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    style:
                        ViewDecoration.textStyleBoldPoppins(textColor, 15.sp),
                  ),
                ),
              ),
            ),
    );
  }

  _laborTableActivityCellValue(
      BuildContext context,
      BorderRadiusGeometry? radiusGeometry,
      Color kWhiteColor,
      Color textColor,
      String text,
      {TableCellVerticalAlignment? verticalAlignment,
      LaborCostModel? laborCostModel,
      AddProductProvider? provider,
      int? index}) {
    return TableCell(
        verticalAlignment:
            verticalAlignment ?? TableCellVerticalAlignment.middle,
        child: TextFormField(
          textAlign: TextAlign.center,
          onChanged: (value) {
            provider?.laborCostList[index!].activity = value;
          },
          keyboardType: TextInputType.text,
          style: ViewDecoration.textStyleBoldPoppins(
              Theme.of(context).primaryColor, 15.sp),
          decoration: ViewDecoration.textFiledDecorationWithoutBorder(
              fillColor: kWhiteColor),
        ));
  }

  _laborTablelaborCellValue(
      BuildContext context,
      BorderRadiusGeometry? radiusGeometry,
      Color kWhiteColor,
      Color textColor,
      String text,
      {TableCellVerticalAlignment? verticalAlignment}) {
    return TableCell(
      verticalAlignment: verticalAlignment ?? TableCellVerticalAlignment.middle,
      child: Container(
        alignment: Alignment.center,
        decoration:
            BoxDecoration(color: kWhiteColor, borderRadius: radiusGeometry),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 0, horizontal: 12.w),
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

  _laborTableMinsCellValue(
      BuildContext context, Color kWhiteColor, Color textColor, String text,
      {TableCellVerticalAlignment? verticalAlignment,
      bool isEditable = false,
      LaborCostModel? laborCostModel,
      AddProductProvider? provider,
      TextInputType? textInputType,
      int? index}) {
    return TableCell(
        verticalAlignment:
            verticalAlignment ?? TableCellVerticalAlignment.middle,
        child: TextFormField(
          textAlign: TextAlign.center,
          onChanged: (value) {
            provider?.laborCostList[index!].mintsToComplete = value;
            provider?.calculatelabor(index);
          },
          keyboardType: textInputType,
          style: ViewDecoration.textStyleBoldPoppins(
              Theme.of(context).primaryColor, 15.sp),
          decoration: ViewDecoration.textFiledDecorationWithoutBorder(
              fillColor: kWhiteColor),
        ));
  }
}
