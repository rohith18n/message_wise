import 'dart:typed_data';

import 'package:equatable/equatable.dart';

abstract class StatusEvent extends Equatable {}

class LoadStatusesEvent extends StatusEvent {
  @override
  List<Object?> get props => [];
}

class AddStatusEvent extends StatusEvent {
  final String description;
  final Uint8List file;
  final String uid;
  final String username;
  final String profImage;

  AddStatusEvent({
    required this.uid,
    required this.username,
    required this.profImage,
    required this.description,
    required this.file,
  });
  @override
  List<Object?> get props => [];
}

class DeleteStatusEvent extends StatusEvent {
  final String statusId;

  DeleteStatusEvent(this.statusId);

  @override
  List<Object?> get props => [statusId];
}
