import 'package:example_project/modules/utils/api.dart';
import 'package:flutter/material.dart';

import '../../network/services.dart';

abstract class IHomeRepository {
  Future<Map<String, dynamic>> fetchListUser(int pages, int perPage);
}

class HomeRepository implements IHomeRepository {
  final DioService _dioService;

  HomeRepository(this._dioService);

  @override
  Future<Map<String, dynamic>> fetchListUser(int page, int perPage) async {
    var result =
        await _dioService.getDio().get(API.REQUEST_LIST_USER(page, perPage));
    return result.data as Map<String, dynamic>;
  }
}
