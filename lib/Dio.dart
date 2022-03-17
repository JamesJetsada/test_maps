import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'Mydomain.dart';

Future<dynamic> get(BuildContext context, String api, dynamic params) async {
  var dio = Dio();
  dio.options.baseUrl = '${Mydomain().domain}';
  dio.options.headers['accept'] = 'application/json';
  dio.options.responseType = ResponseType.json;
  dio.options.followRedirects = false;
  dio.options.validateStatus = (status) {
    return status! < 500;
  };
  var response = await dio.get(api, queryParameters: params);
  print(response.statusCode);
  print("get data ");
  if (response.statusCode! < 400) {
    print('ปกติ');
    return response.data;
  }else{
    return response.data;
  }
  // } catch (e) {
  //   print(e.runtimeType);
  //   FailToConnect(context);
  //   return null;
  // }
}

Future<dynamic> delete(BuildContext context, String api, dynamic params) async {
  // try {
  var dio = Dio();
  dio.options.baseUrl = '${Mydomain().domain}';
  dio.options.headers['accept'] = 'application/json';
  dio.options.responseType = ResponseType.json;
  dio.options.followRedirects = false;
  dio.options.validateStatus = (status) {
    return status! < 500;
  };
  var response = await dio.delete(api, queryParameters: params);
  print(response.statusCode);
  if (response.statusCode! < 400) {
    print('ปกติ');
    return response.data;
  }
}

Future<dynamic> put(BuildContext context, String api, dynamic params) async {
  try {
    var dio = Dio();
    dio.options.baseUrl = '${Mydomain().domain}';
    dio.options.headers['accept'] = 'application/json';
    dio.options.responseType = ResponseType.json;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    var response = await dio.put(api, queryParameters: params);
    print(response.statusCode);
    if (response.statusCode! < 400) {
      print('ปกติ');
      return response.data;
    }
  } catch (e) {
    print(e.runtimeType);
    return null;
  }
}

Future<dynamic> post(BuildContext context, String api, dynamic params) async {
  try {
  
    var dio = Dio();
    dio.options.baseUrl = '${Mydomain().domain}';
    dio.options.headers['accept'] = 'application/json';
    dio.options.responseType = ResponseType.json;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    var response = await dio.post(api, data: params);
    print(response.statusCode);
    if (response.statusCode! < 400) {
      print('ปกติ');
      return response.data;
    }else{
      print('ไม่ผ่าน');
      return response.data;
    }
  } catch (e) {
    print(e.runtimeType);
    return null;
  }
  // } catch (e) {
  //   print(e.runtimeType);
  //   FailToConnect(context);
  //   return null;
  // }
}

Future<dynamic> login(BuildContext context, dynamic params) async {

  try {

    var dio = Dio();
    dio.options.baseUrl = '${Mydomain().domain}/api/';
    dio.options.responseType = ResponseType.json;
    dio.options.followRedirects = false;
    dio.options.validateStatus = (status) {
      return status! < 500;
    };
    // dio.options.contentType = token;
    var response = await dio.post('login', data: params);
    if (response.statusCode! < 400) {
      print('ปกติ');
      return response.data;
    }
    return response.data;
  } catch (e) {
    print(e.runtimeType);
    return null;
  }
}
