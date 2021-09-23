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
      yield state.copyWith(phone: event.password);
    } else if (event is EventLoginButtonSubmmited) {
      yield state.copyWith(process: Process.processing);
      print('fetching token');
      AccessTokenHolderModel a = await _apiCaller.fectchAccessToken();
      print('fetching userinfo');
      UserInfoModel b =
          await _apiCaller.fectchUserInfo(bearerToken: a.accessToken);

      yield state.copyWith(process: Process.finishProcessing);
    }
  }
}
