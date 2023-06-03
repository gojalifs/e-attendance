import 'package:e_presention/env/env.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ResetWebView extends StatefulWidget {
  const ResetWebView({super.key});

  @override
  State<ResetWebView> createState() => _ResetWebViewState();
}

class _ResetWebViewState extends State<ResetWebView> {
  String urls = Env.url.substring(0, Env.url.lastIndexOf('/'));
  var controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
        onNavigationRequest: (NavigationRequest request) {
          if (request.url.startsWith('https://www.youtube.com/')) {
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ),
    )
    ..loadRequest(Uri.parse(
        '${Env.url.substring(0, Env.url.lastIndexOf('/'))}/password/reset'));

  @override
  Widget build(BuildContext context) {
    print(urls);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Kata Sandi'),
      ),
      body: SafeArea(
        child: WebViewWidget(controller: controller),
      ),
    );
  }
}
