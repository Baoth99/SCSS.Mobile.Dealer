import 'package:image_picker/image_picker.dart';

abstract class AddCategoryEvent {}

class EventChangeScrapImageRequest extends AddCategoryEvent {}

class EventOpenImagePicker extends AddCategoryEvent {
  final ImageSource imageSource;

  EventOpenImagePicker({required this.imageSource});
}
