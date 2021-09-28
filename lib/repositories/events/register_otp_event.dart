import 'package:equatable/equatable.dart';

abstract class RegisterOTPEvent extends Equatable {}

class EventOTPChanged extends RegisterOTPEvent {
  final String otp;

  EventOTPChanged({required this.otp});

  @override
  List<String> get props => [otp];
}

class EventCheckOTP extends RegisterOTPEvent {
  @override
  List<Object?> get props => [];
}
