import 'dart:io';

import 'package:dealer_app/blocs/add_category_bloc.dart';
import 'package:dealer_app/repositories/events/add_category_event.dart';
import 'package:dealer_app/repositories/states/add_category_state.dart';
import 'package:dealer_app/ui/widgets/flexible.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCategoryView extends StatelessWidget {
  final String _pickedImageUrl = '';
  final String _scrapName = '';
  final _formKey = GlobalKey<FormState>();

  //controllers
  final TextEditingController _scrapNameController = TextEditingController();
  final Map<TextEditingController, TextEditingController> _unitControllers = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AddCategoryBloc(AddCategoryState(
        scrapName: _scrapName,
        pickedImageUrl: _pickedImageUrl,
        controllers: _unitControllers,
      )),
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
              CustomTexts.addCategoryScreenTitle,
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
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 90,
                  child: ListView(
                    children: [
                      CustomTextWidget.customText(text: 'Hình ảnh'),
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
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return "Nhập tên loại phế liệu";
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget.customText(text: 'Chi tiết'),
                          InkWell(
                            onTap: () {
                              var newUnitController = TextEditingController();
                              var newPriceController = TextEditingController();
                              _unitControllers.putIfAbsent(
                                  newUnitController, () => newPriceController);
                              context.read<AddCategoryBloc>().add(
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
                Flexible(
                  flex: 10,
                  fit: FlexFit.loose,
                  child: Container(
                    height: 40,
                    child: rowFlexibleBuilder(
                      CustomWidget.customCancelButton(context, "Huỷ"),
                      CustomWidget.customElevatedButton(
                          context, "Thêm danh mục", () {
                        if (_formKey.currentState!.validate()) {
                          //TODO: add new scrap category
                          Navigator.of(context).pop();
                        }
                      }),
                      rowFlexibleType.smallToBig,
                    ),
                  ),
                ),
              ],
            ),
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
    return BlocBuilder<AddCategoryBloc, AddCategoryState>(
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
                  ),
                ),
                rowFlexibleType.bigToSmall,
              );
            });
      },
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
