import 'package:flutter/material.dart';
import 'package:myapp/painter.dart';
import 'package:myapp/path_color_pair.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
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
              paths.add(PathColorPair([details.localPosition]));
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