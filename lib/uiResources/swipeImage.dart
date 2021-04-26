import 'package:cached_network_image/cached_network_image.dart';
import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SwipeImage extends StatefulWidget {
  final List imgList;
  SwipeImage(this.imgList);

  @override
  _SwipeImageState createState() => _SwipeImageState();
}

class _SwipeImageState extends State<SwipeImage> {
  int selectedPage = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                selectedPage = index;
              });
            },
            children: [
              for (var i = 0; i < widget.imgList.length; i++)
                Container(
                  child: InteractiveViewer(
                      child: CachedNetworkImage(
                    imageUrl: widget.imgList[i],
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                          value: downloadProgress.progress),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  )),
                ),
            ],
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.imgList.length; i++)
                  AnimatedContainer(
                    duration: Duration(milliseconds: 350),
                    margin: EdgeInsets.symmetric(horizontal: 2),
                    height: 7,
                    width: (selectedPage == i) ? 25 : 7,
                    curve: Curves.easeOutSine,
                    decoration: BoxDecoration(
                      color: (selectedPage == i)
                          ? primary2
                          : primary2.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
