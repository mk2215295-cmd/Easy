import 'package:flutter/material.dart';

import '../../../core/models/job_requirement_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JdRequirementsSection
// Renders the "المتطلبات:" section as a 2-column responsive grid of
// checkmark items. Shows animated skeleton bars when [requirements] is empty
// and [isLoading] is true.
// ════════════════════════════════════════════════════════════════════════════════
class JdRequirementsSection extends StatelessWidget {
  const JdRequirementsSection({
    super.key,
    required this.requirements,
    this.isLoading = false,
    this.isArabic = true,
  });

  final List<JobRequirementModel> requirements;
  final bool isLoading;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),

        // Section heading (المتطلبات:)
        _SectionHeading(
          arText: 'المتطلبات:',
          enText: 'Requirements',
          isArabic: isArabic,
        ),
        const SizedBox(height: 16),

        // Grid body
        if (isLoading || requirements.isEmpty)
          _SkeletonRequirements()
        else
          _RequirementsGrid(
              requirements: requirements, isArabic: isArabic),

        const SizedBox(height: 24),
        const Divider(color: AppColors.borderSubtle, height: 1),
      ],
    );
  }
}

// ── Section Heading ─────────────────────────────────────────────────────────────────────────
class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.arText,
    required this.enText,
    required this.isArabic,
  });
  final String arText;
  final String enText;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Text(
      isArabic ? arText : enText,
      textAlign: TextAlign.right,
      style: AppTextStyles.headlineMedium.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

// ── Requirements grid ───────────────────────────────────────────────────────────────────────
class _RequirementsGrid extends StatelessWidget {
  const _RequirementsGrid({
    required this.requirements,
    required this.isArabic,
  });
  final List<JobRequirementModel> requirements;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 2 columns on wide, 1 column on narrow
        final cols = constraints.maxWidth >= 500 ? 2 : 1;
        final rows = (requirements.length / cols).ceil();
        return Column(
          children: List.generate(rows, (rowIdx) {
            final start = rowIdx * cols;
            final end = (start + cols).clamp(0, requirements.length);
            final rowItems = requirements.sublist(start, end);
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  // Right column first (RTL convention)
                  if (rowItems.length > 1)
                    Expanded(
                      child: _RequirementItem(
                        req: rowItems[1],
                        isArabic: isArabic,
                      ),
                    ),
                  if (rowItems.length > 1)
                    const SizedBox(width: 12),
                  Expanded(
                    child: _RequirementItem(
                      req: rowItems[0],
                      isArabic: isArabic,
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class _RequirementItem extends StatelessWidget {
  const _RequirementItem({required this.req, required this.isArabic});
  final JobRequirementModel req;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final text =
        (isArabic ? req.textAr : req.textEn) ?? req.textEn ?? req.textAr;
    if (text == null) return const SizedBox.shrink();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.check_circle_rounded,
          color: AppColors.accentGreen,
          size: 16,
        ),
      ],
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────────────────────────────────
class _SkeletonRequirements extends StatefulWidget {
  @override
  State<_SkeletonRequirements> createState() => _SkeletonRequirementsState();
}

class _SkeletonRequirementsState extends State<_SkeletonRequirements>
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

  Widget _bar(double width) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: width,
        height: 13,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(3, (_) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(child: _bar(double.infinity)),
              const SizedBox(width: 12),
              Expanded(child: _bar(double.infinity)),
            ],
          ),
        );
      }),
    );
  }
}
