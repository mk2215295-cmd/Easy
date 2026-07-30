import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/models/job_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_header.dart';

// ════════════════════════════════════════════════════════════════════════════
// JobsScreen  (/jobs)
//
// A searchable vertical list of all live job listings pulled directly from
// the global [JobProvider] state.  Mirrors the same locale-switching and
// RTL-awareness as the Dashboard.
//
// Layout:
//   • Pinned universal header
//   • Search bar (filters cards in real-time)
//   • Scrollable list of [_JobListTile] cards
// ════════════════════════════════════════════════════════════════════════════
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final isArabic = jobProvider.isArabic;
    final allJobs = jobProvider.filteredJobs;
    final isLoading = jobProvider.isLoading;

    // Filter by search query (case-insensitive across title + location)
    final filtered = _query.isEmpty
        ? allJobs
        : allJobs.where((j) {
            final q = _query.toLowerCase();
            final title =
                (isArabic ? j.titleAr ?? j.title : j.title)?.toLowerCase() ??
                    '';
            final loc =
                (isArabic ? j.locationAr ?? j.location : j.location)
                    ?.toLowerCase() ??
                    '';
            return title.contains(q) || loc.contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.jobs,
        isArabic: isArabic,
        onLanguageToggle: (v) =>
            jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: Column(
        children: [
          // ── Pinned universal header ──────────────────────────────────
          AppHeader(
            activeRoute: AppRoutes.jobs,
            isArabic: isArabic,
            onLanguageToggle: (v) =>
                jobProvider.setLocaleCode(v ? 'ar' : 'en'),
          ),

          // ── Search bar ───────────────────────────────────────────────
          Padding(
            padding:
                const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: TextField(
              controller: _searchCtrl,
              textDirection:
                  isArabic ? TextDirection.rtl : TextDirection.ltr,
              decoration: InputDecoration(
                hintText: isArabic
                    ? 'ابحث عن وظيفة…'
                    : 'Search jobs…',
                hintTextDirection:
                    isArabic ? TextDirection.rtl : TextDirection.ltr,
                prefixIcon: const Icon(Icons.search_rounded,
                    color: AppColors.textSecondary),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded,
                            color: AppColors.textSecondary),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.backgroundSurface,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.borderSubtle),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide:
                      const BorderSide(color: AppColors.accentBlue),
                ),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),

          // ── Section heading ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
            child: Row(
              mainAxisAlignment: isArabic
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? '${filtered.length} وظيفة متاحة'
                      : '${filtered.length} jobs available',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // ── Job list ─────────────────────────────────────────────────
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.accentBlue))
                : filtered.isEmpty
                    ? _EmptyState(isArabic: isArabic)
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                            24, 0, 24, 32),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: 12),
                        itemBuilder: (_, i) => _JobListTile(
                          job: filtered[i],
                          isArabic: isArabic,
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}

// ── _JobListTile ─────────────────────────────────────────────────────────────
class _JobListTile extends StatefulWidget {
  const _JobListTile({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  State<_JobListTile> createState() => _JobListTileState();
}

class _JobListTileState extends State<_JobListTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final ar = widget.isArabic;
    final title =
        ar ? (job.titleAr ?? job.title ?? '') : (job.title ?? '');
    final location =
        ar ? (job.locationAr ?? job.location ?? '') : (job.location ?? '');
    final desc =
        ar ? (job.descriptionAr ?? job.description ?? '') : (job.description ?? '');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go('${AppRoutes.jobs}/${job.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.backgroundElevated
                : AppColors.backgroundSurface,
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
          child: Row(
            textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Flag / icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.backgroundElevated,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.borderSubtle),
                ),
                child: Center(
                  child: Text(
                    job.countryFlagEmoji ?? '🌍',
                    style: const TextStyle(fontSize: 22),
                  ),
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
                      title,
                      textAlign: ar ? TextAlign.right : TextAlign.left,
                      style: AppTextStyles.headlineMedium
                          .copyWith(fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: ar
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        const Icon(Icons.location_on_outlined,
                            size: 13,
                            color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Flexible(
                          child: Text(
                            location,
                            style: AppTextStyles.bodyMedium
                                .copyWith(fontSize: 12),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (desc.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        desc,
                        textAlign: ar ? TextAlign.right : TextAlign.left,
                        style: AppTextStyles.bodyMedium
                            .copyWith(fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Salary + arrow
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (job.formattedSalary() != null)
                    Text(
                      job.formattedSalary()!,
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.accentGreen,
                        fontSize: 13,
                      ),
                    ),
                  const SizedBox(height: 8),
                  const Icon(Icons.arrow_forward_ios_rounded,
                      size: 14, color: AppColors.textDisabled),
                ],
              ),
            ],
          ),
        ),
      ),
    );
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
          const Icon(Icons.search_off_rounded,
              color: AppColors.textDisabled, size: 52),
          const SizedBox(height: 16),
          Text(
            isArabic ? 'لا توجد نتائج' : 'No jobs found',
            style: AppTextStyles.headlineMedium
                .copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
