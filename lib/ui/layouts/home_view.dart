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
            child: Column(children: [
              _option(
                'Tạo giao dịch mới',
                'Giao dịch thu mua phế liệu',
                () {
                  Navigator.pushNamed(context, CustomRoutes.createTransaction);
                },
                Colors.white,
                Color.fromARGB(255, 57, 172, 143),
                Color.fromARGB(255, 97, 197, 61),
                ImagesPaths.createNewIcon,
              ),
              _option(
                'Bảng giá phế liệu',
                'Danh mục các loại phế liệu của bạn',
                () {
                  Navigator.pushNamed(context, CustomRoutes.categoryList);
                },
                Colors.white,
                Color.fromARGB(255, 79, 148, 232),
                Color.fromARGB(255, 53, 192, 234),
                ImagesPaths.categoriesIcon,
              ),
              _option(
                'Ưu đãi',
                'Sự kiện diễn ra cho người bán phế liệu',
                () {
                  Navigator.pushNamed(context, CustomRoutes.promotionListView);
                },
                Colors.white,
                Color.fromARGB(255, 228, 98, 93),
                Color.fromARGB(255, 254, 202, 35),
                ImagesPaths.ticketLogo,
              ),
            ]),
          ),
        );
      },
    );
  }

  Widget _option(String name, String description, void Function() onPressed,
      Color contentColor, Color startColor, Color endColor, String icon) {
    return Container(
      // color: Colors.white70,
      height: 100,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment
              .bottomRight, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            startColor.withOpacity(0.9),
            endColor.withOpacity(0.9),
          ], // red to yellow
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 5.0,
            spreadRadius: 0.0,
            offset: Offset(1.0, 2.0), // shadow direction: bottom right
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          child: Container(
            child: Row(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Image.asset(icon, width: 50)),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            description,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
