import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ad_sidebar_widget.dart';

// ════════════════════════════════════════════════════════════════════════════
// LoginScreen
//
// Premium dark-themed authentication gateway for Easy Work Web.
//
// Desktop Layout (≥ 900px wide):
//   • 70% Left Column  — Auth / Login Form Panel
//   • 30% Right Column — Ad Banners, Travel & Relocation Promotions Sidebar
//
// Mobile Layout (< 900px wide):
//   • Stacked responsive single-column layout
// ════════════════════════════════════════════════════════════════════════════

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bgCtrl;
  late final Animation<double> _bgAnim;

  @override
  void initState() {
    super.initState();
    _bgCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _bgAnim = CurvedAnimation(parent: _bgCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _bgCtrl.dispose();
    super.dispose();
  }

  // Show error snackbar
  void _showError(BuildContext ctx, String msg) {
    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 10),
            Expanded(
                child: Text(msg,
                    style: const TextStyle(
                        color: Colors.white, fontSize: 13))),
          ],
        ),
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
          // ── Animated background gradient orbs ──────────────────────────
          _AnimatedBackground(animation: _bgAnim),

          // ── Main Content Layout ─────────────────────────────────────────
          SafeArea(
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 70% Left Panel — Auth / Login Form ───────────────
                      Expanded(
                        flex: 70,
                        child: Center(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 48),
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: _LoginCard(onError: _showError),
                            ),
                          ),
                        ),
                      ),

                      // ── Vertical Divider ─────────────────────────────────
                      Container(
                        width: 1,
                        height: double.infinity,
                        color: AppColors.borderSubtle.withValues(alpha: 0.5),
                      ),

                      // ── 30% Right Panel — Ad Banners & Promotions Sidebar
                      Expanded(
                        flex: 30,
                        child: Container(
                          height: double.infinity,
                          color: AppColors.backgroundElevated
                              .withValues(alpha: 0.3),
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.stars_rounded,
                                        color: Color(0xFFF59E0B), size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Relocation Deals & Ads',
                                      style: AppTextStyles.titleMedium.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'عروض السكن والانتقال الحصرية للمتقدمين',
                                  style: AppTextStyles.labelSmall.copyWith(
                                    fontSize: 11,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                const AdSidebarWidget(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 36),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 440),
                          child: _LoginCard(onError: _showError),
                        ),
                        const SizedBox(height: 40),
                        const Divider(
                            color: AppColors.borderSubtle, height: 1),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.stars_rounded,
                                color: Color(0xFFF59E0B), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Relocation Deals & Ads / عروض الانتقال',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
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

// ── Animated background ───────────────────────────────────────────────────────
class _AnimatedBackground extends StatelessWidget {
  const _AnimatedBackground({required this.animation});
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Stack(
          children: [
            // Primary orb — top-left
            Positioned(
              top: -120 + (animation.value * 60),
              left: -80 + (animation.value * 40),
              child: Container(
                width: 500,
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.accentBlue.withValues(alpha: 0.18),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Secondary orb — bottom-right
            Positioned(
              bottom: -100 + (animation.value * -40),
              right: -60 + (animation.value * 30),
              child: Container(
                width: 420,
                height: 420,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xFF0A66C2).withValues(alpha: 0.14),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            // Subtle grid overlay
            SizedBox(
              width: size.width,
              height: size.height,
              child: CustomPaint(painter: _GridPainter()),
            ),
          ],
        );
      },
    );
  }
}

// ── Subtle dot grid painter ───────────────────────────────────────────────────
class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF21262D)
      ..strokeWidth = 1
      ..style = PaintingStyle.fill;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

// ── Main login card ────────────────────────────────────────────────────────────
class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.onError});
  final void Function(BuildContext, String) onError;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.white.withValues(alpha: 0.07),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.45),
                blurRadius: 40,
                offset: const Offset(0, 20),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Brand logo ────────────────────────────────────────────
              _BrandLogo(),
              const SizedBox(height: 12),

              // ── Tagline EN ────────────────────────────────────────────
              Text(
                'Your Gateway to Europe',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // ── Tagline AR ────────────────────────────────────────────
              Text(
                'بوابتك نحو فرص العمل في أوروبا',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),

              // ── Divider with label ────────────────────────────────────
              const _SectionDivider(label: 'Sign in to continue / تسجيل الدخول'),
              const SizedBox(height: 24),

              // ── Google button ─────────────────────────────────────────
              _GoogleButton(onError: onError),
              const SizedBox(height: 14),

              // ── LinkedIn button ───────────────────────────────────────
              _LinkedInButton(onError: onError),
              const SizedBox(height: 32),

              // ── Footer note ───────────────────────────────────────────
              Text(
                'By continuing, you agree to our Terms of Service and Privacy Policy.',
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textDisabled,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Brand logo ────────────────────────────────────────────────────────────────
class _BrandLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentBlue.withValues(alpha: 0.3),
          width: 1.5,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33007FFF),
            blurRadius: 20,
            spreadRadius: 1,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Image.asset(
        AppAssets.logo,
        height: 64,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Image.asset(
          AppAssets.logoImage14,
          height: 64,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

// ── Divider with centred label ────────────────────────────────────────────────
class _SectionDivider extends StatelessWidget {
  const _SectionDivider({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.borderSubtle)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 10,
              color: AppColors.textDisabled,
              letterSpacing: 0.5,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.borderSubtle)),
      ],
    );
  }
}

// ── Google Sign-In button ─────────────────────────────────────────────────────
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
      onTap: isBusy
          ? null
          : () async {
              await auth.signInWithGoogle();
              if (auth.errorMessage != null && context.mounted) {
                onError(context, auth.errorMessage!);
              }
            },
    );
  }
}

// ── LinkedIn Sign-In button ───────────────────────────────────────────────────
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
      onTap: isBusy
          ? null
          : () async {
              await auth.signInWithLinkedIn();
              if (auth.errorMessage != null && context.mounted) {
                onError(context, auth.errorMessage!);
              }
            },
    );
  }
}

// ── Shared OAuth pill button ──────────────────────────────────────────────────
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

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.onTap != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: 54,
          decoration: BoxDecoration(
            color: _hovered
                ? widget.backgroundColor.withValues(alpha: 0.88)
                : widget.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: widget.borderColor, width: 1.5),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: widget.borderColor.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: widget.isBusy
              ? Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      valueColor: AlwaysStoppedAnimation<Color>(
                          widget.foregroundColor),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
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
                                fontFamily: 'Inter',
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: widget.foregroundColor,
                                letterSpacing: 0.1,
                              ),
                            ),
                            Text(
                              widget.labelAr,
                              style: TextStyle(
                                fontSize: 10,
                                color: widget.foregroundColor
                                    .withValues(alpha: 0.6),
                                fontFamily: 'Tajawal',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 16,
                        color: widget.foregroundColor.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// ── Google icon (SVG-equivalent via paint) ────────────────────────────────────
class _GoogleIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: 22,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Draw four quadrant arcs in Google colours
    final segments = [
      (const Color(0xFF4285F4), 0.0),   // Blue — right
      (const Color(0xFF34A853), 1.57),  // Green — bottom
      (const Color(0xFFFBBC05), 3.14),  // Yellow — left
      (const Color(0xFFEA4335), 4.71),  // Red — top
    ];

    for (final (color, start) in segments) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.5
        ..strokeCap = StrokeCap.butt;
      canvas.drawArc(
        Rect.fromCircle(center: Offset(cx, cy), radius: r - 1.75),
        start,
        1.5,
        false,
        paint,
      );
    }

    // White cutout centre for inner circle
    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), r * 0.55, whitePaint);
  }

  @override
  bool shouldRepaint(_GoogleLogoPainter old) => false;
}

// ── LinkedIn icon ─────────────────────────────────────────────────────────────
class _LinkedInIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Center(
        child: Text(
          'in',
          style: TextStyle(
            color: Color(0xFF0A66C2),
            fontSize: 13,
            fontWeight: FontWeight.w900,
            fontFamily: 'Inter',
            height: 1,
          ),
        ),
      ),
    );
  }
}

// ── Auth guard redirect widget ────────────────────────────────────────────────
// Used by GoRouter.redirect — no separate widget needed here.
// See app_router.dart for the redirect logic.
