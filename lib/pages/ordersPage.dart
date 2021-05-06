import 'dart:ui';

import 'package:chef_choice/pages/orderDetailsPage.dart';
import 'package:chef_choice/pages/repeatOrder.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrdersPage extends StatefulWidget {
  static final String routeName = "/ordersPage";

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  Future _futureOrderList;

  bool isLoading = false;
  DateFormat df1 = DateFormat('dd-MMMM-yyyy'); //display format
  DateFormat df2 = DateFormat('yyyy-MM-dd H:m:s'); //order date format coming from api
  DateFormat df3 = DateFormat('y-M-dd'); //delivery date format coming from api

  @override
  void initState() {
    // TODO: implement initState
    getOrderList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("My Orders"),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _futureOrderList,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data is Map) {
              var orders = snapshot.data['data'];
              /*var date = orders[0]['date'];
              DateTime d = df2.parse(date);
              print(df1.format(d));*/
              //print(orders.length);
              return Stack(
                children: [
                  Container(
                    child: ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          var unformattedOrderDate = orders[index]['date'];
                          DateTime dt_orderDate = df2.parse(unformattedOrderDate);

                          var unformattedDeliveryDate = orders[index]['delivereydate'];
                          DateTime dt_deliveryDate = df3.parse(unformattedDeliveryDate);
                          /* print("unformatted delivery date: $unformattedDeliveryDate");
                          print("formatted delivery date: $dt_deliveryDate");
                          print("\n-------------------");*/
                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: mainContainerBoxDecor,
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      "Order #${orders[index]['oid']}",
                                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                                    ),
                                  ),
                                  Divider(color: primary2, thickness: 1),
                                  GridView(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 8,
                                    ),
                                    children: [
                                      Text("Order date : "),
                                      Text(df1.format(dt_orderDate)),
                                      Text("Delivery date : "),
                                      Text(df1.format(dt_deliveryDate)),
                                      Text("Delivery time : "),
                                      Text(orders[index]['deliverytime']),
                                      Text("Order status : "),
                                      Text(orders[index]['ostatus']),
                                      Text("Payment status : "),
                                      Text(orders[index]['pmtstatus']),
                                      Text("Total amount : "),
                                      Text("₹ ${orders[index]['ordervalue']}"),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      getButton(
                                        "Repeat Order",
                                        Icons.repeat,
                                        () async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          await Provider.of<ShopDataProvider>(context, listen: false)
                                              .getOrderDetails(orders[index]['oid'])
                                              .then((value) {
                                            if (value is Map) {
                                              var products = value['data']['order'];
                                              List<String> ids = [];
                                              products.forEach((product) {
                                                ids.add(product['p_uid']);
                                              });
                                              //print(ids);
                                              setState(() {
                                                isLoading = false;
                                              });
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => RepeatOrder(ids)),
                                              );
                                            } else {
                                              showMyDialog("Something went wrong", value);
                                            }
                                          });
                                        },
                                      ),
                                      getButton("Order details", Icons.double_arrow, () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => OrderDetailsPage(
                                              orderid: orders[index]['oid'],
                                              orderNo: orders[index]['orderid'],
                                              orderDate: df1.format(dt_orderDate),
                                              deliveryDate: df1.format(dt_deliveryDate),
                                              deliveryTime: orders[index]['deliverytime'],
                                            ),
                                          ),
                                        );
                                      }),
                                    ],
                                  )
                                  // Text("Total amount : ${orders[index]['total_amt']}")
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                  if (isLoading)
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: mainContainerBoxDecor.copyWith(color: primary2),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                "Please Wait!!!",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white, fontSize: 25, letterSpacing: 1.5, fontWeight: FontWeight.w500),
                              ),
                              CircularProgressIndicator(backgroundColor: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return Center(
                child: Container(
                  child: Text("Something went wrong!!\nError : ${snapshot.data}"),
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> getOrderList() async {
    _futureOrderList = Provider.of<ShopDataProvider>(context, listen: false).getOrderList();
  }

  Future showMyDialog(String title, String content) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              getButton("OK", Icons.warning_amber_rounded, () {
                Navigator.pop(context);
              })
            ],
          );
        });
  }
}
