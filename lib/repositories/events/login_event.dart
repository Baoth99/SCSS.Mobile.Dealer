import 'package:equatable/equatable.dart';

abstract class LoginEvent extends Equatable {}

class EventLoginPhoneNumberChanged extends LoginEvent {
  final String phoneNumber;

  EventLoginPhoneNumberChanged({required this.phoneNumber});

  @override
  List<String> get props => [phoneNumber];
}

class EventLoginPasswordChanged extends LoginEvent {
  final String password;

  EventLoginPasswordChanged({required this.password});

  @override
  List<String> get props => [password];
}

class EventLoginButtonSubmmited extends LoginEvent {
  @override
  List<Object?> get props => [];
}
