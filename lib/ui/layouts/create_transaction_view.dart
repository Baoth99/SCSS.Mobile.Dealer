import 'package:cool_alert/cool_alert.dart';
import 'package:dealer_app/blocs/create_transaction_bloc.dart';
import 'package:dealer_app/repositories/events/create_transaction_event.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/repositories/states/create_transaction_state.dart';
import 'package:dealer_app/ui/widgets/buttons.dart';
import 'package:dealer_app/ui/widgets/flexible.dart';
import 'package:dealer_app/ui/widgets/text.dart';
import 'package:dealer_app/utils/cool_alert.dart';
import 'package:dealer_app/utils/currency_text_formatter.dart';
import 'package:dealer_app/utils/custom_progress_indicator_dialog_widget.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/qr_scanner.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTransactionView extends StatelessWidget {
  final TextEditingController _collectorPhoneController =
      TextEditingController();
  final TextEditingController _collectorNameController =
      TextEditingController();
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
                _showItemDialog(context);
              }
              //process
              if (state.process == Process.processed) {
                Navigator.of(context).pop();
              } else if (state.process == Process.error) {
                _showSnackBar(context, CustomTexts.generalErrorMessage);
              } else if (state.process == Process.valid) {
                CustomCoolAlert.showCoolAlert(
                  context: context,
                  title: CustomTexts.createTransactionSuccessfullyText,
                  type: CoolAlertType.success,
                );
              }
            },
          ),
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
              listenWhen: (previous, current) {
            return previous.process == Process.neutral;
          }, listener: (context, state) {
            if (state.process == Process.processing) {
              showDialog(
                context: context,
                builder: (context) => const CustomProgressIndicatorDialog(
                  text: CustomTexts.pleaseWaitText,
                ),
              );
            }
          }),
          // Collector phone listener
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
              listenWhen: (previous, current) {
            return current.isQRScanned == true;
          }, listener: (context, state) {
            _collectorPhoneController.text = state.collectorPhone;
          }),
          // Collector name listener
          BlocListener<CreateTransactionBloc, CreateTransactionState>(
              listenWhen: (previous, current) {
            return previous.collectorName != current.collectorName;
          }, listener: (context, state) {
            _collectorNameController.text =
                state.collectorName ?? CustomTexts.emptyString;
          }),
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
                      const Divider(),
                      _subTotal(),
                      _promotioBonusnAmount(),
                      const Divider(),
                      _total(),
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
            controller: _collectorPhoneController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: CustomTexts.collectorPhoneLabel,
              floatingLabelBehavior: FloatingLabelBehavior.auto,
              suffixIcon: _scanQRIcon(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: (value) {
              context
                  .read<CreateTransactionBloc>()
                  .add(EventPhoneNumberChanged(collectorPhone: value));
            },
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.phoneBlank;
              if (!state.isPhoneValid) return CustomTexts.phoneError;
              if (!state.isCollectorPhoneExist && state.collectorId == null)
                return CustomTexts.phoneNotExist;
            },
          ),
        );
      },
    );
  }

  _scanQRIcon() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return IconButton(
            onPressed: () async {
              var collectorId;
              collectorId = await QRScanner.scanQR();
              context
                  .read<CreateTransactionBloc>()
                  .add(EventCollectorIdChanged(collectorId: collectorId));
            },
            icon: Icon(Icons.qr_code_scanner));
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
            controller: _collectorNameController,
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
            Visibility(
              visible: state.scrapCategoryMap.length != 0,
              child: InkWell(
                onTap: () {
                  context
                      .read<CreateTransactionBloc>()
                      .add(EventShowItemDialog());
                },
                child: Icon(Icons.add),
              ),
            ),
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
        return ListView.separated(
          primary: false,
          shrinkWrap: true,
          itemCount: state.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                context.read<CreateTransactionBloc>().add(EventShowItemDialog(
                      key: index,
                      detail: state.items[index],
                    ));
              },
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5))),
              tileColor: CustomColors.lightGray,
              title: state.items[index] != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          flex: 3,
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              state.scrapCategories
                                  .firstWhere((element) =>
                                      element.id ==
                                      state.items[index]!.dealerCategoryId)
                                  .name,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                              maxLines: 1,
                            ),
                          ),
                        ),
                        state.items[index]!.quantity != 0 &&
                                state.items[index]!.unit != null
                            ? Flexible(
                                flex: 3,
                                fit: FlexFit.loose,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    state.items[index]!.quantity != 0 &&
                                            state.items[index]!.unit != null
                                        ? '${CustomFormats.numberFormat.format(state.items[index]!.quantity)} ${state.items[index]!.unit}'
                                        : CustomTexts.emptyString,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              )
                            : Container(),
                        Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              CustomFormats.currencyFormat
                                  .format(state.items[index]!.total),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
              subtitle: state.items[index] != null &&
                      state.items[index]!.bonusAmount != 0 &&
                      state.items[index]!.isPromotionnApplied
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
                          CustomFormats.currencyFormat
                              .format(state.items[index]!.bonusAmount),
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                      ],
                    )
                  : null,
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return SizedBox(
              height: 10,
            );
          },
        );
      },
    );
  }

  _subTotal() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: CustomTexts.subTotalText,
              height: 30,
            ),
            customText(
              text: CustomFormats.currencyFormat.format(state.total),
              height: 30,
            ),
          ],
        );
      },
    );
  }

  _promotioBonusnAmount() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: CustomTexts.promotionText,
              height: 30,
            ),
            customText(
              text: CustomFormats.currencyFormat.format(state.totalBonus),
              height: 30,
            ),
          ],
        );
      },
    );
  }

  _total() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            customText(
              text: CustomTexts.totalText,
              height: 30,
            ),
            customText(
              text: CustomFormats.currencyFormat.format(state.grandTotal),
              height: 30,
            ),
          ],
        );
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

// Item fields
  void _showItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
        value: BlocProvider.of<CreateTransactionBloc>(context),
        child: AlertDialog(
          insetPadding: EdgeInsets.zero,
          content: SizedBox(
            width: 320,
            height: 400,
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
                  Stack(
                    children: [
                      _totalField(),
                      Positioned(
                        top: 3,
                        right: 30,
                        child: _promotionApplicationBonusAmount(),
                      )
                    ],
                  ),
                  _promotionApplicationDescription(),
                ],
              ),
            ),
          ),
          actions: [
            cancelButtonBuilder(context, CustomTexts.cancelButtonText),
            _addAndUpdateItemButton(),
          ],
        ),
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
            onChanged:
                state.itemDealerCategoryId != CustomVar.unnamedScrapCategory.id
                    ? (value) {
                        context.read<CreateTransactionBloc>().add(
                            EventCalculatedByUnitPriceChanged(
                                isCalculatedByUnitPrice: value));
                      }
                    : null,
          ),
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
              if (!state.isScrapCategoryValid)
                return CustomTexts.scrapTypeNotChoosenError;
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
            selectedItem: state.itemDealerCategoryDetailId != null
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
              initialValue:
                  CustomFormats.numberFormat.format(state.itemQuantity),
              onChanged: (value) {
                if (value != CustomTexts.emptyString) {
                  context.read<CreateTransactionBloc>().add(
                      EventQuantityChanged(
                          quantity: value.replaceAll(RegExp(r'[^0-9]'), '')));
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
              key: state.itemDealerCategoryDetailId != null
                  ? Key(state.itemDealerCategoryDetailId!)
                  : null,
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
              errorStyle: TextStyle(
                color: Theme.of(context).errorColor, // or any other color
              ),
            ),
            enabled: !state.isItemTotalCalculatedByUnitPrice,
            keyboardType: TextInputType.number,
            inputFormatters: [CurrencyTextFormatter()],
            initialValue: state.isItemTotalCalculatedByUnitPrice
                ? CustomFormats.numberFormat.format(state.itemTotalCalculated)
                : CustomFormats.numberFormat.format(state.itemTotal),
            onChanged: (value) {
              if (value != CustomTexts.emptyString) {
                context.read<CreateTransactionBloc>().add(EventItemTotalChanged(
                    total: value.replaceAll(RegExp(r'[^0-9]'), '')));
              } else {
                context
                    .read<CreateTransactionBloc>()
                    .add(EventItemTotalChanged(total: CustomTexts.zeroString));
              }
            },
            validator: (value) {
              if (value == null || value.isEmpty) return CustomTexts.totalBlank;
              if (!state.isItemTotalNegative) {
                return CustomTexts.totalNegative;
              }
              if (!state.isItemTotalUnderLimit) {
                return CustomTexts.totalOverLimit;
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
          visible: state.isPromotionApplied,
          child: customText(
            textStyle: Theme.of(context).textTheme.bodyText2,
            text:
                '+ ${CustomFormats.numberFormat.format(state.itemBonusAmount)}',
          ),
        );
      },
    );
  }

  _promotionApplicationDescription() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return Visibility(
          visible: state.isPromotionApplied,
          child: customText(
              textStyle: Theme.of(context).textTheme.bodyText2,
              text: state.itemPromotionId != null
                  ? CustomTexts.promotionAppliedText(
                      promotionCode: state.getItemPromotionCode)
                  : CustomTexts.promotionNotAppliedText),
        );
      },
    );
  }

  _addAndUpdateItemButton() {
    return BlocBuilder<CreateTransactionBloc, CreateTransactionState>(
      builder: (context, state) {
        return customElevatedButton(
            context,
            state.key == null
                ? CustomTexts.addScrapButtonText
                : CustomTexts.saveUpdateButtonText, () {
          if (_itemFormKey.currentState!.validate()) {
            if (state.isNewItem)
              context.read<CreateTransactionBloc>().add(EventAddNewItem());
            else
              context.read<CreateTransactionBloc>().add(EventUpdateItem());
            Navigator.of(context).pop();
          }
        });
      },
    );
  }
}