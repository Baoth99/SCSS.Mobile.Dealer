import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/create_transaction_event.dart';
import 'package:dealer_app/repositories/handlers/data_handler.dart';
import 'package:dealer_app/repositories/handlers/promotion_handler.dart';
import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/promotion_model.dart';
import 'package:dealer_app/repositories/states/create_transaction_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreateTransactionBloc
    extends Bloc<CreateTransactionEvent, CreateTransactionState> {
  var dataHandler = getIt.get<IDataHandler>();
  var promotionHandler = getIt.get<IPromotionHandler>();

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
        var scrapCategories = await dataHandler.getScrapCategoryList();
        if (scrapCategories != null) {
          Map<String, String> scrapCategoryMap = {};
          scrapCategories.forEach((element) {
            scrapCategoryMap.putIfAbsent(element.id, () => element.name);
          });
          yield state.copyWith(scrapCategories: scrapCategories);
          yield state.copyWith(scrapCategoryMap: scrapCategoryMap);
          yield state.copyWith(
              itemDealerCategoryId: CustomVar.unnamedScrapCategory.id);
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
          isItemTotalCalculatedByUnitPrice: event.isCalculatedByUnitPrice);
    } else if (event is EventDealerCategoryChanged) {
      yield state.copyWith(itemDealerCategoryId: event.dealerCategoryId);
      yield state.copyWith(itemDealerCategoryDetailId: CustomTexts.emptyString);
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
    } else if (event is EventTotalChanged) {
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
                promotionId: state.itemPromotionId,
                bonusAmount: state.itemBonusAmount,
                total: state.isItemTotalCalculatedByUnitPrice
                    ? state.totalCalculated
                    : state.itemTotal,
                price: state.itemPrice,
                isCalculatedByUnitPrice: state.isItemTotalCalculatedByUnitPrice,
              ));
      yield state.copyWith(isItemsUpdated: true);
      yield state.copyWith(isItemsUpdated: false);
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
    }
  }
}
