import 'package:dealer_app/providers/configs/flavor_config.dart';
import 'package:dealer_app/ui/app.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/configs/injection_config.dart';

void main() async {
  // Load env
  await dotenv.load(fileName: EnvAppSetting.dev);

  // Add Flavor
  FlavorConfiguration.addFlavorConfig(
      EnvBaseAppSettingValue.flavor, Colors.green);
  configureDependencies();

  runApp(DealerApp());
}
