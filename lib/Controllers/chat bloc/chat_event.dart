// ignore_for_file: must_be_immutable

part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class EnterToChatEvent extends ChatEvent {
  final UserModels bot;

  const EnterToChatEvent({required this.bot});

  @override
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String messages;
  String roomID;

  SendMessageEvent({required this.messages, required this.roomID});

  @override
  List<Object?> get props => [];
}

class FetchmessagesEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class OnlineEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class OfflineEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

//intitial event
class ChatInitialEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}
