import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

abstract class CategoryDetailEvent extends Equatable {}

class EventInitData extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeScrapImageRequest extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventOpenImagePicker extends CategoryDetailEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});

  @override
  List<Object?> get props => [imageSource];
}

class EventAddScrapCategoryUnit extends CategoryDetailEvent {
  final Map<TextEditingController, TextEditingController> controllers;

  EventAddScrapCategoryUnit({required this.controllers});

  @override
  List<Object?> get props => [controllers];
}

class EventSubmitScrapCategory extends CategoryDetailEvent {
  @override
  List<Object?> get props => [];
}

class EventChangeScrapName extends CategoryDetailEvent {
  final String scrapName;

  EventChangeScrapName({required this.scrapName});

  @override
  List<Object?> get props => [scrapName];
}
