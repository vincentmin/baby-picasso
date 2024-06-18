import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  List<PathColorPair> paths = [];
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isAnimating = false;
  double _radius = 0.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1000.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _radius = _animation.value;
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _isAnimating = false;
            paths.clear(); // Clear paths when animation completes
          });
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    setState(() {
      _isAnimating = true;
    });
    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    return MaterialApp(
      home: Scaffold(
        body: GestureDetector(
            onPanStart: (details) {
              if (!_isAnimating) {
                setState(() {
                  paths.add(PathColorPair([details.localPosition]));
                });
              }
            },
            onPanUpdate: (details) {
              if (!_isAnimating) {
                setState(() {
                  paths.last.points.add(details.localPosition);
                });
              }
            },
            child: ClipPath(
              clipper: _isAnimating ? CircleRevealClipper(_radius) : null,
              child: CustomPaint(
                painter: DrawingPainter(paths),
                child: Container(),
              ),
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: _startAnimation,
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

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
