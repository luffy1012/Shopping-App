import 'dart:ui';

import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

enum paymentMethods { card, cod, gpay, paytm, phonePay, upi }

class PaymentMethodPage extends StatefulWidget {
  static final String routeName = "/paymentPage";

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  List paymentCards = [
    {
      'title': 'Debit/Credit Card',
      'enum_val': paymentMethods.card,
      'img': 'images/payment_gateways/card.png'
    },
    {
      'title': 'Cash On Delivery',
      'enum_val': paymentMethods.cod,
      'img': 'images/payment_gateways/cod.png'
    },
    {
      'title': 'Google Pay',
      'enum_val': paymentMethods.gpay,
      'img': 'images/payment_gateways/gpay.png'
    },
    {
      'title': 'PayTM',
      'enum_val': paymentMethods.paytm,
      'img': 'images/payment_gateways/paytm.png'
    },
    {
      'title': 'PhonePay',
      'enum_val': paymentMethods.phonePay,
      'img': 'images/payment_gateways/phonepay.png'
    },
    {
      'title': 'UPI',
      'enum_val': paymentMethods.upi,
      'img': 'images/payment_gateways/upi.png'
    },
  ];

  paymentMethods _selectedMethod = paymentMethods.card;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select Payment Type",
          style: TextStyle(color: primary2),
        ),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: Container(
          decoration: mainContainerBoxDecor,
          child: Column(
            children: [
              ListView.builder(
                  shrinkWrap: true,
                  itemCount: paymentCards.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedMethod =
                              _selectedMethod = paymentCards[index]['enum_val'];
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                        child: Container(
                          decoration: mainContainerBoxDecor,
                          child: Row(
                            children: [
                              Radio(
                                value: paymentCards[index]['enum_val'],
                                groupValue: _selectedMethod,
                                onChanged: (value) {
                                  setState(() {
                                    _selectedMethod = value;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  paymentCards[index]['img'],
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 25.0),
                                child: Text(
                                  paymentCards[index]['title'],
                                  style: TextStyle(
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    getButton("Place Order", Icons.check, () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return SimpleDialog(
                              children: [
                                Center(
                                  child: Text(
                                    "Order Placed!",
                                    style: TextStyle(
                                      fontSize: 25,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.green, width: 2),
                                  ),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.green,
                                    size: 70,
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    getButton("Done", Icons.done, () {
                                      Navigator.pushNamedAndRemoveUntil(context,
                                          HomePage.routeName, (route) => false);
                                    }),
                                  ],
                                )
                              ],
                            );
                          });

                      /* showDialog(
                        context: context,
                        child: AlertDialog(
                          title: Center(child: Text("Order Placed!")),
                          content: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.green, width: 2),
                            ),
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 70,
                            ),
                          ),
                          actions: [
                            getButton("Done", Icons.done, () {
                              Navigator.pushNamedAndRemoveUntil(context,
                                  HomePage.routeName, (route) => false);
                            })
                          ],
                        ),
                      );*/
                    }),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
