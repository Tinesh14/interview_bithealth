import 'package:example_project/modules/login/repository/login_repository.dart';
import 'package:example_project/modules/utils/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../config/app_constants.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final ILoginRepository loginRepository;
  LoginCubit(this.loginRepository) : super(LoginInitial());

  login(Map<String, dynamic> data) async {
    emit(LoginLoading());
    try {
      var response = await loginRepository.login(data);
      if (response.containsKey('token')) {
        debugPrint('token: ${response['token']}');
        await writeValue(LOGIN_CONTENT_TOKEN, response['token']);
        emit(LoginSuccess());
      } else {
        emit(LoginError(response['error']));
      }
    } catch (e) {
      if (e is DioError) {
        debugPrint('error: ${e.response?.data['error']}');
        emit(LoginError(e.response?.data['error']));
      } else {
        emit(LoginError(e.toString()));
      }
    }
  }
}
