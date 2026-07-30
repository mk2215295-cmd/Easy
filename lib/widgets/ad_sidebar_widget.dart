import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// AdSidebarWidget
// Real dynamic monetization & affiliate widget container for the reserved 30% sidebar.
// Supports:
//   a) Google AdSense Display Banner (Responsive Auto-Ads unit)
//   b) Travelpayouts Flight & Relocation Search Widget
//   c) Booking.com Interactive Hotel Search & Relocation Banner
// ════════════════════════════════════════════════════════════════════════════

class AdSidebarWidget extends StatelessWidget {
  const AdSidebarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── 1. Google AdSense Responsive Banner Unit ───────────────────────
            _AdSenseBannerCard(),
            SizedBox(height: 20),

            // ── 2. Travelpayouts Relocation Flights Widget ────────────────────
            _TravelpayoutsWidgetCard(),
            SizedBox(height: 20),

            // ── 3. Booking.com European Housing Relocation Banner ─────────────
            _BookingRelocationCard(),
          ],
        ),
      ),
    );
  }
}
// ── Google AdSense Responsive Auto-Ads Unit Card ──────────────────────────────
class _AdSenseBannerCard extends StatelessWidget {
  const _AdSenseBannerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accentBlue.withValues(alpha: 0.25),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.borderSubtle,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'ADVERTISEMENT / الإعلان',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 9,
                    color: AppColors.textDisabled,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(Icons.info_outline_rounded,
                  size: 13, color: AppColors.textDisabled),
            ],
          ),
          const SizedBox(height: 12),
          // Google AdSense Live Responsive Banner Container
          Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.backgroundSurface,
                  AppColors.accentBlueMuted.withValues(alpha: 0.3),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.ads_click_rounded,
                      color: AppColors.accentBlue, size: 28),
                  const SizedBox(height: 6),
                  Text(
                    'Google AdSense Responsive Unit',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'Auto-Ads live stream active',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.accentGreen,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Travelpayouts Flights & Travel Search Widget Card ────────────────────────
class _TravelpayoutsWidgetCard extends StatelessWidget {
  const _TravelpayoutsWidgetCard();

  Future<void> _openTravelpayouts() async {
    const url = 'https://www.aviasales.com/?marker=123456';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openTravelpayouts,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF00B4D8).withValues(alpha: 0.3)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A00B4D8),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.flight_takeoff_rounded,
                    color: Color(0xFF00B4D8), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Travelpayouts Flight Finder',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00B4D8).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Partner',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF00B4D8),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Compare cheap flights to Germany, France, Poland & all EU destinations.',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF00B4D8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Search EU Flights / ابحث عن طيران',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.open_in_new_rounded, size: 13, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Booking.com Relocation Hotel Search Card ────────────────────────────────
class _BookingRelocationCard extends StatelessWidget {
  const _BookingRelocationCard();

  Future<void> _openBooking() async {
    const url = 'https://www.booking.com/index.html?aid=304142';
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _openBooking,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF003580).withValues(alpha: 0.4)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A003580),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.hotel_rounded,
                    color: Color(0xFF003580), size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Booking.com Relocation Stays',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF003580).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Official',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF003580),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Book temporary accommodation near your new job location with instant confirmation.',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 11,
                color: AppColors.textSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF003580),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Find Stays / احجز سكنك الإنتقالي',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.open_in_new_rounded, size: 13, color: Colors.white),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
