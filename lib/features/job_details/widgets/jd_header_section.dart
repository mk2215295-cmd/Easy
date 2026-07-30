import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/providers/job_provider.dart';
import '../../../core/models/job_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JdHeaderSection
// Bilingual job title block at the top of the Job Details left panel.
// Arabic title (large, right-aligned) + English subtitle below it.
// When [job] fields are null the widget renders animated shimmer bars.
// ════════════════════════════════════════════════════════════════════════════════
class JdHeaderSection extends StatelessWidget {
  const JdHeaderSection({super.key, this.job});

  /// Null while the API response is loading — renders shimmer placeholders.
  final JobModel? job;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Back button row ───────────────────────────────────────────
        Row(
          children: [
            _BackButton(),
            if (job?.countryFlagEmoji != null) ...[
              const SizedBox(width: 12),
              Text(
                job!.countryFlagEmoji!,
                style: const TextStyle(fontSize: 28),
              ),
            ],
          ],
        ),
        const SizedBox(height: 20),

        // Watch provider language state
        if (job != null) ...[
          Builder(
            builder: (context) {
              final isArabic = context.watch<JobProvider>().isArabic;
              final primaryText = isArabic ? (job!.titleAr ?? job!.title ?? 'Job Opportunity') : (job!.title ?? 'Job Opportunity');
              final secondaryText = isArabic ? (job!.title ?? '') : (job!.titleAr ?? '');

              return Column(
                crossAxisAlignment: isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Primary title
                  Text(
                    primaryText,
                    textAlign: isArabic ? TextAlign.right : TextAlign.left,
                    style: AppTextStyles.displayLarge.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Secondary title
                  if (secondaryText.isNotEmpty)
                    Text(
                      secondaryText,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              );
            },
          ),
        ] else ...[
          const _ShimmerBar(height: 36, radius: 6),
          const SizedBox(height: 8),
          const _ShimmerBar(height: 20, width: 260, radius: 4),
        ],

        const SizedBox(height: 24),
        const Divider(color: AppColors.borderSubtle, height: 1),
      ],
    );
  }
}

// ── Back Button ───────────────────────────────────────────────────────────────────────────
class _BackButton extends StatefulWidget {
  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.pop(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accentBlueMuted
                : AppColors.backgroundElevated,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? AppColors.accentBlue : AppColors.borderSubtle,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: _hovered
                    ? AppColors.accentBlue
                    : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Back / عودة',
                style: AppTextStyles.titleMedium.copyWith(
                  color: _hovered
                      ? AppColors.accentBlue
                      : AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shimmer placeholder ─────────────────────────────────────────────────────────────────────
class _ShimmerBar extends StatefulWidget {
  const _ShimmerBar({required this.height, this.width, this.radius = 4});
  final double height;
  final double? width;
  final double radius;

  @override
  State<_ShimmerBar> createState() => _ShimmerBarState();
}

class _ShimmerBarState extends State<_ShimmerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _anim = Tween<double>(begin: -1.5, end: 2.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          gradient: LinearGradient(
            stops: [
              (_anim.value - 0.4).clamp(0.0, 1.0),
              _anim.value.clamp(0.0, 1.0),
              (_anim.value + 0.4).clamp(0.0, 1.0),
            ],
            colors: const [
              AppColors.backgroundElevated,
              Color(0xFF2D3748),
              AppColors.backgroundElevated,
            ],
          ),
        ),
      ),
    );
  }
}
