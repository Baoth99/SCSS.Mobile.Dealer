import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {}

class EventPhoneNumberChanged extends RegisterEvent {
  final String phoneNumber;

  EventPhoneNumberChanged({required this.phoneNumber});

  @override
  List<String> get props => [phoneNumber];
}

class EventSendOTP extends RegisterEvent {
  @override
  List<Object?> get props => [];
}

// class EventNameChanged extends RegisterEvent {
//   final String name;

//   EventNameChanged({required this.name});

//   @override
//   List<String> get props => [name];
// }

// class EventIdChanged extends RegisterEvent {
//   final String id;

//   EventIdChanged({required this.id});

//   @override
//   List<String> get props => [id];
// }

// class EventBirthdateChanged extends RegisterEvent {
//   final DateTime birthdate;

//   EventBirthdateChanged({required this.birthdate});

//   @override
//   List<DateTime> get props => [birthdate];
// }

// class EventAddressChanged extends RegisterEvent {
//   final String address;

//   EventAddressChanged({required this.address});

//   @override
//   List<String> get props => [address];
// }

// class EventSexChanged extends RegisterEvent {
//   final Sex sex;

//   EventSexChanged({required this.sex});

//   @override
//   List<Sex> get props => [sex];
// }

// class EventPasswordChanged extends RegisterEvent {
//   final String password;

//   EventPasswordChanged({required this.password});

//   @override
//   List<String> get props => [password];
// }

// class EventRePasswordChanged extends RegisterEvent {
//   final String rePassword;

//   EventRePasswordChanged({required this.rePassword});

//   @override
//   List<String> get props => [rePassword];
// }

// class EventSelectIsBranch extends RegisterEvent {
//   final bool isBranch;

//   EventSelectIsBranch({required this.isBranch});

//   @override
//   List<bool> get props => [isBranch];
// }

// class EventMainBranchChanged extends RegisterEvent {
//   final int mainBranchId;

//   EventMainBranchChanged({required this.mainBranchId});

//   @override
//   List<int> get props => [mainBranchId];
// }

// class EventStoreNameChanged extends RegisterEvent {
//   final String storeName;

//   EventStoreNameChanged({required this.storeName});

//   @override
//   List<String> get props => [storeName];
// }

// class EventStorePhoneChanged extends RegisterEvent {
//   final String storePhone;

//   EventStorePhoneChanged({required this.storePhone});

//   @override
//   List<String> get props => [storePhone];
// }

// class EventStoreAddressChanged extends RegisterEvent {
//   final String storeAddress;

//   EventStoreAddressChanged({required this.storeAddress});

//   @override
//   List<String> get props => [storeAddress];
// }


