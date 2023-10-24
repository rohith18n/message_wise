part of 'posts_bloc.dart';

sealed class PostsEvent extends Equatable {
  const PostsEvent();

  @override
  List<Object> get props => [];
}

class NewPostEvent extends PostsEvent {}

class LoadingPostEvent extends PostsEvent {}

class LoadedPostEvent extends PostsEvent {}
