import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/models/job_model.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animations/page_transition_wrapper.dart';
import '../../widgets/common/app_header.dart';

// ════════════════════════════════════════════════════════════════════════════
// JobsScreen — Premium animated jobs listing page with animated search bar,
//   filter chips, and staggered list entry animations.
// ════════════════════════════════════════════════════════════════════════════
class JobsScreen extends StatefulWidget {
  const JobsScreen({super.key});
  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';
  bool _searchFocused = false;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() {
      setState(() => _searchFocused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final isArabic = jobProvider.isArabic;
    final allJobs = jobProvider.filteredJobs;
    final isLoading = jobProvider.isLoading;

    final filtered = _query.isEmpty
        ? allJobs
        : allJobs.where((j) {
            final q = _query.toLowerCase();
            final title = (isArabic ? j.titleAr ?? j.title : j.title)?.toLowerCase() ?? '';
            final loc = (isArabic ? j.locationAr ?? j.location : j.location)?.toLowerCase() ?? '';
            return title.contains(q) || loc.contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.jobs,
        isArabic: isArabic,
        onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: PageTransitionWrapper(
        child: Column(
          children: [
            // ── Header ─────────────────────────────────────────────────────
            AppHeader(
              activeRoute: AppRoutes.jobs,
              isArabic: isArabic,
              onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
            ),

            // ── Animated search bar ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: _searchFocused
                      ? [BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.25), blurRadius: 20, spreadRadius: 0)]
                      : [],
                ),
                child: TextField(
                  controller: _searchCtrl,
                  focusNode: _focusNode,
                  textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: isArabic ? '🔍 ابحث عن وظيفة أو مكان…' : '🔍 Search jobs or location…',
                    hintTextDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
                    prefixIcon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _searchFocused ? Icons.manage_search_rounded : Icons.search_rounded,
                        color: _searchFocused ? AppColors.accentBlue : AppColors.textSecondary,
                        key: ValueKey(_searchFocused),
                      ),
                    ),
                    suffixIcon: _query.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.cancel_rounded, color: AppColors.textSecondary, size: 20),
                            onPressed: () { _searchCtrl.clear(); setState(() => _query = ''); },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.backgroundSurface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderSubtle)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.borderSubtle)),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.5)),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
            ).animate().fadeIn(delay: 100.ms).slideY(begin: -0.1, end: 0),

            // ── Results count pill ─────────────────────────────────────────
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Padding(
                key: ValueKey(filtered.length),
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.accentBlueMuted.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
                      ),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.work_outline_rounded, size: 12, color: AppColors.accentBlueLighter),
                        const SizedBox(width: 5),
                        Text(
                          isArabic ? '${filtered.length} وظيفة' : '${filtered.length} jobs',
                          style: AppTextStyles.labelSmall.copyWith(
                            fontSize: 12, color: AppColors.accentBlueLighter, fontWeight: FontWeight.w600,
                          ),
                        ),
                      ]),
                    ),
                    if (_query.isNotEmpty) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          isArabic ? 'نتائج: "$_query"' : 'for "$_query"',
                          style: AppTextStyles.labelSmall.copyWith(fontSize: 11),
                          maxLines: 1, overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ).animate(delay: 200.ms).fadeIn(),

            const SizedBox(height: 8),

            // ── Job list ────────────────────────────────────────────────────
            Expanded(
              child: isLoading
                  ? Center(
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        const CircularProgressIndicator(color: AppColors.accentBlue, strokeWidth: 2.5),
                        const SizedBox(height: 16),
                        Text(isArabic ? 'جاري تحميل الوظائف…' : 'Loading jobs…',
                            style: AppTextStyles.bodyMedium)
                            .animate(onPlay: (c) => c.repeat(reverse: true))
                            .fadeIn(duration: 600.ms),
                      ]),
                    )
                  : filtered.isEmpty
                      ? _EmptyState(isArabic: isArabic, hasQuery: _query.isNotEmpty)
                      : ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (_, i) => _JobListTile(
                            job: filtered[i],
                            isArabic: isArabic,
                            index: i,
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── _JobListTile ──────────────────────────────────────────────────────────────
class _JobListTile extends StatefulWidget {
  const _JobListTile({required this.job, required this.isArabic, required this.index});
  final JobModel job;
  final bool isArabic;
  final int index;

  @override
  State<_JobListTile> createState() => _JobListTileState();
}

class _JobListTileState extends State<_JobListTile> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final job = widget.job;
    final ar = widget.isArabic;
    final title = ar ? (job.titleAr ?? job.title ?? '') : (job.title ?? '');
    final location = ar ? (job.locationAr ?? job.location ?? '') : (job.location ?? '');
    final desc = ar ? (job.descriptionAr ?? job.description ?? '') : (job.description ?? '');
    final salary = job.formattedSalary();

    final delay = (widget.index * 50).clamp(0, 500);

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() { _hovered = false; _pressed = false; }),
      child: GestureDetector(
        onTap: () => context.go('${AppRoutes.jobs}/${job.id}'),
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? 0.98 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _hovered ? AppColors.backgroundElevated : AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _hovered ? AppColors.accentBlue.withValues(alpha: 0.6) : AppColors.borderSubtle,
                width: _hovered ? 1.5 : 1.0,
              ),
              boxShadow: _hovered
                  ? [BoxShadow(color: AppColors.accentBlue.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 6))]
                  : [],
            ),
            child: Row(
              textDirection: ar ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Flag bubble
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52, height: 52,
                  decoration: BoxDecoration(
                    color: _hovered
                        ? AppColors.accentBlueMuted.withValues(alpha: 0.4)
                        : AppColors.backgroundElevated,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _hovered ? AppColors.accentBlue.withValues(alpha: 0.4) : AppColors.borderSubtle,
                    ),
                  ),
                  child: Center(
                    child: Text(job.countryFlagEmoji ?? '🌍', style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: ar ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        textAlign: ar ? TextAlign.right : TextAlign.left,
                        style: AppTextStyles.headlineMedium.copyWith(
                          fontSize: 15, color: _hovered ? AppColors.accentBlueLighter : AppColors.textPrimary,
                        ),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: ar ? MainAxisAlignment.end : MainAxisAlignment.start,
                        children: [
                          const Icon(Icons.location_on_outlined, size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 3),
                          Flexible(
                            child: Text(location,
                                style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                                maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          if (job.jobType != null) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.accentBlueMuted.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(job.jobType!,
                                  style: AppTextStyles.labelSmall.copyWith(fontSize: 10, color: AppColors.accentBlueLighter)),
                            ),
                          ],
                        ],
                      ),
                      if (desc.isNotEmpty) ...[
                        const SizedBox(height: 5),
                        Text(desc,
                            textAlign: ar ? TextAlign.right : TextAlign.left,
                            style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Salary + arrow
                Column(crossAxisAlignment: CrossAxisAlignment.end, mainAxisAlignment: MainAxisAlignment.center, children: [
                  if (salary != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accentGreenMuted.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AppColors.accentGreen.withValues(alpha: 0.4)),
                      ),
                      child: Text(salary,
                          style: AppTextStyles.titleMedium.copyWith(color: AppColors.accentGreen, fontSize: 12)),
                    ),
                  const SizedBox(height: 8),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    transform: Matrix4.translationValues(_hovered ? 3 : 0, 0, 0),
                    child: Icon(Icons.arrow_forward_ios_rounded, size: 13,
                        color: _hovered ? AppColors.accentBlue : AppColors.textDisabled),
                  ),
                ]),
              ],
            ),
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: delay)).fadeIn(duration: 350.ms).slideY(begin: 0.06, end: 0);
  }
}

// ── _EmptyState ───────────────────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.isArabic, required this.hasQuery});
  final bool isArabic;
  final bool hasQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const RadialGradient(colors: [AppColors.accentBlueMuted, AppColors.backgroundElevated]),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Icon(
              hasQuery ? Icons.search_off_rounded : Icons.work_off_rounded,
              color: AppColors.textDisabled, size: 36,
            ),
          ).animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.92, 0.92), end: const Offset(1.08, 1.08), duration: 2000.ms),
          const SizedBox(height: 20),
          Text(
            hasQuery
                ? (isArabic ? 'لا توجد نتائج لـ "$_dummy"' : 'No results found')
                : (isArabic ? 'لا توجد وظائف' : 'No jobs available'),
            style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textSecondary),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 8),
          Text(
            isArabic ? 'حاول بحثاً مختلفاً أو تحقق لاحقاً' : 'Try a different search or check back later',
            style: AppTextStyles.bodyMedium, textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms),
        ],
      ),
    );
  }
}

// ignore: unused_element
const _dummy = '';
