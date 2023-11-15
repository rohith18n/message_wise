import 'package:equatable/equatable.dart';

abstract class StatusState extends Equatable {}

class StatusInitialState extends StatusState {
  @override
  List<Object?> get props => [];
}

class StatusLoadingState extends StatusState {
  @override
  List<Object?> get props => [];
}

class StatusLoadSuccessState extends StatusState {
  final List<Map<String, dynamic>> statuses;

  StatusLoadSuccessState({required this.statuses});

  @override
  List<Object?> get props => [statuses];
}

class StatusAddedState extends StatusState {
  @override
  List<Object?> get props => [];
}

class StatusDeletedState extends StatusState {
  @override
  List<Object?> get props => [];
}

class StatusErrorState extends StatusState {
  final String error;

  StatusErrorState({required this.error});

  @override
  List<Object?> get props => [error];
}
