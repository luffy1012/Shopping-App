import 'package:chef_choice/pages/aboutUsPage.dart';
import 'package:chef_choice/pages/addressPage.dart';
import 'package:chef_choice/pages/changePasswordPage.dart';
import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/pages/loginPage.dart';
import 'package:chef_choice/pages/orderDetailsPage.dart';
import 'package:chef_choice/pages/ordersPage.dart';
import 'package:chef_choice/pages/otpPage.dart';
import 'package:chef_choice/pages/paymentMethodPage.dart';
import 'package:chef_choice/pages/productCategoryPage.dart';
import 'package:chef_choice/pages/profilePage.dart';
import 'package:chef_choice/pages/registerPage.dart';
import 'package:chef_choice/pages/timeSlotPage.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:flutter/material.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(new MyApp());
  });
  //runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Database db = SqlfliteDatabaseProvider.instance.database as Database;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShopDataProvider>(create: (_) => ShopDataProvider()),
        ChangeNotifierProvider<CartDataProvider>(create: (_) => CartDataProvider.instance),
        ChangeNotifierProvider<SharedPrefProvider>(create: (_) => SharedPrefProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor: primary2,
          accentColor: primaryLight,
          cursorColor: primaryLight,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          canvasColor: Colors.white,
        ),
        initialRoute: HomePage.routeName,
        routes: {
          LoginPage.routeName: (context) => LoginPage(),
          // OtpPage.routeName: (context) => OtpPage(""),
          //     RegisterPage.routeName: (context) => RegisterPage(),
          HomePage.routeName: (context) => HomePage(),
          ProductCategoryPage.routeName: (context) => ProductCategoryPage(),
          AddressPage.routeName: (context) => AddressPage(),
          TimeSlotPage.routeName: (context) => TimeSlotPage(),
          PaymentMethodPage.routeName: (context) => PaymentMethodPage(),
          ChangePasswordPage.routeName: (context) => ChangePasswordPage(),
          ProfilePage.routeName: (context) => ProfilePage(),
          AboutUsPage.routeName: (context) => AboutUsPage(),
          OrdersPage.routeName: (context) => OrdersPage(),
          //OrderDetailsPage.routeName: (context) => OrderDetailsPage()
        },
      ),
    );
  }
}
