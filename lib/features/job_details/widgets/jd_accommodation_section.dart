import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/models/job_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JdAccommodationSection
// "تفاصيل السكن:" section with a small photo gallery on the left
// and the description text on the right (mimicking mockup layout).
// Shows skeleton state when job data is loading.
// ════════════════════════════════════════════════════════════════════════════════
class JdAccommodationSection extends StatelessWidget {
  const JdAccommodationSection({
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
    final hasData = !isLoading &&
        job != null &&
        (job!.accommodationDescriptionAr != null ||
            job!.accommodationDescriptionEn != null ||
            job!.accommodationImageUrls.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 24),

        // Section heading
        Text(
          isArabic ? 'تفاصيل السكن:' : 'Accommodation Details:',
          textAlign: TextAlign.right,
          style: AppTextStyles.headlineMedium.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),

        const SizedBox(height: 14),

        if (!hasData)
          _SkeletonAccommodation()
        else
          _AccommodationContent(job: job!, isArabic: isArabic),

        const SizedBox(height: 24),
      ],
    );
  }
}

class _AccommodationContent extends StatelessWidget {
  const _AccommodationContent({required this.job, required this.isArabic});
  final JobModel job;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final desc = isArabic
        ? (job.accommodationDescriptionAr ?? job.accommodationDescriptionEn)
        : (job.accommodationDescriptionEn ?? job.accommodationDescriptionAr);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Photo gallery ───────────────────────────────────────────────
        if (job.accommodationImageUrls.isNotEmpty)
          _PhotoGallery(urls: job.accommodationImageUrls),

        if (job.accommodationImageUrls.isNotEmpty)
          const SizedBox(width: 16),

        // ── Description ──────────────────────────────────────────────────
Expanded(
          child: Text(
            desc ?? '',
            textAlign: TextAlign.right,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontSize: 13,
              height: 1.7,
            ),
          ),
        ),
      ],
    );
  }
}

class _PhotoGallery extends StatelessWidget {
  const _PhotoGallery({required this.urls});
  final List<String> urls;

  @override
  Widget build(BuildContext context) {
    // Show max 2 thumbnails as per the mockup
    final display = urls.take(2).toList();
    return Row(
      children: display.map((url) {
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 100,
              height: 80,
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppColors.backgroundElevated,
                  child: const Icon(
                    Icons.home_rounded,
                    color: AppColors.textDisabled,
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.backgroundElevated,
                  child: const Icon(
                    Icons.broken_image_rounded,
                    color: AppColors.textDisabled,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _SkeletonAccommodation extends StatefulWidget {
  @override
  State<_SkeletonAccommodation> createState() =>
      _SkeletonAccommodationState();
}

class _SkeletonAccommodationState extends State<_SkeletonAccommodation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _anim = Tween<double>(begin: -1.5, end: 2.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _box(double w, double h) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              stops: [
                (_anim.value - 0.4).clamp(0.0, 1.0),
                _anim.value.clamp(0.0, 1.0),
                (_anim.value + 0.4).clamp(0.0, 1.0),
              ],
              colors: const [
                AppColors.backgroundElevated,
                Color(0xFF2D3748),
                AppColors.backgroundElevated,
              ],
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _box(100, 80),
        const SizedBox(width: 8),
        _box(100, 80),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _box(double.infinity, 13),
              const SizedBox(height: 6),
              _box(double.infinity, 13),
              const SizedBox(height: 6),
              _box(200, 13),
            ],
          ),
        ),
      ],
    );
  }
}
