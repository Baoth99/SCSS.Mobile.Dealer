import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/create_transaction_event.dart';
import 'package:dealer_app/repositories/handlers/collect_deal_transaction_handler.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/collector_phone_model.dart';
import 'package:dealer_app/repositories/models/info_review_model.dart';
import 'package:dealer_app/repositories/models/promotion_model.dart';
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
    } else if (event is EventShowModalBottomSheet) {
      yield state.copyWith(isModalBottomSheetShowed: true);
      yield state.copyWith(isModalBottomSheetShowed: false);
      if (event.key != null && event.detail != null)
        yield state.copyWith(
          key: event.key,
          itemBonusAmount: event.detail!.bonusAmount,
          itemDealerCategoryDetailId: event.detail!.dealerCategoryDetailId,
          itemDealerCategoryId: event.detail!.dealerCategoryId,
          isItemTotalCalculatedByUnitPrice:
              event.detail!.isCalculatedByUnitPrice,
          itemPrice: event.detail!.price,
          itemPromotionId: event.detail!.promotionId,
          itemQuantity: event.detail!.quantity,
          itemTotal: event.detail!.total,
        );
    } else if (event is EventCalculatedByUnitPriceChanged) {
      yield state.copyWith(
        isItemTotalCalculatedByUnitPrice: event.isCalculatedByUnitPrice,
        itemDealerCategoryDetailId: null,
      );
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
    } else if (event is EventItemTotalChanged) {
      var totalInt = int.tryParse(event.total);
      if (totalInt != null)
        yield state.copyWith(itemTotal: totalInt);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      if (state.isBonusAmountApplied) if (state.promotionBonusAmount != null)
        yield state.copyWith(
          itemBonusAmount: int.parse(state.promotionBonusAmount!),
          itemPromotionId: state.promotionCode,
        );
    } else if (event is EventQuantityChanged) {
      var quantity = int.tryParse(event.quantity);
      if (quantity != null)
        yield state.copyWith(itemQuantity: quantity);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      if (state.isBonusAmountApplied) if (state.promotionBonusAmount != null)
        yield state.copyWith(
          itemBonusAmount: int.parse(state.promotionBonusAmount!),
          itemPromotionId: state.promotionCode,
        );
    } else if (event is EventUnitPriceChanged) {
      var unitPrice = int.tryParse(event.unitPrice);
      if (unitPrice != null)
        yield state.copyWith(itemPrice: unitPrice);
      else {
        yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.neutral);
      }
      if (state.isBonusAmountApplied) if (state.promotionBonusAmount != null)
        yield state.copyWith(
          itemBonusAmount: int.parse(state.promotionBonusAmount!),
          itemPromotionId: state.promotionCode,
        );
    } else if (event is EventAddNewItem) {
      var newItemList = state.items;
      newItemList.putIfAbsent(
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
                    ? state.totalCalculated
                    : state.itemTotal,
                price: state.itemPrice,
                isCalculatedByUnitPrice: state.isItemTotalCalculatedByUnitPrice,
              ));
      // Update the item list
      yield state.copyWith(isItemsUpdated: true);
      yield state.copyWith(isItemsUpdated: false);
      //clear item values
      add(EventClearItemValues());
      // Recalculate total and total bonus amount
      add(EventRecalculateTotalAndBonusAmount());
    } else if (event is EventEditItem) {
      var modifiedItemList = state.items;
      modifiedItemList.putIfAbsent(event.key, () => event.detail);
      yield state.copyWith(items: modifiedItemList);
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
    } else if (event is EventClearItemValues) {
      yield state.clearItem();
    } else if (event is EventRecalculateTotalAndBonusAmount) {
      var total = 0;
      var totalBonus = 0;
      state.items.forEach((key, value) {
        total +=
            value.isCalculatedByUnitPrice ? value.totalCalculated : value.total;
        totalBonus += value.bonusAmount;
      });

      yield state.copyWith(total: total, totalBonus: totalBonus);
    }
  }
}
