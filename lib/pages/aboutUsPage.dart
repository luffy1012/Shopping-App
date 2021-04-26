import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AboutUsPage extends StatefulWidget {
  static final String routeName = "/aboutUsPage";

  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final _key = UniqueKey();
  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About Us"),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          WebView(
            key: _key,
            initialUrl: "https://www.dunzo.com/about",
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

/*SingleChildScrollView(
        child: Column(
          children: [
            getCard(
                title: "Who are we?",
                body:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut velit nulla, consequat in cursus ut, ultrices posuere nisi. Maecenas tincidunt cursus odio vel sollicitudin. Aenean ut porttitor lectus. Ut rhoncus auctor velit ut fringilla. Quisque et dignissim nunc, sit amet egestas velit.",
                imgPath: "images/illustrations/character1.png"),
            getCard(
                title: "What Services we Provide?",
                body:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut velit nulla, consequat in cursus ut, ultrices posuere nisi. Maecenas tincidunt cursus odio vel sollicitudin. Aenean ut porttitor lectus. Ut rhoncus auctor velit ut fringilla. Quisque et dignissim nunc, sit amet egestas velit.",
                imgPath: "images/illustrations/character2.png"),
            getCard(
                title: "Contact us at :",
                body:
                    "Email ID : chefs.choice@gmail.com\nContact No : 9898989898",
                imgPath: "images/illustrations/character1.png"),
          ],
        ),
      ),*/
