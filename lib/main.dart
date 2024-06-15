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
  Offset path;
  Color color;

  PathColorPair(this.path, this.color);
}

Color getRandomColor() {
  return Color((math.Random().nextDouble() * 0xFFFFFF).toInt() << 0).withOpacity(1.0);
}

class _MyAppState extends State<MyApp> {
  Color color = Colors.black;
  List<List<PathColorPair>> paths = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: GestureDetector(
            onPanStart: (details) => setState(() {
              color = getRandomColor();
              paths.add([PathColorPair(details.localPosition, color)]);
            }),
            onPanUpdate: (details) => setState(() {
              paths.last.add(PathColorPair(details.localPosition, color));
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
  final List<List<PathColorPair>> paths;

  DrawingPainter(this.paths);

  @override
  void paint(Canvas canvas, Size size) {

    for (var path in paths) {
      Paint paint = Paint()
        ..color = path.first.color
        ..strokeWidth = 25.0
        ..style = PaintingStyle.stroke; // Use stroke style for drawing lines
      Path drawingPath = Path();
      if (path.isNotEmpty) {
        drawingPath.moveTo(path.first.path.dx, path.first.path.dy);
        for (var point in path.skip(1)) {
          drawingPath.lineTo(point.path.dx, point.path.dy);
        }
      }
      canvas.drawPath(drawingPath, paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}