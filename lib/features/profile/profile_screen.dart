import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/user_profile_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../core/services/pdf_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/ad_sidebar_widget.dart';
import '../../widgets/animations/page_transition_wrapper.dart';
import '../../widgets/common/app_header.dart';
import 'widgets/applications_table_section.dart';
import 'widgets/cv_grid_section.dart';
import 'widgets/profile_sidebar.dart';

// ════════════════════════════════════════════════════════════════════════════
// ProfileScreen  (/profile)
//
// User Profile Dashboard.  Every piece of data here is live from
// [JobProvider] — nothing is hardcoded.
//
// CV cards:  driven by JobProvider._cv.profession (updated via CV Builder).
//            If the user hasn't filled in a profession yet, the grid shows
//            an empty state with a shortcut to /cv-builder.
//
// Applications table:  driven by JobProvider.profile.applications.
//                       Rows are added ONLY when the user taps "Apply Now"
//                       on a JobDetailsScreen — never pre-populated.
//
// Responsive:
//   Desktop ≥ 960 px — sidebar (280 px) + main workspace side-by-side.
//   Mobile           — sidebar above, content below.
// ════════════════════════════════════════════════════════════════════════════
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _activeMenu = 'dashboard';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 960;

    final jobProvider = context.watch<JobProvider>();
    final profile = jobProvider.profile;
    final isArabic = jobProvider.isArabic;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.profile,
        isArabic: isArabic,
        onLanguageToggle: (v) =>
            jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: PageTransitionWrapper(
        child: Column(
          children: [
            // ── Pinned universal header ──────────────────────────────────
            AppHeader(
              activeRoute: AppRoutes.profile,
              isArabic: isArabic,
              onLanguageToggle: (v) =>
                  jobProvider.setLocaleCode(v ? 'ar' : 'en'),
            ),

            // ── Body ─────────────────────────────────────────────────────
            Expanded(
              child: isDesktop
                  ? _buildDesktopLayout(profile, jobProvider, isArabic)
                  : _buildMobileLayout(profile, jobProvider, isArabic),
            ),
          ],
        ),
      ),
    );
  }

  // ── Desktop: sidebar + scrollable workspace + monetization panel ───────────
  Widget _buildDesktopLayout(
    UserProfileModel profile,
    JobProvider jobProvider,
    bool isArabic,
  ) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final showAdSidebar = screenWidth >= 1200;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Navigation sidebar (fixed 270 px)
        SizedBox(
          width: 270,
          height: double.infinity,
          child: ProfileSidebar(
            profile: profile,
            activeMenu: _activeMenu,
            onMenuChanged: (id) => setState(() => _activeMenu = id),
            onLogOut: () {},
          ),
        ),

        // Central workspace
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: _WorkspaceContent(
              profile: profile,
              isArabic: isArabic,
              jobProvider: jobProvider,
            ),
          ),
        ),

        // 30% Reserved Monetization Sidebar on wide desktop
        if (showAdSidebar)
          const SizedBox(
            width: 320,
            height: double.infinity,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: AdSidebarWidget(),
            ),
          ),
      ],
    );
  }

  // ── Mobile: stacked ────────────────────────────────────────────────────────
  Widget _buildMobileLayout(
    UserProfileModel profile,
    JobProvider jobProvider,
    bool isArabic,
  ) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileSidebar(
            profile: profile,
            activeMenu: _activeMenu,
            onMenuChanged: (id) => setState(() => _activeMenu = id),
            onLogOut: () {},
          ),
          const Divider(color: AppColors.borderSubtle, height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _WorkspaceContent(
              profile: profile,
              isArabic: isArabic,
              jobProvider: jobProvider,
            ),
          ),
        ],
      ),
    );
  }
}

// ── _WorkspaceContent ─────────────────────────────────────────────────────────
// Extracted so both desktop and mobile share the same content widget.
// All data flows in from the provider — zero hardcoded strings here.
class _WorkspaceContent extends StatelessWidget {
  const _WorkspaceContent({
    required this.profile,
    required this.isArabic,
    required this.jobProvider,
  });

  final UserProfileModel profile;
  final bool isArabic;
  final JobProvider jobProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Page heading (locale-aware)
        Text(
          isArabic
              ? 'لوحة تحكم الملف الشخصي — ${profile.fullName}'
              : 'Profile Dashboard — ${profile.fullName}',
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.headlineLarge.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        // ── My Generated CVs grid ──────────────────────────────────────
        // cvs list is built dynamically from CV Builder form state.
        CvGridSection(
          cvs: profile.generatedCvs,
          onDownload: (cv) {
            PdfService().downloadUserCvPdf(profile.fullName, cv);
          },
        ),

        const SizedBox(height: 32),

        // ── Applied Applications Status table ──────────────────────────
        // applications list grows only when user taps "Apply Now".
        ApplicationsTableSection(
          applications: profile.applications,
        ),
      ],
    );
  }
}
