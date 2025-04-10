import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:firebase_core/firebase_core.dart';  // Firebase 초기화용 패키지
import 'package:firebase_messaging/firebase_messaging.dart';  // Firebase Messaging 패키지

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Flutter 초기화
  await Firebase.initializeApp();  // Firebase 초기화
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
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse("https://thinkdock.co.kr"));
  }

  // 뒤로가기 버튼 처리
  Future<bool> _onWillPop() async {
    if (await _controller.canGoBack()) {
      await _controller.goBack();
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            WillPopScope(
              onWillPop: _onWillPop,
              child: WebViewWidget(controller: _controller),
            ),
            if (_isLoading)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}

Future<String?> getMyDeviceToken() async {
  final token = await FirebaseMessaging.instance.getToken();
  debugPrint("내 디바이스 토큰: $token");
  return token;
}