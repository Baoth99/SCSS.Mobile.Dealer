import 'package:flutter/cupertino.dart';

class AddCategoryState {
  String scrapName;
  String pickedImageUrl;
  Map<TextEditingController, TextEditingController> controllers;

  bool isImageSourceActionSheetVisible;

  AddCategoryState({
    isImageSourceActionSheetVisible = false,
    String? pickedImageUrl,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
  })  : this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible,
        this.pickedImageUrl = pickedImageUrl ?? '',
        this.scrapName = scrapName ?? '',
        this.controllers = controllers ?? {};

  AddCategoryState copyWith({
    bool? isImageSourceActionSheetVisible,
    String? pickedImageUrl,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
  }) {
    //return state
    return AddCategoryState(
      isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
          this.isImageSourceActionSheetVisible,
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
      scrapName: scrapName ?? this.scrapName,
      controllers: controllers ?? this.controllers,
    );
  }
}
