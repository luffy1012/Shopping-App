import 'dart:ui';

import 'package:chef_choice/pages/paymentMethodPage.dart';
import 'package:chef_choice/pages/timeSlotPage.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class AddressPage extends StatefulWidget {
  static final String routeName = "/addressPage";

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  Future _myFuture;
  TextEditingController tec_addr, tec_landmark, tec_city, tec_state, tec_pin, tec_contactPerson, tec_contactNo;
  String str_addr, str_landmark, str_city, str_state, str_pin, str_contactPerson, str_contactno, str_cadd_id;

  bool isNewAddr = false;
  List<Map> addr = [];
  List<String> states = ['Maharashtra', 'goa'];
  String _selectedState;
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initSate
    loadStates();

    getMyFuture();
    super.initState();
    tec_addr = TextEditingController();
    tec_landmark = TextEditingController();
    tec_city = TextEditingController();
    tec_state = TextEditingController();
    tec_pin = TextEditingController();
    tec_contactPerson = TextEditingController();
    tec_contactNo = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    String errMsg = "";
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Select Delivery Address", style: TextStyle(color: primary2)),
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
                key: _key,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      TextFormField(
                        enabled: !isLoading,
                        controller: tec_addr,
                        keyboardType: TextInputType.streetAddress,
                        decoration: inputDeco.copyWith(labelText: "Address", hintText: "Enter your address", errorStyle: TextStyle(height: 0)),
                        onChanged: (value) {
                          setState(() {
                            if (str_addr == value)
                              isNewAddr = false;
                            else
                              isNewAddr = true;
                          });
                        },
                        maxLines: null,
                        validator: (value) {
                          if (value.isEmpty) {
                            errMsg += "‣ Address Field Cannot Be Empty\n";
                            return '';
                          } else
                            return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isLoading,
                        controller: tec_landmark,
                        keyboardType: TextInputType.streetAddress,
                        decoration: inputDeco.copyWith(labelText: "Landmark", hintText: "Enter the landmark", errorStyle: TextStyle(height: 0)),
                        onChanged: (value) {
                          setState(() {
                            if (str_landmark == value)
                              isNewAddr = false;
                            else
                              isNewAddr = true;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            errMsg += "‣ Landmark Field Cannot Be Empty\n";
                            return '';
                          } else
                            return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isLoading,
                        controller: tec_city,
                        decoration: inputDeco.copyWith(labelText: "City", hintText: "Enter your city", errorStyle: TextStyle(height: 0)),
                        keyboardType: TextInputType.streetAddress,
                        onChanged: (value) {
                          setState(() {
                            if (str_contactno == value)
                              isNewAddr = false;
                            else
                              isNewAddr = true;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            errMsg += "‣ City Field Cannot Be Empty\n";
                            return '';
                          } else
                            return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Listener(
                        onPointerDown: (_) => FocusScope.of(context).unfocus(),
                        child: DropdownButtonFormField<String>(
                          icon: Icon(Icons.arrow_drop_down_outlined, color: primary2),
                          decoration: inputDeco.copyWith(errorStyle: TextStyle(height: 0)),
                          validator: (value) {
                            if (value == null) {
                              errMsg += "‣ Please Select A State\n";
                              return '';
                            } else
                              return null;
                          },
                          isExpanded: true,
                          value: _selectedState,
                          hint: Text("Select State"),
                          onChanged: isLoading
                              ? null
                              : (value) {
                                  setState(() {
                                    if (str_state != value)
                                      isNewAddr = true;
                                    else
                                      isNewAddr = false;
                                    _selectedState = value;
                                  });
                                },
                          items: states
                              .map(
                                (e) => DropdownMenuItem(
                                  child: Text(e),
                                  value: e,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isLoading,
                        controller: tec_pin,
                        decoration: inputDeco.copyWith(
                            labelText: "Pincode", hintText: "Enter your pincode", counterText: "", errorStyle: TextStyle(height: 0)),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        onChanged: (value) {
                          setState(() {
                            if (str_pin == value)
                              isNewAddr = false;
                            else
                              isNewAddr = true;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            errMsg += "‣ Pincode Field Cannot Be Empty\n";
                            return '';
                          } else if (value.length < 6)
                            return '';
                          else
                            return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isLoading,
                        controller: tec_contactPerson,
                        decoration: inputDeco.copyWith(
                            labelText: "Contact Person(Optional)", hintText: "Enter Contact Person", errorStyle: TextStyle(height: 0)),
                        keyboardType: TextInputType.name,
                        onChanged: (value) {
                          setState(() {
                            if (str_contactPerson == value)
                              isNewAddr = false;
                            else
                              isNewAddr = true;
                          });
                        },
                        validator: (value) {
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        enabled: !isLoading,
                        controller: tec_contactNo,
                        decoration: inputDeco.copyWith(
                            labelText: "Contact Person Number(Optional)",
                            hintText: "Enter Contact Number",
                            counterText: "",
                            errorStyle: TextStyle(height: 0)),
                        keyboardType: TextInputType.phone,
                        maxLength: 10,
                        onChanged: (value) {
                          setState(() {
                            if (str_contactno == value)
                              isNewAddr = false;
                            else
                              isNewAddr = true;
                          });
                        },
                        validator: (value) {
                          if (value.isEmpty)
                            return null;
                          else if (value.length < 10)
                            return '';
                          else
                            return null;
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          getButton(isNewAddr ? "Save Address and Proceed" : "Proceed", Icons.arrow_forward_ios, () async {
                            if (_key.currentState.validate() && !isLoading) {
                              setState(() {
                                isLoading = true;
                              });
                              bool isDeliveryAvailable = await checkPincode(tec_pin.text);
                              if (isDeliveryAvailable) {
                                bool savedFlag = !isNewAddr;
                                if (isNewAddr) {
                                  //TODO:add address
                                  await Provider.of<ShopDataProvider>(context, listen: false)
                                      .addNewAddress(tec_addr.text, tec_landmark.text, tec_city.text, _selectedState, tec_pin.text,
                                          tec_contactPerson.text, tec_contactNo.text)
                                      .then(
                                    (value) async {
                                      if (value != null) {
                                        //print(value.runtimeType);
                                        str_cadd_id = value;
                                        //print("NEW ADDRESS : $str_cadd_id");
                                        savedFlag = true;
                                      } else {
                                        showMyDialog("Something wen wrong", "Address did not get add to the server!");
                                        isLoading = false;
                                      }
                                    },
                                  );
                                }
                                if (savedFlag) {
                                  await Provider.of<SharedPrefProvider>(context, listen: false)
                                      .storeDeliveryAddress(str_cadd_id, tec_addr.text, tec_landmark.text, tec_city.text, _selectedState,
                                          tec_pin.text, tec_contactPerson.text, tec_contactNo.text)
                                      .then((value) {
                                    if (value) {
                                      Navigator.pushNamed(context, PaymentMethodPage.routeName).whenComplete(getMyFuture);
                                    } else {
                                      showMyDialog("Something went wrong", "Address did not get stored in sharedprefrences!");
                                      isLoading = false;
                                    }
                                  });
                                }
                              } else {
                                isLoading = false;
                                showMyDialog("Please change the pincode", "Delivery not available at this pincode");
                              }
                              setState(() {});
                              //Navigator.pushNamed(context, PaymentMethodPage.routeName);
                            } else {
                              showAlertDialog("Please Input Details Correctly", errMsg);
                              errMsg = "";
                            }
                          }),
                        ],
                      ),
                      isLoading
                          ? Container(
                              height: 20,
                              child: Center(
                                child: LinearProgressIndicator(
                                  backgroundColor: primaryLight.withOpacity(0.4),
                                ),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _myFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else {
                  var data = snapshot.data;
                  addr.clear();
                  data.forEach((element) {
                    Map map = {
                      'cadd_id': element['cadd_id'],
                      'address': element['address'],
                      'landmark': element['landmark'],
                      'city': element['city'],
                      'state': element['state'],
                      'pincode': element['pincode'],
                      'contactperson': element['contactperson'],
                      'contactno': element['contactno']
                    };
                    addr.add(map);
                  });
//                  print(data);
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: addr.length,
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        setState(() {
                          str_cadd_id = addr[index]['cadd_id'];
                          print(str_cadd_id);
                          isNewAddr = false;
                          str_addr = addr[index]['address'];
                          str_landmark = addr[index]['landmark'];
                          str_city = addr[index]['city'];
                          str_state = addr[index]['state'];
                          str_pin = addr[index]['pincode'];
                          str_contactPerson = addr[index]['contactperson'];
                          str_contactno = addr[index]['contactno'];

                          tec_addr.text = str_addr;
                          tec_landmark.text = str_landmark;
                          tec_city.text = str_city;
                          _selectedState = str_state;
                          tec_pin.text = str_pin;
                          tec_contactPerson.text = str_contactPerson;
                          tec_contactNo.text = str_contactno;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: mainContainerBoxDecor,
                            width: width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Address : ${addr[index]['address']}",
                                ),
                                Text("Landmark : ${addr[index]['landmark']}"),
                                Text("City : ${addr[index]['city']}"),
                                Text("State : ${addr[index]['state']}"),
                                Text("Pincode : ${addr[index]['pincode']}"),
                                Text("Contact Person : ${addr[index]['contactperson']}"),
                                Text("Contact Person number : ${addr[index]['contactno']}"),
                              ],
                            ),
                          ),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete_outline,
                              onTap: () async {
                                //print(data[index]['cadd_id']);
                                await Provider.of<ShopDataProvider>(context, listen: false).deleteAddress(data[index]['cadd_id']).then((value) {
                                  if (value) {
                                    getMyFuture();
                                    setState(() {});
                                  } else {
                                    showMyDialog("Sommething went wrong!", "Address not deleted");
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getMyFuture() async {
    isLoading = false;
    _myFuture = Provider.of<ShopDataProvider>(context, listen: false).getAddressList();
    setState(() {});
  }

  Future<void> loadStates() async {
    List<String> data = await Provider.of<ShopDataProvider>(context, listen: false).getStatesList();
    setState(() {
      states = List<String>.from(data);
    });
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

  void showAlertDialog(String title, String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.left,
            ),
            content: Text(
              content,
              textAlign: TextAlign.left,
            ),
            actions: [
              getButton("Ok", Icons.warning_amber_rounded, () {
                Navigator.pop(context);
              })
            ],
          );
        });
  }

  Future<bool> checkPincode(String pincode) async {
    var data = await Provider.of<ShopDataProvider>(context, listen: false).checkPincode(pincode);
    return data;
  }
}
