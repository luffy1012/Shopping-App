import 'package:cached_network_image/cached_network_image.dart';
import 'package:chef_choice/pages/repeatOrder.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';

class OrderDetailsPage extends StatefulWidget {
  static final String routeName = "/orderDetailsPage";
  final String orderid;
  final String orderNo;
  final String orderDate;
  final String deliveryDate;
  final String deliveryTime;
  OrderDetailsPage(
      {@required this.orderid, @required this.orderNo, @required this.orderDate, @required this.deliveryDate, @required this.deliveryTime});

  @override
  _OrderDetailsPageState createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  Future _futureOrderDetails;

  TextStyle style1 = TextStyle(fontSize: 16);
  TextStyle style2 = TextStyle(fontSize: 16);

  @override
  void initState() {
    // TODO: implement initState
    loadOrderDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order #${widget.orderid}",
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: primary2),
        ),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _futureOrderDetails,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data is Map) {
              var orderDetails = snapshot.data['data']['info'];
              var orderProducts = snapshot.data['data']['order'];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: mainContainerBoxDecor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              "Order Details : ",
                              style: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.5, fontSize: 20),
                            ),
                            SizedBox(height: 20),
                            GridView(
                              shrinkWrap: true,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 5),
                              children: [
                                Text(
                                  "Order #",
                                  style: style1,
                                ),
                                Text(
                                  widget.orderid,
                                  style: style2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "Ordered Date :",
                                  style: style1,
                                ),
                                Text(
                                  widget.orderDate,
                                  style: style2,
                                ),
                                Text(
                                  "Delivered date : ",
                                  style: style1,
                                ),
                                Text(
                                  "${widget.deliveryDate}",
                                  style: style2,
                                ),
                                Text(
                                  "Delivered time : ",
                                  style: style1,
                                ),
                                Text(
                                  widget.deliveryTime,
                                  style: style2,
                                ),
                                Text(
                                  "Total Amount : ",
                                  style: style1,
                                ),
                                Text(
                                  "₹ ${orderDetails['ordervalue']}",
                                  style: style2,
                                ),
                                Text(
                                  "Payment Type : ",
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  orderDetails['payment_type'],
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                            getButton(
                              "Repeat Order",
                              Icons.repeat,
                              () {
                                List<String> ids = [];
                                orderProducts.forEach((product) => ids.add(product['p_uid']));
                                print(ids);
                                Navigator.push(context, MaterialPageRoute(builder: (context) => RepeatOrder(ids)));
                              },
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          decoration: mainContainerBoxDecor,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                "Purchased Products : ",
                                style: TextStyle(fontWeight: FontWeight.w500, letterSpacing: 1.5, fontSize: 20),
                              ),
                              Expanded(
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: orderProducts.length,
                                    itemBuilder: (context, index) {
                                      //print(orderProducts[index]['image']);
                                      return Padding(
                                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                        child: Container(
                                          height: 120,
                                          decoration: mainContainerBoxDecor,
                                          child: Row(
                                            children: [
                                              AspectRatio(
                                                aspectRatio: 1,
                                                child: CachedNetworkImage(
                                                  imageUrl: orderProducts[index]['image'],
                                                  progressIndicatorBuilder: (context, url, downloadProgress) => Center(
                                                    child: CircularProgressIndicator(value: downloadProgress.progress),
                                                  ),
                                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                                ),
                                              ),
                                              Expanded(
                                                child: Container(
                                                  width: MediaQuery.of(context).size.width,
                                                  padding: const EdgeInsets.all(4.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      Expanded(
                                                        child: Html(
                                                          data: orderProducts[index]['title'],
                                                          shrinkWrap: true,
                                                          style: {"*": Style(fontWeight: FontWeight.w600, fontSize: FontSize.medium)},
                                                        ),
                                                      ),
                                                      Text(
                                                        "Price : ₹ ${orderProducts[index]['oprice']}",
                                                        style: style1,
                                                      ),
                                                      Text(
                                                        "Quantity : ${orderProducts[index]['qty']}",
                                                        style: style1,
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
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Text("Someting went wrong\nError : ${snapshot.data}");
            }
          }
        },
      ),
    );
  }

  Future<void> loadOrderDetails() async {
    _futureOrderDetails = Provider.of<ShopDataProvider>(context, listen: false).getOrderDetails(widget.orderid);
  }
}
/*Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: mainContainerBoxDecor,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Order Details : ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                        fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  GridView(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 5),
                    children: [
                      Text(
                        "Order #",
                        style: style1,
                      ),
                      Text(
                        "${order['id']}",
                        style: style2,
                      ),
                      Text(
                        "Ordered On :",
                        style: style1,
                      ),
                      Text(
                        "${order['order_date']}",
                        style: style2,
                      ),
                      Text(
                        "Delivered On : ",
                        style: style1,
                      ),
                      Text(
                        "${order['delivery_date']}",
                        style: style2,
                      ),
                      Text(
                        "Total Amount : ",
                        style: style1,
                      ),
                      Text(
                        "${order['total_amt']}",
                        style: style2,
                      ),
                      Text(
                        "Status : ",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        "${order['status']}",
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  Divider(thickness: 1.5),
                  SizedBox(height: 20),
                  Text(
                    "Products : ",
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.5,
                        fontSize: 20),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: order['products'].length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                            child: Container(
                              height: 100,
                              decoration: mainContainerBoxDecor,
                              child: Row(
                                children: [
                                  Image.asset(order['products'][index]['img']),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          order['products'][index]['title'],
                                          style: style1,
                                        ),
                                        Text(
                                          "Price : ₹ ${order['products'][index]['price']}",
                                          style: style1,
                                        ),
                                        Text(
                                          "Quantity : ${order['products'][index]['qty']}",
                                          style: style1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                  )
                ],
              ),
            ),
          ),
        )*/
