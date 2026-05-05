import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class WeatherWebViewModel extends GetxController {
  static const String url = "http://www.caiyunapp.com/h5/#120.209633,30.205950";
  static const String title = "天气";
  static const bool isNeedHeartbeat = true;
  static const bool showLoading = true;

  static Position? _currentPosition;

  static Future<void> getCurrentLocationUrl() async {
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // url = "http://www.caiyunapp.com/h5/#${_currentPosition!.longitude},${_currentPosition!.latitude}";
    } catch (e) {
      return;
    }
  }

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
