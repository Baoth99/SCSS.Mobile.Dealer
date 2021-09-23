import 'package:dealer_app/blocs/bot_nav_bloc.dart';
import 'package:dealer_app/repositories/events/bot_nav_event.dart';
import 'package:dealer_app/repositories/states/bot_nav_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_view.dart';

class BotNavView extends StatelessWidget {
  const BotNavView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BotNavBloc, BotNavState>(
      builder: (_, state) {
        return Scaffold(
          body: state is StateHome
              //todo: homepage
              ? Container()
              : state is StateNotification
                  //todo: noti
                  ? Container()
                  : state is StateCategory
                      ? CategoryView()
                      //todo history
                      : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: () {},
            child: Icon(Icons.add),
          ),
          bottomNavigationBar: _botnav(),
        );
      },
    );
  }
}

_botnav() {
  return BlocBuilder<BotNavBloc, BotNavState>(
    builder: (context, state) {
      return Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey.shade100, width: 2))),
          child: BottomNavigationBar(
            currentIndex: state is StateHome
                ? StateHome().itemIndex
                : state is StateNotification
                    ? StateNotification().itemIndex
                    : state is StateCategory
                        ? StateCategory().itemIndex
                        : StateHistory().itemIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            selectedItemColor: Colors.green,
            unselectedItemColor: Colors.grey,
            selectedFontSize: 15,
            unselectedFontSize: 13,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (value) {
              switch (value) {
                case BotNavUtils.stateHomeIndex:
                  BlocProvider.of<BotNavBloc>(context)
                      .add(BotNavEvent.eventTapHome);
                  break;
                case BotNavUtils.stateNotificationIndex:
                  BlocProvider.of<BotNavBloc>(context)
                      .add(BotNavEvent.eventTapNotification);
                  break;
                case BotNavUtils.stateCategoryIndex:
                  BlocProvider.of<BotNavBloc>(context)
                      .add(BotNavEvent.eventTapCategory);
                  break;
                case BotNavUtils.stateHistoryIndex:
                  BlocProvider.of<BotNavBloc>(context)
                      .add(BotNavEvent.eventTapHistory);
                  break;
              }
            },
            items: [
              BottomNavigationBarItem(
                label: '',
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(Icons.notifications_outlined),
                activeIcon: Icon(Icons.notifications),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Container(width: 1),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
              ),
              BottomNavigationBarItem(
                label: '',
                icon: Icon(Icons.watch_later_outlined),
                activeIcon: Icon(Icons.watch_later),
              ),
            ],
          ),
        ),
      );
    },
  );
}
