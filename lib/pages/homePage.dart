import 'package:chef_choice/pages/searchProductsPage.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/tabs/cartTab.dart';
import 'package:chef_choice/tabs/homeTab.dart';
import 'package:chef_choice/tabs/settingTab.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/customBottomNavigationBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static final String routeName = "/homePage";
  int selectedTabIndex;
  HomePage([this.selectedTabIndex = 0]);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedTabIndex;
  SearchBar searchBar;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

/*  List products = [
    {
      'title': 'Eggs',
      'img': 'images/food/egg_compressed.jpg',
      'price': 5.0,
      'id': 'Eggs1',
      'mul_img': [
        'images/food/egg.jpg',
        'images/food/egg.jpg',
        'images/food/egg.jpg',
      ]
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken_compressed.jpg',
      'price': 150.0,
      'id': 'Chicken1',
      'mul_img': [
        'images/food/chicken.jpg',
        'images/food/chicken.jpg',
        'images/food/chicken.jpg',
      ]
    },
    {
      'title': 'Eggs',
      'img': 'images/food/egg_compressed.jpg',
      'price': 5.0,
      'id': 'Eggs1',
      'mul_img': [
        'images/food/egg.jpg',
        'images/food/egg.jpg',
        'images/food/egg.jpg',
      ]
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken_compressed.jpg',
      'price': 150.0,
      'id': 'Chicken1',
      'mul_img': [
        'images/food/chicken.jpg',
        'images/food/chicken.jpg',
        'images/food/chicken.jpg',
      ]
    },
    {
      'title': 'Eggs',
      'img': 'images/food/egg_compressed.jpg',
      'price': 5.0,
      'id': 'Eggs1',
      'mul_img': [
        'images/food/egg.jpg',
        'images/food/egg.jpg',
        'images/food/egg.jpg',
      ]
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken_compressed.jpg',
      'price': 150.0,
      'id': 'Chicken1',
      'mul_img': [
        'images/food/chicken.jpg',
        'images/food/chicken.jpg',
        'images/food/chicken.jpg',
      ]
    },
  ];*/

  List<Widget> _tabs;
  void updateTabIndex(int i) {
    setState(() {
      _selectedTabIndex = i;
    });
  }

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: Padding(
          padding: const EdgeInsets.only(
            left: 60,
            right: 60,
          ),
          child: Image.asset(
            "images/logo_text.png",
            fit: BoxFit.fill,
          ),
        ),
        leading: (_selectedTabIndex == 0)
            ? Container()
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: primary2,
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(0)), (route) => false);
                },
              ),
        backgroundColor: Colors.white,
        shadowColor: primary2.withOpacity(0.35),
        iconTheme: IconThemeData(color: primary2),
        actions: [searchBar.getSearchAction(context)]);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedTabIndex = widget.selectedTabIndex;
    _tabs = [HomeTab(), CartTab(), SettingTab()];
    searchBar = new SearchBar(
        inBar: false,
        buildDefaultAppBar: buildAppBar,
        setState: setState,
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchProductPage(
                  searchedTerm: value,
                ),
              ),
            );
          } else {
            showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    title: Icon(
                      Icons.warning_amber_outlined,
                      color: primaryDark,
                    ),
                    children: [
                      Center(child: Text("Search term cannot be empty!")),
                      Center(
                        child: getButton("OK", Icons.warning_amber_outlined, () {
                          Navigator.pop(context);
                        }),
                      )
                    ],
                  );
                });
          }
        },
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    //Provider.of<ShopDataProvider>(context).getShopDetails();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(236, 236, 236, 1),
      appBar: searchBar.build(context),
      body: _tabs[_selectedTabIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        itemColor: primary2,
        currentIndex: _selectedTabIndex,
        onChange: (index) {
          updateTabIndex(index);
        },
        children: [
          CustomBottomNavigationItem(icon: Icons.home_filled, label: 'HOME'),
          CustomBottomNavigationItem(icon: Icons.shopping_cart_rounded, label: 'CART'),
          CustomBottomNavigationItem(icon: Icons.settings, label: 'SETTINGS'),
        ],
      ),
    );
  }
}
