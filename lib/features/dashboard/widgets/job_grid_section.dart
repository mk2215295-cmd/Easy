import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/job_model.dart';
import '../../../core/providers/job_provider.dart';
import '../../../theme/app_theme.dart';
import 'job_card_widget.dart';
import 'skeleton_job_card.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JobGridSection  — Left 70 % panel of the dashboard layout.
//
// Responsibilities:
//   • Section header: "Job Opportunities" title + bilingual sub-label +
//     a "Filters" dropdown button (wired to FilterPanel in Phase 3).
//   • Responsive grid:
//       ≥ 1000 px wide → 3 columns
//       600–999 px     → 2 columns
//       < 600 px       → 1 column
//   • Loading state: renders [skeletonCount] SkeletonJobCards while [isLoading].
//   • Empty state: friendly message when [jobs] is empty and not loading.
//   • Populated state: renders a JobCardWidget for each item in [jobs].
//
// ⚠ No strings are hardcoded — [jobs] list is injected by the parent screen
//   which will source data from the API service in Phase 3.
// ════════════════════════════════════════════════════════════════════════════════

class JobGridSection extends StatelessWidget {
  const JobGridSection({
    super.key,
    required this.jobs,
    this.isLoading = false,
    this.skeletonCount = 6,
    this.onFilterTap,
    this.totalJobCount,
  });

  /// Job list sourced from API. Empty by default until the service responds.
  final List<JobModel> jobs;

  /// Shows skeleton shimmer cards when true (API call in progress).
  final bool isLoading;

  /// Number of skeleton placeholder cards to show while loading.
  final int skeletonCount;

  /// Called when the user taps the Filters button.
  /// Parent screen will open the filter drawer / bottom sheet.
  final VoidCallback? onFilterTap;

  /// Total count from API pagination header (e.g. 143 jobs).
  final int? totalJobCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header ──────────────────────────────────────────────
          _SectionHeader(
            totalCount: totalJobCount,
            onFilterTap: onFilterTap,
          ),

          const SizedBox(height: 16),

          // ── Responsive Filter Chips ──────────────────────────────────────
          const _JobTypeFilterBar(),

          const SizedBox(height: 20),

          // ── Grid content ────────────────────────────────────────────────
          LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final int cols;
              if (width >= 1000) {
                cols = 3;
              } else if (width >= 600) {
                cols = 2;
              } else {
                cols = 1;
              }

              if (isLoading) {
                return _buildGrid(
                  cols: cols,
                  count: skeletonCount,
                  builder: (_) => const SkeletonJobCard(),
                );
              }

              if (jobs.isEmpty) {
                return _EmptyState();
              }

              return _buildGrid(
                cols: cols,
                count: jobs.length,
                builder: (i) => JobCardWidget(job: jobs[i]),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds a fixed-crossAxisCount grid with uniform item aspect ratio.
  Widget _buildGrid({
    required int cols,
    required int count,
    required Widget Function(int) builder,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        // Card aspect ratio tuned to match mockup proportions.
        // Adjust here if card content grows in future phases.
        childAspectRatio: cols == 1 ? 2.0 : 0.72,
      ),
      itemCount: count,
      itemBuilder: (_, i) => builder(i),
    );
  }
}

// ── _SectionHeader ─────────────────────────────────────────────────────────────
class _SectionHeader extends StatefulWidget {
  const _SectionHeader({this.totalCount, this.onFilterTap});
  final int? totalCount;
  final VoidCallback? onFilterTap;

  @override
  State<_SectionHeader> createState() => _SectionHeaderState();
}

class _SectionHeaderState extends State<_SectionHeader> {
  bool _filterHovered = false;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<JobProvider>().isArabic;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── Title block ────────────────────────────────────────────────
        Expanded(
          child: Column(
            crossAxisAlignment:
                isArabic ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              // Main title
              Text(
                isArabic ? 'فرص العمل المتاحة' : 'Job Opportunities',
                style: AppTextStyles.headlineLarge,
              ),
              const SizedBox(height: 4),
              // Subtitle / total count
              RichText(
                text: TextSpan(
                  style: AppTextStyles.bodyMedium,
                  children: [
                    TextSpan(
                      text: isArabic
                          ? 'فرص عمل موثوقة ومباشرة لملفك  ·  '
                          : 'Matching opportunities for your profile  ·  ',
                    ),
                    TextSpan(
                      text: widget.totalCount != null
                          ? (isArabic
                              ? '${widget.totalCount} وظيفة متاحة'
                              : '${widget.totalCount} listings')
                          : (isArabic
                              ? 'جاري جلب الوظائف المتاحة...'
                              : 'Connect API to load listings'),
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: widget.totalCount != null
                            ? AppColors.accentGreen
                            : AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 16),

        // ── Filters button ─────────────────────────────────────────────
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _filterHovered = true),
          onExit: (_) => setState(() => _filterHovered = false),
          child: GestureDetector(
            onTap: widget.onFilterTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _filterHovered
                    ? AppColors.accentBlueMuted
                    : AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _filterHovered
                      ? AppColors.accentBlue
                      : AppColors.borderSubtle,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 16,
                    color: _filterHovered
                        ? AppColors.accentBlue
                        : AppColors.textSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isArabic ? 'تصفية الوظائف' : 'Filters',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: _filterHovered
                          ? AppColors.accentBlue
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 16,
                    color: _filterHovered
                        ? AppColors.accentBlue
                        : AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── _EmptyState ────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: AppColors.textDisabled,
                size: 36,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Job Listings Found',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Connect the API to load real-time job opportunities.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── _JobTypeFilterBar ────────────────────────────────────────────────────────
class _JobTypeFilterBar extends StatelessWidget {
  const _JobTypeFilterBar();

  static const List<({String key, String labelEn, String labelAr, IconData icon})> _filters = [
    (key: 'All', labelEn: 'All Jobs', labelAr: 'كل الوظائف', icon: Icons.apps_rounded),
    (key: 'Full-Time', labelEn: 'Full-Time', labelAr: 'دوام كامل', icon: Icons.access_time_filled_rounded),
    (key: 'Part-Time', labelEn: 'Part-Time', labelAr: 'دوام جزئي', icon: Icons.schedule_rounded),
    (key: 'Volunteering', labelEn: 'Volunteering', labelAr: 'فرص التطوع', icon: Icons.volunteer_activism_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final activeFilter = jobProvider.selectedJobType;
    final isAr = jobProvider.isArabic;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          children: _filters.map((f) {
            final isSelected = activeFilter == f.key;
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: FilterChip(
                selected: isSelected,
                showCheckmark: false,
                avatar: Icon(
                  f.icon,
                  size: 14,
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
                label: Text(
                  isAr ? f.labelAr : f.labelEn,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.white : AppColors.textSecondary,
                  ),
                ),
                selectedColor: AppColors.accentBlue,
                backgroundColor: AppColors.backgroundElevated,
                side: BorderSide(
                  color: isSelected
                      ? AppColors.accentBlue
                      : AppColors.borderSubtle,
                  width: 1,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                onSelected: (_) => jobProvider.setJobTypeFilter(f.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
