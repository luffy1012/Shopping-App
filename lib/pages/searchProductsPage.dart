import 'package:chef_choice/pages/productPage.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/productTile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchProductPage extends StatelessWidget {
  final String searchedTerm;

  SearchProductPage({@required this.searchedTerm});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
        title: Text(
          "Searched Product : $searchedTerm",
          style: TextStyle(color: primary2),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<ShopDataProvider>(context).getProductsBySearch(searchedTerm),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.data[0].product_id == "error") {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "🙁\nNo such product available!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ),
              );
            } else {
              List products = snapshot.data;
              if (products.length > 0)
                return Container(
                  child: GridView.builder(
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.75),
                    itemBuilder: (context, index) {
                      return ProductTile(
                        products[index],
                        {},
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(products[index].product_id),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              else {
                return Container(
                  decoration: mainContainerBoxDecor,
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Icon(
                          Icons.warning_amber_outlined,
                          size: 40,
                        ),
                        Text(
                          "Oops!!!🙁"
                          "\nwe cannot find product named $searchedTerm.",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }
          }
        },
      ),
    );
  }
}
