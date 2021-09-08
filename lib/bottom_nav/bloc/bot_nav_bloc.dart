import 'package:dealer_app/bottom_nav/bot_nav_event.dart';
import 'package:dealer_app/bottom_nav/bot_nav_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BotNavBloc extends Bloc<BotNavEvent, BotNavState> {
  BotNavBloc(BotNavState initialState) : super(initialState);

  @override
  Stream<BotNavState> mapEventToState(BotNavEvent event) async* {
    switch (event) {
      case BotNavEvent.eventTapHome:
        yield StateHome();
        break;
      case BotNavEvent.eventTapNotification:
        yield StateNotification();
        break;
      case BotNavEvent.eventTapCategory:
        yield StateCategory();
        break;
      case BotNavEvent.eventTapHistory:
        yield StateHistory();
        break;
    }
  }
}
