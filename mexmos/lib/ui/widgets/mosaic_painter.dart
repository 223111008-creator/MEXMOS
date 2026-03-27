import 'dart:math';
import 'package:flutter/material.dart';

class MosaicPainter extends CustomPainter {
  final Color baseColor;
  final double fineP;
  final double midP;
  final double coarseP;

  MosaicPainter({
    required this.baseColor,
    required this.fineP,
    required this.midP,
    required this.coarseP,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Draw base background color
    final bgPaint = Paint()..color = baseColor;
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), bgPaint);

    const double tile = 6.0;
    final int cols = (w / tile).floor();
    final int rows = (h / tile).floor();

    final totalGrain = fineP + midP + coarseP;
    // Avoid division by zero
    final fineRatio = fineP / (totalGrain + 0.001);
    final midRatio = midP / (totalGrain + 0.001);

    final random = Random(42); // specific seed for pseudo-consistent pattern during resizing/repainting

    Color lighten(Color c, int amount) {
      return Color.fromARGB(
        c.alpha,
        (c.red + amount).clamp(0, 255),
        (c.green + amount).clamp(0, 255),
        (c.blue + amount).clamp(0, 255),
      );
    }

    Color darken(Color c, int amount) {
      return Color.fromARGB(
        c.alpha,
        (c.red - amount).clamp(0, 255),
        (c.green - amount).clamp(0, 255),
        (c.blue - amount).clamp(0, 255),
      );
    }

    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < cols; col++) {
        final double x = col * tile;
        final double y = row * tile;
        final double r = random.nextDouble();

        final double noiseX = (col / cols - 0.5) * 2;
        final double noiseY = (row / rows - 0.5) * 2;
        final double wave = sin(noiseX * 3.14 + noiseY * 2.1) * 0.5 + 0.5;

        if (r < fineRatio) {
          // Fine grain
          final int v = ((wave * 20) - 10).floor();
          final Color c = v >= 0 ? lighten(baseColor, v) : darken(baseColor, -v);
          final p = Paint()
            ..color = c.withOpacity(0.92 + random.nextDouble() * 0.08)
            ..style = PaintingStyle.fill;
            
          canvas.drawRect(Rect.fromLTWH(x, y, tile - 1, tile - 1), p);
        } else if (r < fineRatio + midRatio) {
          // Medium grain
          final int v = ((wave * 35) - 15).floor();
          final Color c = v >= 0 ? lighten(baseColor, v + 5) : darken(baseColor, -v + 3);
          final p = Paint()
            ..color = c.withOpacity(0.85 + random.nextDouble() * 0.12)
            ..style = PaintingStyle.fill;

          final double gx = x - 1 + random.nextInt(3);
          final double gy = y - 1 + random.nextInt(3);
          
          canvas.save();
          canvas.translate(gx + tile/2, gy + tile/2);
          canvas.rotate(random.nextDouble() * pi);
          canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: tile * 0.96, height: tile * 0.76), p);
          canvas.restore();
        } else {
          // Coarse grain
          final int v = ((wave * 50) - 20).floor();
          final Color c = v >= 0 ? lighten(baseColor, v + 15) : darken(baseColor, -v + 8);
          final p = Paint()
            ..color = c.withOpacity(0.78 + random.nextDouble() * 0.18)
            ..style = PaintingStyle.fill;

          final double sz = tile * (0.6 + random.nextDouble() * 0.5);
          
          canvas.save();
          canvas.translate(x + tile/2, y + tile/2);
          canvas.rotate(random.nextDouble() * pi);
          canvas.drawOval(Rect.fromCenter(center: Offset.zero, width: sz, height: sz * 0.7), p);
          canvas.restore();
        }
      }
    }

    // Cement matrix overlay — lines
    final Paint linePaint = Paint()
      ..color = const Color.fromRGBO(0, 0, 0, 0.04)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const double mosaicTile = 48.0;
    final Path gridPath = Path();
    
    for (double x = 0; x <= w; x += mosaicTile) {
      gridPath.moveTo(x, 0);
      gridPath.lineTo(x, h);
    }
    for (double y = 0; y <= h; y += mosaicTile) {
      gridPath.moveTo(0, y);
      gridPath.lineTo(w, y);
    }
    canvas.drawPath(gridPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant MosaicPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
           oldDelegate.fineP != fineP ||
           oldDelegate.midP != midP ||
           oldDelegate.coarseP != coarseP;
  }
}
