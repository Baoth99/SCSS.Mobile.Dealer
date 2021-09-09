import 'package:dealer_app/blocs/bot_nav_bloc.dart';
import 'package:dealer_app/repositories/states/bot_nav_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'layouts/bot_nav_view.dart';

class DealerApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BotNavBloc(StateHome()),
      child: FlavorBanner(
        color: FlavorConfig.instance.color,
        location: BannerLocation.topStart,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.green,
          ),
          routes: {
            '/pageA': (_) => PageA(),
          },
          home: BlocBuilder<BotNavBloc, BotNavState>(
            builder: (_, state) {
              return Scaffold(
                body: state is StateHome
                    ? PageA()
                    : state is StateNotification
                        ? PageB()
                        : state is StateCategory
                            ? PageC()
                            : PageD(),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                floatingActionButton: FloatingActionButton(
                  onPressed: () {},
                  child: Icon(Icons.add),
                ),
                bottomNavigationBar: BotNavView(),
              );
            },
          ),
        ),
      ),
    );
  }
}
