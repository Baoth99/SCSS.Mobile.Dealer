import 'package:flutter/cupertino.dart';

class CategoryDetailState {
  String scrapName;
  String pickedImageUrl;
  Map<TextEditingController, TextEditingController> controllers;
  String imageUrl;

  bool isImageSourceActionSheetVisible;
  bool isEdited;

  CategoryDetailState({
    String? pickedImageUrl,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
    isImageSourceActionSheetVisible = false,
    bool? isEdited,
    String? imageUrl,
  })  : this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible,
        this.pickedImageUrl = pickedImageUrl ?? '',
        this.scrapName = scrapName ?? '',
        this.controllers = controllers ?? {},
        this.isEdited = isEdited ?? false,
        this.imageUrl = imageUrl ?? '';

  CategoryDetailState copyWith({
    bool? isImageSourceActionSheetVisible,
    String? pickedImageUrl,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
    bool? isEdited,
    String? imageUrl,
  }) {
    //return state
    return CategoryDetailState(
      isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
          this.isImageSourceActionSheetVisible,
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
      scrapName: scrapName ?? this.scrapName,
      controllers: controllers ?? this.controllers,
      isEdited: isEdited ?? this.isEdited,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}
