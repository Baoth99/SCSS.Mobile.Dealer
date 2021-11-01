import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/cupertino.dart';

class CategoryDetailState {
  String initScrapName;
  ImageProvider? initScrapImage;
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

  CategoryDetailState({
    isImageSourceActionSheetVisible = false,
    String? pickedImageUrl,
    String? initScrapName,
    ImageProvider? initScrapImage,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
    this.isNameExisted = false,
  })  : this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible,
        this.pickedImageUrl = pickedImageUrl ?? CustomTexts.emptyString,
        this.initScrapName = initScrapName ?? CustomTexts.emptyString,
        this.initScrapImage = initScrapImage,
        this.scrapName = scrapName ?? CustomTexts.emptyString,
        this.controllers = controllers ?? {};

  CategoryDetailState copyWith({
    bool? isImageSourceActionSheetVisible,
    String? pickedImageUrl,
    String? initScrapName,
    ImageProvider? initScrapImage,
    String? scrapName,
    Map<TextEditingController, TextEditingController>? controllers,
    bool? isNameExisted,
  }) {
    //return state
    return CategoryDetailState(
      isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
          this.isImageSourceActionSheetVisible,
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
      initScrapName: initScrapName ?? this.initScrapName,
      initScrapImage: initScrapImage ?? this.initScrapImage,
      scrapName: scrapName ?? this.scrapName,
      controllers: controllers ?? this.controllers,
      isNameExisted: isNameExisted ?? this.isNameExisted,
    );
  }
}

class ScrapCategorySubmittedState extends CategoryDetailState {}

class LoadingState extends CategoryDetailState {
  LoadingState({
    required isImageSourceActionSheetVisible,
    required controllers,
    required pickedImageUrl,
    required initScrapName,
    required initScrapImage,
    required scrapName,
    required isNameExisted,
  }) : super(
          isImageSourceActionSheetVisible: isImageSourceActionSheetVisible,
          controllers: controllers,
          initScrapName: initScrapName,
          initScrapImage: initScrapImage,
          pickedImageUrl: pickedImageUrl,
          scrapName: scrapName,
          isNameExisted: isNameExisted,
        );
}

class SubmittedState extends CategoryDetailState {
  final String message;

  SubmittedState({required this.message});
}

class ErrorState extends CategoryDetailState {
  final String message;

  ErrorState({
    required this.message,
    required isImageSourceActionSheetVisible,
    required controllers,
    required pickedImageUrl,
    required initScrapName,
    required initScrapImage,
    required scrapName,
    required isNameExisted,
  }) : super(
          isImageSourceActionSheetVisible: isImageSourceActionSheetVisible,
          controllers: controllers,
          pickedImageUrl: pickedImageUrl,
          initScrapName: initScrapName,
          initScrapImage: initScrapImage,
          scrapName: scrapName,
          isNameExisted: isNameExisted,
        );
}
