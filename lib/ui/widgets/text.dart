import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget customText(
    {required String text, Alignment? alignment, double? fontSize}) {
  return Container(
    height: 50,
    alignment: alignment ?? Alignment.centerLeft,
    child: Text(
      text,
      style: TextStyle(fontSize: fontSize ?? 15),
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
