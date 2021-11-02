import 'package:cool_alert/cool_alert.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';

class CustomCoolAlert {
  static Future<dynamic> showCoolAlert({
    required BuildContext context,
    CoolAlertType? type,
    String? title,
    String? text,
    Color? confirmBtnColor,
    String? confirmBtnText,
    Function()? onTap,
  }) {
    return CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: type ?? CoolAlertType.info,
      title: title,
      text: text,
      confirmBtnColor: confirmBtnColor ?? Theme.of(context).accentColor,
      confirmBtnText: confirmBtnText ?? CustomTexts.closeText,
      onConfirmBtnTap: onTap ??
          () {
            Navigator.pop(context);
          },
    );
  }

  static Future<dynamic> showWarningAlert({
    required BuildContext context,
    CoolAlertType? type,
    String? title,
    String? text,
    Color? confirmBtnColor,
    String? confirmBtnText,
    String? cancelBtnText,
    Function()? onConfirmTap,
    Function()? onCancelTap,
  }) {
    return CoolAlert.show(
      barrierDismissible: false,
      context: context,
      type: type ?? CoolAlertType.info,
      title: title,
      text: text,
      confirmBtnColor: confirmBtnColor ?? Theme.of(context).accentColor,
      confirmBtnText: confirmBtnText ?? CustomTexts.ok,
      onConfirmBtnTap: onConfirmTap ??
          () {
            Navigator.pop(context);
          },
      showCancelBtn: true,
      cancelBtnText: cancelBtnText ?? CustomTexts.cancelButtonText,
      onCancelBtnTap: onCancelTap ??
          () {
            Navigator.pop(context);
          },
    );
  }
}
