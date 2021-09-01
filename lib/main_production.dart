import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/ui/app.dart';
import 'package:dealer_app/utils/env_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  // Load env
  await dotenv.load(fileName: EnvAppSetting.production);

  configureDependencies();
  runApp(DealerApp());
}
