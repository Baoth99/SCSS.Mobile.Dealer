import 'package:dealer_app/providers/network/scrap_category_network.dart';
import 'package:dealer_app/repositories/models/request_models/create_category_request_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class IScrapCategoryHandler {
  Future<String> uploadImage({
    required String imagePath,
  });
  Future<bool> checkScrapName({
    required String name,
  });
  Future<bool> createScrapCategory(
      {required CreateScrapCategoryRequestModel model});
  Future<List<ScrapCategoryModel>> getScrapCategories({
    int? page,
    int? pageSize,
  });
}

class ScrapCategoryHandler implements IScrapCategoryHandler {
  Future<String> uploadImage({
    required String imagePath,
  }) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);

      if (accessToken != null) {
        String resData = (await ScrapCategoryNetWork.postImage(
          bearerToken: accessToken,
          imagePath: imagePath,
        ))
            .resData;

        // Return image path on server
        return resData;
      } else
        throw Exception(CustomTexts.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> checkScrapName({
    required String name,
  }) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var responseBody = await ScrapCategoryNetWork.getCheckScrapName(
          bearerToken: accessToken,
          name: name,
        );

        return responseBody['isSuccess'];
      } else
        throw Exception(CustomTexts.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> createScrapCategory(
      {required CreateScrapCategoryRequestModel model}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var responseBody = await ScrapCategoryNetWork.postScrapCategory(
          bearerToken: accessToken,
          body: createScrapCategoryRequestModelToJson(model),
        );

        return responseBody['isSuccess'];
      } else
        throw Exception(CustomTexts.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }

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
