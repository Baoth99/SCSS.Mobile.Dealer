import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dealer_app/blocs/authentication_bloc.dart';
import 'package:dealer_app/blocs/dealer_information_bloc.dart';
import 'package:dealer_app/repositories/states/authentication_state.dart';
import 'package:dealer_app/repositories/states/dealer_information_state.dart';
import 'package:dealer_app/ui/widgets/avartar_widget.dart';
import 'package:dealer_app/ui/widgets/custom_text_widget.dart';
import 'package:dealer_app/ui/widgets/function_widgets.dart';
import 'package:dealer_app/utils/common_utils.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:formz/formz.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        return Scaffold(
          body: Container(
            child: Column(children: [
              avatar(context),
              Expanded(
                  child: ListView(
                children: [
                  _option(
                    'Tạo giao dịch mới',
                    'Giao dịch thu mua phế liệu',
                    () {
                      Navigator.pushNamed(
                          context, CustomRoutes.createTransaction);
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
                      Navigator.pushNamed(
                          context, CustomRoutes.promotionListView);
                    },
                    Colors.white,
                    Color.fromARGB(255, 228, 98, 93),
                    Color.fromARGB(255, 254, 202, 35),
                    ImagesPaths.ticketLogo,
                  ),
                ],
              ))
            ]),
          ),
        );
      },
    );
  }

  Widget avatar(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: 500.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment
              .bottomCenter, // 10% of the width, so there are ten blinds.
          colors: <Color>[
            AppColors.greenFF61C53D.withOpacity(0.7),
            AppColors.greenFF39AC8F.withOpacity(0.7),
          ], // red to yellow
          tileMode: TileMode.repeated, // repeats the gradient over the canvas
        ),
      ),
      child: BlocBuilder<DealerInformationBloc, DealerInformationState>(
        builder: (context, state) {
          return state.status.isSubmissionSuccess
              ? avatarMain(context, state)
              : state.status.isSubmissionInProgress || state.status.isPure
                  ? FunctionalWidgets.getLoadingAnimation()
                  : FunctionalWidgets.getErrorIcon();
        },
      ),
    );
  }

  Widget avatarMain(BuildContext context, DealerInformationState state) {
    return Row(
      children: [
        Container(
          child: CachedAvatarWidget(
            path: state.dealerImageUrl ?? Symbols.empty,
            width: 250,
          ),
          margin: EdgeInsets.only(
              left: 70.w, top: 170.h, right: 40.w, bottom: 40.h),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: CustomText(
                  text: state.dealerName,
                  color: AppColors.white,
                  fontSize: 50.sp,
                  fontWeight: FontWeight.w500,
                ),
                margin: EdgeInsets.only(top: 170.h, right: 80.w, bottom: 20.h),
              ),
              Container(
                padding: EdgeInsets.only(
                  right: 50.w,
                ),
                child: CustomText(
                  text: state.dealerAddress,
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.white,
                ),
              )
            ],
          ),
        ),
      ],
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

class CachedAvatarWidget extends StatelessWidget {
  const CachedAvatarWidget({
    required this.path,
    this.width = 450,
    Key? key,
  }) : super(key: key);
  final String path;
  final double width;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: NetworkUtils.getBearerToken(),
      builder: (context, snapshot) {
        if (path.isNotEmpty && snapshot.hasData) {
          return CachedNetworkImage(
            httpHeaders: {
              HttpHeaders.authorizationHeader: snapshot.data ?? Symbols.empty
            },
            imageUrl: path,
            imageBuilder: (context, imageProvider) => AvatarWidget(
              isMale: true,
              image: imageProvider,
              width: width,
            ),
            placeholder: (context, url) =>
                FunctionalWidgets.getLoadingAnimation(),
            errorWidget: (context, url, error) =>
                FunctionalWidgets.getErrorIcon(),
          );
        }
        return FunctionalWidgets.getLoadingAnimation();
      },
    );
  }
}
