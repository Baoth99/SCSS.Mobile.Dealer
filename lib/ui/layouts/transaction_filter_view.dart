import 'package:dealer_app/blocs/transaction_history_bloc.dart';
import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/transaction_history_event.dart';
import 'package:dealer_app/repositories/states/transaction_history_state.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/custom_widgets.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class TransactionFilterView extends StatelessWidget {
  final _bloc = getIt.get<TransactionHistoryBloc>();
  final _dateController = TextEditingController();

  TransactionFilterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _bloc,
      child: MultiBlocListener(
        listeners: [
          BlocListener<TransactionHistoryBloc, TransactionHistoryState>(
              listenWhen: (previous, current) {
            return current.fromDate != previous.fromDate ||
                current.toDate != previous.toDate;
          }, listener: (context, state) {
            var date;
            if (state.fromDate == null && state.toDate == null) date = '-';
            if (state.fromDate == null && state.toDate != null)
              date = 'Đén ngày ${state.toDate}';
            if (state.fromDate != null && state.toDate == null)
              date = 'Từ ngày ${state.fromDate}';
            if (state.fromDate != null && state.toDate != null)
              date = '${state.fromDate} - ${state.toDate}';

            _dateController.text = date;
          }),
        ],
        child: Scaffold(
          appBar:
              CustomWidget.customAppBar(context: context, titleText: 'Bộ lọc'),
          body: _body(context),
        ),
      ),
    );
  }

  _body(context) {
    return Container(
      margin: EdgeInsets.fromLTRB(30, 30, 30, 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ListView(
            primary: false,
            shrinkWrap: true,
            children: [
              _datePicker(),
              CustomTextWidget.customText(text: 'Giá'),
              _priceRangeSlider(),
            ],
          ),
          CustomWidget.customElevatedButton(
            context,
            'Đồng ý',
            () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
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
                  _bloc.add(EventChangeTotalRange(
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

  _datePicker() {
    return BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextField(
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
                              _bloc.add(EventChangeDate(
                                fromDate: onSelectionChanged.value.startDate,
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
}
