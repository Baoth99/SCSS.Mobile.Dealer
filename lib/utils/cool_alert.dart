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
    String? confirmBtnTapRoute,
  }) {
    return CoolAlert.show(
        barrierDismissible: false,
        context: context,
        type: type ?? CoolAlertType.info,
        title: title,
        text: text,
        confirmBtnColor: confirmBtnColor ?? Theme.of(context).accentColor,
        confirmBtnText: confirmBtnText ?? CustomTexts.closeText,
        onConfirmBtnTap: () {
          if (confirmBtnTapRoute != null) {
            Navigator.popUntil(
              context,
              ModalRoute.withName(
                confirmBtnTapRoute,
              ),
            );
          } else {
            Navigator.pop(context);
          }
        });
  }
}
