import 'package:dealer_app/blocs/transaction_history_detail_bloc.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_history_detail_item_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_detail_state.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class TransactionHistoryDetailView extends StatelessWidget {
  const TransactionHistoryDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String? id = ModalRoute.of(context)?.settings.arguments as String;
    if (id != null)
      return BlocProvider(
        create: (context) {
          // Show loading
          EasyLoading.show(status: 'Đang tải dữ liệu...');
          return TransactionHistoryDetailBloc(id: id);
        },
        child: MultiBlocListener(
          listeners: [
            // Close loading dialog
            BlocListener<TransactionHistoryDetailBloc,
                TransactionHistoryDetailState>(
              listenWhen: (previous, current) {
                return previous is NotLoadedState;
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
      title: BlocBuilder<TransactionHistoryDetailBloc,
          TransactionHistoryDetailState>(
        builder: (context, state) {
          return Text(
            CustomTexts.transactionHistoryDetailScreenTitle,
            style: Theme.of(context).textTheme.headline2,
          );
        },
      ),
    );
  }

  _body() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Container(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: ListView(
                primary: false,
                shrinkWrap: true,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        color: Colors.green,
                      ),
                      SizedBox(width: 10),
                      Text('Mã Đơn: ${state.model.transactionCode}'),
                    ],
                  ),
                  Divider(),
                  Row(
                    children: [
                      CustomWidgets.customAvatar(),
                      SizedBox(width: 20),
                      Text(state.model.collectorName),
                    ],
                  ),
                  Divider(),
                  CustomWidgets.customText(text: 'Thông tin thu gom'),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.event),
                      SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Thời gian giao dịch'),
                          Row(
                            children: [
                              CustomWidgets.customDateText(
                                  time: state.model.transactionDate),
                              SizedBox(width: 10),
                              Text(state.model.transactionTime),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.list_alt),
                      SizedBox(width: 10),
                      Text('Thông tin đơn hàng'),
                    ],
                  ),
                  _items(),
                  Divider(),
                  _subTotal(),
                  _promotioBonusnAmount(),
                  Divider(),
                  _total(),
                ],
              ));
        else if (state is NotLoadedState) {
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

  _items() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return ListView.separated(
            padding: EdgeInsets.only(top: 10),
            primary: false,
            shrinkWrap: true,
            itemCount: state.model.itemDetails.length,
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(
                height: 10,
              );
            },
            itemBuilder: (itemContext, index) =>
                _itemBulder(item: state.model.itemDetails[index]),
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _itemBulder({required CDTransactionHistoryDetailItemModel item}) {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        return ListTile(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
          tileColor: CustomColors.lightGray,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.scrapCategoryName ??
                        CustomVar.unnamedScrapCategory.name,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
              ),
              if (item.quantity != 0 && item.unit != null)
                Flexible(
                  flex: 3,
                  fit: FlexFit.loose,
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      item.quantity != 0 && item.unit != null
                          ? '${CustomFormats.numberFormat.format(item.quantity)} ${item.unit}'
                          : CustomTexts.emptyString,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              Flexible(
                flex: 4,
                fit: FlexFit.tight,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    CustomFormats.currencyFormat.format(item.total),
                    textAlign: TextAlign.right,
                  ),
                ),
              ),
            ],
          ),
          subtitle: item.isBonus
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 150,
                      child: Text(
                        CustomTexts.promotionText,
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                    Text(
                      CustomFormats.currencyFormat.format(item.bonusAmount),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ],
                )
              : null,
        );
      },
    );
  }

  _subTotal() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidgets.customText(
                text: CustomTexts.subTotalText,
                height: 30,
              ),
              CustomWidgets.customText(
                text: CustomFormats.currencyFormat.format(state.model.total),
                height: 30,
              ),
            ],
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _promotioBonusnAmount() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidgets.customText(
                text: CustomTexts.promotionText,
                height: 30,
              ),
              CustomWidgets.customText(
                text:
                    CustomFormats.currencyFormat.format(state.model.totalBonus),
                height: 30,
              ),
            ],
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }

  _total() {
    return BlocBuilder<TransactionHistoryDetailBloc,
        TransactionHistoryDetailState>(
      builder: (context, state) {
        if (state is LoadedState)
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomWidgets.customText(
                text: CustomTexts.totalText,
                height: 30,
              ),
              CustomWidgets.customText(
                text: CustomFormats.currencyFormat.format(state.grandTotal),
                height: 30,
              ),
            ],
          );
        else
          return CustomWidgets.customErrorWidget();
      },
    );
  }
}
