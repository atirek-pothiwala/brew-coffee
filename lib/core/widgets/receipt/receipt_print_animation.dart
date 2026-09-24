import 'package:flutter/material.dart';

class ReceiptPrintAnimation extends StatefulWidget {
  const ReceiptPrintAnimation({
    super.key,
    required this.receipt,
    this.duration = const Duration(milliseconds: 2800),
  });

  final Widget receipt;
  final Duration duration;

  @override
  State<ReceiptPrintAnimation> createState() => _ReceiptPrintAnimationState();
}

class _ReceiptPrintAnimationState extends State<ReceiptPrintAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final GlobalKey _contentKey = GlobalKey();
  double _contentHeight = 320;

  @override
  void initState() {
    super.initState();
    final reduceMotion = WidgetsBinding.instance.platformDispatcher.accessibilityFeatures
        .disableAnimations;
    _controller = AnimationController(
      vsync: this,
      duration: reduceMotion ? const Duration(milliseconds: 1) : widget.duration,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) => _measureAndStart());
  }

  void _measureAndStart() {
    final box = _contentKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) {
      setState(() => _contentHeight = box.size.height);
    }
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _PrinterSlot(),
        const SizedBox(height: 4),
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final h = _contentHeight * Curves.easeOutCubic.transform(_controller.value);
            return ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: 1,
                child: SizedBox(
                  height: h,
                  child: child,
                ),
              ),
            );
          },
          child: KeyedSubtree(key: _contentKey, child: widget.receipt),
        ),
      ],
    );
  }
}

class _PrinterSlot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF4A4A4A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF2A2A2A), width: 2),
          ),
          child: const Center(
            child: Icon(Icons.coffee_maker, color: Colors.white70, size: 28),
          ),
        ),
        Container(
          width: 90,
          height: 6,
          color: const Color(0xFF1A1A1A),
        ),
      ],
    );
  }
}
