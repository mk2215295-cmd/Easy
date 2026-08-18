import 'dart:math' as math;
import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// GlobeParticlesBackground
// Full-screen futuristic dynamic digital Earth and interconnected orbit lines
// matching the luxury neon cyber aesthetics.
// ════════════════════════════════════════════════════════════════════════════
class GlobeParticlesBackground extends StatefulWidget {
  const GlobeParticlesBackground({super.key, required this.child});
  final Widget child;

  @override
  State<GlobeParticlesBackground> createState() =>
      _GlobeParticlesBackgroundState();
}

class _GlobeParticlesBackgroundState extends State<GlobeParticlesBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 24),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ── Deep space gradient base ───────────────────────────────────────
        Container(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(0.0, -0.35),
              radius: 1.2,
              colors: [
                Color(0xFF0D224A), // Glowing deep navy
                Color(0xFF081226), // Midnight blue
                Color(0xFF030712), // Deep obsidian
              ],
              stops: [0.0, 0.55, 1.0],
            ),
          ),
        ),

        // ── Ambient Neon Light Orbs ─────────────────────────────────────────
        Positioned(
          top: -120,
          left: -100,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF007FFF).withValues(alpha: 0.16),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 150,
          right: -150,
          child: Container(
            width: 600,
            height: 600,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF00F0FF).withValues(alpha: 0.12),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),

        // ── Animated 3D Digital Globe & Constellations Mesh ────────────────
        Positioned.fill(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              return CustomPaint(
                painter: _GlobalGlobePainter(progress: _ctrl.value),
              );
            },
          ),
        ),

        // ── Subtle Top / Bottom Vignette ──────────────────────────────────
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF030712).withValues(alpha: 0.2),
                  Colors.transparent,
                  const Color(0xFF030712).withValues(alpha: 0.8),
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),

        // ── Foreground Content ─────────────────────────────────────────────
        widget.child,
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Custom Painter for Large Digital Earth & Orbital Connected Nodes
// ════════════════════════════════════════════════════════════════════════════
class _GlobalGlobePainter extends CustomPainter {
  _GlobalGlobePainter({required this.progress});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final globeCenter = Offset(size.width / 2, size.height * 0.28);
    final globeRadius = math.min(size.width * 0.46, 380.0);

    // 1. Globe Ambient Core Glow (Cyan/Blue Aura)
    final coreAura = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00F0FF).withValues(alpha: 0.22),
          const Color(0xFF0052CC).withValues(alpha: 0.12),
          Colors.transparent,
        ],
        stops: const [0.0, 0.7, 1.0],
      ).createShader(Rect.fromCircle(center: globeCenter, radius: globeRadius * 1.35));
    canvas.drawCircle(globeCenter, globeRadius * 1.3, coreAura);

    // 2. Globe Sphere Body
    final globeBody = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.25, -0.3),
        colors: [
          const Color(0xFF082B66).withValues(alpha: 0.9),
          const Color(0xFF051533).withValues(alpha: 0.95),
          const Color(0xFF020714).withValues(alpha: 0.98),
        ],
        stops: const [0.0, 0.65, 1.0],
      ).createShader(Rect.fromCircle(center: globeCenter, radius: globeRadius));
    canvas.drawCircle(globeCenter, globeRadius, globeBody);

    // 3. Globe Edge Atmosphere Rim
    final rimPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFF00F0FF).withValues(alpha: 0.8),
          const Color(0xFF007FFF).withValues(alpha: 0.4),
          const Color(0xFF10B981).withValues(alpha: 0.7),
          const Color(0xFF00F0FF).withValues(alpha: 0.8),
        ],
        transform: GradientRotation(progress * math.pi * 2),
      ).createShader(Rect.fromCircle(center: globeCenter, radius: globeRadius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(globeCenter, globeRadius, rimPaint);

    // 4. Longitudinal & Latitudinal Digital Lines
    final gridLinePaint = Paint()
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Multiple Latitude Ellipses
    for (int i = 1; i <= 5; i++) {
      final latOffset = (i - 3) * (globeRadius * 0.28);
      final latY = globeCenter.dy + latOffset;
      final latWidth = math.sqrt(math.max(0, globeRadius * globeRadius - latOffset * latOffset)) * 2;
      if (latWidth > 10) {
        canvas.drawOval(
          Rect.fromCenter(
            center: Offset(globeCenter.dx, latY),
            width: latWidth,
            height: latWidth * 0.28,
          ),
          gridLinePaint,
        );
      }
    }

    // Rotating Longitude Lines
    for (int i = 0; i < 6; i++) {
      final angle = (progress * math.pi * 2) + (i * math.pi / 3);
      final sinVal = math.sin(angle);
      final longWidth = globeRadius * 2 * sinVal.abs();
      if (longWidth > 2) {
        final longPaint = Paint()
          ..color = const Color(0xFF00F0FF).withValues(alpha: 0.10 + 0.10 * (sinVal.abs()))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;
        canvas.drawOval(
          Rect.fromCenter(
            center: globeCenter,
            width: longWidth,
            height: globeRadius * 2,
          ),
          longPaint,
        );
      }
    }

    // 5. Great Futuristic Orbital Ellipses (Surrounding the Globe like in the image)
    _drawGreatOrbit(canvas, globeCenter, globeRadius * 1.5, globeRadius * 0.55, -0.38, progress);
    _drawGreatOrbit(canvas, globeCenter, globeRadius * 1.7, globeRadius * 0.65, 0.42, progress * 0.7 + 0.5);
    _drawGreatOrbit(canvas, globeCenter, globeRadius * 1.35, globeRadius * 0.45, -0.15, -progress * 0.9);

    // 6. Constellation Nodes & Glowing Network Satellites (Europe, US, Asia, Middle East hubs)
    final nodes = [
      {'lat': -0.15, 'lon': 0.1, 'color': const Color(0xFF00F0FF), 'size': 4.0},
      {'lat': 0.1, 'lon': -0.3, 'color': const Color(0xFFFF5252), 'size': 4.5},
      {'lat': -0.25, 'lon': -0.2, 'color': const Color(0xFF10B981), 'size': 3.5},
      {'lat': 0.2, 'lon': 0.35, 'color': const Color(0xFFFFB800), 'size': 4.0},
      {'lat': -0.05, 'lon': 0.45, 'color': const Color(0xFF00F0FF), 'size': 3.5},
      {'lat': 0.25, 'lon': -0.1, 'color': const Color(0xFF007FFF), 'size': 3.0},
      {'lat': -0.35, 'lon': 0.25, 'color': const Color(0xFF10B981), 'size': 4.0},
    ];

    for (final node in nodes) {
      final lat = node['lat'] as double;
      final lon = (node['lon'] as double) + (progress * 0.3);
      final nx = globeCenter.dx + globeRadius * 0.85 * math.cos(lon * math.pi * 2) * math.cos(lat * math.pi);
      final ny = globeCenter.dy + globeRadius * 0.85 * math.sin(lat * math.pi);
      final color = node['color'] as Color;
      final size = node['size'] as double;

      // Glow halo
      canvas.drawCircle(
        Offset(nx, ny),
        size * 2.5,
        Paint()
          ..color = color.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
      // Center solid beacon
      canvas.drawCircle(Offset(nx, ny), size, Paint()..color = color);
      canvas.drawCircle(Offset(nx, ny), size * 0.5, Paint()..color = Colors.white);
    }
  }

  void _drawGreatOrbit(Canvas canvas, Offset center, double rx, double ry, double rotationAngle, double orbitP) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);

    final orbitRect = Rect.fromCenter(center: Offset.zero, width: rx * 2, height: ry * 2);

    final orbitPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFF00F0FF).withValues(alpha: 0.8),
          const Color(0xFF007FFF).withValues(alpha: 0.15),
          const Color(0xFF10B981).withValues(alpha: 0.7),
          const Color(0xFF00F0FF).withValues(alpha: 0.8),
        ],
        transform: GradientRotation(orbitP * math.pi * 2),
      ).createShader(orbitRect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    canvas.drawOval(orbitRect, orbitPaint);

    // Satellite particle orbiting on track
    final angle = orbitP * math.pi * 2;
    final px = rx * math.cos(angle);
    final py = ry * math.sin(angle);

    // Glowing satellite node
    canvas.drawCircle(
      Offset(px, py),
      6.0,
      Paint()
        ..color = const Color(0xFF00F0FF).withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawCircle(Offset(px, py), 3.0, Paint()..color = Colors.white);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlobalGlobePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
