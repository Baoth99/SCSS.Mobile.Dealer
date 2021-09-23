import 'package:dealer_app/repositories/events/login_event.dart';
import 'package:dealer_app/repositories/models/access_token_holder_model.dart';
import 'package:dealer_app/repositories/models/user_profile_model.dart';
import 'package:dealer_app/repositories/states/login_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dealer_app/utils/func_util.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  APICaller _apiCaller = APICaller();

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
        //get access token
        AccessTokenHolderModel accessTokenHolderModel = await _apiCaller
            .fectchAccessToken(phone: state.phone, password: state.password);
        //get user information
        UserInfoModel userInfoModel = await _apiCaller.fectchUserInfo(
            bearerToken: accessTokenHolderModel.accessToken);
        //validated
        yield state.copyWith(process: Process.validated);
      } on Exception catch (e) {
        //close progress indicator
        yield state.copyWith(process: Process.finishProcessing);
        //wrong password or phone number
        if (e.toString().contains('Login failed')) {
          yield state.copyWith(process: Process.invalid);
          yield state.copyWith(process: Process.notSubmitted);
        } else
          yield state.copyWith(process: Process.error);
        yield state.copyWith(process: Process.notSubmitted);
      }
    } else if (event is EventShowHidePassword) {
      yield state.copyWith(isPasswordObscured: !state.isPasswordObscured);
    }
  }
}
