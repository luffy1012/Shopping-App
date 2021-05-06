import 'dart:convert';

import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentWebView extends StatefulWidget {
  final url;
  final title;

  PaymentWebView(this.title, this.url);

  @override
  _PaymentWebViewState createState() => _PaymentWebViewState();
}

class _PaymentWebViewState extends State<PaymentWebView> {
  final _key = UniqueKey();
  bool isLoading = true;
  WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(color: primary2),
        ),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _controller = controller;
            },
            onPageFinished: (value) async {
              setState(() {
                isLoading = false;
              });

              RegExp reg = new RegExp("pgResponse.php");
              if (reg.hasMatch(value)) {
                print("PAGE LOADED");
                String html = await _controller.evaluateJavascript("window.document.getElementsByTagName('html')[0].outerHTML;");

                String str = "";
                if (html.contains('success'))
                  str = "success";
                else if (html.contains('failure'))
                  str = "failure";
                else
                  str = "something went wrong";
                print("###HERE $str");
                Navigator.pop(context, str);
              }
            },
          ),
          /*InAppWebView(
            initialUrlRequest: URLRequest(url: Uri.parse(widget.url)),
            key: _key,
            onConsoleMessage: (controller, msg) {
              print(msg);
            },
          ),*/
          isLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                )
              : Stack(),
        ],
      ),
    );
  }
}
