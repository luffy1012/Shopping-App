import 'dart:ui';

import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/swipeImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  final String product_id;

  ProductPage(this.product_id);

  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int prodQuantity = 1;
  int prodQtyRes;
  Future _myFuture; //Future from shopDataProvider
  Future _cartProductFuture; //Future from cartDataProvider
  Product product;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    _myFuture = getProduct(widget.product_id);
    _cartProductFuture = getCartProduct(widget.product_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: _myFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data.title == "error") {
                //TODO: design error page
                return Container();
              } else {
                product = snapshot.data;
                prodQtyRes = product.qty_res;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      //Product name
                      ProductTitleWidget(product: product),
                      //image
                      ProductImageSlider(width: width, product: product),
                      //price,desc,qty,etc
                      ProductDetailsWidget(
                          product: product, prodQtyRes: prodQtyRes),
                    ],
                  ),
                );
              }
            }
          }),
      bottomNavigationBar: BottomAppBar(
        child: bottomBar(context),
      ),
    );
  }

  Widget bottomBar(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_cartProductFuture, _myFuture]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // print(snapshot.data.product_id);
          return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [BoxShadow(blurRadius: 2, color: Colors.grey)]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (prodQuantity > 1) {
                              setState(() {
                                prodQuantity = prodQuantity - 1;
                              });
                            } else {}
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: primary2.withOpacity(0.8),
                              border: Border.all(color: primary2),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10)),
                            ),
                            child: Icon(
                              Icons.remove,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            border: Border(
                              top: BorderSide(color: primary2),
                              bottom: BorderSide(color: primary2),
                            ),
                          ),
                          child: Center(
                              child: Text(
                            "$prodQuantity",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          )),
                        ),
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              if (prodQuantity < prodQtyRes)
                                prodQuantity++;
                              else {
                                final snackBar = SnackBar(
                                  duration: Duration(milliseconds: 600),
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.warning,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 10),
                                      Text("Maximum product quantity reached!")
                                    ],
                                  ),
                                );
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            });
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: primary2.withOpacity(0.8),
                              border: Border.all(color: primary2),
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
                  getButton("Add to cart", Icons.add_shopping_cart, () async {
                    List productData = await Provider.of<CartDataProvider>(
                            context,
                            listen: false)
                        .getRowByID(product.product_id);
                    if (productData.isNotEmpty) {
                      print("Product EXists");
                      //TODO: product exists check qty and program accordingly
                      int purchasedQty =
                          productData[0][CartDataProvider.colQty];
                      int productQtyRes =
                          productData[0][CartDataProvider.colQtyRes];
                      Map<String, dynamic> row = {
                        CartDataProvider.colProductId: product.product_id,
                        CartDataProvider.colProductName: product.title,
                        CartDataProvider.colPrice: double.parse(product.price),
                        CartDataProvider.colQty: prodQuantity,
                        CartDataProvider.colQtyRes: prodQtyRes,
                        CartDataProvider.colImgUrl: product.imgUrls[0]
                      };
                      int i = await Provider.of<CartDataProvider>(context,
                              listen: false)
                          .updateCart(row);
                      final snackBar = cartAddSnackBar(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      print(i);
                    } else {
                      print("New Product Inserted");

                      //TODO: add product
                      Map<String, dynamic> row = {
                        CartDataProvider.colProductId: product.product_id,
                        CartDataProvider.colProductName: product.title,
                        CartDataProvider.colPrice: double.parse(product.price),
                        CartDataProvider.colQty: prodQuantity,
                        CartDataProvider.colQtyRes: prodQtyRes,
                        CartDataProvider.colImgUrl: product.imgUrls[0]
                      };
                      int i = await Provider.of<CartDataProvider>(context,
                              listen: false)
                          .insertProduct(row);
                      print(i);
                      final snackBar = cartAddSnackBar(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  }),
                ],
              ));
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }

  SnackBar cartAddSnackBar(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              child: Text("Product added to cart! (Quantity : $prodQuantity)")),
          TextButton(
            style: TextButton.styleFrom(
                backgroundColor: Colors.white, primary: primaryDark),
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage(1)),
                  (route) => false);
            },
            child: Text("View Cart"),
          )
        ],
      ),
      duration: Duration(milliseconds: 1800),
    );
  }

  SimpleDialog purchaseAlertDialog(
      BuildContext context, String title, String content) {
    return SimpleDialog(
      titlePadding: EdgeInsets.all(10),
      contentPadding: EdgeInsets.all(8),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, color: primaryDark),
          SizedBox(width: 10),
          Expanded(
              child: Text(
            title,
            style: TextStyle(color: primaryDark),
            textAlign: TextAlign.center,
          ))
        ],
      ),
      children: [
        Text(
          content,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 15),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: getButton("OK", Icons.check, () {
            Navigator.pop(context);
          }),
        )
      ],
    );
  }

  Future getProduct(String productId) async {
    var data = await Provider.of<ShopDataProvider>(context, listen: false)
        .getProductDetails(productId);
    return data;
  }

  Future getCartProduct(String productID) async {
    var data = await Provider.of<CartDataProvider>(context, listen: false)
        .getRowByID(productID);
    if (data.length == 0) {
      prodQuantity = 1;
    } else {
      prodQuantity = data[0][CartDataProvider.colQty];
    }
    return data;
  }
}

class ProductDetailsWidget extends StatelessWidget {
  const ProductDetailsWidget({
    Key key,
    @required this.product,
    @required this.prodQtyRes,
  }) : super(key: key);

  final Product product;
  final int prodQtyRes;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding:
              const EdgeInsets.only(left: 8.0, right: 8, top: 8, bottom: 4),
          child: Row(
            children: [
              Text("Price : ₹ ${product.price} ",
                  style: TextStyle(fontSize: 23, color: Colors.black)),
              Text(
                "₹ ${product.oldPrice}",
                style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 18),
              )
            ],
          ),
        ),
        (product.desc == "" || product.desc == null)
            ? Container()
            : Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Description : ",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 23),
                      ),
                      Html(
                        data: product.desc,
                        style: {"*": Style(fontSize: FontSize.large)},
                      )
                    ],
                  ),
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "* Maximum quantity : $prodQtyRes per order",
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    );
  }
}

class ProductImageSlider extends StatelessWidget {
  const ProductImageSlider({
    Key key,
    @required this.width,
    @required this.product,
  }) : super(key: key);

  final double width;
  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: width - 20,
        height: width - 60,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 0),
                blurRadius: 5,
                color: Colors.grey.withOpacity(0.3),
                spreadRadius: 5,
              )
            ]),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SwipeImage(product.imgUrls)),
      ),
    );
  }
}

class ProductTitleWidget extends StatelessWidget {
  const ProductTitleWidget({
    Key key,
    @required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Html(
        data: product.title,
        style: {
          "*": Style(
              fontSize: FontSize.xLarge,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.5)
        },
      ),
    );
  }
}

/*           List data = [];
                            Provider.of<SqlfliteDatabaseProvider>(context,
                                    listen: false)
                                .insertProduct({
                              SqlfliteDatabaseProvider.colProductId:
                                  product.product_id,
                              SqlfliteDatabaseProvider.colProductName:
                                  product.title,
                              SqlfliteDatabaseProvider.colPrice:
                                  double.parse(product.price),
                              SqlfliteDatabaseProvider.colQty: prodQuantity,
                              SqlfliteDatabaseProvider.colQtyRes: prodQtyRes,
                              SqlfliteDatabaseProvider.colImgUrl:
                                  product.imgUrls[0],
                            });
                            data = await Provider.of<SqlfliteDatabaseProvider>(
                                    context,
                                    listen: false)
                                .getRowByID(product.product_id);

                            if (data.isNotEmpty) {
                              print(data);
                            } else
                              print("No data");*/

/*if (purchasedQty == productQtyRes) {
                        //TODO: maxPurchase limit reached
                        showDialog(
                            context: context,
                            builder: (context) {
                              return purchaseAlertDialog(
                                  context,
                                  'Maximum purchase limit reached!',
                                  'You cannot purchase anymore of this product!');
                            });
                      }
                      else {
                        int maxPurchasable = productQtyRes - purchasedQty;
                        //if new puchase is less than maxPurchase, add to cart
                        if (prodQuantity <= productQtyRes) {
                          Map<String, dynamic> row = {
                            CartDataProvider.colProductId: product.product_id,
                            CartDataProvider.colProductName: product.title,
                            CartDataProvider.colPrice:
                                double.parse(product.price),
                            CartDataProvider.colQty: prodQuantity,
                            CartDataProvider.colQtyRes: prodQtyRes,
                            CartDataProvider.colImgUrl: product.imgUrls[0]
                          };
                          int i = await Provider.of<CartDataProvider>(context,
                                  listen: false)
                              .updateCart(row);
                          final snackBar = cartAddSnackBar(context);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          print(i);
                        }
                        else {
                          //TODO: show how many can one purchase and all in Dialog
                          showDialog(
                              context: context,
                              builder: (context) {
                                return purchaseAlertDialog(
                                    context,
                                    'Purchase limit exceeded!',
                                    'You have already added $purchasedQty quantity of this product in your cart!\n'
                                        'You can only purchase $maxPurchasable more quantity!');
                              });
                        }
                      }
                      */
