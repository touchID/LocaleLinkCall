import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'base_web_view.dart';
import 'weather_web_view_model.dart';

class WeatherWebPage extends GetView<WeatherWebViewModel> {
  const WeatherWebPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildWebView(context),
    );
  }

  Widget buildWebView(BuildContext context) {
    return BaseWebView(
      urlString: WeatherWebViewModel.url,
      isNeedHeartbeat: WeatherWebViewModel.isNeedHeartbeat,
      showLoading: WeatherWebViewModel.showLoading,
    );
  }
}
