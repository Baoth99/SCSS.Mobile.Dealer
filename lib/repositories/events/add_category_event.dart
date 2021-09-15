import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddCategoryEvent {}

class EventChangeScrapImageRequest extends AddCategoryEvent {}

class EventOpenImagePicker extends AddCategoryEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});
}

class EventAddScrapCategoryUnit extends AddCategoryEvent {
  Map<TextEditingController, TextEditingController> controllers;

  EventAddScrapCategoryUnit({required this.controllers});
}
