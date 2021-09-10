import 'package:flutter/material.dart';

TextField textFieldBuilder(label) {
  return TextField(
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      labelText: label,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    ),
  );
}
