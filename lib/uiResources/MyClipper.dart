import 'package:flutter/material.dart';

class MyClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final firstControlPoint = Offset(size.width / 4, size.height / 2 + 20);
    final firstEndPoint = Offset(size.width / 2, size.height / 2 - 30);

    final secControlPoint = Offset((size.width * 3) / 4, size.height / 2 - 70);
    final secEndPoint = Offset(size.width, size.height / 2 - 40);

    var path = Path();
    path.lineTo(0, size.height / 2 - 20);

    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(
        secControlPoint.dx, secControlPoint.dy, secEndPoint.dx, secEndPoint.dy);

    path.lineTo(size.width, size.height / 2 - 40);
    path.lineTo(size.width, 0);
    return path;
    throw UnimplementedError();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    // TODO: implement shouldReclip
    return true;
  }
}
