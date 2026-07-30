import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_profile_model.dart';
import '../../../core/providers/job_provider.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// ApplicationsTableSection
//
// Bottom workspace panel showing submitted applications.
//
// Data source: jobProvider.profile.applications — rows are added ONLY when
// the user taps "Apply Now" in JobDetailsScreen. No static placeholder rows.
//
// Features:
//   • Locale-aware column headers (Arabic / English)
//   • Arabic status label translation
//   • Colour-coded status pills
//   • Empty state that explains how to get rows added
// ════════════════════════════════════════════════════════════════════════════
class ApplicationsTableSection extends StatelessWidget {
  const ApplicationsTableSection({
    super.key,
    required this.applications,
  });

  final List<AppliedApplicationModel> applications;

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.select<JobProvider, bool>((p) => p.isArabic);

    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // ── Section heading ────────────────────────────────────────────
        Text(
          isArabic ? 'جدول حالة الطلبات المقدمة' : 'Applied Applications Status',
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),

        // ── Table container ────────────────────────────────────────────
        Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header row
              _TableHeader(isArabic: isArabic),
              const Divider(color: AppColors.borderSubtle, height: 1),

              // Body rows
              if (applications.isEmpty)
                _EmptyState(isArabic: isArabic)
              else
                ...List.generate(applications.length, (i) {
                  final app = applications[i];
                  final isLast = i == applications.length - 1;
                  return Column(
                    children: [
                      _TableRow(app: app, isArabic: isArabic),
                      if (!isLast)
                        const Divider(
                            color: AppColors.borderSubtle, height: 1),
                    ],
                  );
                }),
            ],
          ),
        ),
      ],
    );
  }
}

// ── _TableHeader ──────────────────────────────────────────────────────────────
class _TableHeader extends StatelessWidget {
  const _TableHeader({required this.isArabic});
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundElevated.withValues(alpha: 0.3),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        textDirection:
            isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Expanded(
              flex: 3,
              child: _H(isArabic ? 'المسمى الوظيفي' : 'Job Title',
                  isArabic)),
          Expanded(
              flex: 3,
              child: _H(isArabic ? 'الشركة' : 'Company', isArabic)),
          Expanded(
              flex: 3,
              child:
                  _H(isArabic ? 'الموقع' : 'Location', isArabic)),
          Expanded(
              flex: 2,
              child:
                  _H(isArabic ? 'التاريخ' : 'Date', isArabic)),
          Expanded(
              flex: 2,
              child:
                  _H(isArabic ? 'الحالة' : 'Status', isArabic)),
        ],
      ),
    );
  }
}

class _H extends StatelessWidget {
  const _H(this.text, this.isArabic);
  final String text;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: isArabic ? TextAlign.right : TextAlign.left,
      style: AppTextStyles.labelSmall.copyWith(
        fontWeight: FontWeight.bold,
        color: AppColors.textSecondary,
        fontSize: 11,
      ),
    );
  }
}

// ── _TableRow ─────────────────────────────────────────────────────────────────
class _TableRow extends StatelessWidget {
  const _TableRow({required this.app, required this.isArabic});
  final AppliedApplicationModel app;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        textDirection:
            isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          // Job Title
          Expanded(
            flex: 3,
            child: Text(
              app.jobTitle,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.titleMedium
                  .copyWith(fontSize: 13, color: AppColors.textPrimary),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Company
          Expanded(
            flex: 3,
            child: Text(
              app.companyName,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Location
          Expanded(
            flex: 3,
            child: Text(
              app.location,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Date
          Expanded(
            flex: 2,
            child: Text(
              app.appliedDate,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
            ),
          ),
          // Status pill
          Expanded(
            flex: 2,
            child: Align(
              alignment: isArabic
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: _StatusPill(
                  status: app.status, isArabic: isArabic),
            ),
          ),
        ],
      ),
    );
  }
}

// ── _StatusPill ───────────────────────────────────────────────────────────────
class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status, required this.isArabic});
  final String status;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final lower = status.toLowerCase();

    Color text;
    Color bg;
    Color border;

    if (lower.contains('reviewed')) {
      text = AppColors.accentGreen;
      bg = AppColors.accentGreenMuted.withValues(alpha: 0.2);
      border = AppColors.accentGreen.withValues(alpha: 0.3);
    } else if (lower.contains('interview')) {
      text = AppColors.accentBlueLighter;
      bg = AppColors.accentBlueMuted.withValues(alpha: 0.2);
      border = AppColors.accentBlue.withValues(alpha: 0.3);
    } else if (lower.contains('rejected')) {
      text = AppColors.error;
      bg = AppColors.error.withValues(alpha: 0.12);
      border = AppColors.error.withValues(alpha: 0.3);
    } else {
      // Application Submitted (default)
      text = AppColors.textSecondary;
      bg = AppColors.backgroundElevated.withValues(alpha: 0.6);
      border = AppColors.borderSubtle;
    }

    final displayLabel = isArabic ? _toArabic(lower) : status;

    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Text(
        displayLabel,
        textAlign: TextAlign.center,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 10,
          color: text,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _toArabic(String lower) {
    if (lower.contains('interview')) return 'مقابلة مجدولة';
    if (lower.contains('reviewed')) return 'تمت المراجعة';
    if (lower.contains('rejected')) return 'مرفوض';
    return 'تم التقديم';
  }
}

// ── _EmptyState ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isArabic});
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          children: [
            const Icon(Icons.inbox_outlined,
                color: AppColors.textDisabled, size: 32),
            const SizedBox(height: 10),
            Text(
              isArabic
                  ? 'لا توجد طلبات بعد. اضغط "تقديم الآن" من صفحة تفاصيل أي وظيفة.'
                  : 'No applications yet. Tap "Apply Now" on any job to track it here.',
              textAlign: TextAlign.center,
              style:
                  AppTextStyles.bodyMedium.copyWith(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
