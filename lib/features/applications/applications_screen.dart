import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/models/user_profile_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_header.dart';

// ════════════════════════════════════════════════════════════════════════════
// ApplicationsScreen  (/applications)
//
// Displays the user's submitted job applications, pulled live from the global
// [JobProvider] → [UserProfileModel.applications] list.
//
// Status badge colours:
//   • Application Submitted  → blue
//   • Reviewed               → amber
//   • Interview Scheduled    → green
//   • Rejected               → red
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
        onLanguageToggle: (v) =>
            jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: Column(
        children: [
          // ── Pinned universal header ──────────────────────────────────
          AppHeader(
            activeRoute: AppRoutes.applications,
            isArabic: isArabic,
            onLanguageToggle: (v) =>
                jobProvider.setLocaleCode(v ? 'ar' : 'en'),
          ),

          // ── Page heading ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Row(
              mainAxisAlignment: isArabic
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                const Icon(Icons.assignment_turned_in_outlined,
                    color: AppColors.accentBlue, size: 22),
                const SizedBox(width: 10),
                Text(
                  isArabic ? 'طلباتي' : 'My Applications',
                  style: AppTextStyles.headlineLarge.copyWith(fontSize: 22),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: isArabic
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? '${applications.length} طلب مقدم'
                      : '${applications.length} submitted',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ── Content ──────────────────────────────────────────────────
          Expanded(
            child: applications.isEmpty
                ? _EmptyState(isArabic: isArabic)
                : _ApplicationList(
                    applications: applications,
                    isArabic: isArabic,
                  ),
          ),
        ],
      ),
    );
  }
}

// ── _ApplicationList ──────────────────────────────────────────────────────────
class _ApplicationList extends StatelessWidget {
  const _ApplicationList(
      {required this.applications, required this.isArabic});

  final List<AppliedApplicationModel> applications;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
      itemCount: applications.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) =>
          _ApplicationCard(app: applications[i], isArabic: isArabic),
    );
  }
}

// ── _ApplicationCard ─────────────────────────────────────────────────────────
class _ApplicationCard extends StatefulWidget {
  const _ApplicationCard({required this.app, required this.isArabic});
  final AppliedApplicationModel app;
  final bool isArabic;

  @override
  State<_ApplicationCard> createState() => _ApplicationCardState();
}

class _ApplicationCardState extends State<_ApplicationCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final app = widget.app;
    final ar = widget.isArabic;
    final statusColor = _statusColor(app.status);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.backgroundElevated
              : AppColors.backgroundSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? AppColors.accentBlue.withValues(alpha: 0.4)
                : AppColors.borderSubtle,
          ),
        ),
        child: Row(
          textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
          children: [
            // Status colour dot
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: statusColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.5),
                    blurRadius: 6,
                    spreadRadius: 1,
                  )
                ],
              ),
            ),
            const SizedBox(width: 14),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment:
                    ar ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    app.jobTitle,
                    textAlign: ar ? TextAlign.right : TextAlign.left,
                    style: AppTextStyles.headlineMedium
                        .copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${app.companyName}  •  ${app.location}',
                    textAlign: ar ? TextAlign.right : TextAlign.left,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    app.appliedDate,
                    textAlign: ar ? TextAlign.right : TextAlign.left,
                    style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 11,
                        color: AppColors.textDisabled),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),

            // Status badge
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: statusColor.withValues(alpha: 0.4)),
              ),
              child: Text(
                ar ? _statusAr(app.status) : app.status,
                style: AppTextStyles.labelSmall.copyWith(
                  color: statusColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    return switch (status.toLowerCase()) {
      String s when s.contains('interview') => AppColors.accentGreen,
      String s when s.contains('reviewed') => const Color(0xFFFFB347),
      String s when s.contains('rejected') => AppColors.error,
      _ => AppColors.accentBlue,
    };
  }

  String _statusAr(String status) {
    return switch (status.toLowerCase()) {
      String s when s.contains('interview') => 'مقابلة مجدولة',
      String s when s.contains('reviewed') => 'تمت المراجعة',
      String s when s.contains('rejected') => 'مرفوض',
      _ => 'تم التقديم',
    };
  }
}

// ── _EmptyState ──────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isArabic});
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.inbox_outlined,
              color: AppColors.textDisabled, size: 52),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا يوجد طلبات بعد' : 'No applications yet',
            style: AppTextStyles.headlineMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
