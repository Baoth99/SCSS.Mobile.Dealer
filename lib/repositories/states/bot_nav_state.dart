import 'package:dealer_app/utils/param_util.dart';

abstract class BotNavState {}

class StateHome extends BotNavState {
  final int itemIndex = BotNavUtils.stateHomeIndex;
}

class StateNotification extends BotNavState {
  final int itemIndex = BotNavUtils.stateNotificationIndex;
}

class StateCategory extends BotNavState {
  final int itemIndex = BotNavUtils.stateCategoryIndex;
}

class StateHistory extends BotNavState {
  final int itemIndex = BotNavUtils.stateHistoryIndex;
}
