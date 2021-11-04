import 'package:dealer_app/providers/network/promotion_network.dart';
import 'package:dealer_app/repositories/models/get_promotion_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class IPromotionHandler {
  Future<List<GetPromotionModel>> getPromotions();
}

class PromotionHandler implements IPromotionHandler {
  Future<List<GetPromotionModel>> getPromotions() async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        //get promotions
        var promotions =
            (await PromotionNetwork.getPromotion(bearerToken: accessToken))
                .resData;

        return promotions;
      } else
        throw Exception(CustomTexts.missingBearerToken);
    } catch (e) {
      throw (e);
    }
  }
}
