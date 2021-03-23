import 'dart:ui';

import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  static final String routeName = "/addressPage";

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
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

  TextEditingController tec_name, tec_flat, tec_local, tec_city, tec_pin;

  List addr = [
    {
      'name': 'Pritam Parab',
      'flat_building': 'D-101, Millennium CHS',
      'local_addr': 'Devipada, Borivali East',
      'city': 'Mumbai',
      'pincode': '4000066'
    },
    {
      'name': 'Sarvesh Parab',
      'flat_building': 'f-1201, ABC tower',
      'local_addr': 'Thakur complex, Kandivali East',
      'city': 'Mumbai',
      'pincode': '4000101'
    },
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tec_name = TextEditingController();
    tec_flat = TextEditingController();
    tec_local = TextEditingController();
    tec_city = TextEditingController();
    tec_pin = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: mainContainerBoxDecor,
              child: Form(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: tec_name,
                        decoration: inputDeco.copyWith(
                            labelText: "Name", hintText: "Enter your name"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: tec_flat,
                        decoration: inputDeco.copyWith(
                            labelText: "Flat No., Building Name",
                            hintText: "Flat No. and building name"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: tec_local,
                        decoration: inputDeco.copyWith(
                            labelText: "Local Address",
                            hintText: "Enter your local address"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: tec_city,
                        decoration: inputDeco.copyWith(
                            labelText: "City", hintText: "Enter your city"),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        controller: tec_pin,
                        decoration: inputDeco.copyWith(
                            labelText: "Pincode",
                            hintText: "Enter your pincode"),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getButton("Proceed", Icons.arrow_forward_ios, () {}),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: addr.length,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          setState(() {
                            tec_name.text = addr[index]['name'];
                            tec_flat.text = addr[index]['flat_building'];
                            tec_local.text = addr[index]['local_addr'];
                            tec_city.text = addr[index]['city'];
                            tec_pin.text = addr[index]['pincode'];
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 8),
                          child: Container(
                            decoration: mainContainerBoxDecor,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    addr[index]['name'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(addr[index]['flat_building']),
                                  Text(addr[index]['local_addr']),
                                  Text(addr[index]['city']),
                                  Text(addr[index]['pincode']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))),
        ],
      ),
    );
  }
}
