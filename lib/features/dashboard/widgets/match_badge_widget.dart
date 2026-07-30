import 'package:flutter/material.dart';

import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// MatchBadgeWidget
// Glowing green pill badge showing the AI match score (e.g. "85% Match").
// Displayed on the top-left corner of every job card hero image.
// Percentage value always comes from the API — no hardcoded numbers here.
// ════════════════════════════════════════════════════════════════════════════════
class MatchBadgeWidget extends StatelessWidget {
  const MatchBadgeWidget({super.key, required this.percentage});

  /// Match percentage integer from API (0–100). Displays nothing if null.
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    if (percentage == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.accentGreen,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: AppColors.accentGreenGlow,
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppColors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            '$percentage% Match',
            style: AppTextStyles.matchBadge,
          ),
        ],
      ),
    );
  }
}
