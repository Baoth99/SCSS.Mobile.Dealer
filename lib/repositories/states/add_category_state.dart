import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/cupertino.dart';

class AddCategoryState {
  String scrapName;
  String pickedImageUrl;
  Map<TextEditingController, TextEditingController> controllers;

  bool isImageSourceActionSheetVisible;
  bool isNameExisted;

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
    this.isNameExisted = false,
  })  : this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible,
        this.pickedImageUrl = pickedImageUrl ?? CustomTexts.emptyString,
        this.scrapName = scrapName ?? CustomTexts.emptyString,
        this.controllers = controllers ?? {};

  AddCategoryState copyWith({
    bool? isImageSourceActionSheetVisible,
    String? pickedImageUrl,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
    bool? isNameExisted,
  }) {
    //return state
    return AddCategoryState(
      isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
          this.isImageSourceActionSheetVisible,
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
      scrapName: scrapName ?? this.scrapName,
      controllers: controllers ?? this.controllers,
      isNameExisted: isNameExisted ?? this.isNameExisted,
    );
  }
}

class ScrapCategorySubmittedState extends AddCategoryState {}

class LoadingState extends AddCategoryState {
  LoadingState({
    required isImageSourceActionSheetVisible,
    required controllers,
    required pickedImageUrl,
    required scrapName,
    required isNameExisted,
  }) : super(
          isImageSourceActionSheetVisible: isImageSourceActionSheetVisible,
          controllers: controllers,
          pickedImageUrl: pickedImageUrl,
          scrapName: scrapName,
          isNameExisted: isNameExisted,
        );
}

class SubmittedState extends AddCategoryState {
  final String message;

  SubmittedState({required this.message});
}

class ErrorState extends AddCategoryState {
  final String message;

  ErrorState({
    required this.message,
    required isImageSourceActionSheetVisible,
    required controllers,
    required pickedImageUrl,
    required scrapName,
    required isNameExisted,
  }) : super(
          isImageSourceActionSheetVisible: isImageSourceActionSheetVisible,
          controllers: controllers,
          pickedImageUrl: pickedImageUrl,
          scrapName: scrapName,
          isNameExisted: isNameExisted,
        );
}
