import 'package:chef_choice/pages/productPage.dart';
import 'package:chef_choice/providers/shopDataProvider.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/productTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ProductCategoryPage extends StatelessWidget {
  static final String routeName = "/prodCategoryPage";

  final String category_id;
  final String title;
  ProductCategoryPage({this.category_id, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: TextStyle(color: primary2),
        ),
      ),
      body: FutureBuilder(
        future: Provider.of<ShopDataProvider>(context).getProductsByCategory(category_id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          else {
            if (snapshot.data[0].product_id == "error") {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "🙁\nCurrently no product is available of this category!\n Sorry for the inconvenience.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 18),
                  ),
                ),
              );
            } else {
              var products = snapshot.data;
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
                          {},
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ProductPage(products[index].product_id)),
                            );
                          },
                        );
                      }),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
