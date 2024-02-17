import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/colors_constants.dart';
import '../enums/viewstate.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../helpers/keyboard_helper.dart';
import '../helpers/validations.dart';
import '../provider/forgot_password_provider.dart';
import '../widgets/primary_button.dart';
import 'base_view.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ForgotPasswordViewState createState() => ForgotPasswordViewState();
}

class ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BaseView<ForgotPasswordProvider>(
        builder: (context, provider, _) => GestureDetector(
              onTap: () {
                KeyboardHelper.hideKeyboard(context);
              },
              child: Scaffold(
                backgroundColor: kBgColor,
                resizeToAvoidBottomInset: false,
                appBar: CommonFunction.appBar('password_reset'.tr(), context),
                body: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 40.h, 16.w, 24.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.w),
                          child: Text(
                            'email_address'.tr(),
                            style: ViewDecoration.textStyleSemiBoldPoppins(
                              Theme.of(context).primaryColor, 20.sp,),
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        TextFormField(
                          controller: _emailController,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return 'empty_email_address'.tr();
                            } else if (value.trim().isNotEmpty &&
                                !Validations.emailValidation(value)) {
                              return 'invalid_email'.tr();
                            } else {
                              return null;
                            }
                          },
                          style: ViewDecoration.textStyleMediumPoppins(
                              kBlackColor, 16.sp),
                          decoration: ViewDecoration.textFiledDecoration(
                              hintText:'enter_email_address'.tr(),fillColor: kWhiteColor),
                        ),
                        const Spacer(),
                        provider.state == ViewState.busy
                            ? const Center(
                                child: CircularProgressIndicator(),
                              )
                            : PrimaryButton(
                                width: MediaQuery.of(context).size.width,
                                height: 52.h,
                                title: 'go_to_reset_password'.tr(),
                                radius: 20.r,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    KeyboardHelper.hideKeyboard(context);
                                    provider
                                        .resetPassword(_emailController.text)
                                        .then((value) {
                                      if (value) {
                                        Navigator.of(context).pop();
                                      }
                                    });
                                  }
                                },
                              ),
                        SizedBox(
                          height: 32.h,
                        ),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'return_to_login_screen'.tr(),
                              style: ViewDecoration.textStyleMediumPoppins(
                                  Theme.of(context).primaryColor, 15.sp, true),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
  }
}
