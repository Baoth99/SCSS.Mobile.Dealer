import 'package:dealer_app/providers/network/promotion_network.dart';
import 'package:dealer_app/repositories/models/promotion_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class IPromotionHandler {
  Future<List<PromotionModel>?> getPromotionList();
}

class PromotionHandler implements IPromotionHandler {
  Future<List<PromotionModel>?> getPromotionList() async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        //get promotions
        return (await PromotionNetwork.getPromotion(bearerToken: accessToken))
            .promotionModels;
      } else
        throw Exception(CustomTexts.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
