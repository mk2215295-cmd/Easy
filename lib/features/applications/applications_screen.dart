import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/models/user_profile_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animations/page_transition_wrapper.dart';
import '../../widgets/common/app_header.dart';

// ════════════════════════════════════════════════════════════════════════════
// ApplicationsScreen (/applications) — Premium animated applications list.
// ════════════════════════════════════════════════════════════════════════════
class ApplicationsScreen extends StatelessWidget {
  const ApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final isArabic = jobProvider.isArabic;
    final applications = jobProvider.profile.applications;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.applications,
        isArabic: isArabic,
        onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: PageTransitionWrapper(
        child: Column(
          children: [
            AppHeader(
              activeRoute: AppRoutes.applications,
              isArabic: isArabic,
              onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
            ),

            // ── Animated heading ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Row(
                mainAxisAlignment: isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlueMuted.withValues(alpha: 0.4),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_turned_in_outlined, color: AppColors.accentBlue, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    isArabic ? 'طلباتي' : 'My Applications',
                    style: AppTextStyles.headlineLarge.copyWith(fontSize: 22),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.05, end: 0),

            const SizedBox(height: 16),

            // ── Applications list ─────────────────────────────────────────
            Expanded(
              child: applications.isEmpty
                  ? _EmptyState(isArabic: isArabic)
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                      itemCount: applications.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 10),
                      itemBuilder: (_, i) => _ApplicationCard(
                        app: applications[i],
                        isArabic: isArabic,
                        index: i,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Application card ─────────────────────────────────────────────────────────
class _ApplicationCard extends StatefulWidget {
  const _ApplicationCard({required this.app, required this.isArabic, required this.index});
  final AppliedApplicationModel app;
  final bool isArabic;
  final int index;

  @override
  State<_ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<_ApplicationCard> {
  bool _hovered = false;

  Color _statusColor(String status) {
    final s = status.toLowerCase();
    if (s.contains('submit')) return AppColors.accentBlue;
    if (s.contains('review')) return const Color(0xFFF59E0B);
    if (s.contains('interview')) return AppColors.accentGreen;
    if (s.contains('reject')) return AppColors.error;
    if (s.contains('hired')) return const Color(0xFF34D399);
    return AppColors.textSecondary;
  }

  Color _hexColor(String? hex) {
    if (hex == null) return AppColors.accentBlue;
    try {
      return Color(int.parse(hex.replaceAll('#', ''), radix: 16) | 0xFF000000);
    } catch (_) {
      return AppColors.accentBlue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final delay = (widget.index * 60).clamp(0, 500);
    final statusColor = widget.app.statusColorHex != null
        ? _hexColor(widget.app.statusColorHex)
        : _statusColor(widget.app.status);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.backgroundElevated : AppColors.backgroundSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _hovered ? statusColor.withValues(alpha: 0.5) : AppColors.borderSubtle,
            width: _hovered ? 1.5 : 1.0,
          ),
          boxShadow: _hovered
              ? [BoxShadow(color: statusColor.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4))]
              : [],
        ),
        child: Row(
          textDirection: widget.isArabic ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Animated status dot
            Container(
              width: 10, height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: statusColor,
                boxShadow: [BoxShadow(color: statusColor.withValues(alpha: 0.5), blurRadius: 6, spreadRadius: 1)],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.2, 1.2), duration: 1200.ms),
            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: widget.isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.app.jobTitle,
                    style: AppTextStyles.headlineMedium.copyWith(
                      fontSize: 15,
                      color: _hovered ? AppColors.accentBlueLighter : AppColors.textPrimary,
                    ),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: widget.isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      const Icon(Icons.business_rounded, size: 11, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(widget.app.companyName, style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                      const SizedBox(width: 8),
                      const Icon(Icons.calendar_today_outlined, size: 11, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(widget.app.appliedDate, style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Status badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                widget.app.status,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 11, color: statusColor, fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 350.ms).slideY(begin: 0.06, end: 0);
  }
}

// ── Empty state ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isArabic});
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [AppColors.accentBlueMuted, AppColors.backgroundElevated]),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: const Icon(Icons.assignment_outlined, color: AppColors.textDisabled, size: 36),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.92, 0.92), end: const Offset(1.08, 1.08), duration: 2000.ms),
          const SizedBox(height: 20),
          Text(
            isArabic ? 'لا توجد طلبات بعد' : 'No applications yet',
            style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textSecondary),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'ابدأ بتقديم طلباتك من صفحة الوظائف' : 'Start applying from the Jobs page',
            style: AppTextStyles.bodyMedium, textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}
