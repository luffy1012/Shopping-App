import 'dart:async';

import 'package:badges/badges.dart';
import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/pages/productPage.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/productTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProductCategoryPage extends StatefulWidget {
  static final String routeName = "/prodCategoryPage";

  final String category_id;
  final String title;
  ProductCategoryPage({this.category_id, this.title});
  @override
  _ProductCategoryPageState createState() => _ProductCategoryPageState();
}

class _ProductCategoryPageState extends State<ProductCategoryPage> {
  Stream _streamGetProductCount;
  StreamController _controller;
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
        title: GestureDetector(
          onTap: () {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(0)), (route) => false);
          },
          child: Text(
            widget.title,
            style: TextStyle(color: primary2),
          ),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<ShopDataProvider>(context).getProductsByCategory(widget.category_id),
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
              var products = snapshot.data;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: products.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
                      itemBuilder: (BuildContext context, int index) {
                        return ProductTile(
                          products[index],
                          this.callProuductCount,
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProductPage(products[index].product_title, products[index].product_id)),
                            ).then((value) => setState(() {
                                  getProductCount();
                                }));
                          },
                        );
                      }),
                ),
              );
            }
          }
        },
      ),
    );
  }

  callProuductCount() {
    getProductCount();
    print("HELLO");
  }

  Future getProductCount() async {
    print("There");
    var data = await Provider.of<CartDataProvider>(context, listen: false).getNumberOfProducts();
    _controller.add(data);
  }
}
