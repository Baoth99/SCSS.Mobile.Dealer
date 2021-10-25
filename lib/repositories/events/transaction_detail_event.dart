import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class TransactionDetailEvent extends Equatable {}

class EventInitData extends TransactionDetailEvent {
  @override
  List<Object?> get props => [];
}
