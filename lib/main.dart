import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});
  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..clearCache()
      ..loadRequest(Uri.parse("https://thinkdock.co.kr"));
  }

  // 뒤로가기 버튼 처리
  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      // WebView에서 뒤로 갈 수 있으면, 뒤로 가기
      _controller.goBack();
      return Future.value(false);  // 기본 동작을 막고, WebView 뒤로가기 수행
    } else {
      // WebView에서 뒤로 갈 수 없으면, 기본 앱 뒤로 가기 수행
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: _onWillPop,  // 뒤로가기 처리
        child: WebViewWidget(controller: _controller),
      ),
    );
  }
}
