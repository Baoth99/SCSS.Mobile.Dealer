import 'package:dealer_app/bottom_nav/bloc/bot_nav_bloc.dart';
import 'package:dealer_app/bottom_nav/bot_nav_state.dart';
import 'package:dealer_app/bottom_nav/view/bot_nav_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotNavPage extends StatelessWidget {
  const BotNavPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BotNavBloc(StateHome()),
      child: BotNavView(),
    );
  }
}
