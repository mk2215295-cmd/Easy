import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// FeaturedEmployersAndTrendsSection
// Bottom section matching the reference image:
// - Featured Employers logo pill bar
// - Global Job Trends neon analytic graphic
// - Global network footer
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
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: Featured Employers
                Expanded(
                  flex: 6,
                  child: _buildFeaturedEmployers(),
                ),
                const SizedBox(width: 24),
                // Right: Global Job Trends Graphic
                Expanded(
                  flex: 4,
                  child: _buildJobTrendsCard(),
                ),
              ],
            )
          else ...[
            _buildFeaturedEmployers(),
            const SizedBox(height: 24),
            _buildJobTrendsCard(),
          ],

          const SizedBox(height: 36),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildFeaturedEmployers() {
    final employers = [
      {'name': 'Amazon', 'color': const Color(0xFFFF9900)},
      {'name': 'Microsoft', 'color': const Color(0xFF00A4EF)},
      {'name': 'IBM', 'color': const Color(0xFF1F70C1)},
      {'name': 'Siemens', 'color': const Color(0xFF00646E)},
      {'name': 'Spotify', 'color': const Color(0xFF1DB954)},
      {'name': 'Google', 'color': const Color(0xFF4285F4)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: const Color(0xFF00F0FF),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'شركاء التوظيف العالميون' : 'FEATURED EMPLOYERS',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Wrap(
          spacing: 12,
          runSpacing: 10,
          children: employers.map((emp) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFF0D1B33).withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: emp['color'] as Color,
                    ),
                  ),
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
                    color: Color(0xFF8B949E),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildJobTrendsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D1B33).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'مؤشرات التوظيف العالمية' : 'GLOBAL JOB TRENDS',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 0.8,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up_rounded, size: 13, color: Color(0xFF10B981)),
                    SizedBox(width: 4),
                    Text(
                      '+32.4%',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Futuristic neon wavy chart representation
          SizedBox(
            height: 50,
            child: CustomPaint(
              size: const Size(double.infinity, 50),
              painter: _NeonTrendWavePainter(),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'أكثر من 14,200 وظيفة نشطة هذا الأسبوع' : '14,200+ active EU & Global jobs',
                style: const TextStyle(fontSize: 11, color: Color(0xFF8B949E)),
              ),
              const Text(
                'Q3 2026',
                style: TextStyle(fontSize: 10, color: Color(0xFF00F0FF), fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            _SocialIcon(icon: Icons.public_rounded),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.alternate_email_rounded),
            SizedBox(width: 10),
            _SocialIcon(icon: Icons.share_rounded),
          ],
        ),
        Text(
          isArabic ? 'Easy Work Global © 2026 — كافة الحقوق محفوظة' : 'Easy Work Global Careers © 2026',
          style: const TextStyle(fontSize: 11, color: Color(0xFF8B949E)),
        ),
      ],
    );
  }
}

class _SocialIcon extends StatelessWidget {
  const _SocialIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: 0.06),
      ),
      child: Icon(icon, size: 14, color: const Color(0xFF8B949E)),
    );
  }
}

class _NeonTrendWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path1 = Path();
    final path2 = Path();

    path1.moveTo(0, size.height * 0.7);
    path1.cubicTo(size.width * 0.25, size.height * 0.3, size.width * 0.6, size.height * 0.8, size.width, size.height * 0.2);

    path2.moveTo(0, size.height * 0.85);
    path2.cubicTo(size.width * 0.3, size.height * 0.6, size.width * 0.7, size.height * 0.2, size.width, size.height * 0.5);

    // Wave 1: Cyan Glow
    final paint1 = Paint()
      ..color = const Color(0xFF00F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawPath(path1, paint1);

    // Wave 2: Emerald
    final paint2 = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
