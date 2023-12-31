// ignore_for_file: must_be_immutable

part of 'search_bloc.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoadingState extends SearchState {
  bool isLoading = false;
  SearchLoadingState({required this.isLoading});
}

class SearchResultState extends SearchState {}
