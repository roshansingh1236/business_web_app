import 'dart:async';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/config/network.dart';
import 'package:bussiness_web_app/data/models/user_model.dart';

class UserDatasource {
  Network _network = Network();

  static final _baseUrl = Env.apiBaseUrl;
  static final _profileUrl = _baseUrl + '/vendor/users/profile';

  Future<UserModel> profile() {
    return _network.get(_profileUrl).then((dynamic res) {
      return UserModel.fromJson(res);
    });
    // .catchError((Exception error) => throw Exception('error_msg'));
  }
}
