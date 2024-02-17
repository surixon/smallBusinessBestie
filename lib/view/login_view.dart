import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../constants/colors_constants.dart';
import '../constants/image_constants.dart';
import '../enums/viewstate.dart';
import '../helpers/decoration.dart';
import '../helpers/keyboard_helper.dart';
import '../helpers/validations.dart';
import '../provider/login_provider.dart';
import '../routes.dart';
import '../widgets/image_view.dart';
import '../widgets/primary_button.dart';
import 'base_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return BaseView<LoginProvider>(
      onModelReady: (provider){

      },
        builder: (context, provider, _) => GestureDetector(
              onTap: () {
                KeyboardHelper.hideKeyboard(context);
              },
              child: Scaffold(
                backgroundColor: kBgColor,
                body: SingleChildScrollView(
                  child: SizedBox(
                    height: height,
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 24.h),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                             Center(
                              child:ImageView(
                                width: 330.w,
                                height: 87.h,
                                path: logo,
                              ),
                            ),
                            SizedBox(
                              height: 80.h,
                            ),
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
                              textInputAction: TextInputAction.done,
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
                            Align(
                              alignment: Alignment.topRight,
                              child: GestureDetector(
                                onTap: () {
                                  GoRouter.of(context)
                                      .pushNamed(AppPaths.forgotPassword);
                                },
                                child: Text(
                                  'forgot_your_password'.tr(),
                                  style: ViewDecoration.textStyleMediumPoppins(
                                      Theme.of(context).primaryColor, 16.sp),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 119.h,
                            ),
                            provider.state == ViewState.busy
                                ? const Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : PrimaryButton(
                                    width: MediaQuery.of(context).size.width,
                                    height: 52.h,
                                    title: 'login'.tr(),
                                    radius: 20.r,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        KeyboardHelper.hideKeyboard(context);
                                        provider.login(
                                            context,
                                            _emailController.text,
                                            _passwordController.text,
                                            '');
                                      }
                                    },
                                  ),
                            SizedBox(
                              height: 32.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'dont_have_account'.tr(),
                                  style: ViewDecoration.textStyleMediumPoppins(
                                      kBlackColor, 15.sp),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    GoRouter.of(context)
                                        .pushNamed(AppPaths.createAccount);
                                  },
                                  child: Text(
                                    'member_registration'.tr(),
                                    style: ViewDecoration.textStyleMediumPoppins(
                                        Theme.of(context).primaryColor, 15.sp, true),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }
}
