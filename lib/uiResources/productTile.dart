import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final String imgPath, label;
  final double price;
  final Function onTap;

  ProductTile(this.imgPath, this.label, this.price, this.onTap);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: mainContainerBoxDecor,
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 3 / 2.5,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.2), width: 2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Image.asset(imgPath),
                  ),
                ),
              ),
              AspectRatio(
                aspectRatio: 3 / 0.5,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "₹ $price",
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
