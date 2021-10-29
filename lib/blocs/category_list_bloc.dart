import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/category_list_event.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/scrap_category_handler.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/category_list_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  final _scrapCategoryHandler = getIt.get<IScrapCategoryHandler>();
  final _dataHandler = getIt.get<IDataHandler>();

  CategoryListBloc() : super(NotLoadedState()) {
    add(EventInitData());
  }

  final _initPage = 1;
  final _pageSize = 10;
  int _currentPage = 1;
  List<ScrapCategoryModel> _categoryList = [];

  @override
  Stream<CategoryListState> mapEventToState(CategoryListEvent event) async* {
    if (event is EventInitData) {
      try {
        _currentPage = 1;

        _categoryList = await _scrapCategoryHandler.getScrapCategories(
          page: _initPage,
          pageSize: _pageSize,
        );

        _categoryList = await _addImages(list: _categoryList);

        yield LoadedState(
          categoryList: _categoryList,
          filteredCategoryList:
              _getCategoryListFiltered(categoryList: _categoryList, name: ''),
        );
      } catch (e) {
        print(e);
        yield ErrorState(errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại');
        //  if (e.toString().contains(CustomTexts.missingBearerToken))
        // print(e);
      }
    }
    if (event is EventLoadMoreCategories) {
      try {
        // Get new transactions
        List<ScrapCategoryModel> newList =
            await _scrapCategoryHandler.getScrapCategories(
          page: _currentPage + 1,
          pageSize: _pageSize,
        );
        // If there is more transactions
        if (newList.isNotEmpty) {
          _currentPage += 1;
          _categoryList.addAll(newList);

          yield (state as LoadedState).copyWith(
            categoryList: _categoryList,
            filteredCategoryList: _getCategoryListFiltered(
                categoryList: _categoryList,
                name: (state as LoadedState).searchName),
          );
        }
      } catch (e) {
        yield ErrorState(errorMessage: 'Đã có lỗi xảy ra, vui lòng thử lại');
        //  if (e.toString().contains(CustomTexts.missingBearerToken))
        // print(e);
      }
    }
    if (event is EventChangeSearchName) {
      yield (state as LoadedState).copyWith(
        searchName: event.searchName,
        filteredCategoryList: _sortedList(
          _getCategoryListFiltered(
              categoryList: (state as LoadedState).categoryList,
              name: event.searchName),
        ),
      );
    }
  }

  List<ScrapCategoryModel> _sortedList(List<ScrapCategoryModel> list) {
    list.sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  Future<List<ScrapCategoryModel>> _addImages(
      {required List<ScrapCategoryModel> list}) async {
    for (var item in list) {
      item.image = await _dataHandler.getImageBytes(imageUrl: item.imageUrl);
    }
    return list;
  }

  List<ScrapCategoryModel> _getCategoryListFiltered({
    required List<ScrapCategoryModel> categoryList,
    required String name,
  }) {
    if (name == CustomTexts.emptyString) return categoryList;
    // Check transactionList
    if (categoryList.isEmpty) return List.empty();
    // return filtered List
    var list = categoryList
        .where((element) =>
            element.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
    return list;
  }
}
