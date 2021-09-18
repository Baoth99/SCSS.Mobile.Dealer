import 'package:dealer_app/repositories/events/category_detail_event.dart';
import 'package:dealer_app/repositories/states/category_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final _picker = ImagePicker();

  CategoryDetailBloc(CategoryDetailState initialState) : super(initialState);

  @override
  Stream<CategoryDetailState> mapEventToState(
      CategoryDetailEvent event) async* {
    if (event is EventChangeScrapImageRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
    }
    if (event is EventOpenImagePicker) {
      yield state.copyWith(isImageSourceActionSheetVisible: false);
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage != null) {
        yield state.copyWith(pickedImageUrl: pickedImage.path, isEdited: true);
      } else
        return;
    }
    if (event is EventAddScrapCategoryUnit) {
      yield state.copyWith(controllers: event.controllers);
    }
    if (event is EventChangeEditStatus) {
      yield state.copyWith(isEdited: event.isEdited);
    }
  }
}
