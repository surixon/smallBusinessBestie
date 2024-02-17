import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../constants/colors_constants.dart';
import 'decoration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DialogHelper {
  static Future showDialogWithTwoButtons(
    BuildContext context,
    String okButtonText,
    String cancelButtonText,
    String title,
    String content, {
    VoidCallback? positiveButtonPress,
    VoidCallback? negativeButtonPress,
    barrierDismissible = true,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Center(
                child: Text(
                  title,
                  style: ViewDecoration.textStyleRegular(
                      kBlackColor, 14.sp),
                ),
              ),
              content: Text(
                content,
                style: ViewDecoration.textStyleRegular(
                    kBlackColor, 13.sp),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: negativeButtonPress,
                  child: Text(
                    cancelButtonText,
                    style: ViewDecoration.textStyleRegular(
                        Theme.of(context).primaryColor, 13),
                  ),
                ),
                CupertinoDialogAction(
                  onPressed: positiveButtonPress,
                  child: Text(
                    okButtonText,
                    style: ViewDecoration.textStyleRegular(
                        Theme.of(context).primaryColor, 13),
                  ),
                ),
              ],
            ));
  }

  static Future showDialogWithOneButton(
    BuildContext context,
    String title,
    String content,
    String buttonText, {
    VoidCallback? okButtonPress,
    barrierDismissible = true,
  }) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => CupertinoAlertDialog(
              title: Text(
                title,
                style: ViewDecoration.textStyleBold(Colors.black, 12),
              ),
              content: Text(
                content,
                style: ViewDecoration.textStyleRegular(Colors.black, 11),
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  onPressed: okButtonPress,
                  isDefaultAction: true,
                  child: Text(
                    buttonText,
                    style: ViewDecoration.textStyleBold(
                        Theme.of(context).primaryColor, 12),
                  ),
                ),
              ],
            ));
  }

  static showErrorMessage( String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  static showMessage( String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
