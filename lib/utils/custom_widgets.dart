import 'package:flutter/material.dart';

class CustomWidgets {
  static OutlinedButton customCancelButton(context, text) {
    return OutlinedButton(
      style:
          ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey)),
      onPressed: () => Navigator.pop(context),
      child: Text(text),
    );
  }

  static ElevatedButton customElevatedButton(context, text, action) {
    return ElevatedButton(onPressed: action, child: Text(text));
  }

  static OutlinedButton customSecondaryButton({
    context,
    required String text,
    action,
  }) {
    return OutlinedButton(
      onPressed: action ?? () {},
      child: Text(text),
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.grey),
      ),
    );
  }

  static AppBar customAppBar(
      {required BuildContext context, required String titleText}) {
    return AppBar(
      elevation: 1,
      title: Text(
        titleText,
        style: Theme.of(context).textTheme.headline2,
      ),
    );
  }

  static Widget customErrorWidget() {
    return Container(
      child: Center(
        child: Wrap(
          direction: Axis.vertical,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
            Text('Đã có lỗi xảy ra'),
          ],
        ),
      ),
    );
  }

  static CircleAvatar customAvatar({String? avatarLink}) {
    return CircleAvatar(
      backgroundColor: Colors.green,
      backgroundImage: AssetImage('assets/images/avatar_male_399x425.png'),
      foregroundImage: avatarLink != null ? NetworkImage(avatarLink) : null,
    );
  }

  static Widget customText(
      {required String text,
      Alignment? alignment,
      double? fontSize,
      TextAlign? textAlign,
      Color? color,
      double? height,
      TextStyle? textStyle,
      FontWeight? fontWeight}) {
    return Container(
      height: height ?? 50,
      alignment: alignment ?? Alignment.centerLeft,
      child: Text(
        text,
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 15,
              color: color ?? Color.fromARGB(255, 20, 20, 21),
              fontWeight: fontWeight,
            ),
        textAlign: textAlign ?? TextAlign.left,
      ),
    );
  }

  static Widget customTextButton(
      {required String text,
      Alignment? alignment,
      double? fontSize,
      onPressed}) {
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

  static Widget customDateText(
      {required DateTime time,
      Alignment? alignment,
      double? fontSize,
      TextAlign? textAlign,
      Color? color,
      double? height,
      TextStyle? textStyle,
      FontWeight? fontWeight}) {
    String weekday = '';
    switch (time.weekday) {
      case 1:
        weekday = 'THỨ HAI';
        break;
      case 2:
        weekday = 'THỨ BA';
        break;
      case 3:
        weekday = 'THỨ TƯ';
        break;
      case 4:
        weekday = 'THỨ NĂM';
        break;
      case 5:
        weekday = 'THỨ SÁU';
        break;
      case 6:
        weekday = 'THỨ BẢY';
        break;
      case 7:
        weekday = 'CHỦ NHẬT';
        break;
      default:
    }
    return Container(
      height: height ?? 50,
      alignment: alignment ?? Alignment.centerLeft,
      child: Text(
        '$weekday, ${time.day} THÁNG ${time.month}, ${time.year}',
        style: textStyle ??
            TextStyle(
              fontSize: fontSize ?? 15,
              color: color ?? Color.fromARGB(255, 20, 20, 21),
              fontWeight: fontWeight,
            ),
        textAlign: textAlign ?? TextAlign.left,
      ),
    );
  }
}
