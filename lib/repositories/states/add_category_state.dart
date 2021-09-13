class AddCategoryState {
  bool isImageSourceActionSheetVisible;
  String pickedImageUrl;

  AddCategoryState({
    isImageSourceActionSheetVisible = false,
    String pickedImageUrl = '',
  })  : this.isImageSourceActionSheetVisible = isImageSourceActionSheetVisible,
        this.pickedImageUrl = pickedImageUrl;

  AddCategoryState copyWith(
      {bool? isImageSourceActionSheetVisible, String? pickedImageUrl}) {
    return AddCategoryState(
      isImageSourceActionSheetVisible: isImageSourceActionSheetVisible ??
          this.isImageSourceActionSheetVisible,
      pickedImageUrl: pickedImageUrl ?? this.pickedImageUrl,
    );
  }
}
