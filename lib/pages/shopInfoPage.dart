import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ShopInfoPage extends StatefulWidget {
  @override
  _ShopInfoPageState createState() => _ShopInfoPageState();
}

class _ShopInfoPageState extends State<ShopInfoPage> {
  TextStyle _textStyle1 = TextStyle(fontSize: 16, color: primaryDark, fontWeight: FontWeight.w400);
  TextStyle _textStyle2 = TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
  String shopName = "Shop";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About $shopName",
          style: TextStyle(color: primary2),
        ),
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: Provider.of<SharedPrefProvider>(context).getShopData(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting)
            return Center(
              child: CircularProgressIndicator(),
            );
          else if (snapshot.hasError)
            return Container(
              child: Text("Something went wrong", textAlign: TextAlign.center),
            );
          else {
            ShopGeneralData data = snapshot.data;
            print(data.landmark.isEmpty);
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: mainContainerBoxDecor,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((data.add1 != null && data.add1.isNotEmpty) || (data.add2 != null && data.add2.isNotEmpty))
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Address : ",
                                      style: _textStyle1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${data.add1 ?? ""} \n${data.add2 ?? ""}",
                                      style: _textStyle2,
                                    ),
                                  )
                                ],
                              ),
                              Divider(color: primary2),
                            ],
                          ),
                        if (data.landmark != null && data.landmark.isNotEmpty)
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Landmark : ",
                                      style: _textStyle1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      data.landmark ?? "",
                                      style: _textStyle2,
                                    ),
                                  )
                                ],
                              ),
                              Divider(color: primary2),
                            ],
                          ),
                        if ((data.city != null && data.city.isNotEmpty) || (data.pincode != null && data.pincode.isNotEmpty))
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "City : ",
                                      style: _textStyle1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Text(
                                      "${data.city ?? ''} ${data.pincode ?? ''}",
                                      style: _textStyle2,
                                    ),
                                  )
                                ],
                              ),
                              Divider(color: primary2),
                            ],
                          ),
                        if (data.supportMobile != null && data.supportMobile.isNotEmpty)
                          Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      "Mobile Support : ",
                                      style: _textStyle1,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: GestureDetector(
                                      onTap: () {
                                        if (data.supportMobile != null && data.supportMobile.isNotEmpty) {
                                          List<String> s = data.supportMobile.split(" ");
                                          _launchWhatsapp(s[1]);
                                        }
                                      },
                                      child: Text(
                                        data.supportMobile ?? "",
                                        style: _textStyle2.copyWith(color: Colors.lightBlue),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Divider(color: primary2),
                            ],
                          ),
                        if (data.supportEmail != null && data.supportEmail.isNotEmpty)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "Email Support : ",
                                  style: _textStyle1,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: GestureDetector(
                                  onTap: () {
                                    if (data.supportEmail != null && data.supportEmail.isNotEmpty) _launchGmail(data.supportEmail);
                                  },
                                  child: Text(
                                    data.supportEmail ?? "",
                                    style: _textStyle2.copyWith(color: Colors.lightBlue),
                                  ),
                                ),
                              )
                            ],
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: mainContainerBoxDecor,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("WhatsApp Support", style: _textStyle1),
                            Container(
                                width: 150,
                                child: getButton(
                                  "Chat with us",
                                  Icons.message_outlined,
                                  () {
                                    if (data.supportMobile != null && data.supportMobile.isNotEmpty) {
                                      List<String> s = data.supportMobile.split(" ");
                                      _launchWhatsapp(s[1]);
                                    }
                                  },
                                )),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Email Support", style: _textStyle1),
                            Container(
                              width: 150,
                              child: getButton(
                                "Email us",
                                Icons.alternate_email_outlined,
                                () {
                                  if (data.supportEmail != null && data.supportEmail.isNotEmpty) _launchGmail(data.supportEmail);
                                },
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _launchWhatsapp(String number) async {
    SnackBar snackBar = SnackBar(content: Text("Something went wrong!"));
    var whatsappUrl = "whatsapp://send?phone=91$number";
    await canLaunch(whatsappUrl) ? await launch(whatsappUrl) : ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _launchGmail(String mail) async {
    // Android and iOS
    SnackBar snackBar = SnackBar(content: Text("Something went wrong!"));
    var sub = "Require Aloo kanda support [sent from mobile]";
    var url = 'mailto:$mail?subject=$sub';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
/*Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                "Open Hours : ",
                                style: _textStyle1,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                data.opHours ?? "",
                                style: _textStyle2,
                              ),
                            )
                          ],
                        ),*/
