import 'dart:ui';

import 'package:chef_choice/pages/orderDetailsPage.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrdersPage extends StatelessWidget {
  static final String routeName = "/ordersPage";

  final List orders = [
    {
      'id': 4312,
      'order_date': '12-Mar-2021',
      'delivery_date': '14-Mar-2021',
      'status': 'Delivered',
      'total_amt': 1250,
      'products': [
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
      ]
    },
    {
      'id': 2131,
      'order_date': '22-Mar-2021',
      'delivery_date': 'NA',
      'status': 'On the way',
      'total_amt': 1250,
      'products': [
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
      ]
    },
    {
      'id': 1234,
      'order_date': '12-Mar-2021',
      'delivery_date': '14-Mar-2021',
      'status': 'Delivered',
      'total_amt': 1250,
      'products': [
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
      ]
    },
    {
      'id': 1111,
      'order_date': '22-Mar-2021',
      'delivery_date': 'NA',
      'status': 'On the way',
      'total_amt': 1250,
      'products': [
        {
          'title': 'Eggs',
          'img': 'images/food/egg_compressed.jpg',
          'price': 5.0,
          'qty': 4
        },
        {
          'title': 'Chicken',
          'img': 'images/food/chicken_compressed.jpg',
          'price': 150.0,
          'qty': 4
        },
      ]
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: Container(
        child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: mainContainerBoxDecor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order #${orders[index]['id']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 18),
                            ),
                            Text(
                              "Status : ${orders[index]['status']}",
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            Text("Ordered on : ${orders[index]['order_date']}"),
                            (orders[index]['delivery_date'] == "NA")
                                ? Text("Delivery on : Not yet delivered")
                                : Text(
                                    "Delivered on : ${orders[index]['delivery_date']}"),
                            Text("Total amount : ${orders[index]['total_amt']}")
                          ],
                        ),
                        getButton("Order details", Icons.double_arrow, () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      OrderDetailsPage(order: orders[index])));
                        })
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
