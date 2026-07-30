import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/job_model.dart';
import '../../../core/providers/job_provider.dart';
import '../../../routing/app_router.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// JdApplyButton
//
// Full-width neon CTA — "APPLY NOW / تقديم الآن"
//
// On tap:
//   1. Calls jobProvider.applyToJob(job) → adds a live row to the Profile
//      Dashboard Applications table in real-time.
//   2. Shows a brief confirmation SnackBar.
//   3. Tries to open the external applyUrl if present.
//
// Uses vertical-lift animation (safe AnimationController with lowerBound:0 /
// upperBound:4 — no scale assertion risks).
// ════════════════════════════════════════════════════════════════════════════
class JdApplyButton extends StatefulWidget {
  const JdApplyButton({
    super.key,
    required this.job,
    this.isLoading = false,
  });

  /// Full job model so applyToJob() receives all needed fields.
  final JobModel? job;

  /// Shows skeleton state while job data is loading.
  final bool isLoading;

  @override
  State<JdApplyButton> createState() => _JdApplyButtonState();
}

class _JdApplyButtonState extends State<JdApplyButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  bool _applied = false;
  late final AnimationController _liftCtrl;
  late final Animation<double> _liftAnim;

  @override
  void initState() {
    super.initState();
    _liftCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 4.0,
    );
    _liftAnim = CurvedAnimation(parent: _liftCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _liftCtrl.dispose();
    super.dispose();
  }

  Future<void> _onApply(BuildContext context) async {
    final job = widget.job;
    if (job == null) return;

    final jobProvider = context.read<JobProvider>();
    final isArabic = jobProvider.isArabic;
    final cv = jobProvider.cv;

    // 1. Record application in global state → Profile Dashboard updates live
    jobProvider.applyToJob(job);
    setState(() => _applied = true);

    // 2. Build one-click mailto: URL for native Gmail client launch
    final recruiterEmail = job.recruiterEmailAddress;
    final jobTitle = isArabic
        ? (job.titleAr ?? job.title ?? 'Job Position')
        : (job.title ?? job.titleAr ?? 'Job Position');
    final userFullName = cv.fullName.trim().isEmpty ? 'Mahmoud' : cv.fullName.trim();
    final pitchBody = cv.generatedCoverLetterText;

    final subject = Uri.encodeComponent("Application for $jobTitle - $userFullName");
    final bodyText = Uri.encodeComponent('''
Dear Hiring Manager,

I am applying for the $jobTitle position at ${job.company ?? 'your company'}.

Application Summary:
• Applicant Name: $userFullName
• Profession: ${cv.profession.isEmpty ? 'Professional' : cv.profession}
• Location: ${cv.address}

Cover Letter Pitch:
$pitchBody

Attached CV File:
CV_${userFullName.replaceAll(' ', '_')}_Europass.pdf

Best regards,
$userFullName
''');

    final mailtoUrl = 'mailto:$recruiterEmail?subject=$subject&body=$bodyText';

    // 3. Launch native mailto / Gmail client
    try {
      final uri = Uri.parse(mailtoUrl);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // Fallback if mailto fails or applyUrl exists
      if (job.applyUrl != null && job.applyUrl!.isNotEmpty) {
        final uri = Uri.tryParse(job.applyUrl!);
        if (uri != null) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        }
      }
    }

    // 4. Show bilingual confirmation snackbar
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: AppColors.accentGreen,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: AppColors.white, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isArabic
                      ? 'تم فتح تطبيق البريد وتسجيل طلبك في ملف تعريفك!'
                      : 'Gmail client opened & application saved to Profile!',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.white, fontSize: 13),
                ),
              ),
              TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  context.go(AppRoutes.profile);
                },
                child: Text(
                  isArabic ? 'عرض' : 'View',
                  style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) return _SkeletonButton();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) {
        setState(() => _hovered = true);
        _liftCtrl.forward();
      },
      onExit: (_) {
        setState(() => _hovered = false);
        _liftCtrl.reverse();
      },
      child: AnimatedBuilder(
        animation: _liftAnim,
        builder: (_, child) => Transform.translate(
          offset: Offset(0, -_liftAnim.value),
          child: child,
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            gradient: _applied
                ? const LinearGradient(
                    colors: [Color(0xFF1A7A4A), AppColors.accentGreen],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                : const LinearGradient(
                    colors: [Color(0xFF0052CC), AppColors.accentBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: (_applied ? AppColors.accentGreen : AppColors.accentBlue)
                    .withValues(alpha: _hovered ? 0.7 : 0.45),
                blurRadius: _hovered ? 40 : 24,
                spreadRadius: _hovered ? 4 : 2,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _onApply(context),
              borderRadius: BorderRadius.circular(14),
              splashColor: AppColors.white.withValues(alpha: 0.1),
              highlightColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_applied)
                      const Icon(Icons.check_circle_rounded,
                          color: AppColors.white, size: 22)
                    else ...[
                      Text(
                        'APPLY NOW',
                        style: AppTextStyles.buttonPrimary.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                          letterSpacing: 1.5,
                          shadows: const [
                            Shadow(
                                color: AppColors.accentBlueGlow,
                                blurRadius: 12),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          '/',
                          style: AppTextStyles.buttonPrimary.copyWith(
                            fontSize: 17,
                            color:
                                AppColors.white.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                      Text(
                        'تقديم الآن',
                        style: AppTextStyles.buttonPrimary.copyWith(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                          shadows: const [
                            Shadow(
                                color: AppColors.accentBlueGlow,
                                blurRadius: 12),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppColors.white, size: 22),
                    ],
                    if (_applied) ...[
                      const SizedBox(width: 10),
                      const Text(
                        'Applied!',
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Skeleton ──────────────────────────────────────────────────────────────────
class _SkeletonButton extends StatefulWidget {
  @override
  State<_SkeletonButton> createState() => _SkeletonButtonState();
}

class _SkeletonButtonState extends State<_SkeletonButton>
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
        width: double.infinity,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            stops: [
              (_anim.value - 0.4).clamp(0.0, 1.0),
              _anim.value.clamp(0.0, 1.0),
              (_anim.value + 0.4).clamp(0.0, 1.0),
            ],
            colors: const [
              AppColors.backgroundElevated,
              Color(0xFF1A2A4A),
              AppColors.backgroundElevated,
            ],
          ),
        ),
      ),
    );
  }
}
