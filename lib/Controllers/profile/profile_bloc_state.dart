part of 'profile_bloc_bloc.dart';

abstract class ProfileBlocState extends Equatable {
  const ProfileBlocState();
}

class ProfileBlocInitial extends ProfileBlocState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ProfileBlocState {
  @override
  List<Object?> get props => [];
}

class LoadCurrentUserState extends ProfileBlocState {
  final Profile currentUser;

  const LoadCurrentUserState({required this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

class UpdatedState extends ProfileBlocState {
  final UserModels currentUser;

  const UpdatedState({required this.currentUser});

  @override
  List<Object?> get props => [currentUser];
}

class UpdateSuccessState extends ProfileBlocState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class UpdateErorrState extends ProfileBlocState {
  final String messages;

  const UpdateErorrState({required this.messages});
  @override
  List<Object?> get props => [];
}
