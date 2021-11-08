import 'package:dealer_app/utils/custom_progress_indicator_dialog_widget.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FunctionalWidgets {
  static Widget getErrorIcon() {
    return Icon(
      Icons.error,
      size: 180.sp,
      color: AppColors.red,
    );
  }

  static Widget getLoadingAnimation() {
    return const SpinKitRing(
      color: AppColors.greenFF61C53D,
    );
  }

  static Future<T?> showCustomDialog<T>(BuildContext context,
      [String text = 'Vui lòng đợi...', String? label]) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        child: CustomProgressIndicatorDialog(
          text: text,
          semanticLabel: label,
        ),
        onWillPop: () async => false,
      ),
    );
  }
}
