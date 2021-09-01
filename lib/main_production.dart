import 'package:dealer_app/providers/configs/flavor_config.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/providers/services/firebase_service.dart';
import 'package:dealer_app/ui/app.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Load env
  await dotenv.load(fileName: EnvAppSetting.production);
  // Add Flavor
  FlavorConfiguration.addFlavorConfig(
      EnvBaseAppSettingValue.flavor, Colors.green);
  configureDependencies();
  final firebase = getIt.get<FirebaseNotification>();
  await firebase.initialize();
  runApp(DealerApp());
}
