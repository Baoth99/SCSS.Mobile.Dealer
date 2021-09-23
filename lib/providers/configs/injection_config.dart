import 'package:dealer_app/providers/network/login_network.dart';
import 'package:dealer_app/providers/services/firebase_service.dart';
import 'package:dealer_app/repositories/handlers/login_handler.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;
void configureDependencies() async {
  getIt.registerSingleton<FirebaseNotification>(FirebaseNotification());
  getIt.registerSingleton<LoginNetwork>(LoginNetwork());
  getIt.registerSingleton<LoginHandler>(LoginHandler());
}
