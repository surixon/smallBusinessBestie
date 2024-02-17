import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors_constants.dart';
import '../constants/string_constants.dart';
import '../enums/viewstate.dart';
import '../helpers/common_function.dart';
import '../helpers/decoration.dart';
import '../helpers/keyboard_helper.dart';
import '../helpers/validations.dart';
import '../locator.dart';
import '../provider/create_account_provider.dart';
import '../widgets/primary_button.dart';
import 'base_view.dart';

class CreateAccountView extends StatefulWidget {
  const CreateAccountView({super.key});

  @override
  CreateAccountViewState createState() => CreateAccountViewState();
}

class CreateAccountViewState extends State<CreateAccountView> {

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  final _formKey = GlobalKey<FormState>();


  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateAccountProvider>(
      onModelReady: (provider){

      },
        builder: (context, provider, _) => GestureDetector(
              onTap: () {
                KeyboardHelper.hideKeyboard(context);
              },
              child: Scaffold(
                backgroundColor: kBgColor,
                resizeToAvoidBottomInset: false,
                appBar: CommonFunction.appBar('create_account'.tr(), context),
                body: SingleChildScrollView(
                  child: Padding(
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
                            style: ViewDecoration.textStyleMediumPoppins(
                                kBlackColor, 16.sp),
                            decoration: ViewDecoration.textFiledDecoration(
                                hintText: 'email_address'.tr(),fillColor: kWhiteColor),
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
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              'password'.tr(),
                              style: ViewDecoration.textStyleSemiBoldPoppins(
                                Theme.of(context).primaryColor, 20.sp,),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.text,
                            obscureText: !provider.showPassword,
                            style: ViewDecoration.textStyleMediumPoppins(
                                kBlackColor, 16.sp),
                            decoration:
                                ViewDecoration.passwordTextFiledDecoration(
                                    'password'.tr(),
                                    kWhiteColor,
                                    provider.showPassword, () {
                              provider.showPassword = !provider.showPassword;
                            }),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'empty_password'.tr();
                              } else if (value.trim().isNotEmpty &&
                                  value.length < 8) {
                                return 'invalid_password'.tr();
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 16.h,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.w),
                            child: Text(
                              'confirm_password'.tr(),
                              style: ViewDecoration.textStyleSemiBoldPoppins(
                                Theme.of(context).primaryColor, 20.sp,),
                            ),
                          ),
                          SizedBox(
                            height: 8.h,
                          ),
                          TextFormField(
                            controller: _confirmPasswordController,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            obscureText: !provider.showConfirmPassword,
                            style: ViewDecoration.textStyleMediumPoppins(
                                kBlackColor, 16.sp),
                            decoration:
                                ViewDecoration.passwordTextFiledDecoration(
                              'confirm_password'.tr(),
                              kWhiteColor,
                              provider.showConfirmPassword,
                              () {
                                provider.showConfirmPassword =
                                    !provider.showConfirmPassword;
                              },
                            ),
                            validator: (value) {
                              if (value!.trim().isEmpty) {
                                return 'empty_confirm_password'.tr();
                              } else if (value.trim().isNotEmpty &&
                                  value != _passwordController.text.trim()) {
                                return 'password_not_match'.tr();
                              } else {
                                return null;
                              }
                            },
                          ),
                          SizedBox(
                            height: 146.h,
                          ),
                          Center(
                            child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: "${'before_registering'.tr()} ",
                                      style: ViewDecoration.textStyleMediumPoppins(
                                          kBlackColor, 15.sp),
                                      children: [
                                        TextSpan(
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                CommonFunction.openUrl(
                                                    termOfUseUrl);
                                              },
                                            text: 'terms_of_use'.tr(),
                                            style:
                                                ViewDecoration.textStyleMediumPoppins(
                                                    Theme.of(context).primaryColor, 15.sp, true),
                                            children: [

                                              TextSpan(
                                                  recognizer: TapGestureRecognizer()
                                                    ..onTap = () {
                                                      CommonFunction.openUrl(
                                                          privacyUrl);
                                                    },
                                                  text: " ${'privacy_policy'.tr()}",
                                                  style:
                                                  ViewDecoration.textStyleMediumPoppins(
                                                      Theme.of(context).primaryColor, 15.sp, true),
                                                  children: [
                                                    TextSpan(
                                                      text:
                                                      " ${'please_read_the_following'.tr()}",
                                                      style: ViewDecoration
                                                          .textStyleMediumPoppins(
                                                          kBlackColor, 15.sp),
                                                    ),
                                                  ]),
                                            ]),
                                      ]),
                                ])),
                          ),
                          SizedBox(
                            height: 12.h,
                          ),
                          provider.state == ViewState.busy
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : PrimaryButton(
                                  width: MediaQuery.of(context).size.width,
                                  height: 52.h,
                                  title: 'register_your_profile'.tr(),
                                  radius: 20.r,
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      KeyboardHelper.hideKeyboard(context);
                                      provider
                                          .signUp(
                                              _emailController.text.trim(),
                                              _passwordController.text.trim(),
                                              '')
                                          .then((value) {
                                        if (value) {
                                          Navigator.pop(context);
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
              ),
            ));
  }
}
