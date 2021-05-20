import 'dart:async';
import 'dart:convert';
import 'package:bussiness_web_app/config/cache.dart';
import 'package:bussiness_web_app/config/env.dart';
import 'package:bussiness_web_app/config/network.dart';
import 'package:bussiness_web_app/data/models/token_model.dart';
import 'package:bussiness_web_app/data/models/user_model.dart';

class AuthDatasource {
  Network _network = Network();

  static final _baseUrl = Env.apiBaseUrl;
  static final _signinUrl = _baseUrl + '/vendor/verify/otp';
  static final _activateUrl = _baseUrl + '/vendor/auth/activate';
  static final _forgotUrl = _baseUrl + '/vendor/auth/forgot';
  static final _resetUrl = _baseUrl + '/vendor/auth/reset';

  Future<dynamic> signin(String phoneNumber, String otp, bool isforeign,
      String email, String deviceId, String deviceType, String token) async {
    final body = jsonEncode({
      'email': email,
      'otp': otp,
      "devices": {
        "deviceId": deviceId,
        "token": token,
        "deviceType": deviceType
      },
      'isforeign': isforeign
    });
    final body1 = jsonEncode({
      'phoneNumber': phoneNumber,
      'otp': otp,
      "devices": {
        "deviceId": "123131",
        "token": "asdadasdad",
        "deviceType": "web"
      },
      'isforeign': isforeign
    });
    return _network
        .post(_signinUrl, body: isforeign == true ? body : body1, headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    }).then((dynamic res) {
      Cache.storage.setInt('isProfileCompleted', res['isProfileCompleted']);
      if (res['vendorRole'] != null) {
        Cache.storage.setString('vendorRole', res['vendorRole']);
      }
      if (res['vendorId'] != null) {
        Cache.storage.setString('vendorId', res['vendorId']);
      }

      return {
        'token': TokenModel.fromJson(res['token']),
      };
    });
    // .catchError((Exception e) => throw Exception(e.toString()));
  }

  Future<UserModel> activate(String phoneNumber, String otp) {
    return _network.post(_activateUrl,
        body: {'phoneNumber': phoneNumber, 'otp': otp}).then((dynamic res) {
      return UserModel.fromJson(res['user']);
    });
    // .catchError((Exception e) => throw Exception(e.toString()));
  }

  Future<UserModel> forgot(String email) {
    return _network.post(_forgotUrl, body: {
      'email': email,
    }).then((dynamic res) {
      return UserModel.fromJson(res['user']);
    });
    // .catchError((Exception e) => throw Exception(e.toString()));
  }

  Future<UserModel> reset(String token, int otp, String password) {
    return _network.post(_resetUrl, body: {
      'password': password,
      'token': token,
      'otp': otp,
    }).then((dynamic res) {
      return UserModel.fromJson(res['user']);
    });
    // .catchError((Exception e) => throw Exception(e.toString()));
  }
}
