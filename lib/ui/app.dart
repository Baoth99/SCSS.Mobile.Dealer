import 'package:dealer_app/blocs/authentication_bloc.dart';
import 'package:dealer_app/repositories/handlers/authentication_handler.dart';
import 'package:dealer_app/repositories/handlers/user_handler.dart';
import 'package:dealer_app/repositories/states/authentication_state.dart';
import 'package:dealer_app/ui/layouts/category_detail_view.dart';
import 'package:dealer_app/ui/layouts/login_view.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layouts/add_category_view.dart';
import 'layouts/bot_nav_view.dart';
import 'layouts/register_branch_option_view.dart';
import 'layouts/register_complete_view.dart';
import 'layouts/register_otp_view.dart';
import 'layouts/register_personal_info_view.dart';
import 'layouts/register_store_info_view.dart';
import 'layouts/register_view.dart';

class DealerApp extends StatelessWidget {
  final AuthenticationHandler authenticationHandler;
  final UserHandler userHandler;

  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  DealerApp({
    Key? key,
    required this.authenticationHandler,
    required this.userHandler,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: authenticationHandler,
      child: BlocProvider(
        create: (context) => AuthenticationBloc(
          authenticationHandler: authenticationHandler,
          userHandler: userHandler,
        ),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: _themeData(),
          navigatorKey: _navigatorKey,
          routes: {
            CustomRoutes.addCategory: (_) => AddCategoryView(),
            CustomRoutes.categoryDetail: (_) => CategoryDetailView(),
            CustomRoutes.botNav: (_) => BotNavView(),
            CustomRoutes.register: (_) => RegisterView(),
            CustomRoutes.registerOTP: (_) => RegisterOTPView(),
            CustomRoutes.registerPersonalInfo: (_) =>
                RegisterPersonalInfoView(),
            CustomRoutes.registerBranchOption: (_) =>
                RegisterBranchOptionView(),
            CustomRoutes.registerStoreInfo: (_) => RegisterStoreInfoView(),
            CustomRoutes.registerComplete: (_) => RegisterCompleteView(),
            CustomRoutes.login: (_) => LoginView(),
          },
          home: LoginView(),
          builder: (context, child) {
            return BlocListener<AuthenticationBloc, AuthenticationState>(
              listener: (context, state) {
                switch (state.status) {
                  case AuthenticationStatus.authenticated:
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute<void>(builder: (_) => HomePage()),
                    //     (route) => false);
                    _navigator.pushNamedAndRemoveUntil(
                        CustomRoutes.botNav, (route) => false);
                    break;
                  case AuthenticationStatus.unauthenticated:
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute<void>(builder: (_) => LoginView()),
                    //     (route) => false);
                    _navigator.pushNamedAndRemoveUntil(
                        CustomRoutes.login, (route) => false);
                    break;
                  default:
                    break;
                }
              },
              child: child,
            );
          },
        ),
      ),
    );
  }

  _themeData() {
    return ThemeData(
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        iconTheme: IconThemeData(size: 25),
        actionsIconTheme: IconThemeData(size: 25),
      ),
      textTheme: TextTheme(
        headline1: TextStyle(
          fontSize: 25,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        headline2: TextStyle(
          fontSize: 20,
          color: Colors.black,
          fontWeight: FontWeight.w500,
        ),
      ),
      primarySwatch: Colors.green,
    );
  }
}
