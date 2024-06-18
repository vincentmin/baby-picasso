import 'package:flutter/material.dart';

class CircleRevealClipper extends CustomClipper<Path> {
  final double radius;
  CircleRevealClipper(this.radius);

  @override
  Path getClip(Size size) {
    Path outerPath = Path()..addOval(Rect.largest);

    Path innerPath = Path()
      ..addOval(Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: radius,
      ));

    var invertedPath =
        Path.combine(PathOperation.intersect, outerPath, innerPath);
    return Path.combine(PathOperation.difference, outerPath, invertedPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
