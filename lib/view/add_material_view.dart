import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/provider/add_material_provider.dart';
import 'package:smalll_business_bestie/view/base_view.dart';
import '../constants/colors_constants.dart';
import '../enums/viewstate.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../helpers/keyboard_helper.dart';
import '../widgets/primary_button.dart';

class AddMaterialView extends StatefulWidget {
  const AddMaterialView({super.key});

  @override
  AddMaterialViewState createState() => AddMaterialViewState();
}

class AddMaterialViewState extends State<AddMaterialView> {
  final _nameController = TextEditingController();
  final _costController = TextEditingController();
  final _minQuantityController = TextEditingController();
  final _quantityInStockController = TextEditingController();
  final _inSoldController = TextEditingController();
  final _stockValueController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<AddMaterialProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: CommonFunction.appBarWithButtons('add_material'.tr(), context,
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
                  controller: _nameController,
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
                  controller: _costController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
                  controller: _minQuantityController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
                  controller: _quantityInStockController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
                  controller: _inSoldController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
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
                  controller: _stockValueController,
                  textInputAction: TextInputAction.done,
                  keyboardType: TextInputType.number,
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
                  height: 32.h,
                ),
                provider.state == ViewState.busy
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : PrimaryButton(
                        width: MediaQuery.of(context).size.width,
                        height: 52.h,
                        title: 'add_material'.tr(),
                        radius: 20.r,
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            KeyboardHelper.hideKeyboard(context);
                            provider.addMaterial(
                              context,
                              _nameController.text.trim(),
                              _costController.text.trim(),
                              _minQuantityController.text.trim(),
                              _quantityInStockController.text.trim(),
                              _inSoldController.text.trim(),
                              _stockValueController.text.trim(),
                            );
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
