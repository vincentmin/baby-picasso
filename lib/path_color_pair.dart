import 'package:flutter/material.dart';
import 'package:myapp/utils.dart';

class PathColorPair {
  List<Offset> points;
  Color color = getRandomColor();

  PathColorPair(this.points);

  Path smoothPath() {
    Path path = Path();
    if (points.length < 3) {
      // Not enough points to smooth, draw a simple line or nothing
      if (points.length == 2) {
        path.moveTo(points[0].dx, points[0].dy);
        path.lineTo(points[1].dx, points[1].dy);
      }
      return path;
    }

    // Move to the first point
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 1; i < points.length - 1; i++) {
      // Calculate the midpoint and draw a curve to it
      final currentPoint = points[i];
      final nextPoint = points[i + 1];
      final midpoint = Offset(
        (currentPoint.dx + nextPoint.dx) / 2.0,
        (currentPoint.dy + nextPoint.dy) / 2.0,
      );

      path.quadraticBezierTo(
        currentPoint.dx,
        currentPoint.dy,
        midpoint.dx,
        midpoint.dy,
      );
    }

    // Draw a line to the last point
    path.lineTo(points.last.dx, points.last.dy);

    return path;
  }
}
