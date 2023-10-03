import 'package:example_project/modules/utils/api.dart';
import 'package:flutter/material.dart';

import '../../network/services.dart';

abstract class ILoginRepository {
  Future<Map<String, dynamic>> login(Map<String, dynamic> data);
}

class LoginRepository implements ILoginRepository {
  final DioService _dioService;

  LoginRepository(this._dioService);

  @override
  Future<Map<String, dynamic>> login(Map<String, dynamic> data) async {
    var result = await _dioService.getDio().post(API.REQUEST_LOGIN, data: data);

    debugPrint('data: ${result.data}');
    return result.data as Map<String, dynamic>;
  }
}
