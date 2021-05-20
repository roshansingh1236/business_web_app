import 'dart:async';
import 'package:bussiness_web_app/data/datasources/user_datasource.dart';
import 'package:bussiness_web_app/data/models/user_model.dart';

class UserRepository {
  UserDatasource _userDatasource;
  UserRepository() {
    _userDatasource = UserDatasource();
  }

  Future<UserModel> getProfile() async {
    return await _userDatasource.profile();
  }

  Future<bool> isAdmin() async {
    /// read from keystore/keychain
    await Future.delayed(Duration(seconds: 1));
    return false;
  }
}
