import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    Key? key,
    required this.text,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.overflow,
  }) : super(key: key);

  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: textAlign,
    );
  }
}
