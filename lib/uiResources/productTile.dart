import 'package:cached_network_image/cached_network_image.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:html/parser.dart';

class ProductTile extends StatefulWidget {
  final ProductList product;
  final Function onTap;
  final Function callBack;
  ProductTile(this.product, this.callBack, this.onTap);

  @override
  _ProductTileState createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  bool isBought = false;
  bool isLoading = false;
  int qtyRes;
  Future _cartDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    var doc = parse(widget.product.product_title);
    var title = parse(doc.body.text).documentElement.text;
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
                      /*Expanded(
                        child: Html(
                          data: widget.product.product_title,
                          style: {"*": Style(fontWeight: FontWeight.w600)},
                        ),
                      ),*/
                      Expanded(
                        child: Text(
                          "$title",
                          overflow: TextOverflow.fade,
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ),
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
    isBought = false;
    return FutureBuilder(
      future: Provider.of<CartDataProvider>(context).isProductExist(widget.product.product_id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List rawData = snapshot.data;
          if (rawData == null || rawData.length == 0)
            isBought = false;
          else {
//            print(rawData[0][CartDataProvider.colProductName]);
            isBought = true;
          }

          return Container(
            child: isLoading
                ? Center(
                    child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(),
                  ))
                : (isBought
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      if (rawData[0][CartDataProvider.colQty] > 1) {
                                        Map<String, dynamic> row = {
                                          CartDataProvider.colPid: rawData[0][CartDataProvider.colPid],
                                          CartDataProvider.colProductId: rawData[0][CartDataProvider.colProductId],
                                          CartDataProvider.colProductName: rawData[0][CartDataProvider.colProductName],
                                          CartDataProvider.colPrice: rawData[0][CartDataProvider.colPrice],
                                          CartDataProvider.colQty: rawData[0][CartDataProvider.colQty] - 1,
                                          CartDataProvider.colQtyRes: rawData[0][CartDataProvider.colQtyRes],
                                          CartDataProvider.colImgUrl: rawData[0][CartDataProvider.colImgUrl]
                                        };

                                        int i = await Provider.of<CartDataProvider>(context, listen: false).updateCart(row);
                                        setState(() {});
                                        widget.callBack();
                                      }
                                      if (rawData[0][CartDataProvider.colQty] == 1) {
                                        await Provider.of<CartDataProvider>(context, listen: false)
                                            .removeProduct(rawData[0][CartDataProvider.colProductId]);
                                        setState(() {});
                                        widget.callBack();
                                      }
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
                                      "${rawData[0][CartDataProvider.colQty]}",
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    )),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (rawData[0][CartDataProvider.colQty] < rawData[0][CartDataProvider.colQtyRes]) {
                                        Map<String, dynamic> row = {
                                          CartDataProvider.colPid: rawData[0][CartDataProvider.colPid],
                                          CartDataProvider.colProductId: rawData[0][CartDataProvider.colProductId],
                                          CartDataProvider.colProductName: rawData[0][CartDataProvider.colProductName],
                                          CartDataProvider.colPrice: rawData[0][CartDataProvider.colPrice],
                                          CartDataProvider.colQty: rawData[0][CartDataProvider.colQty] + 1,
                                          CartDataProvider.colQtyRes: rawData[0][CartDataProvider.colQtyRes],
                                          CartDataProvider.colImgUrl: rawData[0][CartDataProvider.colImgUrl]
                                        };

                                        int i = await Provider.of<CartDataProvider>(context, listen: false).updateCart(row);
                                        setState(() {});
                                        widget.callBack();
                                      } else {
                                        //PRODUCT LIMIT EXCEEDS
                                        print("PRODUCT LIMIT!!!!!!!");
                                      }
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
                        child: getButton("Buy ₹ ${widget.product.product_price}", Icons.add_shopping_cart, () async {
                        setState(() {
                          isLoading = true;
                        });
                        var product = await Provider.of<ShopDataProvider>(context, listen: false).getProductDetails(widget.product.product_id);

                        Map<String, dynamic> row = {
                          CartDataProvider.colPid: product.p_id,
                          CartDataProvider.colProductId: product.product_id,
                          CartDataProvider.colProductName: product.title,
                          CartDataProvider.colPrice: double.parse(product.price),
                          CartDataProvider.colQty: 1,
                          CartDataProvider.colQtyRes: product.qty_res,
                          CartDataProvider.colImgUrl: product.imgUrls[0]
                        };
                        int i = await Provider.of<CartDataProvider>(context, listen: false).insertProduct(row);
                        setState(() {
                          isLoading = false;
                        });

                        widget.callBack();
                      }))),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
