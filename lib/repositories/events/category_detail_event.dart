import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class CategoryDetailEvent {}

class EventChangeScrapImageRequest extends CategoryDetailEvent {}

class EventOpenImagePicker extends CategoryDetailEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});
}

class EventAddScrapCategoryUnit extends CategoryDetailEvent {
  Map<TextEditingController, TextEditingController> controllers;

  EventAddScrapCategoryUnit({required this.controllers});
}

class EventChangeEditStatus extends CategoryDetailEvent {
  final bool isEdited;

  EventChangeEditStatus({required this.isEdited});
}
