import 'package:dealer_app/providers/configs/injection_config.dart';
import 'package:dealer_app/repositories/events/login_event.dart';
import 'package:dealer_app/repositories/handlers/login_handler.dart';
import 'package:dealer_app/repositories/states/login_state.dart';
import 'package:dealer_app/utils/param_util.dart' hide Process;
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  var _loginHandler = getIt.get<ILoginHandler>();
  LoginBloc({required LoginState initialState}) : super(initialState);

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
        //TODO: do something about usermodel
        var userModel = await _loginHandler.login(
            phone: state.phone, password: state.password);
        //close progress indicator
        yield state.copyWith(process: Process.finishProcessing);
        //validated
        yield state.copyWith(process: Process.validated);
      } on Exception catch (e) {
        //wrong password or phone number
        if (e.toString().contains(CustomTexts.fetchTokenFailedException)) {
          yield state.copyWith(process: Process.invalid);
          //close progress indicator
          yield state.copyWith(process: Process.finishProcessing);
        } else {
          yield state.copyWith(process: Process.error);
          //close progress indicator
          yield state.copyWith(process: Process.finishProcessing);
        }
      }
    } else if (event is EventShowHidePassword) {
      yield state.copyWith(isPasswordObscured: !state.isPasswordObscured);
    }
  }
}
