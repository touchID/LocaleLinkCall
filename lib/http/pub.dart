import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../../config.dart';
import '../V/showDefineAlertWidget.dart';
import '../main.dart';
import '../utils.dart';
import 'base_response.dart';

Dio dio1 = new Dio();

class PubMoudle {

  httpRequest(contentType,method, url, [data]) async{
    BaseOptions options = BaseOptions();
    options.baseUrl = Config.baseUrl;//baseUrl
    // options.connectTimeout = 5000;//超时时间
    options.receiveTimeout = 3000;//接收数据最长时间
    options.responseType = ResponseType.json;//数据格式
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response;
    try {
      // BaseOptions options = BaseOptions();
      String token_data = await prefs.getString("token") ?? '';

      if(url != '/api/hotel/login') {
        options.headers['Authorization'] = token_data;//请求头 token
      }
      if(data != null ){
        if( data.containsKey('Authorization') ) {
          String authorization = data['Authorization'] ?? '';
          if (authorization.length > 0) {
            options.headers['Authorization'] = authorization; //请求头 token
          }
        }
      }
      // var index = url.indexOf('http');
      // if(index > -1){
      // }else{
      //   url = Config.baseUrl+url;
      // }
      switch (contentType) {
        case "json":
        ///请求header的配置
          options.contentType="application/json";
          dio1.options = options;
          break;
        default:
        ///请求header的配置
          options.contentType="application/x-www-form-urlencoded";
          dio1.options = options;
      }
      dio1.interceptors.add(LogInterceptor(responseBody: false)); //开启请求日志
      // dio1.interceptors.add(
      //   PostmanDioLogger(),
      // );
      try {
        //initializeInterceptors();
        String methodUpper = method.toUpperCase();
        // var queryParameters = data ?? {};
        // if (methodUpper != 'GET') {
        //   response = await dio1.request(
        //     url,
        //     data: data ?? {},
        //     options: Options(method:methodUpper),
        //   );
        // }else{//GET
        //   response = await dio1.request(
        //     url,
        //     queryParameters:  queryParameters,
        //     options: Options(method:methodUpper),
        //   );
        // }
        response = await dio1.request(
          url,
          data: data ?? {},
          queryParameters:  data ?? {},
          options: Options(method:methodUpper),
        );
      } on DioError catch (e) {
        // The request was made and the server responded with a status code
        // that falls out of the range of 2xx and is also not 304.
        if (e.response != null) {
          print('data');
          print(e.response?.data);
          print('headers');
          print(e.response?.headers);
          print('requestOptions');
          print(e.response?.requestOptions);
          BaseResponse baseModel = BaseResponse.fromJson(e.response?.data);
          if (baseModel.code == 401 && url.contains('customer-demand/list') == false) {
            print('需要重新登录');
            tokenAndPushLoginVC();
          }
        } else {
          // Something happened in setting up or sending the request that triggered an Error
          print('requestOptions');
          print(e.requestOptions);
          print('message');
          print(e.message);
        }
      } finally {
        return response;
      }
      return response;
    }catch (err){
      print('err = url = $url ');
      print(err);
      // Response response = Response(requestOptions: requestOptions);
    }
  }

  void tokenAndPushLoginVC() {
    BuildContext? context = navigatorKey.currentState?.overlay?.context;
    PubMoudle.checkUserToken().then((value){
      if (value == '')
      {
        Navigator.pushNamedAndRemoveUntil(context!, '/login', (route) => false);
      }else{
        this.showCupertinoDialog(context!);
      }
    });
  }

  static getHotelId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String hotelId = await prefs.getString("hotelId") ?? '0';
    return hotelId;
  }
  static checkUserToken() async{
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token_data = await prefs.getString("token") ?? '';
      // String hotelId = await getHotelId() ?? '';
      return token_data;
    }catch(err) {
      return '';
    }
  }
  static removeHotelIdAndToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final success1 = await prefs.remove('hotelId');
    final success2 = await prefs.remove('token');
  }
  double lc_ScreenWidth() {
    return window.physicalSize.width/window.devicePixelRatio;
  }

  initializeInterceptors() {
    dio1.interceptors.add(InterceptorsWrapper(onError: (e, handler) {
      print(1);
      print(e);
      // print(e.message);
      print(2);
      return handler.next(e);
    }, onRequest: (r, handler) {//发送
      print(3);
      print(r.method);
      print(r.path);
      print(4);
      return handler.next(r);
    }, onResponse: (r, handler) {//接受
      print(5);
      print(r.data);
      // print('statusMessage：' + r.statusMessage);
      print(6);
      if(r.data != null) {
        BaseResponse baseModel = BaseResponse.fromJson(r.data);
        if (baseModel.code == 401) {
          print('需要重新登录');
          BuildContext? context = navigatorKey.currentState?.overlay?.context;
          this.showCupertinoDialog(context!);
        }
      }
      // throw new Exception('！');
      return handler.next(r);
    }));
  }
  pushLoginVC(){
    BuildContext? context = navigatorKey.currentState?.overlay?.context;
    Navigator.pushNamed(context!, '/login', arguments:null);//(route) => false);
  }
  showCupertinoDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ShowDefineAlertWidget( pushLoginVC , '温馨提示', '登陆已过期，请重新登陆');
        }
    );
  }
}