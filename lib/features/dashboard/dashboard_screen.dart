import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/models/affiliate_deal_model.dart';
import '../../core/models/job_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_header.dart';
import '../../widgets/animations/page_transition_wrapper.dart';
import 'widgets/job_grid_section.dart';
import 'widgets/sidebar_section.dart';

// ════════════════════════════════════════════════════════════════════════════
// DashboardScreen — Animated premium dashboard
// ════════════════════════════════════════════════════════════════════════════
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1000;

    final jobProvider = context.watch<JobProvider>();
    final jobs = jobProvider.filteredJobs;
    final isLoading = jobProvider.isLoading;
    final isArabic = jobProvider.isArabic;

    final flightDeals = jobs.isNotEmpty
        ? jobs.first.contextualDeals.where((d) => d.type == AffiliateDealType.flight).toList()
        : <AffiliateDealModel>[];
    final hotelDeals = jobs.isNotEmpty
        ? jobs.first.contextualDeals.where((d) => d.type == AffiliateDealType.hotel).toList()
        : <AffiliateDealModel>[];

    final int? totalJobCount = isLoading ? null : jobs.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.dashboard,
        isArabic: isArabic,
        onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: PageTransitionWrapper(
        child: Column(
          children: [
            // ── Pinned header ──────────────────────────────────────────────
            AppHeader(
              activeRoute: AppRoutes.dashboard,
              isArabic: isArabic,
              onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
            ).animate().fadeIn(duration: 300.ms),

            // ── Animated stats strip ───────────────────────────────────────
            if (!isLoading)
              _StatsStrip(jobCount: jobs.length, isArabic: isArabic),

            // ── Body ───────────────────────────────────────────────────────
            Expanded(
              child: isDesktop
                  ? _DesktopLayout(
                      jobs: jobs,
                      flightDeals: flightDeals,
                      hotelDeals: hotelDeals,
                      jobsLoading: isLoading,
                      dealsLoading: isLoading,
                      totalJobCount: totalJobCount,
                      isArabic: isArabic,
                    )
                  : _MobileLayout(
                      jobs: jobs,
                      flightDeals: flightDeals,
                      hotelDeals: hotelDeals,
                      jobsLoading: isLoading,
                      dealsLoading: isLoading,
                      totalJobCount: totalJobCount,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _StatsStrip — Animated horizontal stats bar below the header
// ════════════════════════════════════════════════════════════════════════════
class _StatsStrip extends StatelessWidget {
  const _StatsStrip({required this.jobCount, required this.isArabic});
  final int jobCount;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSurface,
        border: const Border(bottom: BorderSide(color: AppColors.borderSubtle)),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.accentBlueMuted.withValues(alpha: 0.15),
            AppColors.backgroundSurface,
            AppColors.accentGreenMuted.withValues(alpha: 0.1),
          ],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _StatChip(
            icon: Icons.work_outline_rounded,
            value: '$jobCount',
            label: isArabic ? 'وظيفة متاحة' : 'Live Jobs',
            color: AppColors.accentBlue,
            delay: 0,
          ),
          const SizedBox(width: 16),
          _StatChip(
            icon: Icons.public_rounded,
            value: '12+',
            label: isArabic ? 'دولة أوروبية' : 'EU Countries',
            color: AppColors.accentGreen,
            delay: 80,
          ),
          const SizedBox(width: 16),
          _StatChip(
            icon: Icons.smart_toy_outlined,
            value: 'AI',
            label: isArabic ? 'مطابقة ذكية' : 'Smart Match',
            color: const Color(0xFFF59E0B),
            delay: 160,
          ),
          const Spacer(),
          // Live indicator
          Row(children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: AppColors.accentGreen,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: AppColors.accentGreen.withValues(alpha: 0.6), blurRadius: 6, spreadRadius: 1)],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(0.7, 0.7), end: const Offset(1.3, 1.3), duration: 900.ms),
            const SizedBox(width: 6),
            Text(
              isArabic ? 'تحديث مباشر' : 'Live Updates',
              style: AppTextStyles.labelSmall.copyWith(color: AppColors.accentGreen, fontSize: 11),
            ),
          ]).animate(delay: 300.ms).fadeIn(),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: -0.2, end: 0, duration: 400.ms);
  }
}

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.delay,
  });
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final int delay;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: color),
      ),
      const SizedBox(width: 8),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: color, height: 1.1)),
          Text(label, style: AppTextStyles.labelSmall.copyWith(fontSize: 10)),
        ],
      ),
    ]).animate(delay: Duration(milliseconds: delay + 200))
        .fadeIn(duration: 400.ms)
        .slideX(begin: -0.1, end: 0, duration: 350.ms);
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _DesktopLayout — 70/30 split with RTL awareness
// ════════════════════════════════════════════════════════════════════════════
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.jobs,
    required this.flightDeals,
    required this.hotelDeals,
    required this.jobsLoading,
    required this.dealsLoading,
    required this.totalJobCount,
    required this.isArabic,
  });
  final List<JobModel> jobs;
  final List<AffiliateDealModel> flightDeals;
  final List<AffiliateDealModel> hotelDeals;
  final bool jobsLoading;
  final bool dealsLoading;
  final int? totalJobCount;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 70% job grid
          Expanded(
            flex: 70,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: JobGridSection(
                jobs: jobs,
                isLoading: jobsLoading,
                totalJobCount: totalJobCount,
                onFilterTap: () {},
              ),
            ),
          ),
          // Divider with gradient
          Container(
            width: 1,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.accentBlue.withValues(alpha: 0.3),
                  AppColors.borderSubtle,
                  AppColors.accentGreen.withValues(alpha: 0.2),
                ],
              ),
            ),
          ),
          // 30% sidebar
          Expanded(
            flex: 30,
            child: ClipRect(
              child: SizedBox(
                height: double.infinity,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: SidebarSection(
                    flightDeals: flightDeals,
                    hotelDeals: hotelDeals,
                    isLoading: dealsLoading,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _MobileLayout — stacked
// ════════════════════════════════════════════════════════════════════════════
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.jobs,
    required this.flightDeals,
    required this.hotelDeals,
    required this.jobsLoading,
    required this.dealsLoading,
    required this.totalJobCount,
  });
  final List<JobModel> jobs;
  final List<AffiliateDealModel> flightDeals;
  final List<AffiliateDealModel> hotelDeals;
  final bool jobsLoading;
  final bool dealsLoading;
  final int? totalJobCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          JobGridSection(
            jobs: jobs,
            isLoading: jobsLoading,
            totalJobCount: totalJobCount,
            onFilterTap: () {},
          ),
          const Divider(color: AppColors.borderSubtle, height: 1, thickness: 1),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SidebarSection(
              flightDeals: flightDeals,
              hotelDeals: hotelDeals,
              isLoading: dealsLoading,
            ),
          ),
        ],
      ),
    );
  }
}
