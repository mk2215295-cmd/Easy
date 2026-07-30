import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/app_router.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// SkeletonJobCard
// Animated shimmer placeholder displayed while job data is loading from the API.
// Mirrors the exact structure and proportions of JobCardWidget so the layout
// does not jump when real data arrives.
// Tapping the card redirects the user to the JobDetailsScreen (Phase 3 navigation).
// ════════════════════════════════════════════════════════════════════════════════
class SkeletonJobCard extends StatefulWidget {
  const SkeletonJobCard({super.key});

  @override
  State<SkeletonJobCard> createState() => _SkeletonJobCardState();
}

class _SkeletonJobCardState extends State<SkeletonJobCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _shimmer = Tween<double>(begin: -1.5, end: 2.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // Shimmer gradient box
  Widget _box({
    required double width,
    required double height,
    double radius = 6,
  }) {
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [
              (_shimmer.value - 0.4).clamp(0.0, 1.0),
              _shimmer.value.clamp(0.0, 1.0),
              (_shimmer.value + 0.4).clamp(0.0, 1.0),
            ],
            colors: const [
              AppColors.backgroundElevated,
              Color(0xFF2D3748), // subtle highlight pulse
              AppColors.backgroundElevated,
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => context.go('${AppRoutes.jobs}/skeleton-loading-id'),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero image placeholder ────────────────────────────────────
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: _box(width: double.infinity, height: 155, radius: 0),
              ),

              // ── Content area ─────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    _box(width: double.infinity, height: 16),
                    const SizedBox(height: 8),
                    // Location
                    _box(width: 140, height: 12),
                    const SizedBox(height: 12),
                    // Description line 1
                    _box(width: double.infinity, height: 11),
                    const SizedBox(height: 5),
                    // Description line 2
                    _box(width: double.infinity * 0.8, height: 11),
                    const SizedBox(height: 14),
                    // Salary
                    _box(width: 160, height: 14),
                    const SizedBox(height: 14),
                    // Buttons row
                    Row(
                      children: [
                        Expanded(child: _box(width: double.infinity, height: 38)),
                        const SizedBox(width: 8),
                        Expanded(child: _box(width: double.infinity, height: 38)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
