import 'dart:math' as math;
import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// EasyWorkAnimatedLogo — Cyber-Neon Animated Brand Logo
//
// Features:
//   • Rotating orbital ring with glowing particle satellites
//   • Pulsing core sphere with radiant gradient and cyber-grid lines
//   • Futuristic typography with neon teal/cyan accents and live status beacon
// ════════════════════════════════════════════════════════════════════════════
class EasyWorkAnimatedLogo extends StatefulWidget {
  const EasyWorkAnimatedLogo({
    super.key,
    this.size = 40.0,
    this.showText = true,
    this.showTagline = true,
    this.isArabic = false,
    this.onTap,
  });

  final double size;
  final bool showText;
  final bool showTagline;
  final bool isArabic;
  final VoidCallback? onTap;

  @override
  State<EasyWorkAnimatedLogo> createState() => _EasyWorkAnimatedLogoState();
}

class _EasyWorkAnimatedLogoState extends State<EasyWorkAnimatedLogo>
    with TickerProviderStateMixin {
  late final AnimationController _orbitController;
  late final AnimationController _pulseController;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _orbitController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _orbitController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Animated Globe & Orbit Icon ─────────────────────────────────
              _buildAnimatedIcon(),

              if (widget.showText) ...[
                const SizedBox(width: 12),
                // ── Brand Text & Tagline ──────────────────────────────────────
                _buildBrandTypography(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_orbitController, _pulseController]),
        builder: (context, _) {
          return CustomPaint(
            painter: _CyberGlobePainter(
              orbitProgress: _orbitController.value,
              pulseProgress: _pulseController.value,
              isHovered: _isHovered,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandTypography() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          widget.isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // Main Name: Easy Work
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Easy',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: widget.size * 0.52,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
                height: 1.1,
              ),
            ),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xFF00F0FF), Color(0xFF007FFF), Color(0xFF10B981)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(bounds),
              child: Text(
                'Work',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: widget.size * 0.52,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: -0.5,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(width: 4),
            // Glowing mini beacon dot
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF00F0FF),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ],
        ),

        // Subtitle / Tagline
        if (widget.showTagline) ...[
          const SizedBox(height: 2),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.isArabic ? 'بوابة التوظيف الدولية' : 'GLOBAL CAREERS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: widget.size * 0.22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8B949E),
                  letterSpacing: widget.isArabic ? 0.0 : 1.6,
                  height: 1.0,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Custom Painter for 3D Cyber Globe & Orbit
// ════════════════════════════════════════════════════════════════════════════
class _CyberGlobePainter extends CustomPainter {
  _CyberGlobePainter({
    required this.orbitProgress,
    required this.pulseProgress,
    required this.isHovered,
  });

  final double orbitProgress;
  final double pulseProgress;
  final bool isHovered;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * 0.72;

    // 1. Outer Glow Aura
    final auraPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF00F0FF).withValues(alpha: isHovered ? 0.35 : 0.2),
          const Color(0xFF007FFF).withValues(alpha: isHovered ? 0.18 : 0.08),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius * 1.5));
    canvas.drawCircle(center, radius * 1.4 + (pulseProgress * 2), auraPaint);

    // 2. Main Globe Sphere (Deep Cyber Gradient)
    final globePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.3, -0.3),
        colors: [
          Color(0xFF0052CC),
          Color(0xFF0A192F),
          Color(0xFF030A16),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, globePaint);

    // 3. Globe Grid Lines (Latitudes & Longitudes)
    final gridPaint = Paint()
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Equator / Latitude ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 2,
        height: radius * 0.75 * math.cos(orbitProgress * math.pi * 2 * 0.2),
      ),
      gridPaint,
    );

    // Longitude ellipse
    canvas.drawOval(
      Rect.fromCenter(
        center: center,
        width: radius * 0.8 * math.sin(orbitProgress * math.pi * 2),
        height: radius * 2,
      ),
      gridPaint,
    );

    // 4. Rotating Orbit Ellipse (3D Tilt)
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-math.pi / 6); // 30 deg tilt

    final orbitRadiusX = radius * 1.35;
    final orbitRadiusY = radius * 0.55;

    final orbitPathPaint = Paint()
      ..shader = SweepGradient(
        colors: [
          const Color(0xFF00F0FF).withValues(alpha: 0.9),
          const Color(0xFF10B981).withValues(alpha: 0.6),
          const Color(0xFF0052CC).withValues(alpha: 0.1),
          const Color(0xFF00F0FF).withValues(alpha: 0.9),
        ],
        transform: GradientRotation(orbitProgress * math.pi * 2),
      ).createShader(Rect.fromCenter(
        center: Offset.zero,
        width: orbitRadiusX * 2,
        height: orbitRadiusY * 2,
      ))
      ..style = PaintingStyle.stroke
      ..strokeWidth = isHovered ? 1.8 : 1.3;

    canvas.drawOval(
      Rect.fromCenter(
        center: Offset.zero,
        width: orbitRadiusX * 2,
        height: orbitRadiusY * 2,
      ),
      orbitPathPaint,
    );

    // 5. Orbiting Satellite Particles
    final angle1 = orbitProgress * math.pi * 2;
    final sat1X = orbitRadiusX * math.cos(angle1);
    final sat1Y = orbitRadiusY * math.sin(angle1);

    final satPaint = Paint()
      ..color = const Color(0xFF00F0FF)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(sat1X, sat1Y), 2.5, satPaint);

    final glowSatPaint = Paint()
      ..color = const Color(0xFF00F0FF).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(sat1X, sat1Y), 4.5, glowSatPaint);

    canvas.restore();

    // 6. Globe Border Ring
    final borderPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF00F0FF), Color(0xFF10B981), Color(0xFF0052CC)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawCircle(center, radius, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _CyberGlobePainter oldDelegate) {
    return oldDelegate.orbitProgress != orbitProgress ||
        oldDelegate.pulseProgress != pulseProgress ||
        oldDelegate.isHovered != isHovered;
  }
}
