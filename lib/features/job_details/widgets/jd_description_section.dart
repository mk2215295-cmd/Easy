import 'package:flutter/material.dart';

import '../../../core/models/job_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JdDescriptionSection
// Renders full authentic job description text, duties, and responsibilities.
// Preserves exact published text without generic fallbacks or truncation.
// ════════════════════════════════════════════════════════════════════════════════
class JdDescriptionSection extends StatelessWidget {
  const JdDescriptionSection({
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
    final text = (isArabic ? job?.descriptionAr : job?.description) ??
        job?.description ??
        job?.descriptionAr;

    if (text == null || text.trim().isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),
        Text(
          isArabic ? 'تفاصيل الوظيفة والمهام المعلنة:' : 'Job Overview & Responsibilities:',
          textAlign: TextAlign.right,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: AppColors.backgroundElevated,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Text(
            text,
            textAlign: isArabic ? TextAlign.right : TextAlign.left,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              height: 1.65,
              fontSize: 13.5,
            ),
          ),
        ),
        const SizedBox(height: 24),
        const Divider(color: AppColors.borderSubtle, height: 1),
      ],
    );
  }
}
