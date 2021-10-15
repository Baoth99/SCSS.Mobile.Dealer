import 'package:flutter/material.dart';

Widget customText({
  required String text,
  Alignment? alignment,
  double? fontSize,
  TextAlign? textAlign,
  Color? color,
  double? height,
  TextStyle? textStyle,
}) {
  return Container(
    height: height ?? 50,
    alignment: alignment ?? Alignment.centerLeft,
    child: Text(
      text,
      style: textStyle ??
          TextStyle(
            fontSize: fontSize ?? 15,
            color: color ?? Color.fromARGB(255, 20, 20, 21),
          ),
      textAlign: textAlign ?? TextAlign.left,
    ),
  );
}

Widget customTextButton(
    {required String text, Alignment? alignment, double? fontSize, onPressed}) {
  return Container(
    height: 50,
    alignment: alignment ?? Alignment.centerLeft,
    child: TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: fontSize ?? 15),
      ),
    ),
  );
}
