import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_profile_model.dart';
import '../../../core/providers/job_provider.dart';
import '../../../routing/app_router.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvGridSection
//
// Top workspace panel in User Profile Dashboard showing generated CV cards.
//
// Data source: jobProvider.profile.generatedCvs — built dynamically from
// the CV Builder form (profession field drives the card title and filename).
// The list is NEVER pre-populated with static placeholders.
//
// Empty state: encourages the user to open the CV Builder.
// ════════════════════════════════════════════════════════════════════════════
class CvGridSection extends StatelessWidget {
  const CvGridSection({
    super.key,
    required this.cvs,
    required this.onDownload,
  });

  final List<UserCvModel> cvs;
  final ValueChanged<UserCvModel> onDownload;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.select<JobProvider, bool>((p) => p.isArabic);

    return Column(
      crossAxisAlignment:
          isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        // ── Section heading ────────────────────────────────────────────
        Text(
          isArabic ? 'السير الذاتية المُنشأة' : 'My Generated CVs',
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),

        // ── Grid / empty state ─────────────────────────────────────────
        if (cvs.isEmpty)
          _buildEmptyState(context, isArabic)
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth >= 900
                  ? 3
                  : constraints.maxWidth >= 600
                      ? 2
                      : 1;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.8,
                ),
                itemCount: cvs.length,
                itemBuilder: (context, index) {
                  final cv = cvs[index];
                  return _CvCard(
                    cv: cv,
                    isArabic: isArabic,
                    onDownload: () => onDownload(cv),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isArabic) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.description_outlined,
                color: AppColors.textDisabled, size: 28),
            const SizedBox(height: 10),
            Text(
              isArabic
                  ? 'لم يتم إنشاء أي سيرة ذاتية بعد'
                  : 'No CVs generated yet',
              style:
                  AppTextStyles.bodyMedium.copyWith(fontSize: 13),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => context.go(AppRoutes.cvBuilder),
              icon: const Icon(Icons.add_rounded, size: 15),
              label: Text(
                  isArabic ? 'إنشاء سيرة ذاتية' : 'Build a CV'),
              style: OutlinedButton.styleFrom(
                textStyle: AppTextStyles.bodyMedium
                    .copyWith(fontSize: 12),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 6),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── _CvCard ───────────────────────────────────────────────────────────────────
class _CvCard extends StatefulWidget {
  const _CvCard({
    required this.cv,
    required this.isArabic,
    required this.onDownload,
  });

  final UserCvModel cv;
  final bool isArabic;
  final VoidCallback onDownload;

  @override
  State<_CvCard> createState() => _CvCardState();
}

class _CvCardState extends State<_CvCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final ar = widget.isArabic;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.backgroundSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? AppColors.accentBlue.withValues(alpha: 0.5)
                : AppColors.borderSubtle,
          ),
          boxShadow: _hovered
              ? const [
                  BoxShadow(
                    color: AppColors.accentBlueGlow,
                    blurRadius: 14,
                    offset: Offset(0, 4),
                  )
                ]
              : const [],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── CV Job Title (dynamic from CV Builder) ──────────────
            Text(
              widget.cv.jobTitle,
              textAlign: ar ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.headlineMedium.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // ── Filename ────────────────────────────────────────────
            Text(
              widget.cv.fileName,
              textAlign: ar ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const Spacer(),

            // ── Download PDF button ─────────────────────────────────
            SizedBox(
              height: 36,
              child: ElevatedButton.icon(
                onPressed: widget.onDownload,
                icon: const Icon(Icons.file_download_outlined, size: 14),
                label: Text(ar ? 'تحميل PDF' : 'Download PDF'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: AppTextStyles.buttonPrimary
                      .copyWith(fontSize: 11),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
