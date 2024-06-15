import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class PathColorPair {
  List<Offset> points;
  Color color;

  PathColorPair(this.points, this.color);

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

Color getRandomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
}

class _MyAppState extends State<MyApp> {
  Color color = Colors.black;
  List<PathColorPair> paths = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: GestureDetector(
            onPanStart: (details) => setState(() {
              color = getRandomColor();
              paths.add(PathColorPair([details.localPosition], color));
            }),
            onPanUpdate: (details) => setState(() {
              paths.last.points.add(details.localPosition);
            }),
            child: CustomPaint(
              painter: DrawingPainter(paths),
              child: Container(),
            ),
          ),
        )
      )
    );
  }

}

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
      // Path drawingPath = Path();
      // if (path.points.isNotEmpty) {
      //   drawingPath.moveTo(path.path.first.dx, path.path.first.dy);
      //   for (var point in path.path.skip(1)) {
      //     drawingPath.lineTo(point.dx, point.dy);
      //   }
      // }
      canvas.drawPath(path.smoothPath(), paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}