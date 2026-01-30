import 'dart:io';

import 'package:flutter/foundation.dart';

class ApiEndpoints {
  ApiEndpoints._();

  static const bool isPhysicalDevice=false;

   static const String computerIpAdress="192.168.1.1";


  static String get baseUrl {
    if(isPhysicalDevice){
      return "http://$computerIpAdress:3000/api";
    }
    if (kIsWeb){
      return 'http://localhost:3000/api';
    }else if(Platform.isAndroid){
      return 'http://10.0.2.2:5000/api/';
    }else if(Platform.isIOS){
      return "http://localhost:3000/api";
    }
    else{
      return "http://localhost:3000/api";
    }
  }

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);


  // ============ User Endpoints ============
  static const String registerUser = 'auth/register';
  static const String loginUser = 'auth/login';
  // static String userById(String id) => '/users/$id';
  // static String userPhoto(String id) => '/users/$id/photo';
}
