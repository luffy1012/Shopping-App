import 'dart:async';

import 'package:badges/badges.dart';
import 'package:chef_choice/pages/productPage.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/productTile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'homePage.dart';

class RepeatOrder extends StatefulWidget {
  final List<String> ids;

  RepeatOrder(this.ids);

  @override
  _RepeatOrderState createState() => _RepeatOrderState();
}

class _RepeatOrderState extends State<RepeatOrder> {
  Stream _streamGetProductCount;
  StreamController _controller;
  bool isStreamOn = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = StreamController();
    _streamGetProductCount = _controller.stream;
    callProuductCount();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "Repeat Order",
            style: TextStyle(color: primary2),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Center(
              child: StreamBuilder(
                stream: _streamGetProductCount,
                builder: (context, snapshot) {
                  if (snapshot.data == null) return Center(child: CircularProgressIndicator());

                  int count = snapshot.data;
                  print("### count : $count");
                  return (count == 0)
                      ? IconButton(
                          icon: Icon(Icons.shopping_cart_outlined),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(1)), (route) => false);
                          },
                        )
                      : Badge(
                          elevation: 0,
                          position: BadgePosition.topEnd(top: 1, end: 1),
                          badgeColor: primary2.withOpacity(0.8),
                          badgeContent: Text(
                            "$count",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 10),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.shopping_cart_outlined),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(1)), (route) => false);
                            },
                          ),
                        );
                },
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<ShopDataProvider>(context).getMultipleProductsById(widget.ids),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            if (snapshot.data[0].product_id == "error") {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "🙁\nCurrently no product is available of this category!\n Sorry for the inconvenience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ),
              );
            } else {
              List<ProductList> products = snapshot.data;
              products.forEach((p) {
/*                print(p.product_id);
                print(p.p_id);
                print(p.product_title);
                print(p.product_img_url);*/
              });
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: products.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
                          itemBuilder: (BuildContext context, int index) {
                            return ProductTile(
                              products[index],
                              callProuductCount,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ProductPage(products[index].product_title, products[index].product_id)),
                                ).then((value) => setState(() {}));
                              },
                            );
                          }),
                    ],
                  ),
                ),
              );
            }
          }
        },
      ),
    );
  }

  callProuductCount() {
    isStreamOn = true;
    getProductCount();
    print("HELLO");
  }

  Future getProductCount() async {
    print("There");
    isStreamOn = false;
    var data = await Provider.of<CartDataProvider>(context, listen: false).getNumberOfProducts();
    _controller.add(data);
  }
}
