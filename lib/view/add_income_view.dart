import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:smalll_business_bestie/provider/add_income_provider.dart';
import 'package:smalll_business_bestie/provider/add_material_provider.dart';
import 'package:smalll_business_bestie/view/base_view.dart';

import '../constants/colors_constants.dart';
import '../enums/viewstate.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../helpers/keyboard_helper.dart';
import '../widgets/primary_button.dart';

class AddIncomeView extends StatefulWidget {
  const AddIncomeView({super.key});

  @override
  AddIncomeViewState createState() => AddIncomeViewState();
}

class AddIncomeViewState extends State<AddIncomeView> {

  final _dateController = TextEditingController();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _taxController = TextEditingController();
  final _netIncomeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<AddIncomeProvider>(builder: (context, provider, _) {
      return Scaffold(
        appBar: CommonFunction.appBarWithButtons('add_income'.tr(), context,
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
                    'date'.tr(),
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
                  controller: _dateController,
                  readOnly: true,
                  validator: (value) {
                    if (value!.trim().isEmpty) {
                      return 'required'.tr();
                    } else {
                      return null;
                    }
                  },
                  onTap: () async {
                    await provider.showDobPicker(context).then((picked) {
                      if (picked != null &&
                          picked != provider.selectedDate) {
                        _dateController.text =
                            CommonFunction.getDateFromTimeStamp(
                                picked, "yyyy-MM-dd");
                        provider.selectedDate = picked;
                      }
                    });
                  },
                  style:
                  ViewDecoration.textStyleMediumPoppins(kBlackColor, 16.sp),
                  decoration: ViewDecoration.textFiledDecoration(
                      hintText: 'date'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'title'.tr(),
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
                  controller: _titleController,
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
                      hintText: 'title'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    'desc'.tr(),
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
                  controller: _descController,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.sentences,
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
                      hintText: 'desc'.tr(), fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    "${'tax'.tr()} (in %)",
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
                  controller: _taxController,
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
                      hintText: 'tax'.tr(),
                      fillColor: kWhiteColor),
                ),
                SizedBox(
                  height: 16.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    "${'net_income'.tr()} (in USD)",
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
                  controller: _netIncomeController,
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
                      hintText: 'net_income'.tr(), fillColor: kWhiteColor),
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
                  title: 'add_income'.tr(),
                  radius: 20.r,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      KeyboardHelper.hideKeyboard(context);
                      provider.addIncome(
                        context,

                        _titleController.text.trim(),
                        _descController.text.trim(),
                        _taxController.text.trim(),
                        _netIncomeController.text.trim(),
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
