import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../core/models/job_model.dart';
import '../../../core/providers/job_provider.dart';
import '../../../routing/app_router.dart';
import '../../../theme/app_theme.dart';
import 'match_badge_widget.dart';

// ════════════════════════════════════════════════════════════════════════════
// JobCardWidget
// Ultra-modern card design with glassmorphic borders, Lucide icons, and
// smooth staggered entrance animations powered by flutter_animate.
// ════════════════════════════════════════════════════════════════════════════
class JobCardWidget extends StatefulWidget {
  const JobCardWidget({super.key, required this.job});
  final JobModel job;

  @override
  State<JobCardWidget> createState() => _JobCardWidgetState();
}

class _JobCardWidgetState extends State<JobCardWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<JobProvider>().isArabic;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('${AppRoutes.jobs}/${widget.job.id}'),
        child: AnimatedScale(
          scale: _hovered ? 1.02 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _hovered
                    ? AppColors.accentBlue.withValues(alpha: 0.6)
                    : AppColors.borderSubtle,
                width: _hovered ? 1.5 : 1.0,
              ),
              boxShadow: _hovered
                  ? const [
                      BoxShadow(
                        color: AppColors.accentBlueGlow,
                        blurRadius: 24,
                        spreadRadius: 1,
                        offset: Offset(0, 8),
                      ),
                    ]
                  : const [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _HeroImage(job: widget.job),
                _ContentPane(job: widget.job, isArabic: isArabic),
                _ActionsRow(job: widget.job, isArabic: isArabic),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0);
  }
}

// ── _HeroImage ───────────────────────────────────────────────────────────────
class _HeroImage extends StatelessWidget {
  const _HeroImage({required this.job});
  final JobModel job;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      child: SizedBox(
        height: 145,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (job.heroImageUrl != null && job.heroImageUrl!.isNotEmpty)
              CachedNetworkImage(
                imageUrl: job.heroImageUrl!,
                fit: BoxFit.cover,
                memCacheWidth: 400,
                memCacheHeight: 280,
                placeholder: (_, __) => const _HeroPlaceholder(),
                errorWidget: (_, __, ___) => const _HeroPlaceholder(),
              )
            else
              const _HeroPlaceholder(),

            // Bottom gradient for legibility
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.4, 1.0],
                    colors: [
                      Colors.transparent,
                      AppColors.backgroundSurface.withValues(alpha: 0.95),
                    ],
                  ),
                ),
              ),
            ),

            // Match badge — top-left
            Positioned(
              top: 10,
              left: 10,
              child: MatchBadgeWidget(percentage: job.matchPercentage),
            ),

            // Country flag — top-right
            if (job.countryFlagEmoji != null)
              Positioned(
                top: 10,
                right: 10,
                child: _FlagBubble(emoji: job.countryFlagEmoji!),
              ),

            // NEW tag — bottom-left
            if (job.isNew == true)
              const Positioned(
                bottom: 10,
                left: 10,
                child: _NewTag(),
              ),
          ],
        ),
      ),
    );
  }
}

class _HeroPlaceholder extends StatelessWidget {
  const _HeroPlaceholder();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accentBlueMuted, AppColors.backgroundElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.work_outline_rounded,
            color: AppColors.borderSubtle, size: 36),
      ),
    );
  }
}

class _FlagBubble extends StatelessWidget {
  const _FlagBubble({required this.emoji});
  final String emoji;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderSubtle.withValues(alpha: 0.6)),
      ),
      child: Text(emoji, style: const TextStyle(fontSize: 16)),
    );
  }
}

class _NewTag extends StatelessWidget {
  const _NewTag();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentBlue,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'NEW',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── _ContentPane ─────────────────────────────────────────────────────────────
class _ContentPane extends StatelessWidget {
  const _ContentPane({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final salary = job.formattedSalary();
    final rawTitle =
        isArabic ? (job.titleAr ?? job.title ?? '') : (job.title ?? '');
    final displayTitle = isArabic ? _cleanArabicText(rawTitle) : _cleanEnglishText(rawTitle);

    final displayCompany = job.company ?? '';
    final rawLocation =
        isArabic ? (job.locationAr ?? job.location ?? '') : (job.location ?? '');
    final displayLocation = isArabic ? _cleanArabicText(rawLocation) : _cleanEnglishText(rawLocation);

    final rawDesc =
        isArabic ? (job.descriptionAr ?? job.description ?? '') : (job.description ?? '');
    final displayDesc = isArabic ? _cleanArabicText(rawDesc) : _cleanEnglishText(rawDesc);

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
      child: Column(
        crossAxisAlignment:
            isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Category & Job Type Tags
          Row(
            mainAxisAlignment:
                isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (job.jobType != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentBlueMuted.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                        color: AppColors.accentBlue.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    job.jobType!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.accentBlueLighter,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              if (job.category != null)
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundElevated,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: AppColors.borderSubtle),
                    ),
                    child: Text(
                      job.category!,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Job Title
          if (displayTitle.isNotEmpty)
            Text(
              displayTitle,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.headlineMedium.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 6),

          // Company & Location Row with Lucide icons
          Row(
            mainAxisAlignment:
                isArabic ? MainAxisAlignment.end : MainAxisAlignment.start,
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            children: [
              if (displayCompany.isNotEmpty) ...[
                const Icon(Icons.business_rounded,
                    size: 13, color: AppColors.accentBlue),
                const SizedBox(width: 5),
                Flexible(
                  child: Text(
                    displayCompany,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (displayLocation.isNotEmpty) ...[
                const Icon(Icons.location_on_outlined,
                    size: 13, color: AppColors.textSecondary),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    displayLocation,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 8),

          // Description Snippet
          if (displayDesc.isNotEmpty)
            Text(
              displayDesc,
              textAlign: isArabic ? TextAlign.right : TextAlign.left,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

          const SizedBox(height: 10),

          // Salary Badge
          if (salary != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.accentGreenMuted.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                    color: AppColors.accentGreen.withValues(alpha: 0.4)),
              ),
              child: Text(
                salary,
                textAlign: isArabic ? TextAlign.right : TextAlign.left,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.accentGreen,
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ── _ActionsRow ──────────────────────────────────────────────────────────────
class _ActionsRow extends StatelessWidget {
  const _ActionsRow({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 38,
              child: ElevatedButton.icon(
                onPressed: () =>
                    context.go('${AppRoutes.jobs}/${job.id}'),
                icon: const Icon(Icons.open_in_new_rounded, size: 14),
                label: Text(isArabic ? 'تقديم الآن' : 'Apply Now'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle:
                      AppTextStyles.buttonPrimary.copyWith(fontSize: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SizedBox(
              height: 38,
              child: OutlinedButton.icon(
                onPressed: () =>
                    context.go('${AppRoutes.jobs}/${job.id}'),
                icon: const Icon(Icons.info_outline_rounded, size: 14),
                label: Text(isArabic ? 'التفاصيل' : 'Details'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  textStyle: AppTextStyles.buttonPrimary.copyWith(
                    fontSize: 12,
                    color: AppColors.accentBlue,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper to ensure clean language separation without combined strings like "عامل بناء (Construction Worker)".
String _cleanArabicText(String text) {
  if (text.isEmpty) return text;
  // Remove parenthetical English if present in combined strings
  return text.replaceAll(RegExp(r'\s*\([A-Za-z0-9\s,\.-]+\)'), '').trim();
}

String _cleanEnglishText(String text) {
  if (text.isEmpty) return text;
  // If text starts with English, keep English part
  final match = RegExp(r'^([A-Za-z0-9\s,\.\-\&\/]+)').firstMatch(text);
  if (match != null && match.group(1)!.trim().length > 2) {
    return match.group(1)!.trim();
  }
  return text;
}
