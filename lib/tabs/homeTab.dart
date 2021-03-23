import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:chef_choice/pages/productCategoryPage.dart';
import 'package:chef_choice/pages/productPage.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/categoryTile.dart';
import 'package:chef_choice/uiResources/productTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  List banners = [1, 2, 3];
  List banner = [
    {'image': 'images/banners/banner_chicken.png', 'onTap': () {}},
    {'image': 'images/banners/banner_egg1.png', 'onTap': () {}},
    {'image': 'images/banners/banner_chicken_Slice.png', 'onTap': () {}}
  ];

  List categories = [
    {'title': 'Eggs', 'img': 'images/food/egg.jpg', 'onTap': () {}},
    {'title': 'Chicken', 'img': 'images/food/chicken.jpg', 'onTap': () {}},
  ];

  List products = [
    {
      'title': 'Eggs',
      'img': 'images/food/egg.jpg',
      'price': 5.0,
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
    },
    {
      'title': 'Eggs',
      'img': 'images/food/egg.jpg',
      'price': 5.0,
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
    },
    {
      'title': 'Eggs',
      'img': 'images/food/egg.jpg',
      'price': 5.0,
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
    },
    {
      'title': 'Eggs',
      'img': 'images/food/egg.jpg',
      'price': 5.0,
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
    },
    {
      'title': 'Eggs',
      'img': 'images/food/egg.jpg',
      'price': 5.0,
    },
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
    },
  ];
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CarouselSlider.builder(
            itemCount: banner.length,
            itemBuilder: (BuildContext context, int index, int index2) {
              return Card(
                elevation: 2,
                child: Container(
                  child: Image.asset(banner[index]['image']),
                ),
              );
            },
            options: CarouselOptions(
                autoPlay: true,
                autoPlayAnimationDuration: Duration(milliseconds: 500),
                autoPlayCurve: Curves.easeInOutSine,
                viewportFraction: 1),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: mainContainerBoxDecor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Category",
                      style: TextStyle(fontSize: 25),
                    ),
                    GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: categories.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1),
                        itemBuilder: (BuildContext context, int index) {
                          return CategoryTile(categories[index]['img'],
                              categories[index]['title'], () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductCategoryPage(
                                  products: products,
                                  category: categories[index]['title'],
                                ),
                              ),
                            );
                          });
                        })
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              decoration: mainContainerBoxDecor,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recommended",
                      style: TextStyle(fontSize: 25),
                    ),
                    GridView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: products.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, childAspectRatio: 1),
                        itemBuilder: (BuildContext context, int index) {
                          return ProductTile(
                              products[index]['img'],
                              products[index]['title'],
                              products[index]['price'], () {
                            //print(products[index].runtimeType);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductPage(
                                  product: products[index],
                                ),
                              ),
                            );
                          });
                        })
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
