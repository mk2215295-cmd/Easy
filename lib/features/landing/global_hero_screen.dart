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
// The flagship interactive animated landing experience for Easy Work Global.
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
    final isDesktop = screenWidth >= 960;

    return Scaffold(
      backgroundColor: const Color(0xFF030712),
      body: GlobeParticlesBackground(
        child: Column(
          children: [
            // ── Top Navigation Bar ──────────────────────────────────────────
            _buildTopNavBar(context, authProvider, jobProvider, isArabic, isDesktop),

            // ── Main Scrollable Body ────────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    const SizedBox(height: 32),

                    // ── Hero Headline ───────────────────────────────────────
                    _buildHeadline(isArabic)
                        .animate()
                        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
                        .slideY(begin: 0.2, end: 0.0, duration: 600.ms),

                    const SizedBox(height: 28),

                    // ── Glowing Dual Search Console & Pills ─────────────────
                    HeroSearchBar(
                      onSearch: _onSearch,
                      onCategorySelected: _onCategorySelected,
                      selectedCategory: _selectedCategory,
                      isArabic: isArabic,
                    )
                        .animate()
                        .fadeIn(delay: 200.ms, duration: 600.ms)
                        .slideY(begin: 0.15, end: 0.0),

                    const SizedBox(height: 48),

                    // ── RECOMMENDED FOR YOU Carousel ────────────────────────
                    RecommendedJobsCarousel(
                      jobs: jobs,
                      isArabic: isArabic,
                    )
                        .animate()
                        .fadeIn(delay: 350.ms, duration: 600.ms)
                        .slideY(begin: 0.1, end: 0.0),

                    const SizedBox(height: 32),

                    // ── Featured Employers & Global Trends ──────────────────
                    FeaturedEmployersAndTrendsSection(isArabic: isArabic)
                        .animate()
                        .fadeIn(delay: 450.ms, duration: 600.ms),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavBar(
    BuildContext context,
    AppAuthProvider authProvider,
    JobProvider jobProvider,
    bool isArabic,
    bool isDesktop,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF070E1E).withValues(alpha: 0.8),
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withValues(alpha: 0.08),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Animated Cyber Brand Logo
          EasyWorkAnimatedLogo(
            size: 38,
            isArabic: isArabic,
            onTap: () => context.go(AppRoutes.dashboard),
          ),

          // Center Links (Desktop only)
          if (isDesktop)
            Row(
              children: [
                _NavLink(
                  label: isArabic ? 'تصفح الوظائف' : 'Find Jobs',
                  isActive: false,
                  onTap: () => context.go(AppRoutes.jobs),
                ),
                const SizedBox(width: 20),
                _NavLink(
                  label: isArabic ? 'صانع الـ CV الأوروبي' : 'Europass CV',
                  isActive: false,
                  onTap: () => context.go(AppRoutes.cvBuilder),
                ),
                const SizedBox(width: 20),
                _NavLink(
                  label: isArabic ? 'التقديمات' : 'Applications',
                  isActive: false,
                  onTap: () => context.go(AppRoutes.applications),
                ),
                const SizedBox(width: 20),
                _NavLink(
                  label: isArabic ? 'الملف الشخصي' : 'Profile',
                  isActive: false,
                  onTap: () => context.go(AppRoutes.profile),
                ),
              ],
            ),

          // Right: Language Switcher + Auth Action Buttons
          Row(
            children: [
              // Language Switcher Pill (Flags 🇺🇸 / 🇪🇬)
              GestureDetector(
                onTap: () {
                  jobProvider.setLocaleCode(isArabic ? 'en' : 'ar');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  child: Row(
                    children: [
                      Text(isArabic ? '🇺🇸 EN' : '🇪🇬 العربية',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Auth state check
              if (authProvider.isAuthenticated)
                ElevatedButton.icon(
                  onPressed: () => context.go(AppRoutes.profile),
                  icon: const Icon(Icons.person_outline_rounded, size: 16),
                  label: Text(isArabic ? 'حسابي' : 'My Account'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052CC),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                )
              else
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
                    ElevatedButton(
                      onPressed: () => context.go(AppRoutes.login),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00F0FF),
                        foregroundColor: const Color(0xFF030712),
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                      ),
                      child: Text(isArabic ? 'حساب جديد' : 'Sign Up'),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeadline(bool isArabic) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 800),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (bounds) => const LinearGradient(
              colors: [Colors.white, Color(0xFFE2E8F0), Color(0xFF00F0FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ).createShader(bounds),
            child: Text(
              isArabic
                  ? 'ابحث عن مستقبلك المهني في أوروبا والعالم'
                  : 'FIND YOUR FUTURE, WORLDWIDE.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: -0.5,
                height: 1.15,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            isArabic
                ? 'آلاف الوظائف الموثقة مع كفالة التأشيرة، توفير السكن، وإنشاء سيرة Europass معتمدة دولياً'
                : 'Verified visa-sponsored careers, European relocation assistance, and certified Europass CV engine.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8B949E),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
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
            color: (_isHovered || widget.isActive) ? const Color(0xFF00F0FF) : const Color(0xFFC9D1D9),
            fontSize: 13.5,
            fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
          ),
          child: Text(widget.label),
        ),
      ),
    );
  }
}
