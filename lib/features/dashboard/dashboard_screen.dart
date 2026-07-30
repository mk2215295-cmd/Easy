import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/affiliate_deal_model.dart';
import '../../core/models/job_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_header.dart';
import 'widgets/job_grid_section.dart';
import 'widgets/sidebar_section.dart';

// ════════════════════════════════════════════════════════════════════════════
// DashboardScreen
//
// Main entry-point screen. Assembles:
//   • Universal AppHeader (pinned, 64 px)
//   • Content body: on desktop ≥ 1000 px the job grid (70%) and affiliate
//     sidebar (30%) sit side-by-side. When the locale is Arabic the layout
//     uses TextDirection.rtl so the sidebar naturally appears on the LEFT
//     without any padding hacks.
//   • On mobile the two sections stack vertically.
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
        ? jobs.first.contextualDeals
            .where((d) => d.type == AffiliateDealType.flight)
            .toList()
        : <AffiliateDealModel>[];
    final hotelDeals = jobs.isNotEmpty
        ? jobs.first.contextualDeals
            .where((d) => d.type == AffiliateDealType.hotel)
            .toList()
        : <AffiliateDealModel>[];

    final int? totalJobCount = isLoading ? null : jobs.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.dashboard,
        isArabic: isArabic,
        onLanguageToggle: (v) =>
            jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: Column(
        children: [
          // ── Pinned header ────────────────────────────────────────────
          AppHeader(
            activeRoute: AppRoutes.dashboard,
            isArabic: isArabic,
            onLanguageToggle: (v) =>
                jobProvider.setLocaleCode(v ? 'ar' : 'en'),
          ),

          // ── Body ─────────────────────────────────────────────────────
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
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _DesktopLayout — 70 / 30 split with RTL awareness
//
// TextDirection.rtl flips the Row children order automatically when Arabic
// is active: sidebar appears on the LEFT, grid on the RIGHT — matching the
// native Arabic reading direction without any manual padding changes.
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
    // Wrapping in Directionality flips the Row order for RTL languages.
    // Individual text widgets still control their own textAlign/TextDirection.
    return Directionality(
      textDirection:
          isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 70% — scrollable job grid
          Expanded(
            flex: 70,
            child: Directionality(
              // Force content pane back to LTR so card internals stay stable
              textDirection: TextDirection.ltr,
              child: JobGridSection(
                jobs: jobs,
                isLoading: jobsLoading,
                totalJobCount: totalJobCount,
                onFilterTap: () {},
              ),
            ),
          ),

          // 30% — sticky affiliate sidebar strictly constrained
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
// _MobileLayout — stacked vertically, single scroll context
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
          const Divider(
            color: AppColors.borderSubtle,
            height: 1,
            thickness: 1,
          ),
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
