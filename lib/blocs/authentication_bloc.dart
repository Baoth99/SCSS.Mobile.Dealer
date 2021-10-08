import 'dart:async';

import 'package:dealer_app/repositories/events/authentication_event.dart';
import 'package:dealer_app/repositories/handlers/authentication_handler.dart';
import 'package:dealer_app/repositories/handlers/user_handler.dart';
import 'package:dealer_app/repositories/models/response_models/dealer_response_model.dart';
import 'package:dealer_app/repositories/states/authentication_state.dart';
import 'package:dealer_app/utils/param_util.dart';
import 'package:dealer_app/utils/secure_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationHandler _authenticationHandler;
  final UserHandler _userHandler;
  late StreamSubscription<AuthenticationStatus>
      _authenticationStatusSubscription;

  //constructor
  AuthenticationBloc({
    required AuthenticationHandler authenticationHandler,
    required UserHandler userHandler,
  })  : _authenticationHandler = authenticationHandler,
        _userHandler = userHandler,
        super(AuthenticationState.unknown()) {
    _authenticationStatusSubscription = _authenticationHandler.stream.listen(
      (status) {
        add(AuthenticationStatusChanged(status));
      },
    );
  }

  @override
  Future<void> close() {
    _authenticationStatusSubscription.cancel();
    _authenticationHandler.dispose();
    return super.close();
  }

  @override
  Stream<AuthenticationState> mapEventToState(
      AuthenticationEvent event) async* {
    if (event is AuthenticationStatusChanged) {
      switch (event.status) {
        case AuthenticationStatus.unauthenticated:
          yield AuthenticationState.unauthenticated();
          break;
        case AuthenticationStatus.authenticated:
          final responseModel = await _tryGetUser();
          if (responseModel != null) {
            yield AuthenticationState.authenticated(
                user: responseModel.dealerInfoModel);
          } else
            yield AuthenticationState.unauthenticated();
          break;
        default:
          yield AuthenticationState.unknown();
      }
    } else if (event is AuthenticationLogoutRequested) {
      _authenticationHandler.logout();
    }
  }

  Future<DealerResponseModel?> _tryGetUser() async {
    try {
      var accessToken =
          await SecureStorage.readValue(key: CustomKeys.accessToken);
      if (accessToken != null) {
        var responseModel =
            await _userHandler.getUser(bearerToken: accessToken);
        return responseModel;
      } else
        return null;
    } catch (_) {
      return null;
    }
  }
}
