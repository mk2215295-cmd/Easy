import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/job_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_header.dart';
import 'widgets/jd_accommodation_section.dart';
import 'widgets/jd_apply_button.dart';
import 'widgets/jd_description_section.dart';
import 'widgets/jd_header_section.dart';
import 'widgets/jd_requirements_section.dart';
import 'widgets/jd_salary_section.dart';
import 'widgets/jd_sidebar.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JobDetailsScreen
//
// Renders the full job detail view based on the Phase 3 mockup.
// Accepts a [jobId] from the router path parameter (/jobs/:jobId).
//
// Layout (desktop ≥ 960 px wide):
//   ┌──────────────────────────────────────────────────────────────┐
//   │  AppHeader (pinned, 64 px)                                   │
//   ├───────────────────────────────┬──────────────────────────────┤
//   │  Left panel (70%)            │  Right sidebar (30%)         │
//   │  • JdHeaderSection           │  • JdSidebar (sticky)        │
//   │  • JdRequirementsSection     │    contextual deals          │
//   │  • JdSalarySection           │                              │
//   │  • JdAccommodationSection    │                              │
//   │  • JdApplyButton (neon CTA)  │                              │
//   └───────────────────────────────┴──────────────────────────────┘
//
// Mobile (< 960 px): single column, sidebar below content.
//
// Data wiring (Phase 4):
//   Uses [JobProvider] state management to get details dynamically.
//   Handles loading / empty states with native skeleton widgets.
// ════════════════════════════════════════════════════════════════════════════════

class JobDetailsScreen extends StatefulWidget {
  const JobDetailsScreen({super.key, required this.jobId});

  /// Job identifier from the URL path parameter (:jobId).
  final String jobId;

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 960;

    // Listen to changes in JobProvider state
    final jobProvider = context.watch<JobProvider>();
    final isLoading = jobProvider.isLoading;
    final job = jobProvider.getJobById(widget.jobId);
    final isArabic = jobProvider.isArabic;

    // If not loading and job isn't found, we can show a skeleton or error state
    final showLoading = isLoading || (job == null);

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.jobs,
        isArabic: isArabic,
        onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: Column(
        children: [
          // ── Pinned header ───────────────────────────────────────────
          AppHeader(
            activeRoute: AppRoutes.jobs,
            isArabic: isArabic,
            onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
          ),

          // ── Body ────────────────────────────────────────────────────
          Expanded(
            child: isDesktop
                ? _DesktopLayout(
                    job: job,
                    isLoading: showLoading,
                    isArabic: isArabic,
                  )
                : _MobileLayout(
                    job: job,
                    isLoading: showLoading,
                    isArabic: isArabic,
                  ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _DesktopLayout — 70 / 30 split
// ════════════════════════════════════════════════════════════════════════════════
class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout({
    required this.job,
    required this.isLoading,
    required this.isArabic,
  });

  final JobModel? job;
  final bool isLoading;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Left 70% — scrollable job content ─────────────────────
        Expanded(
          flex: 70,
          child: _JobContentPanel(
            job: job,
            isLoading: isLoading,
            isArabic: isArabic,
          ),
        ),

        // ── Right 30% — sticky contextual sidebar ─────────────────
        SizedBox(
          width: 320,
          height: double.infinity,
          child: JdSidebar(
            deals: job?.contextualDeals ?? const [],
            isLoading: isLoading,
            titleAr: job?.sidebarTitleAr,
            titleEn: job?.sidebarTitleEn,
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _MobileLayout — stacked
// ════════════════════════════════════════════════════════════════════════════════
class _MobileLayout extends StatelessWidget {
  const _MobileLayout({
    required this.job,
    required this.isLoading,
    required this.isArabic,
  });

  final JobModel? job;
  final bool isLoading;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _JobContentPanel(
            job: job,
            isLoading: isLoading,
            isArabic: isArabic,
            scrollable: false, // parent handles scroll
          ),
          const Divider(color: AppColors.borderSubtle, height: 1),
          SizedBox(
            height: 520,
            child: JdSidebar(
              deals: job?.contextualDeals ?? const [],
              isLoading: isLoading,
              titleAr: job?.sidebarTitleAr,
              titleEn: job?.sidebarTitleEn,
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _JobContentPanel — scrollable left panel containing all JD sections.
// When [scrollable] is false the panel uses a Column without scroll (used in
// the mobile layout where the outer SingleChildScrollView handles scrolling).
// ════════════════════════════════════════════════════════════════════════════════
class _JobContentPanel extends StatelessWidget {
  const _JobContentPanel({
    required this.job,
    required this.isLoading,
    required this.isArabic,
    this.scrollable = true,
  });

  final JobModel? job;
  final bool isLoading;
  final bool isArabic;
  final bool scrollable;

  Widget _buildContent(BuildContext context) {
    final isDesktop = MediaQuery.sizeOf(context).width >= 600;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── 1. Bilingual title + back button ──────────────────────
          JdHeaderSection(job: job),

          // ── 2. Full Published Job Description ──────────────────────
          JdDescriptionSection(
            job: job,
            isLoading: isLoading,
            isArabic: isArabic,
          ),

          // ── 3. Requirements grid ──────────────────────────────────
          JdRequirementsSection(
            requirements: job?.requirements ?? const [],
            isLoading: isLoading,
            isArabic: isArabic,
          ),

          // ── 3. Salary + benefit chips ─────────────────────────────
          JdSalarySection(
            job: job,
            isLoading: isLoading,
            isArabic: isArabic,
          ),

          // ── 4. Accommodation photos + description ─────────────────
          JdAccommodationSection(
            job: job,
            isLoading: isLoading,
            isArabic: isArabic,
          ),

          const SizedBox(height: 8),

          // ── 5. Neon apply CTA ─────────────────────────────────────
          JdApplyButton(
            job: job,
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return SingleChildScrollView(child: _buildContent(context));
    }
    return _buildContent(context);
  }
}
