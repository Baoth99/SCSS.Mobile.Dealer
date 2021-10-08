import 'package:dealer_app/repositories/models/collect_deal_transaction_detail_model.dart';
import 'package:equatable/equatable.dart';

abstract class CreateTransactionEvent extends Equatable {}

class EventPhoneNumberChanged extends CreateTransactionEvent {
  final String phoneNumber;

  EventPhoneNumberChanged({required this.phoneNumber});

  @override
  List<String> get props => [phoneNumber];
}

class EventOpenQRScanner extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}

class EventSellerNameChanged extends CreateTransactionEvent {
  final String sellerName;

  EventSellerNameChanged({required this.sellerName});

  @override
  List<String> get props => [sellerName];
}

class EventDetailAdded extends CreateTransactionEvent {
  final CollectDealTransactionDetailModel detail;

  EventDetailAdded({required this.detail});

  @override
  List<CollectDealTransactionDetailModel> get props => [detail];
}

class EventDetailedChanged extends CreateTransactionEvent {
  final int key;
  final CollectDealTransactionDetailModel detail;

  EventDetailedChanged({required this.detail, required this.key});

  @override
  List<Object> get props => [key, detail];
}

class EventSendOTP extends CreateTransactionEvent {
  @override
  List<Object?> get props => [];
}
