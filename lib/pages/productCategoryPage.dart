import 'package:chef_choice/pages/productPage.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:chef_choice/uiResources/productTile.dart';
import 'package:flutter/material.dart';

class ProductCategoryPage extends StatelessWidget {
  static final String routeName = "/prodCategoryPage";

  String category;
  List products;
  ProductCategoryPage({this.products, this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: primary2),
        backgroundColor: Colors.white,
        title: Text(
          category,
          style: TextStyle(color: primary2),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 1),
                itemBuilder: (BuildContext context, int index) {
                  return ProductTile(products[index]['img'],
                      products[index]['title'], products[index]['price'], () {
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
                }),
          ),
        ),
      ),
    );
  }
}
