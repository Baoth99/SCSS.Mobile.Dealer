import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/login_event.dart';
import 'package:dealer_app/repositories/handlers/authentication_handler.dart';
import 'package:dealer_app/repositories/states/login_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var _authenticationHandler = getIt.get<IAuthenticationHandler>();
  LoginBloc({
    required LoginState initialState,
  }) : super(initialState);
  @override
  Stream<LoginState> mapEventToState(LoginEvent event) async* {
    if (event is EventLoginPhoneNumberChanged) {
      yield state.copyWith(phone: event.phoneNumber);
    } else if (event is EventLoginPasswordChanged) {
      yield state.copyWith(password: event.password);
    } else if (event is EventLoginButtonSubmmited) {
      try {
        //start progress indicator
        yield state.copyWith(process: Process.processing);
        //login
        await _authenticationHandler.login(
          phone: state.phone,
          password: state.password,
        );
        // close progress indicator
        yield state.copyWith(process: Process.processed);
      } on Exception catch (e) {
        //wrong password or phone number
        if (e.toString().contains(CustomTexts.fetchTokenFailedException)) {
          //close progress indicator
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.invalid);
        } else {
          //close progress indicator
          yield state.copyWith(process: Process.processed);
          yield state.copyWith(process: Process.error);
        }
      } finally {
        yield state.copyWith(process: Process.neutral);
      }
    } else if (event is EventShowHidePassword) {
      yield state.copyWith(isPasswordObscured: !state.isPasswordObscured);
    }
  }
}
