import 'dart:ui';

import 'package:chef_choice/uiConstants.dart';
import 'package:flutter/material.dart';
import 'package:chef_choice/uiConstants.dart';

const Color PRIMARY_COLOR = Color.fromRGBO(206, 100, 142, 1);
const Color BACKGROUND_COLOR = Color.fromRGBO(206, 100, 142, 1);

class CustomBottomNavigationBar extends StatefulWidget {
  final Color backgroundColor;
  final Color itemColor;
  final List<CustomBottomNavigationItem> children;
  final Function(int) onChange;
  final int currentIndex;

  CustomBottomNavigationBar(
      {this.backgroundColor = BACKGROUND_COLOR,
      this.itemColor = PRIMARY_COLOR,
      this.currentIndex = 0,
      @required this.children,
      this.onChange});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  void _changeIndex(int index) {
    if (widget.onChange != null) {
      widget.onChange(index);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: primary2.withOpacity(0.35),
            spreadRadius: 1.5,
            blurRadius: 2,
//            offset: Offset(0, -1),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: widget.children.map((item) {
          var color = item.color ?? widget.itemColor;
          var icon = item.icon;
          var label = item.label;
          int index = widget.children.indexOf(item);
          return GestureDetector(
            onTap: () {
              _changeIndex(index);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              width: widget.currentIndex == index
                  ? MediaQuery.of(context).size.width * (3 / 8)
                  : MediaQuery.of(context).size.width * (2 / 8),
              padding: EdgeInsets.only(left: 10, right: 10),
              margin: EdgeInsets.only(top: 5, bottom: 5),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: widget.currentIndex == index
                      ? color.withOpacity(0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: widget.currentIndex == index
                        ? EdgeInsets.only(left: 10.0)
                        : EdgeInsets.only(left: 0.0),
                    child: Icon(
                      icon,
                      size: 20,
                      color: widget.currentIndex == index
                          ? color
                          : color.withOpacity(0.5),
                    ),
                  ),
                  widget.currentIndex == index
                      ? Expanded(
                          flex: 2,
                          child: Text(
                            label ?? '',
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: widget.currentIndex == index
                                    ? color
                                    : color.withOpacity(0.5),
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class CustomBottomNavigationItem {
  final IconData icon;
  final String label;
  final Color color;

  CustomBottomNavigationItem(
      {@required this.icon, @required this.label, this.color});
}
