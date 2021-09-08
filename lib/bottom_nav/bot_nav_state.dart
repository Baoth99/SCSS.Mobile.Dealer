import 'package:dealer_app/utils/env_util.dart';

abstract class BotNavState {}

class StateHome extends BotNavState {
  final String title = BotNavUtils.stateHomeTitle;
  final int itemIndex = BotNavUtils.stateHomeIndex;
}

class StateNotification extends BotNavState {
  final String title = BotNavUtils.stateNotificationTitle;
  final int itemIndex = BotNavUtils.stateNotificationIndex;
}

class StateCategory extends BotNavState {
  final String title = BotNavUtils.stateCategoryTitle;
  final int itemIndex = BotNavUtils.stateCategoryIndex;
}

class StateHistory extends BotNavState {
  final String title = BotNavUtils.stateHistoryTitle;
  final int itemIndex = BotNavUtils.stateHistoryIndex;
}
