import 'package:equatable/equatable.dart';

import '../model/user.dart';

abstract class HomeState extends Equatable {
  const HomeState();
  @override
  List<Object> get props => [];
}

class HomeLoading extends HomeState {}

class HomeSuccess extends HomeState {
  final List<User> data;
  const HomeSuccess(this.data);
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);
}
