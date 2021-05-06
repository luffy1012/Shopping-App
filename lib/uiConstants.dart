import 'package:flutter/material.dart';

var inputDeco = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: primaryDark,
      width: 2.0,
    ),
  ),
);
var textfield1Deco = InputDecoration(
  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10.0),
    borderSide: BorderSide(
      color: primary2,
      width: 2.0,
    ),
  ),
);

var dropDownDecor = BoxDecoration(
  border: Border.all(
    color: primary2,
    width: 2.0,
  ),
  borderRadius: BorderRadius.circular(10.0),
);

var mainContainerBoxDecor = BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
  BoxShadow(
    blurRadius: 4,
    color: Colors.grey.withOpacity(0.5),
    offset: Offset(2, 2),
  )
]);

var textStyle1 = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);

Widget getButton(String label, IconData icon, Function onTap) {
  return FlatButton.icon(
    splashColor: primary2,
    highlightColor: primaryLight.withOpacity(0.2),
    color: Colors.white,
    minWidth: 120,
    onPressed: onTap,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(color: primary2),
    ),
    icon: Icon(
      icon,
      color: primary2,
    ),
    label: Text(
      label,
      style: textStyle1,
    ),
  );
}

/*
Color color1 = Color.fromRGBO(0, 0, 0, 1);
Color primary = Color.fromRGBO(33, 150, 243, 1);
Color primary1 = Color.fromRGBO(22, 255, 245, 0.60);
Color primaryLight = Color.fromRGBO(194, 228, 255, 1);
Color primaryDark = Color.fromRGBO(141, 161, 159, 1);

*/
/*
Color primary2 = Color.fromRGBO(206, 100, 142, 1); //most used color, Used as primary color
Color primaryLight = Color.fromRGBO(255, 168, 203, 1); //Used as primaryAccent color
Color primaryDark = Color.fromRGBO(82, 0, 33, 1);*/

Color primary2 = Color.fromRGBO(37, 179, 130, 1); //most used color, Used as primary color
Color primaryLight = Color.fromRGBO(41, 187, 137, 1); //Used as primaryAccent color

Color primaryDark = Color.fromRGBO(30, 111, 92, 1);
