import 'package:dealer_app/repositories/events/register_event.dart';
import 'package:dealer_app/repositories/states/register_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc({required RegisterState initialState}) : super(initialState);

  @override
  Stream<RegisterState> mapEventToState(RegisterEvent event) async* {
    if (event is EventPhoneNumberChanged) {
      yield state.copyWith(phone: event.phoneNumber);
      // } else if (event is EventNameChanged) {
      //   yield state.copyWith(name: event.name);
      // } else if (event is EventIdChanged) {
      //   yield state.copyWith(id: event.id);
      // } else if (event is EventBirthdateChanged) {
      //   yield state.copyWith(birthdate: event.birthdate);
      // } else if (event is EventAddressChanged) {
      //   yield state.copyWith(address: event.address);
      // } else if (event is EventSexChanged) {
      //   yield state.copyWith(sex: event.sex);
      // } else if (event is EventPasswordChanged) {
      //   yield state.copyWith(password: event.password);
      // } else if (event is EventRePasswordChanged) {
      //   yield state.copyWith(rePassword: event.rePassword);
      // } else if (event is EventSelectIsBranch) {
      //   yield state.copyWith(isBranch: event.isBranch);
      // } else if (event is EventMainBranchChanged) {
      //   yield state.copyWith(mainBranchId: event.mainBranchId);
      // } else if (event is EventStoreNameChanged) {
      //   yield state.copyWith(storeName: event.storeName);
      // } else if (event is EventStorePhoneChanged) {
      //   yield state.copyWith(storePhone: event.storePhone);
      // } else if (event is EventStoreAddressChanged) {
      //   yield state.copyWith(storeAddress: event.storeAddress);
    } else if (event is EventSendOTP) {
      //start progress indicator
      yield state.copyWith(process: Process.processing);
      try {
        //TODO: send OTP
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
