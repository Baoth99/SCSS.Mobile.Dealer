import 'package:dealer_app/blocs/promotion_detail_bloc.dart';
import 'package:dealer_app/repositories/states/promotion_detail_state.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class PromotionDetailView extends StatelessWidget {
  PromotionDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? id = ModalRoute.of(context)?.settings.arguments as String;
    if (id != null)
      return BlocProvider(
        create: (context) {
          // Show loading
          EasyLoading.show(status: 'Đang tải dữ liệu...');
          return PromotionDetailBloc(promotionId: id);
        },
        child: MultiBlocListener(
          listeners: [
            // Close loading dialog
            BlocListener<PromotionDetailBloc, PromotionDetailState>(
              listenWhen: (previous, current) {
                return previous is LoadingState;
              },
              listener: (context, state) {
                if (state is LoadedState) {
                  EasyLoading.dismiss();
                }
              },
            ),
          ],
          child: Scaffold(
            appBar: _appBar(),
            body: _body(),
          ),
        ),
      );
    else
      return CustomWidgets.customErrorWidget();
  }

  _appBar() {
    return AppBar(
      backgroundColor: Colors.lightGreen,
      elevation: 0,
      title: BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
        builder: (context, state) {
          return Text(
            CustomTexts.promotionDetail,
            style: Theme.of(context).textTheme.headline2,
          );
        },
      ),
    );
  }

  _body() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  _promotionCode(),
                  _promotionName(),
                  _appliedScrapCategory(),
                  _appliedAmount(),
                  _bonusAmount(),
                  _appliedTime(),
                ],
              ));
        else if (state is LoadingState) {
          return Container(
            child: Center(
              child: Text('Đang tải dữ liệu...'),
            ),
          );
        } else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _promotionCode() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Mã khuyến mãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue: state.model.code,
            readOnly: true,
          ),
        );
      },
    );
  }

  _promotionName() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Tên khuyến mãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue: state.model.promotionName,
            readOnly: true,
          ),
        );
      },
    );
  }

  _appliedScrapCategory() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Áp dụng cho danh mục',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue: state.model.appliedScrapCategory,
            readOnly: true,
          ),
        );
      },
    );
  }

  _appliedAmount() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Mức giá áp dụng khuyến mãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue:
                CustomFormats.currencyFormat.format(state.model.appliedAmount),
            readOnly: true,
          ),
        );
      },
    );
  }

  _bonusAmount() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Số tiền khuyến mãi',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue:
                CustomFormats.currencyFormat.format(state.model.bonusAmount),
            readOnly: true,
          ),
        );
      },
    );
  }

  _appliedTime() {
    return BlocBuilder<PromotionDetailBloc, PromotionDetailState>(
      buildWhen: (p, c) => false,
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
              labelText: 'Thời gian áp dụng',
              floatingLabelBehavior: FloatingLabelBehavior.always,
            ),
            initialValue:
                '${state.model.appliedFromTime} - ${state.model.appliedToTime}',
            readOnly: true,
          ),
        );
      },
    );
  }
}
