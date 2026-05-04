import 'dart:io';

import 'package:flutter/material.dart';
import 'package:locale_link_call/weather_web/base_web_view.dart';

class DataCenter extends StatefulWidget {
  final String url;
  const DataCenter(this.url);
  // const DataCenter({Key? key}) : super(key: key);

  @override
  _DataCenterState createState() => _DataCenterState();
}

class _DataCenterState extends State<DataCenter> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      // WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("数据中心"),
        centerTitle: true,
      ),
      body: new Center(
        child: BaseWebView(
          urlString: widget.url,
          // initialUrl: widget.url,
          // // initialUrl: "https://aisuda.bce.baidu.com/amis/examples/chart",
          // // initialUrl: "https://cloud.jimureport.com/bigscreen/#/view/1211961482594553857",
          // // javascriptMode: JavascriptMode.unrestricted,
          // onPageStarted: (String url) {
          //   print("onPageStarted $url");
          // },
          // onPageFinished: (String url) {
          //   print("onPageFinished $url");
          // },
          // onWebResourceError: (error) {
          //   print("${error.description}");
          // },
        ),
      ),
    );
  }
}
