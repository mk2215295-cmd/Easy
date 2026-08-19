import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/models/job_model.dart';
import '../../../routing/app_router.dart';

// ════════════════════════════════════════════════════════════════════════════
// RecommendedJobsCarousel
// Exact 1-to-1 visual match of the 4 RECOMMENDED FOR YOU cards from image:
// Google UX Designer NY, Siemens Data Analyst Munich, Spotify Software Engineer Stockholm, Airbnb Product Manager Tokyo.
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
        final page = (_scrollController.offset / 240).round();
        if (page != _currentPage && mounted) {
          setState(() => _currentPage = page);
        }
      }
    });
  }

  void _scroll(int direction) {
    const itemWidth = 240.0;
    final newOffset = _scrollController.offset + (direction * itemWidth * 2);
    _scrollController.animateTo(
      newOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 350),
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
    final displayJobs = widget.jobs.isNotEmpty ? widget.jobs : _fallbackMockJobs();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1050;

    return Container(
      constraints: const BoxConstraints(maxWidth: 1100),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Title & Left/Right Arrows ─────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.isArabic ? 'موصى به لك' : 'RECOMMENDED FOR YOU',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: 1.0,
                ),
              ),

              if (isDesktop)
                Row(
                  children: [
                    _ArrowCircle(
                      icon: Icons.chevron_left_rounded,
                      onTap: () => _scroll(-1),
                    ),
                    const SizedBox(width: 8),
                    _ArrowCircle(
                      icon: Icons.chevron_right_rounded,
                      onTap: () => _scroll(1),
                    ),
                  ],
                ),
            ],
          ),

          const SizedBox(height: 16),

          // ── 4 Job Cards Row ───────────────────────────────────────────────
          if (isDesktop)
            Row(
              children: displayJobs.take(4).map((job) {
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: _ExactJobCard(job: job, isArabic: widget.isArabic),
                  ),
                );
              }).toList(),
            )
          else
            SizedBox(
              height: 220,
              child: ListView.separated(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: displayJobs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: 230,
                    child: _ExactJobCard(job: displayJobs[index], isArabic: widget.isArabic),
                  );
                },
              ),
            ),

          const SizedBox(height: 16),

          // ── 3 Pagination Dots matching Image Reference ─────────────────────
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00C2E8),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF475569),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                Container(
                  width: 5,
                  height: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF475569),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<JobModel> _fallbackMockJobs() {
    return const [
      JobModel(
        id: 'job-rec-1',
        company: 'Google',
        title: 'UX Designer',
        location: 'NY',
        salaryMin: 1000,
        salaryMax: 12000,
        salaryCurrency: r'$',
      ),
      JobModel(
        id: 'job-rec-2',
        company: 'Siemens',
        title: 'Data Analyst',
        location: 'Munich',
        salaryMin: 500,
        salaryMax: 12000,
        salaryCurrency: r'$',
      ),
      JobModel(
        id: 'job-rec-3',
        company: 'Spotify',
        title: 'Software Engineer',
        location: 'Stockholm',
        salaryMin: 1000,
        salaryMax: 12000,
        salaryCurrency: r'$',
      ),
      JobModel(
        id: 'job-rec-4',
        company: 'Airbnb',
        title: 'Product Manager',
        location: 'Tokyo',
        salaryMin: 1000,
        salaryMax: 12000,
        salaryCurrency: r'$',
      ),
    ];
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Exact Job Card matching the image design
// ════════════════════════════════════════════════════════════════════════════
class _ExactJobCard extends StatefulWidget {
  const _ExactJobCard({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  State<_ExactJobCard> createState() => _ExactJobCardState();
}

class _ExactJobCardState extends State<_ExactJobCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final company = widget.job.company ?? 'Global';
    final title = widget.isArabic
        ? (widget.job.titleAr ?? widget.job.title ?? '')
        : (widget.job.title ?? widget.job.titleAr ?? '');
    final location = (widget.job.location ?? '').split(',').first.trim();
    final salary = (widget.job.salaryMin != null && widget.job.salaryMax != null)
        ? '\$${widget.job.salaryMin!.toInt()} - \$${widget.job.salaryMax!.toInt()}'
        : '\$1000 - \$12,000';

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 205,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: _isHovered
              ? const Color(0xFF1B2A44).withValues(alpha: 0.9)
              : const Color(0xFF121E33).withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isHovered
                ? const Color(0xFF00C2E8).withValues(alpha: 0.6)
                : const Color(0xFF2C3E5A).withValues(alpha: 0.5),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
            if (_isHovered)
              BoxShadow(
                color: const Color(0xFF00C2E8).withValues(alpha: 0.2),
                blurRadius: 20,
              ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Company Logo + Company Name
            Row(
              children: [
                _buildCompanyLogo(company),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    company,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            // 2. Job Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // 3. Location (📍 Location)
            Row(
              children: [
                const Icon(
                  Icons.location_on_outlined,
                  size: 13,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 4),
                Text(
                  location.isNotEmpty ? location : 'Remote',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),

            // 4. Salary ($1000 - $12,000)
            Row(
              children: [
                const Icon(
                  Icons.payments_outlined,
                  size: 13,
                  color: Color(0xFF94A3B8),
                ),
                const SizedBox(width: 4),
                Text(
                  salary,
                  style: const TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFCBD5E1),
                  ),
                ),
              ],
            ),

            // 5. [ VIEW JOB ] Button
            GestureDetector(
              onTap: () {
                context.go('${AppRoutes.jobs}/${widget.job.id}');
              },
              child: Container(
                width: double.infinity,
                height: 32,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? const Color(0xFF00C2E8)
                      : const Color(0xFF1E2E4A).withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _isHovered
                        ? const Color(0xFF00C2E8)
                        : Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Center(
                  child: Text(
                    widget.isArabic ? 'VIEW JOB' : 'VIEW JOB',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: _isHovered ? const Color(0xFF030712) : const Color(0xFFE2E8F0),
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

  Widget _buildCompanyLogo(String company) {
    final c = company.toLowerCase();
    if (c.contains('google')) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(6)),
        child: const Center(
          child: Text('G', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF4285F4))),
        ),
      );
    }
    if (c.contains('siemens')) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: const Color(0xFF00646E), borderRadius: BorderRadius.circular(6)),
        child: const Center(
          child: Text('S', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.white)),
        ),
      );
    }
    if (c.contains('spotify')) {
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(color: Color(0xFF1DB954), shape: BoxShape.circle),
        child: const Center(
          child: Icon(Icons.graphic_eq_rounded, size: 14, color: Colors.white),
        ),
      );
    }
    if (c.contains('airbnb')) {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(color: const Color(0xFFFF5A5F), borderRadius: BorderRadius.circular(6)),
        child: const Center(
          child: Icon(Icons.roofing_rounded, size: 14, color: Colors.white),
        ),
      );
    }
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(color: const Color(0xFF00C2E8), borderRadius: BorderRadius.circular(6)),
      child: Center(
        child: Text(company.substring(0, 1).toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
    );
  }
}

class _ArrowCircle extends StatelessWidget {
  const _ArrowCircle({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xFF1B2A44).withValues(alpha: 0.8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
        ),
        child: Icon(icon, color: const Color(0xFF94A3B8), size: 16),
      ),
    );
  }
}
