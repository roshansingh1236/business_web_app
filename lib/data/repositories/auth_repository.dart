import 'package:flutter/material.dart';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/data/datasources/auth_datasource.dart';
import 'package:bussiness_web_app/data/models/token_model.dart';
import 'package:bussiness_web_app/data/models/user_model.dart';

class AuthRepository {
  AuthDatasource authDatasource;

  AuthRepository() {
    this.authDatasource = AuthDatasource();
  }

  Future<dynamic> login(
      {@required String phoneNumber,
      @required String otp,
      @required bool isforeign,
      @required String deviceId,
      @required String token,
      @required String deviceType,
      @required String email}) async {
    return await authDatasource.signin(
        phoneNumber, otp, isforeign, email, deviceId, deviceType, token);
  }

  Future<UserModel> activation(
      {@required String phoneNumber, @required String otp}) async {
    return await authDatasource.activate(phoneNumber, otp);
  }

  Future<UserModel> forgotPassword({
    @required String email,
  }) async {
    return await authDatasource.forgot(email);
  }

  Future<UserModel> resetPassword({
    @required String token,
    @required int otp,
    @required String password,
  }) async {
    return await authDatasource.reset(token, otp, password);
  }

  void setLoggedIn(TokenModel data) {
    Cache.storage.setBool('loggedIn', true);
    Cache.storage.setString('authToken', data.token);
  }

  bool isLoggedIn() {
    // TODO: check expires datetime
    return Cache.storage.getBool('loggedIn') ?? false;
  }

  Future<void> logout() async {
    /// delete from storage
    await Future.delayed(Duration(seconds: 1));
    Cache.storage.remove('loggedIn');
    Cache.storage.remove('authToken');
    return;
  }

  void deleteAuth(String token) {
    if (Cache.storage.get('authToken') == token) {
      Cache.storage.remove('loggedIn');
      Cache.storage.remove('authToken');
      Cache.storage.remove('refreshToken');
      Cache.storage.remove('tokenExpiresIn');
    }
  }
}
