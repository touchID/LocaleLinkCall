// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
//
// class CacheInterceptor extends Interceptor {
//   final _cache = Map<Uri, Response>();
//
//   @override
//   Future onRequest(RequestOptions options) async {
//     Response response = _cache[options.uri];
//     if (options.extra["refresh"] == true) {
//       debugPrint("${options.uri}: force refresh, ignore cache! \n");
//       return options;
//     } else if (response != null) {
//       debugPrint("cache hit: ${options.uri} \n");
//       return response;
//     } else
//       return options;
//   }
//
//   @override
//   Future onResponse(Response response) async {
//     debugPrint('caching result...');
//     _cache[response.request.uri] = response;
//     return response;
//   }
//
//   @override
//   Future onError(DioError err) async {
//     if (err.type == DioErrorType.CONNECT_TIMEOUT) {
//       var cachedResponse = _cache[err.response.realUri];
//       debugPrint('${err.type}: return cached result...');
//       if (cachedResponse != null) return cachedResponse;
//     }
//     // else return error
//     return err;
//   }
// }