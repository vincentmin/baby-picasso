import 'package:flutter/material.dart';
import 'package:myapp/path_color_pair.dart';

class DrawingPainter extends CustomPainter {
  final List<PathColorPair> paths;

  DrawingPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {

    for (var path in paths) {
      Paint paint = Paint()
        ..color = path.color.withOpacity(0.5)
        ..strokeWidth = 25.0
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;
      canvas.drawPath(path.smoothPath(), paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}