import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:flutter/material.dart';

class ReceiptZigzagBottom extends StatelessWidget {
  const ReceiptZigzagBottom({super.key, this.height = 12});

  final double height;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ZigzagClipper(height: height),
      child: Container(
        height: height,
        color: ReceiptTheme.pageBackground,
      ),
    );
  }
}

class _ZigzagClipper extends CustomClipper<Path> {
  _ZigzagClipper({required this.height});

  final double height;

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, 0);
    const tooth = 8.0;
    var x = 0.0;
    var down = true;
    while (x < size.width) {
      path.lineTo(x, down ? height : 0);
      x += tooth;
      down = !down;
    }
    path.lineTo(size.width, 0);
    path.lineTo(size.width, height);
    path.lineTo(0, height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
