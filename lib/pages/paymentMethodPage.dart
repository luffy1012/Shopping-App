import 'dart:ui';

import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/pages/paymentWebView.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/WebViewCotainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentMethodPage extends StatefulWidget {
  static final String routeName = "/paymentPage";

  @override
  _PaymentMethodPageState createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  TextEditingController tec_coupon, tec_specialInstruction;

  Future _futureDeliveryDetails;

  bool _isLoading = false;

  double _totAmt, _deliveryCharge, _couponDiscount, _totBill;
  List _paymentModes = [];
  List _deliveryCharges = [];

  String imgUrl, paymentType, payNotes;
  String _selectedMethod;
  Map _selectedMethodMap;
  @override
  void initState() {
    // TODO: implement initState
    loadFuture();
    super.initState();
    tec_coupon = TextEditingController();
    tec_specialInstruction = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(fontSize: 16, color: primary2, letterSpacing: 1.2);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "Select Payment Type",
          style: TextStyle(color: primary2),
        ),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: _futureDeliveryDetails,
          builder: (context, snapshot) {
            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
              return Container(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()));
            } else {
              Map data = snapshot.data;
              _totAmt = data['total_amount'];
              Map deliveryData = data['details'];

              _paymentModes = deliveryData['paymode'];
//--------------------------------------------------
              _deliveryCharges = deliveryData['deliverycharge'];
              _deliveryCharge = double.parse(_deliveryCharges[0]['del_charge']);
              bool isDeliveryAvailable = (_deliveryCharges[0]['isActive'].toLowerCase() == "y");
              // print(_deliveryCharge);

              _totBill = _totAmt + _deliveryCharge;
              return Form(
                key: _key,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: mainContainerBoxDecor,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Delivery Details', style: _textStyle.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Delivery Description : ', style: _textStyle, textAlign: TextAlign.start),
                                Flexible(
                                  child: Text("${_deliveryCharges[0]['del_desc']}"),
                                ),
                              ],
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Delivery Status : ", style: _textStyle, textAlign: TextAlign.start),
                                Text(isDeliveryAvailable ? "Delivery Available" : "Currently Delivery Unavailable",
                                    style: TextStyle(color: isDeliveryAvailable ? Colors.green : Colors.red))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: mainContainerBoxDecor,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Cost : ", style: _textStyle, textAlign: TextAlign.start),
                                Text("₹ $_totAmt", style: _textStyle, textAlign: TextAlign.end),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Delivery Charges : ", style: _textStyle, textAlign: TextAlign.start),
                                Text("+ ₹ $_deliveryCharge", style: _textStyle, textAlign: TextAlign.end),
                              ],
                            ),
/*
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Coupon Discount : ", style: _textStyle, textAlign: TextAlign.start),
                                Text("- ₹ 10.0", style: _textStyle, textAlign: TextAlign.end),
                              ],
                            ),
*/
                            Divider(color: primary2, thickness: 0.8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Bill : ", style: _textStyle, textAlign: TextAlign.start),
                                Text("₹ $_totBill", style: _textStyle, textAlign: TextAlign.end),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: mainContainerBoxDecor,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: tec_coupon,
                              decoration: textfield1Deco.copyWith(labelText: "Coupon Code"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                getButton("Apply Coupon", Icons.whatshot_outlined, () {}),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: mainContainerBoxDecor,
                        child: TextFormField(
                          controller: tec_specialInstruction,
                          decoration: textfield1Deco.copyWith(labelText: "Special Instructions (If any)"),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          decoration: mainContainerBoxDecor,
                          child: Column(
                            children: [
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: _paymentModes.length,
                                  itemBuilder: (context, index) {
                                    paymentType = _paymentModes[index]["paymenttype"];
                                    if (paymentType.toLowerCase() == "paytm") {
                                      imgUrl = "images/payment_gateways/paytm.png";
                                    } else if (paymentType.toLowerCase() == "cash on delivery") {
                                      imgUrl = "images/payment_gateways/cod.png";
                                    } else if (paymentType.toLowerCase() == "googlepay") {
                                      imgUrl = "images/payment_gateways/gpay.png";
                                    } else if (paymentType.toLowerCase() == "phonepay") {
                                      imgUrl = "images/payment_gateways/phonepay.png";
                                    } else {
                                      imgUrl = "images/payment_gateways/cod.png";
                                    }

                                    payNotes = _paymentModes[index]['paynotes'];
                                    return GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _selectedMethod = _paymentModes[index]["payrid"];
                                          _selectedMethodMap = _paymentModes[index];
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                        child: Container(
                                          decoration: mainContainerBoxDecor,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                children: [
                                                  Radio(
                                                    value: _paymentModes[index]['payrid'],
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
                                                      imgUrl,
                                                      height: 50,
                                                      width: 50,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 25.0),
                                                    child: Text(
                                                      paymentType,
                                                      style: TextStyle(
                                                        fontSize: 17,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              (payNotes != "")
                                                  ? Container(
                                                      padding: EdgeInsets.all(8),
                                                      child: Text("Note : $payNotes", style: TextStyle(color: primary2)),
                                                    )
                                                  : Container()
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
                                    _isLoading
                                        ? Row(
                                            children: [
                                              CircularProgressIndicator(),
                                              Text("Please Wait!!"),
                                            ],
                                          )
                                        : getButton(
                                            "Place Order",
                                            Icons.check,
                                            () async {
                                              // print(_selectedMethod);
                                              print(_selectedMethodMap);
                                              //payrid : 1 -> cash on delivery
                                              //payer : 3 -> paytm
                                              if (_selectedMethodMap != null) {
                                                await Provider.of<ShopDataProvider>(context, listen: false)
                                                    .placeOrder(
                                                        mobile: data['mobile'],
                                                        session: data['session'],
                                                        cadd_id: data['cadd_id'],
                                                        address: data['address'],
                                                        landmark: data['landmark'],
                                                        city: data['city'],
                                                        state: data['state'],
                                                        pincode: data['pincode'],
                                                        contactperson: data['contactperson'],
                                                        cotanctno: data['contactno'],
                                                        couponcode: tec_coupon.text,
                                                        payment_type: _selectedMethodMap['payrid'],
                                                        specialinstruction: tec_specialInstruction.text,
                                                        products: data['products'],
                                                        book_date: data['bookDate'],
                                                        timing: data['timing'])
                                                    .then(
                                                  (value) async {
                                                    if (value['status'] == true) {
                                                      print("Order placed");
                                                      if (_selectedMethodMap['payrid'] == "1") {
                                                        await Provider.of<CartDataProvider>(context, listen: false).truncateTable();
                                                        buildShowDialog(context);
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                      } else if (_selectedMethodMap['payrid'] == "3" && value['data']['complete'] == 'N') {
                                                        await Provider.of<CartDataProvider>(context, listen: false).truncateTable();
                                                        setState(() {
                                                          _isLoading = false;
                                                        });
                                                        print(value['data']['url']);
                                                        var result = await Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => PaymentWebView('Payment Gateway', value['data']['url'])));
                                                        if (result == 'success') {
                                                          buildShowDialog(context);
                                                        } else {
                                                          buildAlertDialog(context, "Payment unsuccessful",
                                                              result + "\n, order is placed, if possible try cash on delivery", true);
                                                        }
                                                      } else {
                                                        buildAlertDialog(context, "Sorry for inconvenience",
                                                            "Selected payment method is currently unavailable", false);
                                                      }
                                                    } else {
                                                      buildAlertDialog(context, "Something went wrong!", value['message'], false);
                                                      setState(
                                                        () {
                                                          _isLoading = false;
                                                        },
                                                      );
                                                    }
                                                  },
                                                );
                                              } else {
                                                buildAlertDialog(context, "Payment method not selected!", "Please select a payment method", false);
                                              }
                                            },
                                          ),
                                  ],
                                ),
                              )
                            ],
                          )),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }

  Future buildShowDialog(BuildContext context) {
    return showDialog(
        barrierDismissible: false,
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
                  border: Border.all(color: Colors.green, width: 2),
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
                    //Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
                    Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false);
                  }),
                ],
              )
            ],
          );
        });
  }

  Future buildAlertDialog(BuildContext context, String title, String content, bool isExit) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,
            ),
            content: Text(
              content,
              textAlign: TextAlign.center,
            ),
            actions: [
              getButton("OK", Icons.warning, () {
                isExit ? Navigator.pushNamedAndRemoveUntil(context, HomePage.routeName, (route) => false) : Navigator.pop(context);
              })
            ],
          );
        });
  }

  Future<void> loadFuture() async {
    _futureDeliveryDetails = Provider.of<SharedPrefProvider>(context, listen: false).getDeliveryDetails();
  }
}

/*
enum paymentMethods { card, cod, gpay, paytm, phonePay, upi, other }
*/

/*List paymentCards = [
    {'title': 'Debit/Credit Card', 'enum_val': paymentMethods.card, 'img': 'images/payment_gateways/card.png'},
    {'title': 'Cash On Delivery', 'enum_val': paymentMethods.cod, 'img': 'images/payment_gateways/cod.png'},
    {'title': 'Google Pay', 'enum_val': paymentMethods.gpay, 'img': 'images/payment_gateways/gpay.png'},
    {'title': 'PayTM', 'enum_val': paymentMethods.paytm, 'img': 'images/payment_gateways/paytm.png'},
    {'title': 'PhonePay', 'enum_val': paymentMethods.phonePay, 'img': 'images/payment_gateways/phonepay.png'},
    {'title': 'UPI', 'enum_val': paymentMethods.upi, 'img': 'images/payment_gateways/upi.png'},
    {'title': 'Other', 'enum_val': paymentMethods.upi, 'img': 'images/payment_gateways/cod.png'},
  ];*/
