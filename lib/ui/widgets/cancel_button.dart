import 'package:flutter/material.dart';

OutlinedButton cancelButtonBuilder(context, text) {
  return OutlinedButton(
    style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.grey)),
    onPressed: () => Navigator.pop(context),
    child: Text(text),
  );
}

ElevatedButton customElevatedButton(context, text, action) {
  return ElevatedButton(onPressed: action, child: Text(text));
}
