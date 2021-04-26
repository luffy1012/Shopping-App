import 'dart:ui';

import 'package:chef_choice/pages/addressPage.dart';
import 'package:chef_choice/pages/homePage.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

class TimeSlotPage extends StatefulWidget {
  static final String routeName = "/timeSlotPage";

  @override
  _TimeSlotPageState createState() => _TimeSlotPageState();
}

class _TimeSlotPageState extends State<TimeSlotPage> {
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

  DateFormat dateFormat = DateFormat('d - MMMM - y');
  int _selectedSlot = 0;
  int _selectedDate = 0;
  List dates = List();
  List time = [
    "09:00 AM - 12:00 PM",
    "12:00 PM - 04:00 PM",
    "04:00 PM - 09:00 PM"
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dates.add(dateFormat.format(DateTime.now().add(Duration(days: 1))));
    dates.add(dateFormat.format(DateTime.now().add(Duration(days: 2))));
    dates.add(dateFormat.format(DateTime.now().add(Duration(days: 3))));
    dates.add(dateFormat.format(DateTime.now().add(Duration(days: 4))));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
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
                    "Select Delivery Date : ",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    itemCount: dates.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 2.5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedDate = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: Container(
                            decoration: mainContainerBoxDecor.copyWith(
                                color: (index != _selectedDate)
                                    ? Colors.white
                                    : primaryLight),
                            child: Center(
                                child: Text(
                              dates[index],
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
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5),
                  ),
                  SizedBox(height: 10),
                  GridView.builder(
                    itemCount: time.length,
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 2.5),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedSlot = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: Container(
                            decoration: mainContainerBoxDecor.copyWith(
                                color: (index != _selectedSlot)
                                    ? Colors.white
                                    : primaryLight),
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
                      getButton("Proceed", Icons.arrow_forward_ios, () {
                        Navigator.pushNamed(context, AddressPage.routeName);
                      }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
