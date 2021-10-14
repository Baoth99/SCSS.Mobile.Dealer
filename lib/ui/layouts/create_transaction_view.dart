import 'package:dealer_app/blocs/create_transaction_bloc.dart';
import 'package:dealer_app/repositories/events/create_transaction_event.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/repositories/states/create_transaction_state.dart';
import 'package:dealer_app/ui/widgets/buttons.dart';
import 'package:dealer_app/ui/widgets/flexible.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/currency_text_formatter.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTransactionView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _itemFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CreateTransactionBloc(initialState: CreateTransactionState()),
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
            listener: (context, state) {
              if (state.isModalBottomSheetShowed) {
                _showModalBottomSheet(context);
              }
              //process
              if (state.process == Process.processed) {
                Navigator.of(context).pop();
              } else if (state.process == Process.error) {
                _showSnackBar(context, CustomTexts.generalErrorMessage);
              }
              //  else if (state.process == Process.valid) {
              //   Navigator.of(context).pushNamed(CustomRoutes.registerOTP,
              //       arguments: {'phone': state.phone});
              // }
            },
          ),
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
              listenWhen: (previous, current) {
            return previous.process == Process.neutral;
          }, listener: (context, state) {
            if (state.process == Process.processing) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(),
                    ),
                  );
                },
              );
            }
          })
        ],
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            title: Text(
              CustomTexts.createTransactionScreenTitle,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          body: _body(),
        ),
      ),
    );
  }

  _body() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 30),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 90,
                  fit: FlexFit.tight,
                  child: ListView(
                    children: [
                      _phoneField(),
                      _nameField(),
                      _detailText(),
                      _items(),
                    ],
                  ),
                ),
                Flexible(
                  flex: 10,
                  child: _transactionButtons(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _phoneField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.collectorPhoneLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
            keyboardType: TextInputType.text,
            onChanged: (value) => context
                .read<CreateTransactionBloc>()
                .add(EventPhoneNumberChanged(collectorPhone: value)),
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.phoneBlank;
            },
          ),
        );
      },
    );
  }

  _nameField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: TextFormField(
            enabled: false,
            initialValue: state.collectorName,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.collectorNameLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
            ),
          ),
        );
      },
    );
  }

  _detailText() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(text: CustomTexts.detailText),
            //add item button
            InkWell(
              onTap: () {
                context
                    .read<CreateTransactionBloc>()
                    .add(EventShowModalBottomSheet());
              },
              child: Icon(Icons.add),
            )
          ],
        );
      },
    );
  }

  _items() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      buildWhen: (previous, current) {
        return previous.isItemsUpdated == false &&
            current.isItemsUpdated == true;
      },
      builder: (context, state) {
        return ListView.builder(
            primary: true,
            shrinkWrap: true,
            itemCount: state.items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: state.items[index] != null
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                              width: 150,
                              child: Text(
                                state.scrapCategories
                                    .firstWhere((element) =>
                                        element.id ==
                                        state.items[index]!.dealerCategoryId)
                                    .name,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                maxLines: 1,
                              )),
                          Text(CustomFormats.currencyFormat
                              .format(state.items[index]!.total)),
                        ],
                      )
                    : null,
                subtitle: state.items[index] != null
                    ? state.items[index]!.bonusAmount != 0
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(CustomTexts.promotionText),
                              ),
                              Text(CustomFormats.currencyFormat
                                  .format(state.items[index]!.bonusAmount)),
                            ],
                          )
                        : null
                    : null,
              );
            });
      },
    );
  }

  _transactionButtons() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Container(
          height: 40,
          child: rowFlexibleBuilder(
            cancelButtonBuilder(context, CustomTexts.cancelButtonText),
            customElevatedButton(
                context, CustomTexts.createTransactionButtonText, () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<CreateTransactionBloc>()
                    .add(EventSubmitNewTransaction());
                Navigator.of(context).pop();
              }
            }),
            rowFlexibleType.smallToBig,
          ),
        );
      },
    );
  }

  _showSnackBar(context, text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  void _showModalBottomSheet(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        insetPadding: EdgeInsets.zero,
        content: SizedBox(
          width: 320,
          height: 350,
          child: BlocProvider.value(
            value: BlocProvider.of<CreateTransactionBloc>(context),
            child: Form(
              key: _itemFormKey,
              child: ListView(
                children: [
                  _calculatedByUnitPriceSwitch(),
                  rowFlexibleBuilder(
                    _scrapCategoryUnitField(),
                    _scrapCategoryField(),
                    rowFlexibleType.bigToSmall,
                  ),
                  _quantityField(),
                  _unitPriceField(),
                  _totalField(),
                  _promotionApplicationBonusAmount(),
                  _promotionApplicationDescription(),
                ],
              ),
            ),
          ),
        ),
        actions: [
          cancelButtonBuilder(context, CustomTexts.cancelButtonText),
          customElevatedButton(context, CustomTexts.addScrapButtonText, () {
            if (_itemFormKey.currentState!.validate()) {
              context.read<CreateTransactionBloc>().add(EventAddNewItem());
              Navigator.of(context).pop();
            }
          }),
        ],
      ),
    );
  }

  _calculatedByUnitPriceSwitch() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return ListTile(
          isThreeLine: true,
          title: Text(CustomTexts.calculatedByUnitPriceText),
          subtitle: Text(CustomTexts.calculatedByUnitPriceExplainationText),
          trailing: Switch(
              value: state.isItemTotalCalculatedByUnitPrice,
              onChanged: (value) {
                context.read<CreateTransactionBloc>().add(
                    EventCalculatedByUnitPriceChanged(
                        isCalculatedByUnitPrice: value));
              }),
        );
      },
    );
  }

  _scrapCategoryField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch(
            mode: Mode.DIALOG,
            maxHeight: 250,
            showSelectedItems: true,
            showSearchBox: true,
            label: CustomTexts.scrapTypeLabel,
            items: state.scrapCategoryMap.keys.toList(),
            selectedItem: state.itemDealerCategoryId != CustomTexts.emptyString
                ? state.itemDealerCategoryId
                : null,
            compareFn: (String? item, String? selectedItem) =>
                item == selectedItem,
            itemAsString: (String? id) => id != null
                ? state.scrapCategoryMap[id] ?? CustomTexts.emptyString
                : CustomTexts.emptyString,
            validator: (value) {
              if (value == null || value == CustomTexts.emptyString)
                return CustomTexts.scrapTypeBlank;
            },
            onChanged: (String? selectedValue) {
              if (selectedValue != null)
                context.read<CreateTransactionBloc>().add(
                    EventDealerCategoryChanged(
                        dealerCategoryId: selectedValue));
            },
          ),
        );
      },
    );
  }

  _scrapCategoryUnitField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          height: 90,
          child: DropdownSearch(
            enabled: state.scrapCategoryDetails.isNotEmpty &&
                state.isItemTotalCalculatedByUnitPrice,
            selectedItem: state.itemDealerCategoryDetailId !=
                    CustomTexts.emptyString
                ? state.scrapCategoryDetails.firstWhere(
                    (element) => element.id == state.itemDealerCategoryDetailId)
                : null,
            mode: Mode.DIALOG,
            maxHeight: 250,
            showSelectedItems: true,
            label: CustomTexts.unitLabel,
            items: state.scrapCategoryDetails,
            compareFn: (ScrapCategoryDetailModel? item,
                    ScrapCategoryDetailModel? selectedItem) =>
                item?.id == selectedItem?.id,
            itemAsString: (ScrapCategoryDetailModel? model) =>
                model != null ? model.unit : CustomTexts.emptyString,
            validator: (value) {
              if (state.isItemTotalCalculatedByUnitPrice) {
                if (value == null || value == CustomTexts.emptyString)
                  return CustomTexts.scrapCategoryUnitBlank;
              }
            },
            onChanged: (ScrapCategoryDetailModel? selectedValue) {
              if (selectedValue != null)
                context.read<CreateTransactionBloc>().add(
                    EventDealerCategoryUnitChanged(
                        dealerCategoryDetailId: selectedValue.id));
            },
          ),
        );
      },
    );
  }

  _quantityField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isItemTotalCalculatedByUnitPrice,
          child: SizedBox(
            height: 90,
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: CustomTexts.quantityLabel,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyTextFormatter()],
              initialValue: state.itemQuantity.toString(),
              onChanged: (value) {
                if (value != CustomTexts.emptyString) {
                  context
                      .read<CreateTransactionBloc>()
                      .add(EventQuantityChanged(quantity: value));
                } else {
                  context.read<CreateTransactionBloc>().add(
                      EventQuantityChanged(quantity: CustomTexts.zeroString));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return CustomTexts.quantityBlank;
                if (!state.isItemQuantityValid) {
                  return CustomTexts.quantityZero;
                }
              },
            ),
          ),
        );
      },
    );
  }

  _unitPriceField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isItemTotalCalculatedByUnitPrice,
          child: SizedBox(
            height: 90,
            child: TextFormField(
              key: Key(state.itemDealerCategoryDetailId),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: CustomTexts.unitPriceLabel,
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                suffixText: CustomTexts.vndSymbolText,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [CurrencyTextFormatter()],
              //get the unit price for each unit
              initialValue: CustomFormats.numberFormat.format(state.itemPrice),
              onChanged: (value) {
                if (value != CustomTexts.emptyString) {
                  context.read<CreateTransactionBloc>().add(
                      EventUnitPriceChanged(
                          unitPrice: value.replaceAll(RegExp(r'[^0-9]'), '')));
                } else {
                  context.read<CreateTransactionBloc>().add(
                      EventUnitPriceChanged(unitPrice: CustomTexts.zeroString));
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty)
                  return CustomTexts.unitPriceBlank;
                if (!state.isItemPriceValid) {
                  return CustomTexts.unitPriceNegative;
                }
              },
            ),
          ),
        );
      },
    );
  }

  _totalField() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return SizedBox(
          key: state.isItemTotalCalculatedByUnitPrice ? UniqueKey() : null,
          height: 90,
          child: TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.totalLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixText: CustomTexts.vndSymbolText,
            ),
            enabled: !state.isItemTotalCalculatedByUnitPrice,
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyTextFormatter()],
            initialValue: state.isItemTotalCalculatedByUnitPrice
                ? CustomFormats.numberFormat.format(state.totalCalculated)
                : CustomFormats.numberFormat.format(state.itemTotal),
            onChanged: (value) {
              if (value != CustomTexts.emptyString) {
                context.read<CreateTransactionBloc>().add(EventTotalChanged(
                    total: value.replaceAll(RegExp(r'[^0-9]'), '')));
              } else {
                context
                    .read<CreateTransactionBloc>()
                    .add(EventTotalChanged(total: CustomTexts.zeroString));
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.totalBlank;
              if (!state.isItemPriceValid) {
                return CustomTexts.totalNegative;
              }
            },
          ),
        );
      },
    );
  }

  _promotionApplicationBonusAmount() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isBonusAmountApplied,
          child: customText(
            color: Color.fromARGB(204, 228, 121, 7),
            text: state.promotionBonusAmount != null
                ? '+ ${CustomFormats.numberFormat.format(int.parse(state.promotionBonusAmount!))}'
                : CustomTexts.emptyString,
          ),
        );
      },
    );
  }

  _promotionApplicationDescription() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isBonusAmountApplied,
          child: customText(
              color: Color.fromARGB(204, 228, 121, 7),
              text: state.promotionCode != null
                  ? CustomTexts.promotionAppliedText(
                      promotionId:
                          state.promotionCode ?? CustomTexts.emptyString)
                  : CustomTexts.promotionNotAppliedText),
        );
      },
    );
  }
}
