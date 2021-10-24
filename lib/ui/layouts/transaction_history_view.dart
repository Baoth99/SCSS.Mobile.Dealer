import 'package:cool_alert/cool_alert.dart';
import 'package:dealer_app/blocs/transaction_history_bloc.dart';
import 'package:dealer_app/repositories/events/transaction_history_event.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_model.dart';
import 'package:dealer_app/repositories/states/transaction_history_state.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/cool_alert.dart';
import 'package:dealer_app/utils/custom_progress_indicator_dialog_widget.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionHistoryView extends StatelessWidget {
  final _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // category screen
    return BlocProvider(
      create: (context) => TransactionHistoryBloc(),
      child: MultiBlocListener(
        listeners: [
          BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
            listener: (context, state) {
              //process
              if (state.process == TransactionHistoryProcess.invalid) {
                _showSnackBar(context, CustomTexts.generalErrorMessage);
              } else if (state.process == TransactionHistoryProcess.valid) {
                CustomCoolAlert.showCoolAlert(
                  context: context,
                  title: CustomTexts.createTransactionSuccessfullyText,
                  type: CoolAlertType.success,
                );
              }
            },
          ),
          // Show processing dialog
          BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
              listenWhen: (previous, current) {
            return previous.process == TransactionHistoryProcess.neutral;
          }, listener: (context, state) {
            if (state.process == TransactionHistoryProcess.processing) {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) => const CustomProgressIndicatorDialog(
                  text: CustomTexts.pleaseWaitText,
                ),
              );
            } else if (state.process == TransactionHistoryProcess.processed) {
              Navigator.of(context).pop();
            }
          }),
          // Close processing dialog
          BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
              listenWhen: (previous, current) {
            return previous.process == TransactionHistoryProcess.processing;
          }, listener: (context, state) {
            if (state.process == TransactionHistoryProcess.processed) {
              Navigator.of(context).pop();
            }
          }),
          // Date listener
          BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
              listenWhen: (previous, current) {
            return current.fromDate != previous.fromDate ||
                current.toDate != previous.toDate;
          }, listener: (context, state) {
            var date;
            if (state.fromDate == null && state.toDate == null) date = '';
            if (state.fromDate == null && state.toDate != null)
              date =
                  'Đén ngày ${DateFormat('dd/MM/yyyy').format(state.toDate!)}';
            if (state.fromDate != null && state.toDate == null)
              date =
                  'Từ ngày ${DateFormat('dd/MM/yyyy').format(state.fromDate!)}';
            if (state.fromDate != null && state.toDate != null)
              date =
                  '${DateFormat('dd/MM/yyyy').format(state.fromDate!)} - ${DateFormat('dd/MM/yyyy').format(state.toDate!)}';

            _dateController.text = date;
          }),
        ],
        child: Scaffold(
          body: _body(),
        ),
      ),
    );
  }

  _searchField() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.collectorPhoneLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              context
                  .read<TransactionHistoryBloc>()
                  .add(EventChangeSearchPhone(searchphone: value));
            },
          ),
        );
      },
    );
  }

  _showFilter(blocBuilderContext) {
    showModalBottomSheet(
      context: blocBuilderContext,
      builder: (sheetContext) {
        return BlocProvider.value(
          value: BlocProvider.of<TransactionHistoryBloc>(blocBuilderContext),
          child: Container(
            padding: EdgeInsets.all(30),
            child: Wrap(
              alignment: WrapAlignment.end,
              spacing: 10,
              children: [
                _datePicker(),
                CustomTextWidget.customText(text: 'Tiền'),
                _priceRangeSlider(),
                _resetFilterButton(sheetContext),
                _filterButton(sheetContext),
              ],
            ),
          ),
        );
      },
    );
  }

  _datePicker() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextField(
            textAlign: TextAlign.center,
            controller: _dateController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Thời gian',
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            readOnly: true,
            onTap: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      content: Container(
                        height: 400,
                        width: 400,
                        child: Stack(children: [
                          SfDateRangePicker(
                            onSelectionChanged:
                                (DateRangePickerSelectionChangedArgs
                                    onSelectionChanged) {
                              context
                                  .read<TransactionHistoryBloc>()
                                  .add(EventChangeDate(
                                    fromDate:
                                        onSelectionChanged.value.startDate,
                                    toDate: onSelectionChanged.value.endDate,
                                  ));
                            },
                            selectionMode: DateRangePickerSelectionMode.range,
                            initialSelectedRange: PickerDateRange(
                              state.fromDate,
                              state.toDate,
                            ),
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Đồng ý')),
                          ),
                        ]),
                      ),
                    );
                  });
            },
          ),
        );
      },
    );
  }

  _priceRangeSlider() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 70,
          child: Stack(
            children: [
              Positioned(
                left: 10,
                bottom: 50,
                child:
                    Text(CustomFormats.currencyFormat.format(state.totalMin)),
              ),
              Positioned(
                right: 10,
                bottom: 50,
                child:
                    Text(CustomFormats.currencyFormat.format(state.totalMax)),
              ),
              RangeSlider(
                values: RangeValues(
                    state.fromTotal.toDouble(), state.toTotal.toDouble()),
                onChanged: (RangeValues newRange) {
                  context
                      .read<TransactionHistoryBloc>()
                      .add(EventChangeTotalRange(
                        startValue: newRange.start,
                        endValue: newRange.end,
                      ));
                },
                min: state.totalMin.toDouble(),
                max: state.totalMax.toDouble(),
                divisions: state.getDivision,
                labels: RangeLabels(
                    '${CustomFormats.currencyFormat.format(state.fromTotal)}',
                    '${CustomFormats.currencyFormat.format(state.toTotal)}'),
              ),
            ],
          ),
        );
      },
    );
  }

  _filterButton(sheetContext) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return CustomWidget.customElevatedButton(
          context,
          'Lọc',
          () {
            context.read<TransactionHistoryBloc>().add(EventInitData());
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  _resetFilterButton(sheetContext) {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return CustomWidget.customSecondaryButton(
          context: context,
          text: 'Thiết lập lại',
          action: () {
            context.read<TransactionHistoryBloc>().add(EventResetFilter());
            Navigator.pop(sheetContext);
          },
        );
      },
    );
  }

  _body() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      buildWhen: (previous, current) {
        return previous.transactionList.length !=
            current.transactionList.length;
      },
      builder: (context, state) {
        if (state.transactionList.isNotEmpty)
          return LazyLoadScrollView(
            scrollDirection: Axis.vertical,
            onEndOfPage: () {
              print('load more');
              _loadMoreTransactions(context);
            },
            child: RefreshIndicator(
              onRefresh: () async {
                print('init');
                context.read<TransactionHistoryBloc>().add(EventInitData());
              },
              child: NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    _appBar(),
                  ];
                },
                body: Container(
                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                  child: GroupedListView<CollectDealTransactionModel, DateTime>(
                    physics: NeverScrollableScrollPhysics(),
                    elements: state.transactionList,
                    order: GroupedListOrder.DESC,
                    groupBy: (CollectDealTransactionModel element) => DateTime(
                        element.transactionDateTime.year,
                        element.transactionDateTime.month,
                        element.transactionDateTime.day),
                    groupSeparatorBuilder: (DateTime element) =>
                        _groupSeparatorBuilder(time: element),
                    itemBuilder: (context, element) =>
                        _listTileBuilder(model: element, context: context),
                    separator: SizedBox(height: 5),
                  ),
                ),
              ),
            ),
          );
        else
          return Center(
            child: Text('Không có giao dịch'),
          );
      },
    );
  }

  _appBar() {
    return SliverAppBar(
      expandedHeight: 100,
      floating: true,
      pinned: true,
      snap: true,
      title: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
        builder: (context, state) {
          return Text(
            CustomTexts.transactionHistoryScreenTitle,
            style: Theme.of(context).textTheme.headline1,
          );
        },
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.amber,
        ),
        centerTitle: true,
        title: _searchField(),
      ),
      actions: [
        BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
          builder: (context, state) {
            return IconButton(
                onPressed: () {
                  _showFilter(context);
                },
                icon: Icon(Icons.filter_alt));
          },
        ),
      ],
    );
  }

  _groupSeparatorBuilder({required DateTime time}) {
    return Container(
        color: Colors.white,
        child: CustomTextWidget.customDateText(time: time));
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
