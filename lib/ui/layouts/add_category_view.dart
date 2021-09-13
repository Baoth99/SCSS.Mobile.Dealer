import 'dart:io';

import 'package:dealer_app/blocs/add_category_bloc.dart';
import 'package:dealer_app/repositories/events/add_category_event.dart';
import 'package:dealer_app/repositories/states/add_category_state.dart';
import 'package:dealer_app/ui/widgets/cancel_button.dart';
import 'package:dealer_app/ui/widgets/flexible.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/ui/widgets/text_field.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCategoryBloc(AddCategoryState()),
      child: BlocListener<AddCategoryBloc, AddCategoryState>(
        listener: (context, state) {
          if (state.isImageSourceActionSheetVisible) {
            _showImageSourceActionSheet(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(
              ScreenTitles.addCategoryScreenTitle,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: _addCategoryBody(),
        ),
      ),
    );
  }

  _addCategoryBody() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (context, state) {
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(25, 20, 25, 25),
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
                    textFieldBuilder("Tên loại phế liệu"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        textBuilder("Chi tiết"),
                        InkWell(
                          onTap: () {},
                          child: Icon(Icons.add),
                        )
                      ],
                    ),
                    _scrapUnit(),
                  ],
                ),
              ),
              Flexible(
                flex: 10,
                fit: FlexFit.loose,
                child: Container(
                  height: 40,
                  child: rowFlexibleBuilder(
                    cancelButtonBuilder(context, "Huỷ"),
                    elevatedButtonBuilder(context, "Thêm danh mục", () {}),
                    rowFlexibleType.smallToBig,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  _scrapImage() {
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
      builder: (context, state) {
        return InkWell(
          onTap: () {
            context.read<AddCategoryBloc>().add(EventChangeScrapImageRequest());
          },
          child: state.pickedImageUrl != ''
              ? Image.file(File(state.pickedImageUrl))
              : Icon(
                  Icons.add_a_photo,
                  size: 100,
                ),
        );
      },
    );
  }

  _scrapUnit() {
    return rowFlexibleBuilder(
      textFieldBuilder("Đơn vị"),
      textFieldBuilder("Đơn giá"),
      rowFlexibleType.bigToSmall,
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Function(ImageSource) selectImageSource = (imageSource) {
      context
          .read<AddCategoryBloc>()
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
