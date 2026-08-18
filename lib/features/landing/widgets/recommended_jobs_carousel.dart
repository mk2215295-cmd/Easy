import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/job_model.dart';
import '../../../routing/app_router.dart';

// ════════════════════════════════════════════════════════════════════════════
// RecommendedJobsCarousel
// Glassmorphic interactive recommended jobs row matching the reference image.
// ════════════════════════════════════════════════════════════════════════════
class RecommendedJobsCarousel extends StatefulWidget {
  const RecommendedJobsCarousel({
    super.key,
    required this.jobs,
    required this.isArabic,
  });

  final List<JobModel> jobs;
  final bool isArabic;

  @override
  State<RecommendedJobsCarousel> createState() =>
      _RecommendedJobsCarouselState();
}

class _RecommendedJobsCarouselState extends State<RecommendedJobsCarousel> {
  final ScrollController _scrollController = ScrollController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.hasClients && _scrollController.position.maxScrollExtent > 0) {
        final page = (_scrollController.offset / 280).round();
        if (page != _currentPage && mounted) {
          setState(() => _currentPage = page);
        }
      }
    });
  }

  void _scroll(int direction) {
    const itemWidth = 280.0;
    final newOffset = _scrollController.offset + (direction * itemWidth * 2);
    _scrollController.animateTo(
      newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.jobs.isEmpty) return const SizedBox.shrink();

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1000;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1200),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Row: Title + Controls ──────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: 18,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00F0FF),
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.isArabic ? 'موصى به لك' : 'RECOMMENDED FOR YOU',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),

              // Arrow Navigation
              if (isDesktop)
                Row(
                  children: [
                    _ArrowButton(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => _scroll(-1),
                    ),
                    const SizedBox(width: 8),
                    _ArrowButton(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => _scroll(1),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ── Horizontal Cards Slider ───────────────────────────────────────
          SizedBox(
            height: 240,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.jobs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) {
                final job = widget.jobs[index];
                return _GlassJobCard(job: job, isArabic: widget.isArabic);
              },
            ),
          ),

          const SizedBox(height: 12),

          // ── Pagination Indicator Dots ─────────────────────────────────────
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                (widget.jobs.length / 4).clamp(1, 5).toInt(),
                (i) => Container(
                  width: i == _currentPage ? 20 : 6,
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: i == _currentPage
                        ? const Color(0xFF00F0FF)
                        : Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(3),
                    boxShadow: i == _currentPage
                        ? [
                            BoxShadow(
                              color: const Color(0xFF00F0FF).withValues(alpha: 0.8),
                              blurRadius: 6,
                            )
                          ]
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Glassmorphic Job Card matching the reference image
// ════════════════════════════════════════════════════════════════════════════
class _GlassJobCard extends StatefulWidget {
  const _GlassJobCard({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  State<_GlassJobCard> createState() => _GlassJobCardState();
}

class _GlassJobCardState extends State<_GlassJobCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final title = widget.isArabic
        ? (widget.job.titleAr ?? widget.job.title ?? '')
        : (widget.job.title ?? widget.job.titleAr ?? '');
    final location = widget.isArabic
        ? (widget.job.locationAr ?? widget.job.location ?? '')
        : (widget.job.location ?? widget.job.locationAr ?? '');
    final salary = (widget.job.salaryMin != null && widget.job.salaryMax != null)
        ? '${widget.job.salaryCurrency ?? '€'}${widget.job.salaryMin!.toInt()} – ${widget.job.salaryCurrency ?? '€'}${widget.job.salaryMax!.toInt()}/${widget.job.salaryPeriod ?? 'mo'}'
        : '€2,500 – €5,000/mo';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 260,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isHovered
              ? const Color(0xFF13284C).withValues(alpha: 0.8)
              : const Color(0xFF0C1930).withValues(alpha: 0.65),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF00F0FF).withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.12),
            width: 1.3,
          ),
          boxShadow: [
            BoxShadow(
              color: _isHovered
                  ? const Color(0xFF00F0FF).withValues(alpha: 0.25)
                  : Colors.black.withValues(alpha: 0.4),
              blurRadius: _isHovered ? 24 : 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Company Brand & Logo Badge
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (widget.job.company ?? 'E').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF0D1B2A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.job.company ?? 'Global Partner',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      if (widget.job.requiresVisaSponsorship == true)
                        Text(
                          widget.isArabic ? 'كفالة فيزا متاحة' : 'Visa Sponsored',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF10B981),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),

            // Middle: Job Title & Location
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 13,
                      color: Color(0xFF8B949E),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8B949E),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Salary Row
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 13,
                  color: Color(0xFF00F0FF),
                ),
                const SizedBox(width: 4),
                Text(
                  salary.isNotEmpty ? salary : '€2,500 – €4,500/mo',
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF00F0FF),
                  ),
                ),
              ],
            ),

            // Bottom: VIEW JOB Button
            GestureDetector(
              onTap: () {
                context.go('${AppRoutes.jobs}/${widget.job.id}');
              },
              child: Container(
                width: double.infinity,
                height: 38,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? const Color(0xFF00F0FF)
                      : Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _isHovered
                        ? const Color(0xFF00F0FF)
                        : Colors.white.withValues(alpha: 0.15),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.isArabic ? 'عرض الوظيفة' : 'VIEW JOB',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.8,
                      color: _isHovered ? const Color(0xFF030712) : Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF0C1930).withValues(alpha: 0.6),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }
}
