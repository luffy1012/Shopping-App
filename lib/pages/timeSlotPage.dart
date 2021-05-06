import 'dart:convert';
import 'dart:ui';

import 'package:chef_choice/pages/addressPage.dart';
import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TimeSlotPage extends StatefulWidget {
  static final String routeName = "/timeSlotPage";

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
  Future _myFuture;
  Map scheduleDetails;
  String _selectedDate;

  DateFormat dateFormat = DateFormat('y-MM-d');
  int _selectedSlot = 0;
  List dates = [];
  List dates1 = [];
  List time = [];

  @override
  void initState() {
    // TODO: implement initState
    //_selectedDate = dateFormat.format(DateTime.now().add(Duration(days: 1))).toString();
    // print(_selectedDate);
    getMyFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomePage(1)), (route) => false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Select Delivery Time",
            style: TextStyle(color: primary2),
          ),
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: primary2,
            ),
            onPressed: () {
              Navigator.pushNamed(context, HomePage.routeName);
            },
          ),
        ),
        body: FutureBuilder(
          future: _myFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              scheduleDetails = snapshot.data;
              var dateDetails = scheduleDetails['data']['schedule']['date'];
              dateDetails.forEach((element) {
                if (!dates.contains(element['date'])) dates.add(element['date']);
                if (!dates1.contains(element['book_date'])) dates1.add(element['book_date']);
              });
              if (_selectedDate == null) _selectedDate = dates[0];
              print(_selectedDate);
              var timingDetails = scheduleDetails['data']['schedule']['timing'];
              time.clear();
              timingDetails.forEach((element) => time.add(element['time']));
              //  print(dateDetails);
              // print(scheduleDetails);
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: mainContainerBoxDecor,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Select Delivery Date : ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        SizedBox(height: 10),
                        GridView.builder(
                          itemCount: dates.length,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                _selectedDate = dates[index];
                                getMyFuture();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                                child: Container(
                                  decoration: mainContainerBoxDecor.copyWith(color: (dates[index] != _selectedDate) ? Colors.white : primaryLight),
                                  child: Center(
                                      child: Text(
                                    dates1[index],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Select Delivery Time : ",
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1.5),
                        ),
                        SizedBox(height: 10),
                        GridView.builder(
                          itemCount: time.length,
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 2.5),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedSlot = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                                child: Container(
                                  decoration: mainContainerBoxDecor.copyWith(color: (index != _selectedSlot) ? Colors.white : primaryLight),
                                  child: Center(
                                      child: Text(
                                    time[index],
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            );
                          },
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            getButton("Proceed", Icons.arrow_forward_ios, () async {
                              if (_selectedDate.isNotEmpty || _selectedDate != "") {
                                List paymentModesList = snapshot.data['data']['paymode'];
                                String jsonEncodedPaymentModes = json.encode(paymentModesList);
                                //print(paymentModesList);
                                //print(jsonEncodedPaymentModes);
                                String coupon = snapshot.data['data']['coupon'];
                                List deliveryCharge = snapshot.data['data']['deliverycharge'];
                                String jsonEncodedDeliveryCharge = json.encode(deliveryCharge);
                                //print(deliveryCharge);
                                //print(jsonEncodedDeliveryCharge);

                                if (jsonEncodedDeliveryCharge.isNotEmpty && jsonEncodedPaymentModes.isNotEmpty) {
                                  await Provider.of<SharedPrefProvider>(context, listen: false)
                                      .storeDeliveryTimeSlot(_selectedDate, time[_selectedSlot])
                                      .then(
                                    (value) {
                                      if (value)
                                        Navigator.pushNamed(context, AddressPage.routeName);
                                      else
                                        showMyDialog("Something went wrong", "storeDeliveryTimeSlot() returned false while storing the data");
                                    },
                                  );
                                } else {
                                  showMyDialog("Data not received", "payment data or delivery charges data not received!");
                                }
                              } else {
                                showMyDialog("Date or time-slot not selected!", "Please select date or time-slot before proceeding");
                              }
                            }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  void showMyDialog(String title, String content) {
    showDialog(
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
              getButton("Ok", Icons.thumb_up_alt_outlined, () {
                Navigator.pop(context);
              })
            ],
          );
        });
  }

  var inputDeco = InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: BorderSide(
        color: primaryLight,
        width: 2.0,
      ),
    ),
  );

  Future getMyFuture() async {
    String date = dateFormat.format(DateTime.now());
    await Provider.of<CartDataProvider>(context, listen: false).getFormattedProductsMap().then((value) async {
      // print(value);
      // print("Selected date in getMyFuture() : $_selectedDate");
      _myFuture = Provider.of<ShopDataProvider>(context, listen: false).getDeliveryDetails((_selectedDate == null) ? date : _selectedDate, value);
    });
    setState(() {});
  }
}
