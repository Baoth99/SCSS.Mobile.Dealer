import 'package:flutter/material.dart';

class CustomWidget {
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
}
