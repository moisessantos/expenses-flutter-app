import 'package:flutter/material.dart';

class FilterIcon extends StatelessWidget {
  final bool isActive;
  final double size;

  const FilterIcon({
    super.key,
    this.isActive = false,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurface;

    return CustomPaint(
      size: Size(size, size),
      painter: _FilterIconPainter(color: color),
    );
  }
}

class _FilterIconPainter extends CustomPainter {
  final Color color;

  _FilterIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();

    // Create funnel/filter shape
    final width = size.width;
    final height = size.height;

    // Top horizontal line
    path.moveTo(width * 0.15, height * 0.2);
    path.lineTo(width * 0.85, height * 0.2);

    // Left funnel line
    path.moveTo(width * 0.15, height * 0.2);
    path.lineTo(width * 0.35, height * 0.5);
    path.lineTo(width * 0.35, height * 0.8);

    // Right funnel line
    path.moveTo(width * 0.85, height * 0.2);
    path.lineTo(width * 0.65, height * 0.5);
    path.lineTo(width * 0.65, height * 0.8);

    // Bottom horizontal line
    path.moveTo(width * 0.35, height * 0.8);
    path.lineTo(width * 0.65, height * 0.8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is _FilterIconPainter && oldDelegate.color != color;
  }
}
