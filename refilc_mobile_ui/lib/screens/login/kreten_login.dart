// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KretenLoginWidget extends StatefulWidget {
  const KretenLoginWidget({super.key, required this.onLogin});

  // final String selectedSchool;
  final void Function(String code) onLogin;

  @override
  State<KretenLoginWidget> createState() => _KretenLoginWidgetState();
}

class _KretenLoginWidgetState extends State<KretenLoginWidget> {
  late final WebViewController controller;
  var loadingPercentage = 0;
  var currentUrl = '';

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) async {
          setState(() {
            loadingPercentage = 0;
            currentUrl = url;
          });

          // final String instituteCode = widget.selectedSchool;
          if (!url.startsWith(
              'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=')) {
            return;
          }

          List<String> requiredThings = url
              .replaceAll(
                  'https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect?code=',
                  '')
              .replaceAll(
                  '&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&state=refilc_student_mobile&session_state=',
                  ':')
              .split(':');

          String code = requiredThings[0];
          // String sessionState = requiredThings[1];

          widget.onLogin(code);
          // Future.delayed(const Duration(milliseconds: 500), () {
          //   Navigator.of(context).pop();
          // });
          // Navigator.of(context).pop();
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..loadRequest(
        Uri.parse(
            'https://idp.e-kreta.hu/connect/authorize?prompt=login&nonce=wylCrqT4oN6PPgQn2yQB0euKei9nJeZ6_ffJ-VpSKZU&response_type=code&code_challenge_method=S256&scope=openid%20email%20offline_access%20kreta-ellenorzo-webapi.public%20kreta-eugyintezes-webapi.public%20kreta-fileservice-webapi.public%20kreta-mobile-global-webapi.public%20kreta-dkt-webapi.public%20kreta-ier-webapi.public&code_challenge=HByZRRnPGb-Ko_wTI7ibIba1HQ6lor0ws4bcgReuYSQ&redirect_uri=https://mobil.e-kreta.hu/ellenorzo-student/prod/oauthredirect&client_id=kreta-ellenorzo-student-mobile-ios&state=refilc_student_mobile'), // &institute_code=${widget.selectedSchool}
      );
  }

  //   String nonceStr = await Provider.of<KretaClient>(context, listen: false)
  //         .getAPI(KretaAPI.nonce, json: false);

  //     Nonce nonce = getNonce(nonceStr, );
  // }

 @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
