import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  void _setColor(Color color) {
    setState(() {
      selectedColor = color;
    });
  }

  void _clearPaths() {
    setState(() {
      paths.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Drawing App'),
            actions: [
              // IconButton(
              //   icon: const Icon(Icons.color_lens),
              //   onPressed: () => _showColorPicker(context),
              // ),
              IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clearPaths,
              ),
            ],
          ),
          body: GestureDetector(
            onPanUpdate: (details) => setState(() {
              if (paths.isNotEmpty) {
                paths.last.add(details.globalPosition);
              } else {
                paths.add([details.globalPosition]); // Start a new path if there are none
              }
            }),
            child: CustomPaint(
              painter: DrawingPainter(paths, selectedColor),
            ),
          ),
        )
      )
    );
  }

  
  // void _showColorPicker(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Pick a color'),
  //         content: SingleChildScrollView(
  //           child: ColorPicker(
  //             pickerColor: selectedColor,
  //             onColorChanged: _setColor,
  //           ),
  //         ),
  //         actions: <Widget>[
  //           ElevatedButton(
  //             child: const Text('Got it'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

}

class DrawingPainter extends CustomPainter {
  final List<List<Offset>> paths;
  final Color color;

  DrawingPainter(this.paths, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    for (var path in paths) {
      Paint paint = Paint()..color = color..strokeWidth = 25;
      canvas.drawPath(Path()..addPolygon(path, true), paint);
    }
  }

  @override
  bool shouldRepaint(DrawingPainter oldDelegate) => true;
}