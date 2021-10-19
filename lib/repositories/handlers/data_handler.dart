import 'package:dealer_app/providers/network/data_network.dart';
import 'package:dealer_app/repositories/models/collector_phone_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class IDataHandler {
  Future<List<ScrapCategoryModel>?> getScrapCategoryList();
  Future<List<ScrapCategoryDetailModel>?> getScrapCategoryDetailList(
      {required String scrapCategoryId});
  Future<List<CollectorPhoneModel>?> getCollectorPhoneList();
}

class DataHandler implements IDataHandler {
  Future<List<ScrapCategoryModel>?> getScrapCategoryList() async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var scrapCategories = (await DataNetWork.getScrapCategories(
          bearerToken: accessToken,
        ))
            .scrapCategoryModels;
        if (scrapCategories != null) {
          scrapCategories.sort((cat1, cat2) => cat1.name.compareTo(cat2.name));
          //insert to first position
          scrapCategories.insert(0, CustomVar.unnamedScrapCategory);
        }
        //get scrap categories
        return scrapCategories;
      } else
        return null;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<ScrapCategoryDetailModel>?> getScrapCategoryDetailList(
      {required String scrapCategoryId}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var scrapCategoryDetails = (await DataNetWork.getScrapCategoryDetails(
          bearerToken: accessToken,
          scrapCategoryId: scrapCategoryId,
        ))
            .scrapCategoryDetailModels;
        if (scrapCategoryDetails != null) {
          scrapCategoryDetails
              .sort((cat1, cat2) => cat1.unit.compareTo(cat2.unit));
        }
        //get scrap category details
        return scrapCategoryDetails;
      } else
        return null;
    } catch (e) {
      throw (e);
    }
  }

  Future<List<CollectorPhoneModel>?> getCollectorPhoneList() async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var collectorPhones = (await DataNetWork.getCollectorPhones(
          bearerToken: accessToken,
        ))
            .collectorPhoneModels;
        //get collector phones
        return collectorPhones;
      } else
        return null;
    } catch (e) {
      throw (e);
    }
  }
}