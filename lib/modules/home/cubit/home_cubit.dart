import 'dart:convert';

import 'package:example_project/modules/home/cubit/home_state.dart';
import 'package:example_project/modules/home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../model/user.dart';

class HomeCubit extends Cubit<HomeState> {
  final IHomeRepository homeRepository;
  int perPage;
  HomeCubit(
    this.homeRepository,
    this.perPage,
  ) : super(HomeLoading());

  Future<List<User>> fetch({int? pages}) async {
    List<User> dataUser = [];
    try {
      var response = await homeRepository.fetchListUser(pages ?? 1, perPage);
      Iterable data = jsonDecode(jsonEncode(response['data']));
      dataUser = List<User>.from(data.map((e) => User.fromJson(e)));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
    return dataUser;
  }
}
