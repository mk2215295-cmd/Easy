import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../../core/models/job_model.dart';
import '../../../core/providers/job_provider.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/animations/page_transition_wrapper.dart';
import 'job_card_widget.dart';
import 'skeleton_job_card.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JobGridSection  — Enhanced with animated header, filter chips, and staggered grid.
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

  final List<JobModel> jobs;
  final bool isLoading;
  final int skeletonCount;
  final VoidCallback? onFilterTap;
  final int? totalJobCount;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Animated section header ──────────────────────────────────────
          AnimatedSectionHeader(
            title: context.watch<JobProvider>().isArabic ? 'فرص العمل المتاحة' : 'Job Opportunities',
            subtitle: totalJobCount != null
                ? (context.watch<JobProvider>().isArabic
                    ? '$totalJobCount وظيفة متاحة الآن'
                    : '$totalJobCount live listings')
                : null,
            trailing: _FilterButton(onTap: onFilterTap),
          ),

          const SizedBox(height: 16),

          // ── Filter chips ─────────────────────────────────────────────────
          const _JobTypeFilterBar(),

          const SizedBox(height: 20),

          // ── Grid content ─────────────────────────────────────────────────
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
                return _buildGrid(cols: cols, count: skeletonCount, builder: (_) => const SkeletonJobCard());
              }

              if (jobs.isEmpty) {
                return const _EmptyState();
              }

              return _buildGrid(
                cols: cols,
                count: jobs.length,
                builder: (i) => StaggeredListItem(
                  index: i,
                  child: JobCardWidget(job: jobs[i]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildGrid({required int cols, required int count, required Widget Function(int) builder}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: cols == 1 ? 2.0 : 0.72,
      ),
      itemCount: count,
      itemBuilder: (_, i) => builder(i),
    );
  }
}

// ── Filter Button ─────────────────────────────────────────────────────────────
class _FilterButton extends StatefulWidget {
  const _FilterButton({this.onTap});
  final VoidCallback? onTap;

  @override
  State<_FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<_FilterButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isArabic = context.watch<JobProvider>().isArabic;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accentBlueMuted : AppColors.backgroundElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _hovered ? AppColors.accentBlue : AppColors.borderSubtle,
              width: _hovered ? 1.5 : 1.0,
            ),
            boxShadow: _hovered
                ? [BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.2), blurRadius: 12)]
                : [],
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            AnimatedRotation(
              turns: _hovered ? 0.1 : 0,
              duration: const Duration(milliseconds: 200),
              child: Icon(Icons.tune_rounded, size: 16,
                  color: _hovered ? AppColors.accentBlue : AppColors.textSecondary),
            ),
            const SizedBox(width: 8),
            Text(
              isArabic ? 'تصفية' : 'Filters',
              style: AppTextStyles.titleMedium.copyWith(
                color: _hovered ? AppColors.accentBlue : AppColors.textSecondary,
              ),
            ),
          ]),
        ),
      ),
    ).animate(delay: 200.ms).fadeIn().slideX(begin: 0.1, end: 0);
  }
}

// ── EmptyState ────────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 360,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [AppColors.accentBlueMuted, AppColors.backgroundElevated],
                ),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: const Icon(Icons.search_off_rounded, color: AppColors.textDisabled, size: 36),
            )
                .animate(onPlay: (c) => c.repeat(reverse: true))
                .scale(begin: const Offset(0.95, 0.95), end: const Offset(1.05, 1.05), duration: 2000.ms),
            const SizedBox(height: 20),
            Text('No Job Listings Found',
                style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textSecondary))
                .animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
            const SizedBox(height: 8),
            Text('Connect the API to load real-time job opportunities.',
                style: AppTextStyles.bodyMedium, textAlign: TextAlign.center)
                .animate().fadeIn(delay: 350.ms),
          ],
        ),
      ),
    );
  }
}

// ── Filter Bar ────────────────────────────────────────────────────────────────
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
          children: _filters.asMap().entries.map((entry) {
            final i = entry.key;
            final f = entry.value;
            final isSelected = activeFilter == f.key;
            return Padding(
              padding: const EdgeInsetsDirectional.only(end: 10),
              child: _AnimatedFilterChip(
                icon: f.icon,
                label: isAr ? f.labelAr : f.labelEn,
                isSelected: isSelected,
                delay: i * 60,
                onTap: () => jobProvider.setJobTypeFilter(f.key),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _AnimatedFilterChip extends StatefulWidget {
  const _AnimatedFilterChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.delay,
    required this.onTap,
  });
  final IconData icon;
  final String label;
  final bool isSelected;
  final int delay;
  final VoidCallback onTap;

  @override
  State<_AnimatedFilterChip> createState() => _AnimatedFilterChipState();
}

class _AnimatedFilterChipState extends State<_AnimatedFilterChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: widget.isSelected
                  ? AppColors.accentBlue
                  : (_hovered ? AppColors.backgroundHover : AppColors.backgroundElevated),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: widget.isSelected
                    ? AppColors.accentBlue
                    : (_hovered ? AppColors.accentBlue.withValues(alpha: 0.5) : AppColors.borderSubtle),
                width: widget.isSelected ? 1.5 : 1.0,
              ),
              boxShadow: widget.isSelected
                  ? [BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
                  : [],
            ),
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(widget.icon, size: 14,
                  color: widget.isSelected ? Colors.white : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 12,
                  fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
                  color: widget.isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ]),
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: widget.delay + 100))
        .fadeIn(duration: 350.ms)
        .slideX(begin: -0.05, end: 0, duration: 300.ms);
  }
}
