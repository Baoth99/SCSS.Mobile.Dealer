import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class AddCategoryEvent extends Equatable {}

class EventChangeScrapImageRequest extends AddCategoryEvent {
  @override
  List<Object?> get props => [];
}

class EventOpenImagePicker extends AddCategoryEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});

  @override
  List<Object?> get props => [imageSource];
}

class EventAddScrapCategoryUnit extends AddCategoryEvent {
  final Map<TextEditingController, TextEditingController> controllers;

  EventAddScrapCategoryUnit({required this.controllers});

  @override
  List<Object?> get props => [controllers];
}

class EventSubmitScrapCategory extends AddCategoryEvent {
  @override
  List<Object?> get props => [];
}
