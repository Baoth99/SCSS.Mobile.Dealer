import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/cupertino.dart';

class AddCategoryState {
  String scrapName;
  String pickedImageUrl;
  Map<TextEditingController, TextEditingController> controllers;

  bool isImageSourceActionSheetVisible;

  bool get isOneUnitExist {
    var result = false;
    controllers.forEach((key, value) {
      if (key.text != CustomTexts.emptyString) result = true;
    });
    return result;
  }

  AddCategoryState({
    isImageSourceActionSheetVisible = false,
    String? pickedImageUrl,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
  })  : this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible,
        this.pickedImageUrl = pickedImageUrl ?? CustomTexts.emptyString,
        this.scrapName = scrapName ?? CustomTexts.emptyString,
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

class ScrapCategorySubmittedState extends AddCategoryState {}
