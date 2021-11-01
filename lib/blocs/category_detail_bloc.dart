import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/category_detail_event.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/scrap_category_handler.dart';
import 'package:dealer_app/repositories/models/request_models/create_category_request_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_item_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/category_detail_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CategoryDetailBloc
    extends Bloc<CategoryDetailEvent, CategoryDetailState> {
  final _picker = ImagePicker();
  final String id;
  final _scrapCategoryHandler = getIt.get<IScrapCategoryHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  CategoryDetailBloc({required this.id}) : super(CategoryDetailState()) {
    add(EventInitData());
  }

  @override
  Stream<CategoryDetailState> mapEventToState(
      CategoryDetailEvent event) async* {
    if (event is EventInitData) {
      yield LoadingState(
        isImageSourceActionSheetVisible: false,
        controllers: null,
        pickedImageUrl: null,
        initScrapName: null,
        initScrapImage: null,
        scrapName: null,
        isNameExisted: false,
      );
      try {
        ScrapCategoryDetailModel model =
            await _scrapCategoryHandler.getScrapCategoryDetail(id: id);
        // Get Image
        ImageProvider? initImage;
        if (model.imageUrl != CustomTexts.emptyString)
          initImage =
              await _dataHandler.getImageBytes(imageUrl: model.imageUrl);

        yield CategoryDetailState(
          isImageSourceActionSheetVisible: false,
          isNameExisted: false,
          initScrapName: model.name,
          initScrapImage: initImage,
          scrapName: model.name,
          pickedImageUrl: null,
          controllers: await _createControllers(model.details),
        );
      } catch (e) {
        yield ErrorState(
          message: CustomTexts.errorHappenedTryAgain,
          controllers: state.controllers,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
    if (event is EventChangeScrapImageRequest) {
      yield state.copyWith(isImageSourceActionSheetVisible: true);
      yield state.copyWith(isImageSourceActionSheetVisible: false);
    }
    if (event is EventOpenImagePicker) {
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage != null) {
        yield state.copyWith(pickedImageUrl: pickedImage.path);
      } else
        return;
    }
    if (event is EventChangeScrapName) {
      yield state.copyWith(
        scrapName: event.scrapName,
        isNameExisted: false,
      );
    }
    if (event is EventAddScrapCategoryUnit) {
      yield state.copyWith(controllers: event.controllers);
    }
    if (event is EventSubmitScrapCategory) {
      yield LoadingState(
        controllers: state.controllers,
        isImageSourceActionSheetVisible: state.isImageSourceActionSheetVisible,
        pickedImageUrl: state.pickedImageUrl,
        initScrapName: state.initScrapName,
        initScrapImage: state.initScrapImage,
        scrapName: state.scrapName,
        isNameExisted: state.isNameExisted,
      );
      try {
        bool checkNameResult =
            await _scrapCategoryHandler.checkScrapName(name: state.scrapName);
        print(checkNameResult);
        if (checkNameResult) {
          String imagePath = CustomTexts.emptyString;
          if (state.pickedImageUrl.isNotEmpty) {
            // Upload image
            imagePath = await _scrapCategoryHandler.uploadImage(
                imagePath: state.pickedImageUrl);
          }
          // Create details list
          List<ScrapCategoryModel> details =
              await _getScrapCategoryUnitPriceList(
                  controllers: state.controllers);

          // Submit category
          var result = await _scrapCategoryHandler.createScrapCategory(
            model: CreateScrapCategoryRequestModel(
              name: state.scrapName,
              imageUrl: imagePath,
              details: details,
            ),
          );

          if (result) {
            yield SubmittedState(
                message: CustomTexts.addScrapCategorySucessfull);
          } else {
            yield ErrorState(
              message: CustomTexts.errorHappenedTryAgain,
              controllers: state.controllers,
              isImageSourceActionSheetVisible:
                  state.isImageSourceActionSheetVisible,
              pickedImageUrl: state.pickedImageUrl,
              initScrapName: state.initScrapName,
              initScrapImage: state.initScrapImage,
              scrapName: state.scrapName,
              isNameExisted: state.isNameExisted,
            );
          }
        } else {
          yield CategoryDetailState(
            controllers: state.controllers,
            isImageSourceActionSheetVisible:
                state.isImageSourceActionSheetVisible,
            pickedImageUrl: state.pickedImageUrl,
            initScrapName: state.initScrapName,
            scrapName: state.scrapName,
            isNameExisted: true,
          );
        }
      } catch (e) {
        print(e);
        yield ErrorState(
          message: CustomTexts.errorHappenedTryAgain,
          controllers: state.controllers,
          isImageSourceActionSheetVisible:
              state.isImageSourceActionSheetVisible,
          pickedImageUrl: state.pickedImageUrl,
          initScrapName: state.initScrapName,
          initScrapImage: state.initScrapImage,
          scrapName: state.scrapName,
          isNameExisted: state.isNameExisted,
        );
      }
    }
  }

  Future<Map<TextEditingController, TextEditingController>> _createControllers(
      List<CategoryDetailItemModel> details) async {
    Map<TextEditingController, TextEditingController> controllers = {};
    for (var item in details) {
      controllers.putIfAbsent(
        TextEditingController(text: item.unit),
        () => TextEditingController(text: item.price.toString()),
      );
    }
    return controllers;
  }

  Future<List<ScrapCategoryModel>> _getScrapCategoryUnitPriceList({
    required Map<TextEditingController, TextEditingController> controllers,
  }) async {
    List<ScrapCategoryModel> list = [];
    for (var key in controllers.keys) {
      if (key.text != CustomTexts.emptyString)
        list.add(ScrapCategoryModel.createCategoryModel(
            unit: key.text,
            price: int.tryParse(
                    controllers[key]?.text ?? CustomTexts.zeroString) ??
                0));
    }
    return list;
  }
}
