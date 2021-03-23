import 'package:chef_choice/pages/addressPage.dart';
import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/pages/loginPage.dart';
import 'package:chef_choice/pages/productCategoryPage.dart';
import 'package:chef_choice/pages/registerPage.dart';
import 'package:flutter/material.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: primary,
        cursorColor: primary,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.white,
      ),
      initialRoute: LoginPage.routeName,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        RegisterPage.routeName: (context) => RegisterPage(),
        HomePage.routeName: (context) => HomePage(),
        ProductCategoryPage.routeName: (context) => ProductCategoryPage(),
        AddressPage.routeName: (context) => AddressPage()
      },
    );
  }
}
