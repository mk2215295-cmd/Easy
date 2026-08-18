import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ad_sidebar_widget.dart';

// ════════════════════════════════════════════════════════════════════════════
// LoginScreen — Premium animated auth gateway for Easy Work Web.
// Features: Neon pulsing logo, dynamic particle mesh bg, glassmorphism form,
//           staggered content entry, glow button hover effects.
// ════════════════════════════════════════════════════════════════════════════
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final Animation<double> _bgAnim;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 10))
      ..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);

    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..repeat(reverse: true);
    _pulseAnim = CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  void _showError(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(children: [
          const Icon(Icons.error_outline_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 10),
          Expanded(child: Text(msg, style: const TextStyle(color: Colors.white, fontSize: 13))),
        ]),
        backgroundColor: const Color(0xFFB91C1C),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 900;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Stack(
        children: [
          // ── Dynamic background ─────────────────────────────────────────
          _EnhancedAnimatedBg(bgAnim: _bgAnim, pulseAnim: _pulseAnim),

          // ── Main Content ───────────────────────────────────────────────
          SafeArea(
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 70,
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: _LoginCard(onError: _showError),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: AppColors.borderSubtle.withValues(alpha: 0.4),
                      ),
                      Expanded(
                        flex: 30,
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.backgroundElevated.withValues(alpha: 0.4),
                                AppColors.backgroundSurface.withValues(alpha: 0.2),
                              ],
                            ),
                          ),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Relocation Deals & Ads',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontSize: 14, fontWeight: FontWeight.bold,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ]).animate().fadeIn(delay: 800.ms).slideX(begin: 0.1),
                                const SizedBox(height: 4),
                                Text(
                                  'عروض السكن والانتقال الحصرية للمتقدمين',
                                  style: AppTextStyles.labelSmall.copyWith(fontSize: 11, color: AppColors.textSecondary),
                                ).animate().fadeIn(delay: 900.ms),
                                const SizedBox(height: 20),
                                const AdSidebarWidget()
                                    .animate().fadeIn(delay: 1000.ms).slideY(begin: 0.05),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: _LoginCard(onError: _showError),
                        ),
                        const SizedBox(height: 40),
                        const Divider(color: AppColors.borderSubtle, height: 1),
                        const SizedBox(height: 24),
                        Row(children: [
                          const Icon(Icons.stars_rounded, color: Color(0xFFF59E0B), size: 20),
                          const SizedBox(width: 8),
                          Text(
                            'Relocation Deals & Ads / عروض الانتقال',
                            style: AppTextStyles.titleMedium.copyWith(
                              fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.textPrimary,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 16),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: const AdSidebarWidget(),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _EnhancedAnimatedBg — Multi-orb animated gradient background with
//   dynamic particle mesh and radial glow effects.
// ════════════════════════════════════════════════════════════════════════════
class _EnhancedAnimatedBg extends StatelessWidget {
  const _EnhancedAnimatedBg({required this.bgAnim, required this.pulseAnim});
  final Animation<double> bgAnim;
  final Animation<double> pulseAnim;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: Listenable.merge([bgAnim, pulseAnim]),
      builder: (_, __) => Stack(
        children: [
          // Primary blue orb — top-left drifting
          Positioned(
            top: -140 + (bgAnim.value * 70),
            left: -100 + (bgAnim.value * 50),
            child: _Orb(
              size: 560,
              color: AppColors.accentBlue.withValues(alpha: 0.15 + pulseAnim.value * 0.06),
            ),
          ),
          // Green orb — bottom-right
          Positioned(
            bottom: -120 + (bgAnim.value * -50),
            right: -80 + (bgAnim.value * 40),
            child: _Orb(
              size: 460,
              color: AppColors.accentGreen.withValues(alpha: 0.08 + pulseAnim.value * 0.04),
            ),
          ),
          // Amber orb — center top
          Positioned(
            top: size.height * 0.3 + (bgAnim.value * -30),
            left: size.width * 0.45 + (bgAnim.value * 20),
            child: _Orb(
              size: 300,
              color: const Color(0xFFF59E0B).withValues(alpha: 0.05 + pulseAnim.value * 0.03),
            ),
          ),
          // Particle grid overlay
          SizedBox.fromSize(
            size: size,
            child: CustomPaint(
              painter: _ParticleMeshPainter(progress: bgAnim.value),
            ),
          ),
          // Subtle vignette
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [Colors.transparent, Color(0x660D1117)],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Orb extends StatelessWidget {
  const _Orb({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, Colors.transparent],
          stops: const [0.0, 1.0],
        ),
      ),
    );
  }
}

// ── Particle Mesh Painter ─────────────────────────────────────────────────────
class _ParticleMeshPainter extends CustomPainter {
  _ParticleMeshPainter({this.progress = 0.0});
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = const Color(0xFF388BFD).withValues(alpha: 0.28)
      ..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = const Color(0xFF1F6FEB).withValues(alpha: 0.10)
      ..strokeWidth = 0.7
      ..style = PaintingStyle.stroke;

    const spacing = 52.0;
    final cols = (size.width / spacing).ceil() + 1;
    final rows = (size.height / spacing).ceil() + 1;

    final points = <Offset>[];
    for (int col = 0; col < cols; col++) {
      for (int row = 0; row < rows; row++) {
        final wave = math.sin((col + row) * 0.4 + progress * math.pi * 2);
        final ox = (col % 2 == 0) ? (progress * 10) : -(progress * 10);
        final oy = wave * 6;
        points.add(Offset(col * spacing + ox, row * spacing + oy));
      }
    }

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final dist = (points[i] - points[j]).distance;
        if (dist < spacing * 1.6) {
          final alpha = (1 - dist / (spacing * 1.6)) * 0.12;
          canvas.drawLine(
            points[i], points[j],
            linePaint..color = const Color(0xFF1F6FEB).withValues(alpha: alpha),
          );
        }
      }
    }

    for (final pt in points) {
      final sz = 1.5 + math.sin(pt.dx * 0.1 + progress * math.pi) * 0.5;
      canvas.drawCircle(pt, sz, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_ParticleMeshPainter old) => old.progress != progress;
}

// ════════════════════════════════════════════════════════════════════════════
// _LoginCard — Glassmorphism card with staggered animated content.
// ════════════════════════════════════════════════════════════════════════════
class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.onError});
  final void Function(BuildContext, String) onError;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface.withValues(alpha: 0.82),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.08),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 60, offset: const Offset(0, 24)),
              BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.06), blurRadius: 40, spreadRadius: 2),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Animated logo ──────────────────────────────────────────
              _BrandLogo().animate()
                  .scale(begin: const Offset(0.6, 0.6), end: const Offset(1, 1), duration: 700.ms, curve: Curves.elasticOut)
                  .fadeIn(duration: 500.ms),
              const SizedBox(height: 16),

              // ── Tagline EN ─────────────────────────────────────────────
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF007FFF), Color(0xFF10B981)],
                ).createShader(bounds),
                child: Text(
                  'Your Gateway to Europe',
                  style: AppTextStyles.headlineMedium.copyWith(
                    fontSize: 23, fontWeight: FontWeight.bold,
                    letterSpacing: -0.3, color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).animate(delay: 200.ms)
                  .fadeIn(duration: 500.ms)
                  .slideY(begin: 0.1, end: 0, duration: 450.ms),

              const SizedBox(height: 6),
              Text(
                'بوابتك نحو فرص العمل في أوروبا',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 13, color: AppColors.textSecondary, height: 1.5,
                ),
                textAlign: TextAlign.center,
              ).animate(delay: 350.ms).fadeIn(duration: 450.ms),

              const SizedBox(height: 36),

              // ── Feature pills ──────────────────────────────────────────
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8, runSpacing: 8,
                children: [
                  const _FeaturePill(icon: Icons.verified_rounded, label: 'AI Matching'),
                  const _FeaturePill(icon: Icons.flight_takeoff_rounded, label: 'EU Jobs'),
                  const _FeaturePill(icon: Icons.shield_rounded, label: 'Trusted'),
                ].asMap().entries.map((e) =>
                  e.value.animate(delay: Duration(milliseconds: 400 + e.key * 80))
                      .fadeIn().scale(begin: const Offset(0.8, 0.8)),
                ).toList(),
              ),

              const SizedBox(height: 28),
              const _SectionDivider(label: 'Sign in to continue / تسجيل الدخول'),
              const SizedBox(height: 24),

              // ── Auth buttons ───────────────────────────────────────────
              _GoogleButton(onError: onError)
                  .animate(delay: 600.ms).fadeIn().slideY(begin: 0.1, end: 0),
              const SizedBox(height: 12),
              _LinkedInButton(onError: onError)
                  .animate(delay: 700.ms).fadeIn().slideY(begin: 0.1, end: 0),

              const SizedBox(height: 28),
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy.',
                style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.textDisabled, height: 1.6),
                textAlign: TextAlign.center,
              ).animate(delay: 800.ms).fadeIn(),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Feature pill widget ───────────────────────────────────────────────────────
class _FeaturePill extends StatelessWidget {
  const _FeaturePill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accentBlueMuted.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 13, color: AppColors.accentBlueLighter),
        const SizedBox(width: 5),
        Text(label, style: AppTextStyles.labelSmall.copyWith(
          fontSize: 11, color: AppColors.accentBlueLighter, fontWeight: FontWeight.w600,
        )),
      ]),
    );
  }
}

// ── Brand logo ─────────────────────────────────────────────────────────────────
class _BrandLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.35), width: 1.5),
        boxShadow: const [
          BoxShadow(color: Color(0x44007FFF), blurRadius: 28, spreadRadius: 2, offset: Offset(0, 6)),
        ],
      ),
      child: Image.asset(
        AppAssets.logo,
        height: 64,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(AppAssets.logoImage14, height: 64, fit: BoxFit.contain),
      ),
    );
  }
}

// ── Divider ────────────────────────────────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const Expanded(child: Divider(color: AppColors.borderSubtle)),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(label, style: AppTextStyles.labelSmall.copyWith(
          fontSize: 10, color: AppColors.textDisabled, letterSpacing: 0.5,
        )),
      ),
      const Expanded(child: Divider(color: AppColors.borderSubtle)),
    ]);
  }
}

// ── Google Sign-In button ──────────────────────────────────────────────────────
class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.onError});
  final void Function(BuildContext, String) onError;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final isBusy = auth.isBusy;
    return _OAuthButton(
      id: 'google_signin_btn',
      label: 'Continue with Google',
      labelAr: 'المتابعة بحساب Google',
      icon: _GoogleIcon(),
      backgroundColor: const Color(0xFFFFFFFF),
      foregroundColor: const Color(0xFF1F1F1F),
      borderColor: const Color(0xFFE2E8F0),
      isBusy: isBusy,
      onTap: isBusy ? null : () async {
        await auth.signInWithGoogle();
        if (auth.errorMessage != null && context.mounted) onError(context, auth.errorMessage!);
      },
    );
  }
}

// ── LinkedIn Sign-In button ────────────────────────────────────────────────────
class _LinkedInButton extends StatelessWidget {
  const _LinkedInButton({required this.onError});
  final void Function(BuildContext, String) onError;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final isBusy = auth.isBusy;
    return _OAuthButton(
      id: 'linkedin_signin_btn',
      label: 'Continue with LinkedIn',
      labelAr: 'المتابعة بحساب LinkedIn',
      icon: _LinkedInIcon(),
      backgroundColor: const Color(0xFF0A66C2),
      foregroundColor: Colors.white,
      borderColor: const Color(0xFF0A66C2),
      isBusy: isBusy,
      onTap: isBusy ? null : () async {
        await auth.signInWithLinkedIn();
        if (auth.errorMessage != null && context.mounted) onError(context, auth.errorMessage!);
      },
    );
  }
}

// ── Shared OAuth pill button ───────────────────────────────────────────────────
class _OAuthButton extends StatefulWidget {
  const _OAuthButton({
    required this.id,
    required this.label,
    required this.labelAr,
    required this.icon,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderColor,
    required this.isBusy,
    this.onTap,
  });
  final String id;
  final String label;
  final String labelAr;
  final Widget icon;
  final Color backgroundColor;
  final Color foregroundColor;
  final Color borderColor;
  final bool isBusy;
  final VoidCallback? onTap;

  @override
  State<_OAuthButton> createState() => _OAuthButtonState();
}

class _OAuthButtonState extends State<_OAuthButton> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() { _hovered = false; _pressed = false; }),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.97 : 1.0,
          duration: const Duration(milliseconds: 120),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            height: 56,
            decoration: BoxDecoration(
              color: _hovered
                  ? widget.backgroundColor.withValues(alpha: 0.88)
                  : widget.backgroundColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: widget.borderColor, width: 1.5),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: widget.borderColor.withValues(alpha: 0.35),
                        blurRadius: 20, offset: const Offset(0, 6),
                      ),
                    ]
                  : [BoxShadow(color: Colors.black.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: widget.isBusy
                ? Center(child: SizedBox(
                    width: 22, height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(widget.foregroundColor),
                    ),
                  ))
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(children: [
                      widget.icon,
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.label,
                              style: TextStyle(
                                fontFamily: 'Inter', fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: widget.foregroundColor, letterSpacing: 0.1,
                              ),
                            ),
                            Text(
                              widget.labelAr,
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.foregroundColor.withValues(alpha: 0.6),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        transform: Matrix4.translationValues(_hovered ? 4 : 0, 0, 0),
                        child: Icon(Icons.arrow_forward_rounded, size: 16,
                          color: widget.foregroundColor.withValues(alpha: _hovered ? 0.8 : 0.4)),
                      ),
                    ]),
                  ),
          ),
        ),
      ),
    );
  }
}

// ── Google icon ────────────────────────────────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 22, height: 22, child: CustomPaint(painter: _GoogleLogoPainter()));
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;
    final segments = [
      (const Color(0xFF4285F4), 0.0),
      (const Color(0xFF34A853), 1.57),
      (const Color(0xFFFBBC05), 3.14),
      (const Color(0xFFEA4335), 4.71),
    ];
    for (final (color, start) in segments) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 1.75),
        start, 1.5, false,
        Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 3.5..strokeCap = StrokeCap.butt,
      );
    }
    canvas.drawCircle(Offset(cx, cy), r * 0.55,
        Paint()..color = Colors.white..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(_GoogleLogoPainter old) => false;
}

// ── LinkedIn icon ──────────────────────────────────────────────────────────────
class _LinkedInIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22, height: 22,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)),
      child: const Center(
        child: Text('in', style: TextStyle(
          color: Color(0xFF0A66C2), fontSize: 13,
          fontWeight: FontWeight.w900, fontFamily: 'Inter', height: 1,
        )),
      ),
    );
  }
}
