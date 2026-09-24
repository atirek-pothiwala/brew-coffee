import 'package:brew_coffee/core/theme/receipt_theme.dart';
import 'package:flutter/material.dart';

class ReceiptDivider extends StatelessWidget {
  const ReceiptDivider({super.key, this.dotted = false});

  final bool dotted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: CustomPaint(
        painter: _DashPainter(dotted: dotted),
        child: const SizedBox(height: 1, width: double.infinity),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  _DashPainter({required this.dotted});

  final bool dotted;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = ReceiptTheme.dash
      ..strokeWidth = 1;
    const dash = 4.0;
    const gap = 3.0;
    double x = 0;
    while (x < size.width) {
      if (dotted) {
        canvas.drawCircle(Offset(x, 0), 0.8, paint);
      } else {
        canvas.drawLine(Offset(x, 0), Offset(x + dash, 0), paint);
      }
      x += dash + gap;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
