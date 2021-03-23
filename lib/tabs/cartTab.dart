import 'dart:ui';

import 'package:chef_choice/pages/addressPage.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  List products = [
    {'title': 'Eggs', 'img': 'images/food/egg.jpg', 'price': 5.0, 'qty': 4},
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
      'qty': 1
    },
    {'title': 'Eggs', 'img': 'images/food/egg.jpg', 'price': 5.0, 'qty': 4},
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
      'qty': 1
    },
    {'title': 'Eggs', 'img': 'images/food/egg.jpg', 'price': 5.0, 'qty': 4},
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
      'qty': 1
    },
    {'title': 'Eggs', 'img': 'images/food/egg.jpg', 'price': 5.0, 'qty': 4},
    {
      'title': 'Chicken',
      'img': 'images/food/chicken.jpg',
      'price': 150.0,
      'qty': 1
    },
  ];
  double totalAmt;
  @override
  void initState() {
    super.initState();
    updateTotalAmt();
  }

  updateTotalAmt() {
    setState(() {
      totalAmt = products
          .map((element) => element['price'] * element['qty'])
          .fold(0, (prev, amount) => prev + amount);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Container(
            decoration: mainContainerBoxDecor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Amount : ₹ $totalAmt",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  getButton("Proceed", Icons.arrow_forward_ios, () {
                    Navigator.pushNamed(context, AddressPage.routeName);
                  })
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 4.0, right: 4, top: 5),
                  child: Container(
                    color: Colors.white,
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Image.asset(
                                products[index]['img'],
                                fit: BoxFit.contain,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      products[index]['title'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      "₹ ${products[index]['price']}",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Container(
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (products[index]['qty'] > 1) {
                                      products[index]['qty']--;
                                      updateTotalAmt();
                                    } else if (products[index]['qty'] == 1) {
                                      products.removeAt(index);
                                      updateTotalAmt();
                                    } else {}
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                    ),
                                    child: Icon(
                                      (products[index]['qty'] == 1)
                                          ? Icons.delete_outline
                                          : Icons.remove,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    border: Border(
                                      top: BorderSide(),
                                      bottom: BorderSide(),
                                    ),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "${products[index]['qty']}",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    products[index]['qty']++;
                                    updateTotalAmt();
                                  },
                                  child: Container(
                                    width: 35,
                                    height: 35,
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      border: Border.all(color: Colors.green),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                    ),
                                    child: Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        )
      ],
    );
  }
}
