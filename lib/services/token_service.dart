import 'dart:convert';

import 'package:demoecommerceproduct/networking/app_request_manager.dart';
import 'package:demoecommerceproduct/networking/request_manager.dart';
import 'package:flutter/material.dart';

typedef RefreshTokenSuccess = Function(String success);

class TokenService {
  static const String _baseUrl = "https://onedollarapp.onrender.com/";
  static const String _urlPath = "api/";

  static void refreshToken(
      String token, RefreshTokenSuccess success, RequestFail fail) {
    var urlMethod = "Auth/refresh-token";
    var url = _baseUrl + _urlPath + urlMethod;
    var params = {
      "expiredToken": token,
    };
    AppRequestManager.postWithToken(url, params, null, true, false, (response) {
      try {
        Map<String, dynamic> result = json.decode(response);
        String successData = result['data']['token'];
        success(successData);
      } catch (e) {
        debugPrint("Could not parse : ${e.toString()}");
      }
    }, (error) => fail(error));
  }
}
