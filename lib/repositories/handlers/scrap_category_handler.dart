import 'package:dealer_app/providers/network/scrap_category_network.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class IScrapCategoryHandler {
  Future<List<ScrapCategoryModel>> getScrapCategories({
    int? page,
    int? pageSize,
  });
}

class ScrapCategoryHandler implements IScrapCategoryHandler {
  Future<List<ScrapCategoryModel>> getScrapCategories({
    int? page,
    int? pageSize,
  }) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var scrapCategories = (await ScrapCategoryNetWork.getScrapCategories(
          bearerToken: accessToken,
          page: page?.toString(),
          pageSize: pageSize?.toString(),
        ))
            .scrapCategoryModels;

        //get scrap categories
        return scrapCategories;
      } else
        throw Exception(CustomTexts.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
