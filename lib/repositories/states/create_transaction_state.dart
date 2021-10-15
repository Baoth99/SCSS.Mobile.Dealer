import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:dealer_app/repositories/models/collector_phone_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_detail_model.dart';
import 'package:dealer_app/repositories/models/scrap_category_model.dart';
import 'package:dealer_app/utils/param_util.dart';

class CreateTransactionState {
  String? collectorId;
  String collectorPhone;
  String? collectorName;
  int total;
  int totalBonus;

  Map<int, CollectDealTransactionDetailModel> items;

  Process process;
  bool isModalBottomSheetShowed;
  bool isItemsUpdated;
  bool isCollectorPhoneExist;

  //item data
  bool isNewItem;
  int? key;
  String itemDealerCategoryId;
  String? itemDealerCategoryDetailId;
  String? itemPromotionId;
  int itemBonusAmount;
  int itemTotal;
  int itemQuantity;
  int itemPrice;
  bool isItemTotalCalculatedByUnitPrice;
  List<ScrapCategoryDetailModel> scrapCategoryDetails;

  //data
  List<ScrapCategoryModel> scrapCategories;
  Map<String, String>
      scrapCategoryMap; //map contains unique categories <id, name> for dropdown list
  List<CollectorPhoneModel> collectorPhoneList;

  bool get isBonusAmountApplied {
    //check category id
    if (scrapCategories.isNotEmpty &&
        itemDealerCategoryId != '' &&
        itemDealerCategoryId != CustomVar.unnamedScrapCategory.id) {
      var appliedAmount = scrapCategories
          .firstWhere((element) => element.id == itemDealerCategoryId)
          .appliedAmount;
      // Check if appliedAmount is null or zero
      if (appliedAmount != null) {
        if (isItemTotalCalculatedByUnitPrice) {
          return totalCalculated >= appliedAmount;
        } else {
          return itemTotal >= appliedAmount;
        }
      } else
        return false;
    } else
      return false;
  }

  String? get promotionCode {
    if (isBonusAmountApplied) {
      return scrapCategories
          .firstWhere((element) => element.id == itemDealerCategoryId)
          .promotionCode;
    }
  }

  String? get promotionBonusAmount {
    if (isBonusAmountApplied) {
      return scrapCategories
          .firstWhere((element) => element.id == itemDealerCategoryId)
          .bonusAmount
          .toString();
    }
  }

  int get totalCalculated {
    if (isItemTotalCalculatedByUnitPrice && itemPrice != 0)
      return itemPrice * itemQuantity;
    else
      return 0;
  }

  int get initialUnitPrice {
    if (scrapCategoryDetails.isNotEmpty &&
        itemDealerCategoryDetailId != CustomTexts.emptyString) {
      return scrapCategoryDetails
          .firstWhere((element) => element.id == itemDealerCategoryDetailId)
          .price;
    }
    return itemPrice;
  }

  int get grandTotal {
    return total + totalBonus;
  }

  //validators
  bool get isScrapCategoryValid {
    if (itemDealerCategoryId == CustomTexts.emptyString ||
        (isItemTotalCalculatedByUnitPrice &&
            itemDealerCategoryId == CustomVar.unnamedScrapCategory.id)) {
      return false;
    } else
      return true;
  }

  bool get isScrapCategoryUnitValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemDealerCategoryDetailId == CustomTexts.emptyString ||
          itemDealerCategoryDetailId == null) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemQuantityValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemQuantity <= 0) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemPriceValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (itemPrice < 0) {
        return false;
      } else
        return true;
    } else
      return true;
  }

  bool get isItemTotalValid {
    if (isItemTotalCalculatedByUnitPrice) {
      if (totalCalculated < 0) {
        return false;
      } else
        return true;
    } else {
      if (itemTotal < 0) {
        return false;
      } else
        return true;
    }
  }

  bool get isPhoneValid =>
      RegExp(CustomRegexs.phoneRegex).hasMatch(collectorPhone);

  CreateTransactionState({
    String? collectorId,
    String? collectorPhone,
    String? collectorName,
    int? total,
    int? totalBonus,
    Map<int, CollectDealTransactionDetailModel>? items,
    Process? process,
    bool? isModalBottomSheetShowed,
    bool? isItemsUpdated,
    bool? isCollectorPhoneExist,
    //New item
    bool? isNewItem,
    int? key,
    String? itemDealerCategoryId,
    String? itemDealerCategoryDetailId,
    int? itemQuantity,
    String? itemPromotionId,
    int? itemBonusAmount,
    int? itemTotal,
    int? itemPrice,
    bool? isItemTotalCalculatedByUnitPrice,
    List<ScrapCategoryDetailModel>? scrapCategoryDetails,
    //Data
    List<ScrapCategoryModel>? scrapCategories,
    Map<String, String>? scrapCategoryMap,
    List<CollectorPhoneModel>? collectorPhoneList,
  })  : collectorId = collectorId,
        collectorPhone = collectorPhone ?? '',
        collectorName = collectorName,
        total = total ?? 0,
        totalBonus = totalBonus ?? 0,
        items = items ?? {},
        process = process ?? Process.neutral,
        isModalBottomSheetShowed = isModalBottomSheetShowed ?? false,
        isItemsUpdated = isItemsUpdated ?? false,
        isCollectorPhoneExist = isCollectorPhoneExist ?? false,
        //New item
        isNewItem = isNewItem ?? true,
        key = key,
        itemDealerCategoryId =
            itemDealerCategoryId ?? CustomVar.unnamedScrapCategory.id,
        itemDealerCategoryDetailId = itemDealerCategoryDetailId,
        itemQuantity = itemQuantity ?? 0,
        itemPromotionId = itemPromotionId,
        itemBonusAmount = itemBonusAmount ?? 0,
        itemTotal = itemTotal ?? 0,
        itemPrice = itemPrice ?? 0,
        isItemTotalCalculatedByUnitPrice =
            isItemTotalCalculatedByUnitPrice ?? false,
        scrapCategoryDetails = scrapCategoryDetails ?? [],
        //Data
        scrapCategories = scrapCategories ?? [],
        scrapCategoryMap = scrapCategoryMap ?? {},
        collectorPhoneList = collectorPhoneList ?? [];

  CreateTransactionState copyWith({
    String? collectorId,
    String? collectorPhone,
    String? collectorName,
    int? total,
    int? totalBonus,
    Map<int, CollectDealTransactionDetailModel>? items,
    Process? process,
    bool? isModalBottomSheetShowed,
    bool? isItemsUpdated,
    bool? isCollectorPhoneExist,
    //New item
    bool? isNewItem,
    int? key,
    String? itemDealerCategoryId,
    String? itemDealerCategoryDetailId,
    int? itemQuantity,
    String? itemPromotionId,
    int? itemBonusAmount,
    int? itemTotal,
    int? itemPrice,
    bool? isItemTotalCalculatedByUnitPrice,
    List<ScrapCategoryDetailModel>? scrapCategoryDetails,
    //Data
    List<ScrapCategoryModel>? scrapCategories,
    Map<String, String>? scrapCategoryMap,
    List<CollectorPhoneModel>? collectorPhoneList,
  }) {
    return CreateTransactionState(
      collectorId: collectorId ?? this.collectorId,
      collectorPhone: collectorPhone ?? this.collectorPhone,
      collectorName: collectorName ?? this.collectorName,
      total: total ?? this.total,
      totalBonus: totalBonus ?? this.totalBonus,
      items: items ?? this.items,
      process: process ?? this.process,
      isModalBottomSheetShowed:
          isModalBottomSheetShowed ?? this.isModalBottomSheetShowed,
      isItemsUpdated: isItemsUpdated ?? this.isItemsUpdated,
      isCollectorPhoneExist:
          isCollectorPhoneExist ?? this.isCollectorPhoneExist,
      //New item
      isNewItem: isNewItem ?? this.isNewItem,
      key: key ?? this.key,
      itemDealerCategoryId: itemDealerCategoryId ?? this.itemDealerCategoryId,
      itemDealerCategoryDetailId:
          itemDealerCategoryDetailId ?? this.itemDealerCategoryDetailId,
      itemQuantity: itemQuantity ?? this.itemQuantity,
      itemPromotionId: itemPromotionId ?? this.itemPromotionId,
      itemBonusAmount: itemBonusAmount ?? this.itemBonusAmount,
      itemTotal: itemTotal ?? this.itemTotal,
      itemPrice: itemPrice ?? this.itemPrice,
      isItemTotalCalculatedByUnitPrice: isItemTotalCalculatedByUnitPrice ??
          this.isItemTotalCalculatedByUnitPrice,
      scrapCategoryDetails: scrapCategoryDetails ?? this.scrapCategoryDetails,
      //Data
      scrapCategories: scrapCategories ?? this.scrapCategories,
      scrapCategoryMap: scrapCategoryMap ?? this.scrapCategoryMap,
      collectorPhoneList: collectorPhoneList ?? this.collectorPhoneList,
    );
  }

  CreateTransactionState clearItem() {
    return CreateTransactionState(
      collectorId: this.collectorId,
      collectorPhone: this.collectorPhone,
      collectorName: this.collectorName,
      total: this.total,
      totalBonus: this.totalBonus,
      items: this.items,
      process: this.process,
      isModalBottomSheetShowed: this.isModalBottomSheetShowed,
      isItemsUpdated: this.isItemsUpdated,
      isCollectorPhoneExist: this.isCollectorPhoneExist,
      //New item
      isNewItem: null,
      key: null,
      itemDealerCategoryId: null,
      itemDealerCategoryDetailId: null,
      itemQuantity: null,
      itemPromotionId: null,
      itemBonusAmount: null,
      itemTotal: null,
      itemPrice: null,
      isItemTotalCalculatedByUnitPrice: null,
      scrapCategoryDetails: null,
      //data
      scrapCategories: this.scrapCategories,
      scrapCategoryMap: this.scrapCategoryMap,
      collectorPhoneList: this.collectorPhoneList,
    );
  }

  CreateTransactionState clearCollector() {
    return CreateTransactionState(
      collectorId: null,
      collectorPhone: this.collectorPhone,
      collectorName: null,
      total: this.total,
      totalBonus: this.totalBonus,
      items: this.items,
      process: this.process,
      isModalBottomSheetShowed: this.isModalBottomSheetShowed,
      isItemsUpdated: this.isItemsUpdated,
      isCollectorPhoneExist: false,
      //New item
      isNewItem: this.isNewItem,
      key: this.key,
      itemDealerCategoryId: this.itemDealerCategoryId,
      itemDealerCategoryDetailId: this.itemDealerCategoryDetailId,
      itemQuantity: this.itemQuantity,
      itemPromotionId: this.itemPromotionId,
      itemBonusAmount: this.itemBonusAmount,
      itemTotal: this.itemTotal,
      itemPrice: this.itemPrice,
      isItemTotalCalculatedByUnitPrice: this.isItemTotalCalculatedByUnitPrice,
      scrapCategoryDetails: this.scrapCategoryDetails,
      //data
      scrapCategories: this.scrapCategories,
      scrapCategoryMap: this.scrapCategoryMap,
      collectorPhoneList: this.collectorPhoneList,
    );
  }
}
