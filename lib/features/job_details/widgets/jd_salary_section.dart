import 'package:flutter/material.dart';

import '../../../core/models/job_benefit_model.dart';
import '../../../core/models/job_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JdSalarySection
// "حزمة الراتب والمزايا:" section.
//
// Visual structure (top → bottom):
//   1. Section heading (right-aligned Arabic / English)
//   2. Glowing salary range text  → "€2,500 – €3,000 شهرياً"
//      Uses a text-shadow glow that mimics the neon effect in the mockup.
//   3. Benefit chips row  — green checkmark + label for each [JobBenefitModel]
//      (توفير السكن / تأمين صحي شامل / تذكرة طيران سنوية)
//
// Shows animated shimmer placeholders when [isLoading] or data is null.
// ════════════════════════════════════════════════════════════════════════════════

class JdSalarySection extends StatelessWidget {
  const JdSalarySection({
    super.key,
    this.job,
    this.isLoading = false,
    this.isArabic = true,
  });

  final JobModel? job;
  final bool isLoading;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),

        // ── Section heading ──────────────────────────────────────────────
        Text(
          isArabic ? 'حزمة الراتب والمزايا:' : 'Salary & Benefits:',
          textAlign: TextAlign.right,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 16),

        // ── Salary display ───────────────────────────────────────────────
        if (isLoading || job == null)
          _SkeletonSalary()
        else
          _SalaryDisplay(job: job!, isArabic: isArabic),

        const SizedBox(height: 24),
        const Divider(color: AppColors.borderSubtle, height: 1),
      ],
    );
  }
}

// ── _SalaryDisplay ─────────────────────────────────────────────────────────────
class _SalaryDisplay extends StatelessWidget {
  const _SalaryDisplay({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Glowing salary range
        if (job.salaryMin != null || job.salaryMax != null) ...[
          _GlowingSalaryText(job: job, isArabic: isArabic),
          const SizedBox(height: 16),
        ],

        // Benefit chips
        if (job.benefits.isNotEmpty) _BenefitsRow(benefits: job.benefits, isArabic: isArabic),
      ],
    );
  }
}

// ── _GlowingSalaryText ─────────────────────────────────────────────────────────
class _GlowingSalaryText extends StatelessWidget {
  const _GlowingSalaryText({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final curr = job.salaryCurrency ?? '€';
    final min = job.salaryMin;
    final max = job.salaryMax;
    final period = isArabic ? 'شهرياً' : 'per month';

    // Build the display string
    String salaryStr = '';
    if (min != null && max != null) {
      salaryStr = '$curr${_fmt(min)} - $curr${_fmt(max)}';
    } else if (min != null) {
      salaryStr = '$curr${_fmt(min)}+';
    } else if (max != null) {
      salaryStr = '$curr${_fmt(max)}';
    }

    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 12,
      children: [
        // Period label first (RTL: shows after salary on right)
        Text(
          period,
          textAlign: TextAlign.right,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        // Salary range with neon glow
        Text(
          salaryStr,
          textAlign: TextAlign.right,
          style: AppTextStyles.displayLarge.copyWith(
            color: AppColors.accentBlue,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            shadows: const [
              Shadow(
                color: AppColors.accentBlueGlow,
                blurRadius: 18,
              ),
              Shadow(
                color: AppColors.accentBlueGlow,
                blurRadius: 36,
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _fmt(double v) => v
      .toStringAsFixed(0)
      .replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},');
}

// ── _BenefitsRow ───────────────────────────────────────────────────────────────
class _BenefitsRow extends StatelessWidget {
  const _BenefitsRow({required this.benefits, required this.isArabic});
  final List<JobBenefitModel> benefits;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.end,
      spacing: 10,
      runSpacing: 8,
      children: benefits.map((b) => _BenefitChip(benefit: b, isArabic: isArabic)).toList(),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({required this.benefit, required this.isArabic});
  final JobBenefitModel benefit;
  final bool isArabic;

  static const Map<String, IconData> _iconMap = {
    BenefitType.accommodation: Icons.home_rounded,
    BenefitType.healthInsurance: Icons.health_and_safety_rounded,
    BenefitType.flightTicket: Icons.flight_rounded,
    BenefitType.transportation: Icons.directions_bus_rounded,
    BenefitType.bonus: Icons.savings_rounded,
    BenefitType.visa: Icons.card_travel_rounded,
    BenefitType.other: Icons.star_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final label = isArabic
        ? (benefit.labelAr ?? benefit.labelEn)
        : (benefit.labelEn ?? benefit.labelAr);
    if (label == null) return const SizedBox.shrink();
    final icon = _iconMap[benefit.type] ?? Icons.check_circle_rounded;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.accentGreenMuted,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.accentGreen,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 6),
          Icon(icon, color: AppColors.accentGreen, size: 14),
        ],
      ),
    );
  }
}

// ── _SkeletonSalary ────────────────────────────────────────────────────────────
class _SkeletonSalary extends StatefulWidget {
  @override
  State<_SkeletonSalary> createState() => _SkeletonSalaryState();
}

class _SkeletonSalaryState extends State<_SkeletonSalary>
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

  Widget _bar(double? w, double h) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Salary bar
        _bar(300, 40),
        const SizedBox(height: 16),
        // Benefit chips row
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _bar(110, 34),
            const SizedBox(width: 10),
            _bar(140, 34),
            const SizedBox(width: 10),
            _bar(130, 34),
          ],
        ),
      ],
    );
  }
}
