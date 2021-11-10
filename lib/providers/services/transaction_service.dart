import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/network/transaction_network.dart';
import 'package:dealer_app/repositories/states/statistic_state.dart';
import 'package:http/http.dart';

abstract class TransactionService {
  Future<StatisticData> getStatistic(
      String dealerId, DateTime fromDate, DateTime toDate);
  Future<List<DealerInfo>> getBranches();
}

class TransactionServiceImpl implements TransactionService {
  TransactionServiceImpl({
    TransactionNetwork? transactionNetwork,
  }) {
    _transactionNetwork = transactionNetwork ?? getIt.get<TransactionNetwork>();
  }

  late final TransactionNetwork _transactionNetwork;

  @override
  Future<StatisticData> getStatistic(
      String dealerId, DateTime fromDate, DateTime toDate) async {
    StatisticData reuslt = StatisticData();
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getStatistic(
          dealerId,
          fromDate,
          toDate,
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      reuslt = StatisticData(
        totalCollecting: d.totalCollecting,
        totalFee: d.totalFee,
        bonusAmount: d.bonusAmount,
        numOfCompletedTrans: d.numOfCompletedTrans,
      );
    }
    return reuslt;
  }

  @override
  Future<List<DealerInfo>> getBranches() async {
    List<DealerInfo> result = [];
    Client client = Client();
    var responseModel = await _transactionNetwork
        .getBranches(
          client,
        )
        .whenComplete(
          () => client.close(),
        );
    var d = responseModel.resData;
    if (d != null) {
      result = d.map((e) {
        return DealerInfo(id: e.dealerAccountId, name: e.dealerName);
      }).toList();
    }
    return result;
  }
}
