import 'package:dealer_app/repositories/events/add_category_event.dart';
import 'package:dealer_app/repositories/states/add_category_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final _picker = ImagePicker();

  AddCategoryBloc()
      : super(
          AddCategoryState(
            controllers: {
              new TextEditingController(): new TextEditingController(),
            },
          ),
        );

  @override
  Stream<AddCategoryState> mapEventToState(AddCategoryEvent event) async* {
    if (event is EventChangeScrapImageRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
    }
    if (event is EventOpenImagePicker) {
      yield state.copyWith(isImageSourceActionSheetVisible: false);
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage != null) {
        yield state.copyWith(pickedImageUrl: pickedImage.path);
      } else
        return;
    }
    if (event is EventAddScrapCategoryUnit) {
      yield state.copyWith(controllers: event.controllers);
    }
    if (event is EventSubmitScrapCategory) {}
  }
}
