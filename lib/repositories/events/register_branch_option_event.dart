import 'package:equatable/equatable.dart';

abstract class RegisterBranchOptionEvent extends Equatable {}

class EventIsBranchChanged extends RegisterBranchOptionEvent {
  final bool isBranch;

  EventIsBranchChanged({required this.isBranch});

  @override
  List<bool> get props => [isBranch];
}

class EventMainBranchChanged extends RegisterBranchOptionEvent {
  final int mainBranchId;

  EventMainBranchChanged({required this.mainBranchId});

  @override
  List<int> get props => [mainBranchId];
}

class EventNextbuttonPressed extends RegisterBranchOptionEvent {
  @override
  List<Object?> get props => [];
}
