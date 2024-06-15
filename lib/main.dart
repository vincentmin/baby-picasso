import 'package:flutter/material.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Color selectedColor = Colors.black;
  List<List<Offset>> paths = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: GestureDetector(
            onPanStart: (details) => setState(() {
              paths.add(<Offset>[details.localPosition]);
            }),
            onPanUpdate: (details) => setState(() {
              paths.last.add(details.localPosition);
            }),
            // onPanEnd: (details) => setState(() {
            //   paths.add(<Offset>[]);
            // }),
            child: CustomPaint(
              painter: DrawingPainter(paths, selectedColor),
              child: Container(),
            ),
          ),
        )
      )
    );
  }

}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> paths;
  final Color color;

  DrawingPainter(this.paths, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = 25.0
      ..style = PaintingStyle.stroke; // Use stroke style for drawing lines

    for (var path in paths) {
      Path drawingPath = Path();
      if (path.isNotEmpty) {
        drawingPath.moveTo(path.first.dx, path.first.dy);
        for (var point in path.skip(1)) {
          drawingPath.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(drawingPath, paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}