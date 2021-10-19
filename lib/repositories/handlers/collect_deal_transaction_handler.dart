import 'package:dealer_app/providers/network/collect_deal_transaction_network.dart';
import 'package:dealer_app/repositories/models/info_review_model.dart';
import 'package:dealer_app/repositories/models/request_models/collect_deal_transaction_request_model.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';

abstract class ICollectDealTransactionHandler {
  Future<InfoReviewModel?> getInfoReview({required String collectorId});
  Future<bool> createCollectDealTransaction(
      {required CollectDealTransactionRequestModel model});
}

class CollectDealTransactionHandler implements ICollectDealTransactionHandler {
  Future<InfoReviewModel?> getInfoReview({required String collectorId}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var infoReview = (await CollectDealTransactionNetWork.getInfoReview(
          bearerToken: accessToken,
          collectorId: collectorId,
        ))
            .resData;
        //get info review
        return infoReview;
      } else
        return null;
    } catch (e) {
      throw (e);
    }
  }

  Future<bool> createCollectDealTransaction(
      {required CollectDealTransactionRequestModel model}) async {
    try {
      //get access token
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var result =
            (await CollectDealTransactionNetWork.postCollectDealTransaction(
          bearerToken: accessToken,
          body: collectDealTransactionRequestModelToJson(model),
        ));
        //get info review
        return result;
      } else
        return false;
    } catch (e) {
      throw (e);
    }
  }
}
