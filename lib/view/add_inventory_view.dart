import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/models/material_model.dart';
import 'package:smalll_business_bestie/provider/add_material_provider.dart';
import 'package:smalll_business_bestie/view/base_view.dart';
import '../constants/colors_constants.dart';
import '../enums/viewstate.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../helpers/keyboard_helper.dart';
import '../widgets/primary_button.dart';

class AddInventoryView extends StatefulWidget {
  final MaterialModel? materialModel;

  const AddInventoryView({super.key, this.materialModel});

  @override
  AddInventoryViewState createState() => AddInventoryViewState();
}

class AddInventoryViewState extends State<AddInventoryView> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<AddMaterialProvider>(
      onModelReady: (provider){
        provider.setData(widget.materialModel);
      },
        builder: (context, provider, _) {
      return Scaffold(
        appBar: CommonFunction.appBarWithButtons( widget.materialModel==null?'add_inventory'.tr():"Update Inventory", context,
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
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'name'.tr(),
                    style: ViewDecoration.textStyleSemiBoldPoppins(
                      Theme.of(context).primaryColor,
                      20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  controller: provider.nameController,
                  textInputAction: TextInputAction.next,
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
                      hintText: 'name'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    "${'cost'.tr()} (in USD)",
                    style: ViewDecoration.textStyleSemiBoldPoppins(
                      Theme.of(context).primaryColor,
                      20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  controller: provider.costController,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'required'.tr();
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    provider.getStockStatus();
                    provider.getStockValue();
                  },
                  style:
                      ViewDecoration.textStyleMediumPoppins(kBlackColor, 16.sp),
                  decoration: ViewDecoration.textFiledDecoration(
                      hintText: 'cost'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'min_quantity'.tr(),
                    style: ViewDecoration.textStyleSemiBoldPoppins(
                      Theme.of(context).primaryColor,
                      20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  controller: provider.minQuantityController,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    provider.getStockStatus();
                    provider.getStockValue();
                  },
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
                      hintText: 'min_quantity'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'quantity_in_stock'.tr(),
                    style: ViewDecoration.textStyleSemiBoldPoppins(
                      Theme.of(context).primaryColor,
                      20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  controller: provider.quantityInStockController,
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (value) {
                    provider.getStockStatus();
                    provider.getStockValue();
                  },
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
                      hintText: 'quantity_in_stock'.tr(),
                      fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'insold_value'.tr(),
                    style: ViewDecoration.textStyleSemiBoldPoppins(
                      Theme.of(context).primaryColor,
                      20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  controller: TextEditingController(text: provider.inSold),
                  textInputAction: TextInputAction.next,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  readOnly: true,
                  style:
                      ViewDecoration.textStyleMediumPoppins(kBlackColor, 16.sp),
                  decoration: ViewDecoration.textFiledDecoration(
                      hintText: 'insold_value'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'stock_value'.tr(),
                    style: ViewDecoration.textStyleSemiBoldPoppins(
                      Theme.of(context).primaryColor,
                      20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  controller: TextEditingController(text: provider.stockValue),
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  readOnly: true,
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
                      hintText: 'stock_value'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'stock_status'.tr(),
                    style: ViewDecoration.textStyleSemiBoldPoppins(
                      Theme.of(context).primaryColor,
                      20.sp,
                    ),
                  ),
                ),
                SizedBox(
                  height: 8.h,
                ),
                TextFormField(
                  controller:
                      TextEditingController(text: provider.stockStatusString),
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  readOnly: true,
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
                      hintText: 'stock_status'.tr(), fillColor: kWhiteColor),
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
                        title: widget.materialModel==null? 'add_inventory'.tr():"Update Inventory",
                        radius: 20.r,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            KeyboardHelper.hideKeyboard(context);
                            provider.addMaterial(context);
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
}
