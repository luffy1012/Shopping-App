import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chef_choice/pages/loginPage.dart';
import 'package:chef_choice/pages/timeSlotPage.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/PageConstant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:html/parser.dart';
import 'package:provider/provider.dart';

class CartTab extends StatefulWidget {
  @override
  _CartTabState createState() => _CartTabState();
}

class _CartTabState extends State<CartTab> {
  bool isLoading = false;
  TextStyle _textStyle = TextStyle(fontWeight: FontWeight.w400, fontSize: 15, letterSpacing: 1.5);
  List products = [];
  Future _myFuture;
  double totalAmt = 0;
  @override
  void initState() {
    _myFuture = getAllProducts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final btnHeight = 30.0;
    final btnWidth = 30.0;
    return FutureBuilder(
      future: _myFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          products = snapshot.data;
          // print(products);
          totalAmt = 0;
          products.forEach((element) {
            totalAmt += element[CartDataProvider.colQty] * element[CartDataProvider.colPrice];
          });
          return isLoading
              ? CircularProgressIndicator()
              : Column(
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
                              getButton("Proceed", Icons.arrow_forward_ios, () async {
                                if (products.length != 0) {
                                  setState(() {
                                    isLoading = true;
                                  });

                                  await Provider.of<SharedPrefProvider>(context, listen: false).storeDeliveryTotalAmount(totalAmt).then(
                                    (value) async {
                                      if (value) {
                                        await Provider.of<SharedPrefProvider>(context, listen: false).isLoggedIn().then(
                                          (value) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            print("is logged in : $value");
                                            if (value) {
                                              Navigator.pushNamed(context, TimeSlotPage.routeName);
                                            } else {
                                              Navigator.push(
                                                  context, MaterialPageRoute(builder: (context) => LoginPage(goToPage: PageConstant.TimSlotPage)));
                                            }
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: Text("Something went wrong"),
                                              content: Text("storeDeliveryTotalAmount() returned false!"),
                                              actions: [
                                                getButton("OK", Icons.thumb_up_alt_outlined, () => Navigator.pop(context)),
                                              ],
                                            );
                                          },
                                        );
                                      }
                                    },
                                  );
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Cart is empty!"),
                                        content: Text("Please add products into the cart before proceeding!"),
                                        actions: [
                                          getButton("OK", Icons.thumb_up_alt_outlined, () => Navigator.pop(context)),
                                        ],
                                      );
                                    },
                                  );
                                }
                              })
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: products.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1, childAspectRatio: 2.5),
                          itemBuilder: (context, index) {
                            var prodQuantity = products[index][CartDataProvider.colQty];
                            var prodQtyRes = products[index][CartDataProvider.colQtyRes];
                            var doc = parse(products[index][CartDataProvider.colProductName]);
                            var title = parse(doc.body.text).documentElement.text;
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                              child: Card(
                                child: Row(
                                  children: [
                                    Flexible(
                                      flex: 2,
                                      child: Container(
                                        child: CachedNetworkImage(
                                          imageUrl: products[index][CartDataProvider.colImgUrl],
                                          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                            child: CircularProgressIndicator(value: downloadProgress.progress),
                                          ),
                                          errorWidget: (context, url, error) => Icon(Icons.error),
                                        ), /*Image.network(products[index]
                                      [CartDataProvider.colImgUrl]),*/
                                      ),
                                    ),
                                    Flexible(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 8.0),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.stretch,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              title,
                                              style: _textStyle,
                                              overflow: TextOverflow.fade,
                                            ),
                                            SizedBox(height: 10),
                                            /* Html(
                                              data: products[index][CartDataProvider.colProductName],
                                              style: {"*": Style(fontWeight: FontWeight.w400, fontSize: FontSize.large, letterSpacing: 1.5)},
                                            ),*/
                                            Text(
                                              "Price : ₹ ${products[index][CartDataProvider.colPrice]}",
                                              style: _textStyle,
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                                "Total Amount : ₹ ${products[index][CartDataProvider.colQty] * products[index][CartDataProvider.colPrice]}",
                                                style: _textStyle),
                                            SizedBox(height: 10),
                                            qtyButton(prodQuantity, index, btnWidth, btnHeight, prodQtyRes, context),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    )
                  ],
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Container qtyButton(prodQuantity, int index, double btnWidth, double btnHeight, prodQtyRes, BuildContext context) {
    return Container(
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              if (prodQuantity > 1) {
                prodQuantity = prodQuantity - 1;
                var data = await updateDatabase(products[index], prodQuantity);
                setState(() {});
              } else {
                var data = await deleteProduct(products[index][CartDataProvider.colProductId]);
                setState(() {});
              }
            },
            child: Container(
              width: btnWidth,
              height: btnHeight,
              decoration: BoxDecoration(
                color: primary2.withOpacity(0.8),
                border: Border.all(color: primary2),
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
              ),
              child: (prodQuantity > 1)
                  ? Icon(
                      Icons.remove,
                      color: Colors.white,
                    )
                  : Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.white,
                    ),
            ),
          ),
          Container(
            width: btnWidth,
            height: btnHeight,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: primary2),
                bottom: BorderSide(color: primary2),
              ),
            ),
            child: Center(
                child: Text(
              "${products[index][CartDataProvider.colQty]}",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            )),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                if (prodQuantity < prodQtyRes) {
                  prodQuantity++;
                  updateDatabase(products[index], prodQuantity);
                } else {
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
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              });
            },
            child: Container(
              width: btnWidth,
              height: btnHeight,
              decoration: BoxDecoration(
                color: primary2.withOpacity(0.8),
                border: Border.all(color: primary2),
                borderRadius: BorderRadius.only(topRight: Radius.circular(10), bottomRight: Radius.circular(10)),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future getAllProducts() async {
    var data = await Provider.of<CartDataProvider>(context, listen: false).getAllProducts();
    return data;
  }

  Future updateDatabase(product, prodQuantity) async {
    Map<String, dynamic> row = {
      CartDataProvider.colPid: product[CartDataProvider.colPid],
      CartDataProvider.colProductId: product[CartDataProvider.colProductId],
      CartDataProvider.colProductName: product[CartDataProvider.colProductName],
      CartDataProvider.colPrice: product[CartDataProvider.colPrice],
      CartDataProvider.colQty: prodQuantity,
      CartDataProvider.colQtyRes: product[CartDataProvider.colQtyRes],
      CartDataProvider.colImgUrl: product[CartDataProvider.colImgUrl]
    };
    var data = await Provider.of<CartDataProvider>(context, listen: false).updateCart(row);
    _myFuture = getAllProducts();
    return data;
  }

  Future deleteProduct(String productID) async {
    var res = await Provider.of<CartDataProvider>(context, listen: false).removeProduct(productID);
    _myFuture = getAllProducts();
    return res;
  }
}
