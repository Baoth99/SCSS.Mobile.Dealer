import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:equatable/equatable.dart';

abstract class CreateTransactionEvent extends Equatable {}

class EventPhoneNumberChanged extends CreateTransactionEvent {
  final String collectorPhone;

  EventPhoneNumberChanged({required this.collectorPhone});

  @override
  List<String> get props => [collectorPhone];
}

class EventOpenQRScanner extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventCalculatedByUnitPriceChanged extends CreateTransactionEvent {
  final bool isCalculatedByUnitPrice;

  EventCalculatedByUnitPriceChanged({required this.isCalculatedByUnitPrice});

  @override
  List<bool> get props => [isCalculatedByUnitPrice];
}

class EventDealerCategoryChanged extends CreateTransactionEvent {
  final String dealerCategoryId;

  EventDealerCategoryChanged({required this.dealerCategoryId});

  @override
  List<String> get props => [dealerCategoryId];
}

class EventDealerCategoryUnitChanged extends CreateTransactionEvent {
  final String dealerCategoryDetailId;

  EventDealerCategoryUnitChanged({required this.dealerCategoryDetailId});

  @override
  List<String> get props => [dealerCategoryDetailId];
}

class EventTotalChanged extends CreateTransactionEvent {
  final String total;

  EventTotalChanged({required this.total});

  @override
  List<String> get props => [total];
}

class EventQuantityChanged extends CreateTransactionEvent {
  final String quantity;

  EventQuantityChanged({required this.quantity});

  @override
  List<String> get props => [quantity];
}

class EventUnitPriceChanged extends CreateTransactionEvent {
  final String unitPrice;

  EventUnitPriceChanged({required this.unitPrice});

  @override
  List<String> get props => [unitPrice];
}

class EventAddNewItem extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventEditItem extends CreateTransactionEvent {
  final int key;
  final CollectDealTransactionDetailModel detail;

  EventEditItem({required this.detail, required this.key});

  @override
  List<Object> get props => [key, detail];
}

class EventSubmitNewTransaction extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventShowModalBottomSheet extends CreateTransactionEvent {
  final int? key;
  final CollectDealTransactionDetailModel? detail;

  EventShowModalBottomSheet({this.detail, this.key});

  @override
  List<Object?> get props => [key, detail];
}

class EventInitValues extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}
