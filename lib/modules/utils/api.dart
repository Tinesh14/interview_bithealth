// ignore_for_file: non_constant_identifier_names

class API {
  static String REQUEST_LOGIN = 'api/login';
  static String REQUEST_LIST_USER(int page, int perPage) =>
      'api/users?page=$page&per_page=$perPage';
}
