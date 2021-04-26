import 'package:cached_network_image/cached_network_image.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';

class ProductTile extends StatefulWidget {
  final ProductList product;
  final Function onTap;
  final Map purchasedProducts;

  ProductTile(this.product, this.purchasedProducts, this.onTap);

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool isBought = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 4),
        child: Container(
          decoration: mainContainerBoxDecor,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 1.2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: primary2.withOpacity(0.2), width: 2), borderRadius: BorderRadius.circular(10)),
                      child: CachedNetworkImage(
                        imageUrl: widget.product.product_img_url,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(value: downloadProgress.progress),
                        ),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ) /*Image.network(
                      product.product_img_url,
                      gaplessPlayback: true,
                    ),*/
                      ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Html(
                          data: widget.product.product_title,
                          style: {"*": Style(fontWeight: FontWeight.w600)},
                        ),
                      ),
                      /*Text(
                        product.product_title,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500),
                      ),*/
                      /*Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Price: ₹ ${product.product_price}",
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),*/
                      bottomBtn()
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomBtn() {
    var productsData = widget.purchasedProducts;
    isBought = productsData.containsKey(widget.product.product_id);
    return isBought
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          /* if (prodQuantity > 1) {
                                            setState(() {
                                              prodQuantity = prodQuantity - 1;
                                            });
                                          } else {}*/
                        },
                        child: Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: primary2.withOpacity(0.8),
                            border: Border.all(color: primary2),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), bottomLeft: Radius.circular(10)),
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
                          /* "$prodQuantity",*/
                          "${productsData[widget.product.product_id]}",
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                        )),
                      ),
                      GestureDetector(
                        onTap: () async {
                          /*setState(() {
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
                                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                            }
                                          });*/
                        },
                        child: Container(
                          width: 35,
                          height: 35,
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
                ),
              ],
            ),
          )
        : Center(
            child: getButton("Buy ₹ ${widget.product.product_price}", Icons.add_shopping_cart, () {
            setState(() {
              isBought = true;
            });
          }));
  }
}
