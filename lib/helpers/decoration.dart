import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/colors_constants.dart';
import '../constants/string_constants.dart';
import '../widgets/image_view.dart';

class ViewDecoration {
  static InputDecoration textFiledDecoration(
      {String? hintText, Color? fillColor, String? suffixIcon}) {
    return InputDecoration(
      counterText: null,
      errorMaxLines: 2,
      alignLabelWithHint: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintText: hintText,
      hintStyle: ViewDecoration.textStyleMediumPoppins(kGreyColor.withOpacity(.7), 16.sp),
      border: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),
      errorBorder: outlineInputBorder(),
      filled: true,
      suffixIcon: suffixIcon != null ? buildCustomPrefixIcon(suffixIcon) : null,
      fillColor: fillColor,
      disabledBorder: outlineInputBorder(),
    );
  }

  static InputDecoration passwordTextFiledDecoration([
    String? hintText,
    Color? fillColor,
    bool? showPassword,
    VoidCallback? onSuffixTap,
  ]) {
    return InputDecoration(
      counterText: null,
      errorMaxLines: 2,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      hintText: hintText,
      hintStyle: ViewDecoration.textStyleMediumPoppins(kGreyColor.withOpacity(.7), 16.sp),
      border: outlineInputBorder(),
      focusedBorder: outlineInputBorder(),
      enabledBorder: outlineInputBorder(),
      errorBorder: outlineInputBorder(),
      filled: true,
      fillColor: fillColor,
      disabledBorder: outlineInputBorder(),
      suffixIcon: GestureDetector(
        onTap: onSuffixTap,
        child: Icon(
          showPassword! ? Icons.visibility : Icons.visibility_off,
          color: kPrimaryColor,
        ),
      ),
    );
  }

  static InputDecoration searchBarDecoration(
      {String? hintText, Color? fillColor, String? prefixIcon}) {
    return InputDecoration(
      counterText: null,
      errorMaxLines: 2,
      isCollapsed: true,
      isDense: true,
      alignLabelWithHint: true,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      hintText: hintText,
      hintStyle: ViewDecoration.textStyleRegular(kWhiteColor, 14.sp),
      border: outlineInputWithoutBorder(),
      focusedBorder: outlineInputWithoutBorder(),
      enabledBorder: outlineInputWithoutBorder(),
      errorBorder: outlineInputWithoutBorder(),
      filled: true,
      prefixIcon: prefixIcon != null ? buildCustomPrefixIcon(prefixIcon) : null,
      fillColor: fillColor,
      disabledBorder: outlineInputWithoutBorder(),
    );
  }

  static OutlineInputBorder outlineInputBorder([double? radius]) {
    return OutlineInputBorder(
      borderSide: const BorderSide(color: kPrimaryColor),
      borderRadius: BorderRadius.circular(radius ?? 12.r),
    );
  }

  static OutlineInputBorder outlineInputWithoutBorder([double? radius]) {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(radius ?? 12.r),
    );
  }

  static TextStyle textStyleRegular(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: inter,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w400,
        fontSize: textSize);
  }

  static TextStyle textStyleMedium(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: inter,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w500,
        fontSize: textSize);
  }

  static TextStyle textStyleSemiBold(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: inter,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w600,
        fontSize: textSize);
  }

  static TextStyle textStyleBold(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: inter,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w700,
        fontSize: textSize);
  }

  static TextStyle textStyleRegularPoppins(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: poppins,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w400,
        fontSize: textSize);
  }

  static TextStyle textStyleMediumPoppins(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: poppins,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w500,
        fontSize: textSize);
  }

  static TextStyle textStyleSemiBoldPoppins(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: poppins,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w600,
        fontSize: textSize);
  }

  static TextStyle textStyleBoldPoppins(Color color, double textSize,
      [bool isUnderLine = false]) {
    return TextStyle(
        color: color,
        fontFamily: poppins,
        fontStyle: FontStyle.normal,
        decoration:
            isUnderLine ? TextDecoration.underline : TextDecoration.none,
        fontWeight: FontWeight.w700,
        fontSize: textSize);
  }

  static Widget buildCustomPrefixIcon(String iconPath) {
    return Container(
      width: 0,
      alignment: const Alignment(-0.99, 0.0),
      child: Padding(
        padding: EdgeInsets.only(left: 14.w, right: 14.w),
        child: ImageView(
          path: iconPath,
        ),
      ),
    );
  }
}
