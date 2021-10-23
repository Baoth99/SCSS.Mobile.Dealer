import 'package:cool_alert/cool_alert.dart';
import 'package:dealer_app/blocs/transaction_history_bloc.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/transaction_history_event.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_state.dart';
import 'package:dealer_app/ui/layouts/transaction_filter_view.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/cool_alert.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

class TransactionHistoryView extends StatelessWidget {
  final _bloc = getIt.get<TransactionHistoryBloc>();

  @override
  Widget build(BuildContext context) {
    // category screen
    return BlocProvider(
      create: (context) => _bloc,
      child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                CustomTexts.transactionHistoryScreenTitle,
                style: Theme.of(context).textTheme.headline1,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => TransactionFilterView(),
                      ));
                    },
                    icon: Icon(Icons.filter_alt))
              ],
            ),
            body: MultiBlocListener(
              listeners: [
                BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
                  listener: (context, state) {
                    //process
                    if (state.process == TransactionHistoryProcess.processed) {
                      // Navigator.of(context).pop();
                    } else if (state.process ==
                        TransactionHistoryProcess.invalid) {
                      _showSnackBar(context, CustomTexts.generalErrorMessage);
                    } else if (state.process ==
                        TransactionHistoryProcess.valid) {
                      CustomCoolAlert.showCoolAlert(
                        context: context,
                        title: CustomTexts.createTransactionSuccessfullyText,
                        type: CoolAlertType.success,
                      );
                    }
                  },
                ),
                BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
                    listenWhen: (previous, current) {
                  return previous.process == TransactionHistoryProcess.neutral;
                }, listener: (context, state) {
                  if (state.process == TransactionHistoryProcess.processing) {
                    // showDialog(
                    //   barrierDismissible: false,
                    //   context: context,
                    //   builder: (context) => const CustomProgressIndicatorDialog(
                    //     text: CustomTexts.pleaseWaitText,
                    //   ),
                    // );
                  }
                }),
              ],
              child:
                  BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
                builder: (context, state) {
                  return LazyLoadScrollView(
                    scrollDirection: Axis.vertical,
                    onEndOfPage: () {
                      print('load more');
                      _loadMoreTransactions(context);
                    },
                    child: RefreshIndicator(
                      onRefresh: () async {
                        print('init');
                        context
                            .read<TransactionHistoryBloc>()
                            .add(EventInitData());
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: StickyGroupedListView<
                            CollectDealTransactionModel, DateTime>(
                          elements: state.transactionList,
                          order: StickyGroupedListOrder.ASC,
                          groupBy: (CollectDealTransactionModel element) =>
                              DateTime(
                                  element.transactionDateTime.year,
                                  element.transactionDateTime.month,
                                  element.transactionDateTime.day),
                          groupSeparatorBuilder:
                              (CollectDealTransactionModel element) =>
                                  _groupSeparatorBuilder(model: element),
                          itemBuilder: (context, element) => _listTileBuilder(
                              model: element, context: context),
                          separator: SizedBox(height: 5),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  _groupSeparatorBuilder({required CollectDealTransactionModel model}) {
    return Container(
        color: Colors.white,
        child:
            CustomTextWidget.customDateText(time: model.transactionDateTime));
  }

  _listTileBuilder({
    required CollectDealTransactionModel model,
    required BuildContext context,
  }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).accentColor,
        backgroundImage: AssetImage('assets/images/avatar_male_399x425.png'),
        foregroundImage: model.collectorImage != null
            ? NetworkImage(model.collectorImage!)
            : null,
      ),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5))),
      tileColor: CustomColors.lightGray,
      title: Text(model.collectorName),
      subtitle: Text(CustomFormats.currencyFormat.format(model.total)),
      trailing: Text(
          '${model.transactionDateTime.hour}:${model.transactionDateTime.minute}'),
    );
  }

  Future _loadMoreTransactions(BuildContext context) async {
    context.read<TransactionHistoryBloc>().add(EventLoadMoreTransactions());
  }

  _showSnackBar(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }
}
