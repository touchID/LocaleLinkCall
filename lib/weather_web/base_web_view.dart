import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class BaseWebView extends StatefulWidget {
  BaseWebView({
    super.key,
    required this.urlString,
    this.height = 0,
    this.maxHeight,
    this.backgroundColor,
    this.enableZoom = false,
    this.isNeedHeartbeat = false,
    this.isRemoveSpace = false,
    this.showLoading = false,
    this.showError = true,
  });

  final String urlString;
  final double height;
  final double? maxHeight;
  final Color? backgroundColor;
  final bool enableZoom;
  final bool isNeedHeartbeat;
  final bool isRemoveSpace;
  final bool showLoading;
  final bool showError;

  @override
  State<BaseWebView> createState() => _BaseWebViewState();
}

class _BaseWebViewState extends State<BaseWebView> {
  late final WebViewController _webViewController;
  bool isError = false;
  bool isPageFinished = false;
  bool isReady = true;
  bool _isLoading = true;
  double _loadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _initController();
  }

  void _initController() {
    _webViewController = WebViewController()
      ..enableZoom(widget.enableZoom)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(widget.backgroundColor ?? Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadProgress = progress / 100;
            });
          },
          onPageStarted: (String url) {
            log("onPageStarted $url");
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            log("onPageFinished $url");
            setState(() {
              _isLoading = false;
            });
            await _webViewController.runJavaScript(
              "document.getElementById('isFooter').style.display = 'none';",
            );
          },
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) {
            log("WebResourceError: ${error.description}");
            setState(() {
              isError = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.urlString));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isRemoveSpace && (isReady || isError)) {
      return const SizedBox.shrink();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final viewHeight = widget.height == 0 ? screenHeight : widget.height;

    return SizedBox(
      height: viewHeight,
      child: Stack(
        children: [
          WebViewWidget(controller: _webViewController),
          if (_isLoading && widget.showLoading)
            LinearProgressIndicator(
              value: _loadProgress,
            ),
        ],
      ),
    );
  }
}