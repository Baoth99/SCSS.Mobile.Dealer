import 'package:dealer_app/blocs/transaction_history_bloc.dart';
import 'package:dealer_app/providers/network/notification_network.dart';
import 'package:dealer_app/providers/services/firebase_service.dart';
import 'package:dealer_app/providers/services/notification_service.dart';
import 'package:dealer_app/repositories/handlers/authentication_handler.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/handlers/scrap_category_handler.dart';
import 'package:dealer_app/repositories/handlers/user_handler.dart';
import 'package:dealer_app/utils/ticker.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';

final getIt = GetIt.instance;
void configureDependencies() async {
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());
  getIt.registerSingleton<IAuthenticationHandler>(AuthenticationHandler());
  getIt.registerSingleton<ImagePicker>(ImagePicker());
  getIt.registerSingleton<ITicker>(Ticker());
  getIt.registerSingleton<IUserHandler>(UserHandler());
  getIt.registerSingleton<IPromotionHandler>(PromotionHandler());
  getIt.registerSingleton<IDataHandler>(DataHandler());
  getIt.registerSingleton<ICollectDealTransactionHandler>(
      CollectDealTransactionHandler());
  getIt.registerSingleton<TransactionHistoryBloc>(TransactionHistoryBloc());
  getIt.registerSingleton<IScrapCategoryHandler>(ScrapCategoryHandler());

  getIt.registerLazySingleton<NotificationNetwork>(
    () => NotificationNetworkImpl(),
  );

  getIt.registerLazySingleton<NotificationService>(
    () => NotificationServiceImp(),
  );
}
