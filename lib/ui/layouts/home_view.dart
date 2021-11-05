import 'package:dealer_app/blocs/authentication_bloc.dart';
import 'package:dealer_app/repositories/states/authentication_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, CustomRoutes.promotionListView);
                },
                child: Text('promotion')),
          ),
        );
      },
    );
  }
}
