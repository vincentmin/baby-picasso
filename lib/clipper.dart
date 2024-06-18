import 'package:flutter/material.dart';

class CircleRevealClipper extends CustomClipper<Path> {
  final double radius;
  final Offset center;
  CircleRevealClipper(this.radius, this.center);

  @override
  Path getClip(Size size) {
    Path outerPath = Path()..addOval(Rect.largest);

    Path innerPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));

    final invertedPath =
        Path.combine(PathOperation.intersect, outerPath, innerPath);
    return Path.combine(PathOperation.difference, outerPath, invertedPath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
