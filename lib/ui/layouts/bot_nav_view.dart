import 'package:dealer_app/blocs/bot_nav_bloc.dart';
import 'package:dealer_app/repositories/events/bot_nav_event.dart';
import 'package:dealer_app/repositories/states/bot_nav_state.dart';
import 'package:dealer_app/ui/layouts/transaction_history_view.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'category_list_view.dart';
import 'home_view.dart';

enum BotNavItem {
  STATISTIC,
  NOTIFICATION,
  HOME,
  ACTIVITY,
  PROFILE,
}

extension BotNavItemExtension on BotNavItem {
  int get index {
    switch (this) {
      case BotNavItem.STATISTIC:
        return 0;
      case BotNavItem.NOTIFICATION:
        return 1;
      case BotNavItem.HOME:
        return 2;
      case BotNavItem.ACTIVITY:
        return 3;
      case BotNavItem.PROFILE:
        return 4;
      default:
        return 2;
    }
  }
}

class BotNavView extends StatelessWidget {
  const BotNavView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BotNavBloc(BotNavState(BotNavItem.HOME.index)),
      child: Scaffold(
        body: _body(),
        bottomNavigationBar: _botnav(),
      ),
    );
  }
}

_body() {
  return BlocBuilder<BotNavBloc, BotNavState>(
    builder: (context, state) {
      if (state.index == BotNavItem.HOME.index) return HomeView();
      if (state.index == BotNavItem.ACTIVITY.index)
        return TransactionHistoryView();
      else
        return Container();
    },
  );
}

_botnav() {
  return BlocBuilder<BotNavBloc, BotNavState>(
    builder: (context, state) {
      return BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFF61C53D),
          unselectedFontSize: 10,
          selectedFontSize: 15,
          currentIndex: state.index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              label: 'Thống kê',
              icon: Icon(Icons.analytics),
              activeIcon: Icon(Icons.analytics_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Thông báo',
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications),
                  // sno.unreadCount > 0
                  //     ? Positioned(
                  //         // draw a red marble
                  //         top: -25.0.h,
                  //         right: -20.0.w,
                  //         child: Container(
                  //           width: 60.w,
                  //           height: 60.h,
                  //           decoration: const BoxDecoration(
                  //             shape: BoxShape.circle,
                  //             color: Colors.red,
                  //           ),
                  //           child: Center(
                  //             child: CustomText(
                  //               color: Colors.white,
                  //               text: sno.unreadCount <= 99
                  //                   ? '${sno.unreadCount}'
                  //                   : '99+',
                  //               fontSize: 30.sp,
                  //               fontWeight: FontWeight.w600,
                  //             ),
                  //           ),
                  //         ),
                  //       )
                  //     : const SizedBox.shrink(),
                ],
              ),
              activeIcon: Icon(Icons.notifications_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Trang chủ',
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Hoạt động',
              icon: Icon(Icons.history),
              activeIcon: Icon(Icons.history_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Tài khoản',
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person_outline),
            ),
          ],
          onTap: (value) {
            BlocProvider.of<BotNavBloc>(context).add(EventTap(value));
          },
        ),
      );
    },
  );
}
