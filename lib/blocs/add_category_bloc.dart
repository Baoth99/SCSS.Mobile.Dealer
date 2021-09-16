import 'package:dealer_app/repositories/events/add_category_event.dart';
import 'package:dealer_app/repositories/states/add_category_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryBloc extends Bloc<AddCategoryEvent, AddCategoryState> {
  final _picker = ImagePicker();

  AddCategoryBloc(AddCategoryState initialState) : super(initialState);

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
  }
}
