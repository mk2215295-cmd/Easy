import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// FeaturedEmployersAndTrendsSection
// Exact 1-to-1 visual match of FEATURED EMPLOYERS, GLOBAL JOB TRENDS, and footer from image.
// ════════════════════════════════════════════════════════════════════════════
class FeaturedEmployersAndTrendsSection extends StatelessWidget {
  const FeaturedEmployersAndTrendsSection({
    super.key,
    required this.isArabic,
  });

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 960;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1100),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: FEATURED EMPLOYERS
                Expanded(
                  flex: 62,
                  child: _buildFeaturedEmployers(),
                ),
                const SizedBox(width: 24),
                // Right: GLOBAL JOB TRENDS
                Expanded(
                  flex: 38,
                  child: _buildJobTrendsCard(),
                ),
              ],
            )
          else ...[
            _buildFeaturedEmployers(),
            const SizedBox(height: 20),
            _buildJobTrendsCard(),
          ],

          const SizedBox(height: 28),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFeaturedEmployers() {
    final employers = [
      {
        'name': 'amazon',
        'type': 'amazon',
        'bg': const Color(0xFF131F35),
      },
      {
        'name': 'Microsoft',
        'type': 'microsoft',
        'bg': const Color(0xFF131F35),
      },
      {
        'name': 'IBM',
        'type': 'ibm',
        'bg': const Color(0xFF131F35),
      },
      {
        'name': 'Coca-Cola',
        'type': 'coke',
        'bg': const Color(0xFF2C1417),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'شركاء التوظيف المعتمدون' : 'FEATURED EMPLOYERS',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: employers.map((emp) {
              return Container(
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: emp['bg'] as Color,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFF2C3E5A).withValues(alpha: 0.6)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildEmployerLogo(emp['type'] as String),
                    const SizedBox(width: 8),
                    Text(
                      emp['name'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 14,
                      color: Color(0xFF64748B),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildEmployerLogo(String type) {
    if (type == 'microsoft') {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            children: [
              Container(width: 5, height: 5, color: const Color(0xFFF25022)),
              const SizedBox(height: 1),
              Container(width: 5, height: 5, color: const Color(0xFF00A4EF)),
            ],
          ),
          const SizedBox(width: 1),
          Column(
            children: [
              Container(width: 5, height: 5, color: const Color(0xFF7FBA00)),
              const SizedBox(height: 1),
              Container(width: 5, height: 5, color: const Color(0xFFFFB900)),
            ],
          ),
        ],
      );
    }
    if (type == 'ibm') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(color: const Color(0xFF006699), borderRadius: BorderRadius.circular(2)),
        child: const Text('IBM', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
      );
    }
    if (type == 'coke') {
      return Container(
        width: 10,
        height: 10,
        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFF40009)),
      );
    }
    return Container(
      width: 10,
      height: 10,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF9900)),
    );
  }

  Widget _buildJobTrendsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isArabic ? 'مؤشرات التوظيف العالمية' : 'GLOBAL JOB TRENDS',
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF131F35),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF2C3E5A).withValues(alpha: 0.6)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metric row: • Growth 30 205 • Date
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF00C2E8))),
                      const SizedBox(width: 4),
                      const Text('Growth', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0xFF1E3A5F), borderRadius: BorderRadius.circular(4)),
                        child: const Text('30 205', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(width: 4, height: 4, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFFF5252))),
                      const SizedBox(width: 4),
                      const Text('Date', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Exact wavy neon chart painter matching image
              SizedBox(
                height: 38,
                child: CustomPaint(
                  size: const Size(double.infinity, 38),
                  painter: _ExactTrendsGraphPainter(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Social Media Icons matching image
        Row(
          children: [
            _FooterSocialIcon(icon: Icons.facebook_rounded),
            SizedBox(width: 8),
            _FooterSocialIcon(icon: Icons.camera_alt_outlined),
            SizedBox(width: 8),
            _FooterSocialIcon(icon: Icons.alternate_email_rounded),
            SizedBox(width: 8),
            _FooterSocialIcon(icon: Icons.public_rounded),
          ],
        ),
        SizedBox(width: 14),
        Text(
          'GlobalConnect Jobs © 2026',
          style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
        ),
      ],
    );
  }
}

class _FooterSocialIcon extends StatelessWidget {
  const _FooterSocialIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.08),
      ),
      child: Icon(icon, size: 12, color: const Color(0xFF94A3B8)),
    );
  }
}

class _ExactTrendsGraphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Grid reference lines
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.drawLine(Offset(0, size.height * 0.3), Offset(size.width, size.height * 0.3), gridPaint);
    canvas.drawLine(Offset(0, size.height * 0.7), Offset(size.width, size.height * 0.7), gridPaint);

    // Wave 1: Cyan Curve (Growth)
    final cyanPath = Path();
    cyanPath.moveTo(0, size.height * 0.8);
    cyanPath.cubicTo(size.width * 0.25, size.height * 0.1, size.width * 0.55, size.height * 0.9, size.width * 0.8, size.height * 0.2);
    cyanPath.lineTo(size.width, size.height * 0.4);

    final cyanPaint = Paint()
      ..color = const Color(0xFF00C2E8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;
    canvas.drawPath(cyanPath, cyanPaint);

    // Wave 2: Coral / Orange Curve
    final coralPath = Path();
    coralPath.moveTo(0, size.height * 0.6);
    coralPath.cubicTo(size.width * 0.35, size.height * 0.85, size.width * 0.65, size.height * 0.15, size.width, size.height * 0.7);

    final coralPaint = Paint()
      ..color = const Color(0xFFFF6E40)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    canvas.drawPath(coralPath, coralPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
