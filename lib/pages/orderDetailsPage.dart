import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetailsPage extends StatelessWidget {
  static final String routeName = "/orderDetailsPage";
  Map order;
  OrderDetailsPage({@required this.order});

  TextStyle style1 = TextStyle(fontSize: 18);
  TextStyle style2 = TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Order #${order['id']}"),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: Padding(
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
      ),
    );
  }
}
