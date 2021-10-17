import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/create_transaction_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/collector_phone_model.dart';
import 'package:dealer_app/repositories/models/info_review_model.dart';
import 'package:dealer_app/repositories/models/promotion_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/repositories/states/create_transaction_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTransactionBloc
    extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  var dataHandler = getIt.get<IDataHandler>();
  var promotionHandler = getIt.get<IPromotionHandler>();
  var collectDealTransactionHandler =
      getIt.get<ICollectDealTransactionHandler>();

  CreateTransactionBloc({required CreateTransactionState initialState})
      : super(initialState) {
    add(EventInitValues());
  }

  late List<PromotionModel> promotions;

  @override
  Stream<CreateTransactionState> mapEventToState(
      CreateTransactionEvent event) async* {
    if (event is EventInitValues) {
      //get categories
      yield state.copyWith(process: Process.processing);
      try {
        var collectorPhoneList = await dataHandler.getCollectorPhoneList();
        var scrapCategories = await dataHandler.getScrapCategoryList();
        if (scrapCategories != null) {
          Map<String, String> scrapCategoryMap = {};
          scrapCategories.forEach((element) {
            scrapCategoryMap.putIfAbsent(element.id, () => element.name);
          });
          yield state.copyWith(
            scrapCategories: scrapCategories,
            collectorPhoneList: collectorPhoneList,
            scrapCategoryMap: scrapCategoryMap,
            itemDealerCategoryId: CustomVar.unnamedScrapCategory.id,
          );
        }
        yield state.copyWith(process: Process.processed);
      } catch (e) {
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.error);
      } finally {
        yield state.copyWith(process: Process.neutral);
      }
    } else if (event is EventPhoneNumberChanged) {
      yield state.copyWith(collectorPhone: event.collectorPhone);
      // Check if phone is valid
      if (state.isPhoneValid) {
        yield state.copyWith(process: Process.processing);
        try {
          CollectorPhoneModel? collectorModel = state.collectorPhoneList
              .firstWhere((element) => element.phone == event.collectorPhone);
          // Check if collector phone exist, then get collector name + id
          if (collectorModel != null) {
            InfoReviewModel? collectorInfo = await collectDealTransactionHandler
                .getInfoReview(collectorId: collectorModel.id);
            // Check if collectorInfo is null
            if (collectorInfo != null) {
              yield state.copyWith(
                collectorId: collectorInfo.collectorId,
                collectorName: collectorInfo.collectorName,
                isCollectorPhoneExist: true,
              );
            } else
              yield state.copyWith(isCollectorPhoneExist: false);
          } else
            yield state.copyWith(isCollectorPhoneExist: false);
          //Done processing
          yield state.copyWith(process: Process.processed);
        } on StateError {
          yield state.copyWith(isCollectorPhoneExist: false);
          yield state.copyWith(process: Process.processed);
        } catch (e) {
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.error);
        } finally {
          yield state.copyWith(process: Process.neutral);
        }
      } else {
        // Remove id and name if phone is not valid
        if (state.collectorId != null) yield state.clearCollector();
        if (state.collectorName != null) yield state.clearCollector();
        if (state.isCollectorPhoneExist) yield state.clearCollector();
      }
    } else if (event is EventOpenQRScanner) {
      //TODO:
    } else if (event is EventShowItemDialog) {
      // Update dropdown list
      _updateScrapCategoryMap();
      if (event.key == null || event.detail == null)
        _updateItemDealerCategoryId();
      // If item is choosen instead
      else {
        // Add scrap category back to the dropdown list
        var scrapCategory = state.scrapCategories.firstWhere(
            (element) => element.id == event.detail!.dealerCategoryId);
        _addScrapCategoryOnItemSelected(
          id: scrapCategory.id,
          name: scrapCategory.name,
        );
        // Get details
        List<ScrapCategoryDetailModel>? details;
        if (event.detail!.dealerCategoryId !=
            CustomVar.unnamedScrapCategory.id) {
          details = await dataHandler.getScrapCategoryDetailList(
              scrapCategoryId: event.detail!.dealerCategoryId);
        }
        // Add item data
        state.isNewItem = false;
        state.key = event.key;
        state.itemBonusAmount = event.detail!.bonusAmount;
        state.itemDealerCategoryDetailId = event.detail!.dealerCategoryDetailId;
        state.itemDealerCategoryId = event.detail!.dealerCategoryId;
        state.isItemTotalCalculatedByUnitPrice =
            event.detail!.isCalculatedByUnitPrice;
        state.itemPrice = event.detail!.price;
        state.itemPromotionId = event.detail!.promotionId;
        state.itemQuantity = event.detail!.quantity;
        state.itemTotal = event.detail!.total;
        state.scrapCategoryDetails = details ?? [];
        state.isPromotionApplied = event.detail!.isPromotionnApplied;
      }
      // Open dialog
      yield state.copyWith(isItemDialogShowed: true);
      yield state.copyWith(isItemDialogShowed: false);
    } else if (event is EventCalculatedByUnitPriceChanged) {
      state.isItemTotalCalculatedByUnitPrice = event.isCalculatedByUnitPrice;
      state.itemDealerCategoryDetailId = null;
      // Check if false
      if (event.isCalculatedByUnitPrice != false &&
          state.itemDealerCategoryId != CustomVar.unnamedScrapCategory.id) {
        try {
          //get category details
          yield state.copyWith(process: Process.processing);
          var scrapCategoryDetailList =
              await dataHandler.getScrapCategoryDetailList(
                  scrapCategoryId: state.itemDealerCategoryId);
          if (scrapCategoryDetailList != null)
            yield state.copyWith(scrapCategoryDetails: scrapCategoryDetailList);
          yield state.copyWith(process: Process.processed);
        } catch (e) {
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.error);
        } finally {
          yield state.copyWith(process: Process.neutral);
        }
      } else {
        yield state.copyWith(scrapCategoryDetails: []);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventDealerCategoryChanged) {
      yield state.copyWith(itemDealerCategoryId: event.dealerCategoryId);
      yield state.copyWith(itemDealerCategoryDetailId: null);
      if (event.dealerCategoryId != CustomVar.unnamedScrapCategory.id) {
        try {
          //get category details
          yield state.copyWith(process: Process.processing);
          var scrapCategoryDetailList =
              await dataHandler.getScrapCategoryDetailList(
                  scrapCategoryId: event.dealerCategoryId);
          if (scrapCategoryDetailList != null)
            yield state.copyWith(scrapCategoryDetails: scrapCategoryDetailList);
          yield state.copyWith(process: Process.processed);
        } catch (e) {
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.error);
        } finally {
          yield state.copyWith(process: Process.neutral);
        }
      } else {
        yield state.copyWith(scrapCategoryDetails: []);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventDealerCategoryUnitChanged) {
      var unitPrice = state.scrapCategoryDetails
          .firstWhere((element) => element.id == event.dealerCategoryDetailId)
          .price;
      if (unitPrice != null) {
        yield state.copyWith(
            itemDealerCategoryDetailId: event.dealerCategoryDetailId,
            itemPrice: unitPrice);
      } else {
        yield state.copyWith(
            itemDealerCategoryDetailId: event.dealerCategoryDetailId);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventItemTotalChanged) {
      var totalInt = int.tryParse(event.total);
      if (totalInt != null)
        yield state.copyWith(itemTotal: totalInt);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventQuantityChanged) {
      var quantity = int.tryParse(event.quantity);
      if (quantity != null)
        yield state.copyWith(itemQuantity: quantity);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventUnitPriceChanged) {
      var unitPrice = int.tryParse(event.unitPrice);
      if (unitPrice != null)
        yield state.copyWith(itemPrice: unitPrice);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      //Check promotion
      _setItemPromotion();
    } else if (event is EventAddNewItem) {
      // Put new item
      state.items.putIfAbsent(
          state.items.length,
          () => CollectDealTransactionDetailModel(
                dealerCategoryId: state.itemDealerCategoryId,
                dealerCategoryDetailId: state.itemDealerCategoryDetailId,
                quantity: state.itemQuantity,
                unit: state.itemDealerCategoryDetailId != null
                    ? state.scrapCategoryDetails
                        .firstWhere((element) =>
                            element.id == state.itemDealerCategoryDetailId)
                        .unit
                    : null,
                promotionId: state.itemPromotionId,
                bonusAmount: state.itemBonusAmount,
                total: state.isItemTotalCalculatedByUnitPrice
                    ? state.itemTotalCalculated
                    : state.itemTotal,
                price: state.itemPrice,
                isCalculatedByUnitPrice: state.isItemTotalCalculatedByUnitPrice,
                isPromotionnApplied: state.isPromotionApplied,
              ));
      // Update category dropdown
      _updateScrapCategoryMap();
      // Update the item list
      yield state.copyWith(isItemsUpdated: true);
      yield state.copyWith(isItemsUpdated: false);
      //clear item values
      _resetItemValue();
      // Reload values
      add(EventReloadValues());
    } else if (event is EventSubmitNewTransaction) {
      //start progress indicator
      yield state.copyWith(process: Process.processing);
      try {
        //TODO:
        await Future.delayed(Duration(seconds: 5));
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.valid);
      } on Exception {
        yield state.copyWith(process: Process.processed);
        yield state.copyWith(process: Process.error);
      } finally {
        yield state.copyWith(process: Process.neutral);
      }
    } else if (event is EventUpdateItem) {
      if (state.key != null) {
        // update item
        state.items.update(
            state.key!,
            (value) => CollectDealTransactionDetailModel(
                  dealerCategoryId: state.itemDealerCategoryId,
                  dealerCategoryDetailId: state.itemDealerCategoryDetailId,
                  quantity: state.itemQuantity,
                  unit: state.itemDealerCategoryDetailId != null
                      ? state.scrapCategoryDetails
                          .firstWhere((element) =>
                              element.id == state.itemDealerCategoryDetailId)
                          .unit
                      : null,
                  promotionId: state.itemPromotionId,
                  bonusAmount: state.itemBonusAmount,
                  total: state.isItemTotalCalculatedByUnitPrice
                      ? state.itemTotalCalculated
                      : state.itemTotal,
                  price: state.itemPrice,
                  isCalculatedByUnitPrice:
                      state.isItemTotalCalculatedByUnitPrice,
                  isPromotionnApplied: state.isPromotionApplied,
                ));
        // Update category dropdown
        _updateScrapCategoryMap();
        // Update the item list
        yield state.copyWith(isItemsUpdated: true);
        yield state.copyWith(isItemsUpdated: false);
        //clear item values
        _resetItemValue();
        // Reload values
        add(EventReloadValues());
      }
    } else if (event is EventReloadValues) {
      // // Activate highest bonus amount promotion, and disable the others
      // _enablePromotionInItems();
      // Recalculate total and total bonus amount
      _recalculateTotalAndBonusAmount();

      yield state.copyWith();
    }
  }

  _updateScrapCategoryMap() {
    state.items.forEach((itemKey, itemValue) {
      state.scrapCategoryMap.removeWhere(
          (mapKey, mapValue) => mapKey == itemValue.dealerCategoryId);
    });
  }

  _updateItemDealerCategoryId() {
    state.itemDealerCategoryId = state.scrapCategoryMap.keys.first;
  }

  _addScrapCategoryOnItemSelected({required id, required name}) {
    state.scrapCategoryMap.putIfAbsent(id, () => name);
  }

  // ScrapCategoryModel? _getScrapCategoryWithActivePromotion() {
  //   var promotionId;
  //   state.items.forEach((key, value) {
  //     if (value.isPromotionnApplied) promotionId = value.promotionId;
  //   });
  //   if (promotionId == null)
  //     return null;
  //   else {
  //     var model = state.scrapCategories
  //         .firstWhere((element) => element.promotionId == promotionId);
  //     return model;
  //   }
  // }

  _setItemPromotion() {
    //Get sublist of selected category from dropdown
    List<ScrapCategoryModel> scrapSublist = state.scrapCategories
        .where((element) => element.id == state.itemDealerCategoryId)
        .toList();
    // If there is no promotion
    if (scrapSublist.isEmpty) {
      state.itemPromotionId = null;
      state.itemBonusAmount = 0;
    }
    // If there is promotion
    else {
      // var scrapCategoryWithActivePromotion =
      //     _getScrapCategoryWithActivePromotion();
      var itemPromotionId;
      var itemBonusAmount = 0;
      var isPromotionApplied = false;
      var total = 0;
      if (state.isItemTotalCalculatedByUnitPrice)
        total = state.itemTotalCalculated;
      else
        total = state.itemTotal;
      //Searching for suitable promotion
      scrapSublist.forEach((element) {
        if (element.appliedAmount != null &&
            total >= element.appliedAmount &&
            element.bonusAmount > itemBonusAmount) {
          // Found suitable promotion
          // // If there is no active promotion
          // if (scrapCategoryWithActivePromotion == null) {
          itemPromotionId = element.promotionId;
          itemBonusAmount = element.bonusAmount;
          isPromotionApplied = true;
          // } else {
          // // If this one is the active one or has bonus amount > active one
          // if (element.promotionId ==
          //         scrapCategoryWithActivePromotion.promotionId ||
          //     element.bonusAmount >
          //         scrapCategoryWithActivePromotion.bonusAmount) {
          //   itemPromotionId = element.promotionId;
          //   itemBonusAmount = element.bonusAmount;
          //   isPromotionApplied = true;
          // }
          // // If this one is not the active one
          // else if (element.promotionId !=
          //     scrapCategoryWithActivePromotion.promotionId) {
          //   itemPromotionId = element.promotionId;
          //   itemBonusAmount = element.bonusAmount;
          //   isPromotionApplied = false;
          // }
          // }
        }
      });
      //Set promotion
      state.itemPromotionId = itemPromotionId;
      state.itemBonusAmount = itemBonusAmount;
      state.isPromotionApplied = isPromotionApplied;
    }
  }

  _resetItemValue() {
    state.isNewItem = true;
    state.key = null;
    state.itemDealerCategoryId = state.scrapCategoryMap.isNotEmpty
        ? state.scrapCategoryMap.keys.first
        : '';
    state.itemDealerCategoryDetailId = null;
    state.itemQuantity = 0;
    state.itemPromotionId = null;
    state.itemBonusAmount = 0;
    state.itemTotal = 0;
    state.itemPrice = 0;
    state.isItemTotalCalculatedByUnitPrice = false;
    state.scrapCategoryDetails = [];
    state.isPromotionApplied = false;
  }

  _recalculateTotalAndBonusAmount() {
    var total = 0;
    var totalBonus = 0;
    state.items.forEach((key, value) {
      total +=
          value.isCalculatedByUnitPrice ? value.totalCalculated : value.total;
      if (value.isPromotionnApplied) totalBonus += value.bonusAmount;
    });
    // Set value
    state.total = total;
    state.totalBonus = totalBonus;
  }

  // _enablePromotionInItems() {
  //   var itemKey;
  //   var bonusAmount = 0;
  //   // Find the promotion with highest bonus amount
  //   state.items.forEach((key, value) {
  //     if (value.bonusAmount > bonusAmount) {
  //       itemKey = key;
  //       bonusAmount = value.bonusAmount;
  //     }
  //   });
  //   // Activate the promotion with highest bonus amount
  //   state.items.forEach((key, value) {
  //     if (key != itemKey)
  //       value.isPromotionnApplied = false;
  //     else
  //       value.isPromotionnApplied = true;
  //   });
  // }
}
