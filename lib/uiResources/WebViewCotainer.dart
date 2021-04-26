import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewContainer extends StatefulWidget {
  final url;
  final title;

  WebViewContainer(this.title, this.url);

  @override
  _WebViewContainerState createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final _key = UniqueKey();
  bool isLoading = true;

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
            onPageFinished: (value) {
              setState(() {
                isLoading = false;
              });
            },
          ),
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
