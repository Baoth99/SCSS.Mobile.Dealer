import 'package:cool_alert/cool_alert.dart';
import 'package:dealer_app/blocs/category_list_bloc.dart';
import 'package:dealer_app/repositories/events/category_list_event.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/category_list_state.dart';
import 'package:dealer_app/utils/cool_alert.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class CategoryListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // category screen
    return BlocProvider(
      create: (context) => CategoryListBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<CategoryListBloc, CategoryListState>(
            listener: (context, state) {
              if (state is NotLoadedState) {
                EasyLoading.show(status: CustomTexts.processing);
              } else {
                EasyLoading.dismiss();
                if (state is ErrorState) {
                  CustomCoolAlert.showCoolAlert(
                    context: context,
                    title: state.errorMessage,
                    type: CoolAlertType.success,
                    onTap: () {
                      Navigator.popUntil(
                          context, ModalRoute.withName(CustomRoutes.botNav));
                    },
                  );
                }
              }
            },
          ),
        ],
        child: Scaffold(
          appBar: _appBar(context),
          body: _body(),
        ),
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      title: Text(
        CustomTexts.categoryScreenTitle,
        style: Theme.of(context).textTheme.headline1,
      ),
      actions: [
        InkWell(
          onTap: () =>
              Navigator.of(context).pushNamed(CustomRoutes.addCategory),
          child: Container(
            width: 60,
            child: Center(
              child: Icon(
                Icons.add,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _body() {
    return Container(
      child: Column(
        children: [
          Flexible(
            fit: FlexFit.loose,
            flex: 1,
            child: _searchField(),
          ),
          Flexible(
            flex: 9,
            child: _list(),
          ),
        ],
      ),
    );
  }

  _searchField() {
    return BlocBuilder<CategoryListBloc, CategoryListState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          color: Colors.white,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Tìm danh mục...',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              prefixIcon:
                  Icon(Icons.search, color: Theme.of(context).accentColor),
            ),
            onChanged: (value) {
              context
                  .read<CategoryListBloc>()
                  .add(EventChangeSearchName(searchName: value));
            },
          ),
        );
      },
    );
  }

  _list() {
    return BlocBuilder<CategoryListBloc, CategoryListState>(
      builder: (context, state) {
        if (state is LoadedState)
          return LazyLoadScrollView(
              scrollDirection: Axis.vertical,
              onEndOfPage: () {
                _loadMoreTransactions(context);
              },
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<CategoryListBloc>().add(EventInitData());
                },
                child: GroupedListView<ScrapCategoryModel, String>(
                  padding: EdgeInsets.fromLTRB(20, 10, 20, 40),
                  physics: AlwaysScrollableScrollPhysics(),
                  elements: state.filteredCategoryList,
                  order: GroupedListOrder.ASC,
                  groupBy: (ScrapCategoryModel element) =>
                      element.name.toUpperCase(),
                  groupSeparatorBuilder: (String element) =>
                      _groupSeparatorBuilder(name: element),
                  itemBuilder: (context, element) =>
                      _listTileBuilder(model: element, context: context),
                  separator: SizedBox(height: 10),
                ),
              ));
        else if (state is NotLoadedState) {
          return Center(
            child: Text('Không có danh mục'),
          );
        } else {
          return CustomWidgets.customErrorWidget();
        }
      },
    );
  }

  _groupSeparatorBuilder({required String name}) {
    return Container(child: Text(name.characters.first.toUpperCase()));
  }

  _listTileBuilder({required ScrapCategoryModel model, required context}) {
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      onTap: () => Navigator.of(context).pushNamed(
        CustomRoutes.categoryDetail,
        arguments: model.id,
      ),
      leading: SizedBox(
        width: 45.0,
        height: 45.0,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: BlocBuilder<CategoryListBloc, CategoryListState>(
              builder: (context, state) {
                return Stack(
                  children: [
                    const SizedBox(
                      width: 45.0,
                      height: 45.0,
                      child: const DecoratedBox(
                        decoration: const BoxDecoration(color: Colors.green),
                      ),
                    ),
                    if (model.image != null)
                      Positioned(
                        width: 45.0,
                        height: 45.0,
                        child: Image(
                          image: model.image!,
                          fit: BoxFit.cover,
                        ),
                      ),
                  ],
                );
              },
            )),
      ),
      title: Text(model.name),
    );
  }

  Future _loadMoreTransactions(BuildContext context) async {
    context.read<CategoryListBloc>().add(EventLoadMoreCategories());
  }
}
