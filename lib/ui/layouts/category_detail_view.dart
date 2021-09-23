import 'dart:io';

import 'package:dealer_app/blocs/category_detail_bloc.dart';
import 'package:dealer_app/repositories/events/category_detail_event.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/category_detail_state.dart';
import 'package:dealer_app/ui/widgets/cancel_button.dart';
import 'package:dealer_app/ui/widgets/flexible.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class CategoryDetailView extends StatelessWidget {
  //form key
  final _formKey = GlobalKey<FormState>();

  //controllers
  final TextEditingController _scrapNameController = TextEditingController();
  final Map<TextEditingController, TextEditingController> _unitControllers = {};

  @override
  Widget build(BuildContext context) {
    // initialize controllers from arguments
    final model =
        ModalRoute.of(context)!.settings.arguments as ScrapCategoryModel;
    _scrapNameController.text = model.getName;
    model.getUnitList?.forEach((element) {
      _unitControllers.putIfAbsent(
        new TextEditingController(text: element.getUnit),
        () => new TextEditingController(text: element.getPrice.toString()),
      );
    });

    return BlocProvider(
      create: (context) => CategoryDetailBloc(CategoryDetailState(
        scrapName: model.getName,
        imageUrl: model.getImageUrl,
        controllers: _unitControllers,
      )),
      child: BlocListener<CategoryDetailBloc, CategoryDetailState>(
        listener: (context, state) {
          if (state.isImageSourceActionSheetVisible) {
            _showImageSourceActionSheet(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(
              ScreenTitles.categoryDetailScreenTitle,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: _categoryDetailBody(),
        ),
      ),
    );
  }

  _categoryDetailBody() {
    return BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 90,
                  child: ListView(
                    children: [
                      textBuilder("Hình ảnh"),
                      Container(
                        padding: EdgeInsets.fromLTRB(70, 10, 70, 10),
                        height: 150,
                        child: Center(
                          child: _scrapImage(),
                        ),
                      ),
                      TextFormField(
                        controller: _scrapNameController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Tên loại phế liệu",
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Nhập tên loại phế liệu";
                        },
                        onFieldSubmitted: (value) => context
                            .read<CategoryDetailBloc>()
                            .add(EventChangeEditStatus(isEdited: true)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          textBuilder("Chi tiết"),
                          InkWell(
                            onTap: () {
                              var newUnitController = TextEditingController();
                              var newPriceController = TextEditingController();
                              _unitControllers.putIfAbsent(
                                  newUnitController, () => newPriceController);
                              context.read<CategoryDetailBloc>().add(
                                  EventAddScrapCategoryUnit(
                                      controllers: _unitControllers));
                            },
                            child: Icon(Icons.add),
                          )
                        ],
                      ),
                      state.controllers.isEmpty
                          ? Center(
                              child: Text(
                                  'Nhấn (+) để thêm đơn vị cho danh mục phế liệu'))
                          : _scrapUnit(),
                    ],
                  ),
                ),
                //Form submit button
                if (state.isEdited) _buttons(),
              ],
            ),
          ),
        );
      },
    );
  }

  _scrapImage() {
    return BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
      builder: (context, state) {
        try {
          return InkWell(
            onTap: () {
              context
                  .read<CategoryDetailBloc>()
                  .add(EventChangeScrapImageRequest());
            },
            child: state.pickedImageUrl.isNotEmpty
                ? Image.file(File(state.pickedImageUrl))
                : state.imageUrl.isNotEmpty
                    ? Image.network(state.imageUrl)
                    : Icon(
                        Icons.add_a_photo,
                        size: 100,
                      ),
          );
        } catch (e) {
          print(e);
          return InkWell(
            onTap: () {
              context
                  .read<CategoryDetailBloc>()
                  .add(EventChangeScrapImageRequest());
            },
            child: Icon(
              Icons.add_a_photo,
              size: 100,
            ),
          );
        }
      },
    );
  }

  _scrapUnit() {
    return BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
      builder: (context, state) {
        return ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: state.controllers.length,
            itemBuilder: (context, index) {
              return rowFlexibleBuilder(
                SizedBox(
                  height: 90,
                  child: TextFormField(
                    controller: state.controllers.keys.elementAt(index),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Đơn vị",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      if (value == '') return null;
                      var text = 'Đơn vị đã có';
                      var count = 0;
                      _unitControllers.keys.forEach((element) {
                        if (element.text == value?.trim()) {
                          count++;
                        }
                      });
                      if (count >= 2)
                        return text;
                      else
                        return null;
                    },
                    onFieldSubmitted: (value) => context
                        .read<CategoryDetailBloc>()
                        .add(EventChangeEditStatus(isEdited: true)),
                  ),
                ),
                SizedBox(
                  height: 90,
                  child: TextFormField(
                    controller: state.controllers.values.elementAt(index),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Đơn giá",
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                    ),
                    onFieldSubmitted: (value) => context
                        .read<CategoryDetailBloc>()
                        .add(EventChangeEditStatus(isEdited: true)),
                  ),
                ),
                rowFlexibleType.bigToSmall,
              );
            });
      },
    );
  }

  _buttons() {
    return BlocBuilder<CategoryDetailBloc, CategoryDetailState>(
      builder: (context, state) {
        return Flexible(
          flex: 10,
          fit: FlexFit.loose,
          child: Container(
            height: 40,
            child: rowFlexibleBuilder(
              cancelButtonBuilder(context, "Huỷ"),
              elevatedButtonBuilder(context, "Thêm danh mục", () {
                if (_formKey.currentState!.validate()) {
                  //TODO: save scrap category
                  Navigator.of(context).pop();
                }
              }),
              rowFlexibleType.smallToBig,
            ),
          ),
        );
      },
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<CategoryDetailBloc>()
          .add(EventOpenImagePicker(imageSource: imageSource));
    };

    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        builder: (_) => ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: Icon(Icons.camera_alt),
                  title: Text('Máy ảnh'),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.image),
                  title: Text('Thư viện'),
                  onTap: () {
                    Navigator.pop(context);
                    selectImageSource(ImageSource.gallery);
                  },
                ),
              ],
            ));
  }
}
