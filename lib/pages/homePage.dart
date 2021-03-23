import 'package:chef_choice/tabs/cartTab.dart';
import 'package:chef_choice/tabs/homeTab.dart';
import 'package:chef_choice/tabs/settingTab.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/customBottomNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "/homePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex = 0;
  final List<Widget> _tabs = [HomeTab(), CartTab(), SettingTab()];
  void updateTabIndex(int i) {
    setState(() {
      _selectedTabIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(236, 236, 236, 1),
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(
            left: 60,
            right: 90,
          ),
          child: Image.asset(
            "images/logo_text.png",
            fit: BoxFit.fill,
          ),
        ),
        backgroundColor: Colors.white,
        shadowColor: primary.withOpacity(0.35),
        iconTheme: IconThemeData(color: primary2),
      ),
      body: _tabs[_selectedTabIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedTabIndex,
        onChange: (index) {
          updateTabIndex(index);
        },
        children: [
          CustomBottomNavigationItem(icon: Icons.home_filled, label: 'HOME'),
          CustomBottomNavigationItem(
              icon: Icons.shopping_cart_rounded, label: 'CART'),
          CustomBottomNavigationItem(icon: Icons.settings, label: 'SETTINGS'),
        ],
      ),
    );
  }
}
