import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/providers/auth_provider.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../widgets/brand/easy_work_animated_logo.dart';
import 'widgets/featured_employers_section.dart';
import 'widgets/globe_particles_background.dart';
import 'widgets/hero_search_bar.dart';
import 'widgets/recommended_jobs_carousel.dart';

// ════════════════════════════════════════════════════════════════════════════
// GlobalHeroScreen
// 100% pixel-accurate match of the user's reference mockup:
// - Outer glowing neon cyan viewport container
// - Top Navbar with GlobalConnect/EasyWork brand, navigation, Sign Up, and Flags
// - Centered 3D Digital Earth Globe with orbital network arcs & nodes
// - Headline: FIND YOUR FUTURE, WORLDWIDE.
// - Dual glass search console with Software Engineer / Berlin inputs
// - 4 distinct category cards (Tech, Finance, Creative, Remote) with exact colors
// - RECOMMENDED FOR YOU 4 cards (Google, Siemens, Spotify, Airbnb)
// - FEATURED EMPLOYERS & GLOBAL JOB TRENDS
// ════════════════════════════════════════════════════════════════════════════
class GlobalHeroScreen extends StatefulWidget {
  const GlobalHeroScreen({super.key});

  @override
  State<GlobalHeroScreen> createState() => _GlobalHeroScreenState();
}

class _GlobalHeroScreenState extends State<GlobalHeroScreen> {
  String _selectedCategory = 'All';

  void _onSearch(String titleQuery, String locationQuery) {
    final jobProvider = context.read<JobProvider>();
    jobProvider.setSearchQueries(titleQuery, locationQuery);
    context.go(AppRoutes.jobs);
  }

  void _onCategorySelected(String category) {
    setState(() => _selectedCategory = category);
    final jobProvider = context.read<JobProvider>();
    jobProvider.setCategoryFilter(category);
    context.go(AppRoutes.jobs);
  }

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final authProvider = context.watch<AppAuthProvider>();
    final isArabic = jobProvider.isArabic;
    final jobs = jobProvider.jobs;

    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1000;

    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      body: Container(
        margin: isDesktop ? const EdgeInsets.all(12) : EdgeInsets.zero,
        decoration: BoxDecoration(
          color: const Color(0xFF070B14),
          borderRadius: BorderRadius.circular(isDesktop ? 24 : 0),
          border: Border.all(
            color: const Color(0xFF00C2E8).withValues(alpha: 0.35),
            width: 1.5,
          ),
          boxShadow: isDesktop
              ? [
                  BoxShadow(
                    color: const Color(0xFF00C2E8).withValues(alpha: 0.15),
                    blurRadius: 36,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isDesktop ? 22 : 0),
          child: GlobeParticlesBackground(
            child: Column(
              children: [
                // ── Top Navigation Bar matching reference image ───────────────
                _buildMockupNavBar(context, authProvider, jobProvider, isArabic, isDesktop),

                // ── Main Scrollable Body ────────────────────────────────────
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 28),

                        // ── FIND YOUR FUTURE, WORLDWIDE. Headline ───────────
                        Text(
                          isArabic ? 'ابحث عن مستقبلك في كل مكان بالعالم' : 'FIND YOUR FUTURE, WORLDWIDE.',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            shadows: [
                              Shadow(
                                color: Color(0xFF00C2E8),
                                blurRadius: 18,
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 500.ms)
                            .slideY(begin: 0.15, end: 0.0),

                        const SizedBox(height: 24),

                        // ── Dual Search Console & 4 Exact Category Pills ────
                        HeroSearchBar(
                          onSearch: _onSearch,
                          onCategorySelected: _onCategorySelected,
                          selectedCategory: _selectedCategory,
                          isArabic: isArabic,
                        )
                            .animate()
                            .fadeIn(delay: 150.ms, duration: 500.ms),

                        const SizedBox(height: 38),

                        // ── RECOMMENDED FOR YOU (Google, Siemens, Spotify, Airbnb)
                        RecommendedJobsCarousel(
                          jobs: jobs,
                          isArabic: isArabic,
                        )
                            .animate()
                            .fadeIn(delay: 250.ms, duration: 500.ms),

                        const SizedBox(height: 28),

                        // ── FEATURED EMPLOYERS & GLOBAL JOB TRENDS ──────────
                        FeaturedEmployersAndTrendsSection(isArabic: isArabic)
                            .animate()
                            .fadeIn(delay: 350.ms, duration: 500.ms),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMockupNavBar(
    BuildContext context,
    AppAuthProvider authProvider,
    JobProvider jobProvider,
    bool isArabic,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1424).withValues(alpha: 0.7),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Brand with Cyber Globe icon
          EasyWorkAnimatedLogo(
            size: 32,
            isArabic: isArabic,
            onTap: () => context.go(AppRoutes.dashboard),
          ),

          // Center Links matching Image Mockup
          if (isDesktop)
            Row(
              children: [
                _NavBarItem(
                  label: isArabic ? 'الوظائف' : 'Find Jobs',
                  onTap: () => context.go(AppRoutes.jobs),
                ),
                const SizedBox(width: 22),
                _NavBarItem(
                  label: isArabic ? 'إنشاء سيرة' : 'Post a Job',
                  onTap: () => context.go(AppRoutes.cvBuilder),
                ),
                const SizedBox(width: 22),
                _NavBarItem(
                  label: isArabic ? 'المرشحون' : 'Candidates',
                  onTap: () => context.go(AppRoutes.jobs),
                ),
                const SizedBox(width: 22),
                _NavBarItem(
                  label: isArabic ? 'الشركات' : 'Companies',
                  onTap: () => context.go(AppRoutes.jobs),
                ),
                const SizedBox(width: 22),
                _NavBarItem(
                  label: isArabic ? 'الموارد ▾' : 'Resources ▾',
                  onTap: () => context.go(AppRoutes.cvBuilder),
                ),
              ],
            ),

          // Right: Login, [Sign Up] button & Flags
          Row(
            children: [
              TextButton(
                onPressed: () => context.go(AppRoutes.login),
                child: Text(
                  isArabic ? 'دخول' : 'Login',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // Sign Up Outline Button matching reference image
              OutlinedButton(
                onPressed: () => context.go(AppRoutes.login),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00C2E8),
                  side: const BorderSide(color: Color(0xFF00C2E8), width: 1.2),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  isArabic ? 'تسجيل' : 'Sign Up',
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              // Country Flags pill (🇺🇸 🇩🇪)
              GestureDetector(
                onTap: () {
                  jobProvider.setLocaleCode(isArabic ? 'en' : 'ar');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: const Text('🇺🇸 🇩🇪 ▾', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatefulWidget {
  const _NavBarItem({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            color: _isHovered ? const Color(0xFF00C2E8) : const Color(0xFFC7D2E0),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
