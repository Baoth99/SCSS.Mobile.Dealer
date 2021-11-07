import 'package:dealer_app/repositories/models/get_promotion_detail_model.dart';
import 'package:equatable/equatable.dart';

abstract class PromotionDetailState extends Equatable {
  final GetPromotionDetailModel model;

  PromotionDetailState(this.model);
}

class LoadingState extends PromotionDetailState {
  LoadingState({
    required GetPromotionDetailModel model,
  }) : super(model);

  @override
  List<Object?> get props => [model];
}

class LoadedState extends PromotionDetailState {
  LoadedState({
    required GetPromotionDetailModel model,
  }) : super(model);

  @override
  List<Object?> get props => [model];
}

class ErrorState extends PromotionDetailState {
  final String message;

  ErrorState({
    required GetPromotionDetailModel model,
    required this.message,
  }) : super(model);

  @override
  List<Object?> get props => [model, message];
}
