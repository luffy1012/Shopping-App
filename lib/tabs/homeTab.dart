import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chef_choice/handlers/locationHandler.dart';
import 'package:chef_choice/pages/bannerProductsList.dart';
import 'package:chef_choice/pages/productCategoryPage.dart';
import 'package:chef_choice/pages/productPage.dart';
import 'package:chef_choice/providers/cartDataProvider.dart';
import 'package:chef_choice/providers/sharedPrefProvider.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/WebViewCotainer.dart';
import 'package:chef_choice/uiResources/categoryTile.dart';
import 'package:chef_choice/uiResources/productTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class HomeTab extends StatefulWidget {
  HomeTab();

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final _formKey = GlobalKey<FormState>();

  Future _futureData;
  List categories;

  int _selectedPincode;
  String pincodeMessage = "";
  bool _isPincodeLoading = false; //show progress bar when pincode is loading
  bool pincodeFlag = false; //this flag is specifically for pincode message

  TextEditingController tec_pincode;
  @override
  void initState() {
    // TODO: implement initState
    _futureData = getShopDetails();
    super.initState();
    tec_pincode = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          /*getButton("TESTING", Icons.adb_outlined, () async {
            await Provider.of<ShopDataProvider>(context, listen: false).getOrderList();
            */ /*await Provider.of<CartDataProvider>(context, listen: false).getFormattedProductsMap();
               await Provider.of<CartDataProvider>(context, listen: false).getFormattedProductsMap().then((value) async {
              // print(value);
              await Provider.of<ShopDataProvider>(context, listen: false).getSchedule("2021-04-27", value);
            });*/ /*
          }),*/
          pincodeTile(context),
          bannerCarousel(context, width, height),
          categoryContainer(context),
          recommendedContainer(context),
        ],
      ),
    );
  }

  Widget bannerCarousel(BuildContext context, double width, double height) {
    return FutureBuilder(
      future: _futureData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
          return Container(
            width: MediaQuery.of(context).size.width,
            height: height / 6,
            color: Colors.white,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Container(
            width: MediaQuery.of(context).size.width,
            child: Text(
              "Something went wrong!!",
              textAlign: TextAlign.center,
            ),
          );
        } else {
          List<MyBanner> banners = snapshot.data['banners'];
          //print(banners);

          return (banners.length != 0)
              ? Container(
                  child: CarouselSlider.builder(
                    itemCount: banners.length,
                    itemBuilder: (BuildContext context, int index, int index2) {
                      return GestureDetector(
                        onTap: () {
                          if (banners[index].ban_type == "external") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WebViewContainer(banners[index].ban_title, banners[index].ban_link),
                              ),
                            );
                          } else if (banners[index].ban_type == "category" || banners[index].ban_type == "product") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BannerProductsList(banners[index].ban_title, banners[index].ban_type, banners[index].ban_details),
                              ),
                            ).then((value) => setState(() {}));
                            ;
                          }
                        },
                        child: Card(
                          elevation: 2,
                          child: Container(
                            child: CachedNetworkImage(imageUrl: banners[index].ban_img),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                        aspectRatio: width / (height / 6),
                        autoPlay: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 700),
                        autoPlayCurve: Curves.easeInOutSine,
                        viewportFraction: 1),
                  ),
                )
              : Container();
        }
      },
    );
  }

  Widget pincodeTile(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        color: Colors.white,
        child: ExpansionTile(
          onExpansionChanged: (value) {
            setState(() {
              pincodeMessage = "";
            });
          },
          leading: Icon(
            Icons.add_location_alt_outlined,
            color: primary2,
          ),
          title: Container(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              (_selectedPincode == null) ? "Pincode" : "$_selectedPincode",
              style: TextStyle(color: primary2),
            ),
          ),
          children: [
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(15, 8, 15, 8),
                child: Column(
                  children: [
                    //first row with textfield and button
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            maxLength: 6,
                            controller: tec_pincode,
                            keyboardType: TextInputType.number,
                            decoration: textfield1Deco.copyWith(counterText: "", hintText: "Enter your Pincode", labelText: "Enter your Pincode"),
                            validator: (value) {
                              if (value.isEmpty) {
                                return "Please enter your pincode";
                              } else
                                return null;
                            },
                          ),
                        ),
                        SizedBox(width: 10),
                        Container(
                          child: getButton("Go", Icons.location_on_outlined, () async {
                            FocusScope.of(context).unfocus();
                            final isValid = _formKey.currentState.validate();
                            if (!isValid) {
                              return;
                            }
                            setState(() {
                              _isPincodeLoading = true;
                            });
                            final pincodeAvailable = await Provider.of<ShopDataProvider>(context, listen: false).checkPincode(tec_pincode.text);
                            setState(() {
                              pincodeFlag = pincodeAvailable;
                              pincodeMessage =
                                  pincodeAvailable ? "Delivery Available At ${tec_pincode.text}" : "Delivery Not Available At ${tec_pincode.text}";
                              _selectedPincode = pincodeAvailable ? int.parse(tec_pincode.text) : null;
                              _isPincodeLoading = false;
                            });
                            _formKey.currentState.save();
                          }),
                        )
                      ],
                    ),
                    //divider
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              thickness: 1,
                              color: primary2,
                            ),
                          ),
                        ),
                        Text("OR"),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Divider(
                              thickness: 1,
                              color: primary2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    //hidden circularProgressIndicator
                    Container(
                      child: _isPincodeLoading
                          ? Container(
                              width: 25,
                              height: 25,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: primary2,
                              ))
                          : Container(),
                    ),
                    //current location button
                    Container(
                      child: getButton("Check availability at current Location", Icons.location_searching_outlined, () async {
                        FocusScope.of(context).unfocus();
                        tec_pincode.clear();
                        setState(() {
                          _isPincodeLoading = true;
                        });
                        String pin = await LocationHandler().getPincode().then((value) async {
                          final pincodeAvailable = await Provider.of<ShopDataProvider>(context, listen: false).checkPincode(value);
                          setState(() {
                            _isPincodeLoading = false;
                          });
                          if (int.tryParse(value) != null) {
                            if (pincodeAvailable) {
                              pincodeMessage = "Delivery Available At $value";
                              pincodeFlag = true;
                              _selectedPincode = int.parse(value);
                            } else {
                              pincodeMessage = "Delivery Not Available At $value";
                              pincodeFlag = false;
                              _selectedPincode = null;
                            }
                            setState(() {});
                            return value;
                          } else {
                            pincodeMessage = "Please enable GPS!";
                            pincodeFlag = false;
                          }
                        }).catchError((e) {
                          setState(() {
                            pincodeMessage = e.toString();
                          });
                        });
                      }),
                    ),
                    SizedBox(height: 10),
                    //pincode status
                    Text(
                      pincodeMessage,
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: pincodeFlag ? Colors.green : Colors.red),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: mainContainerBoxDecor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Shop by Category",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, letterSpacing: 1.5),
              ),
            ),
            FutureBuilder(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    color: Colors.white,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      "Something went wrong!!",
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  if (snapshot.data['categories'][0].id == "error") {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "🙁\nSomething went wrong! Please check your internet connection!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                      ),
                    );
                  } else {
                    categories = snapshot.data['categories'];
                    //print(categories);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemCount: categories.length,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, childAspectRatio: 1, crossAxisSpacing: 1, mainAxisSpacing: 1),
                          itemBuilder: (BuildContext context, int index) {
                            return CategoryTile(categories[index].cat_img, categories[index].name, () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductCategoryPage(
                                          category_id: categories[index].c_uid,
                                          title: categories[index].name,
                                        )),
                              ).then((value) => setState(() {}));
                            });
                          }),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget recommendedContainer(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Container(
        decoration: mainContainerBoxDecor,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Featured Products",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w400, letterSpacing: 1.5),
            ),
            FutureBuilder(
              future: _futureData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                else {
                  if (snapshot.data['featuredProducts'][0].product_id == "error") {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "🙁\nNo featured product is available at the moment!",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                        ),
                      ),
                    );
                  } else {
                    var products = snapshot.data['featuredProducts'];

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GridView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: products.length,
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
                            itemBuilder: (BuildContext context, int index) {
                              return ProductTile(
                                products[index],
                                callProductCount,
                                () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ProductPage(products[index].product_title, products[index].product_id)),
                                  ).then((value) => setState(() {}));
                                },
                              );
                            }),
                      ),
                    );
                  }
                }
              },
            ),
            /*GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
                itemBuilder: (BuildContext context, int index) {
                  return ProductTile(products[index], () {
                    //print(products[index].runtimeType);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductPage(
                          product: products[index],
                        ),
                      ),
                    );
                  });
                })*/
          ],
        ),
      ),
    );
  }

  Future getShopDetails() async {
    var data = Provider.of<ShopDataProvider>(context, listen: false).getShopDetails();
    return data;
  }

  callProductCount() {
    print("callback ");
  }
}
