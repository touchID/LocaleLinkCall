import 'package:get/get.dart';

class WeatherWebViewModel extends GetxController {
  static const String url = "http://www.caiyunapp.com/h5/#120.209633,30.205950";
  static const String title = "天气";
  static const bool isNeedHeartbeat = true;
  static const bool showLoading = true;

  List<String> webViewAllowList = [];

  bool isWebViewAllow({required String url, required List<String> allowList}) {
    for (String allowUrl in allowList) {
      if (url.contains(allowUrl)) {
        return true;
      }
    }
    return false;
  }
}
