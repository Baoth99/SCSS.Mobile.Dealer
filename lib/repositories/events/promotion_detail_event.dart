import 'package:equatable/equatable.dart';

abstract class PromotionDetailEvent extends Equatable {}

class EventInitData extends PromotionDetailEvent {
  @override
  List<Object?> get props => [];
}
