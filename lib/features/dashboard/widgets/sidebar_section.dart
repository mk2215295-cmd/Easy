import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl, LaunchMode;

import '../../../core/models/affiliate_deal_model.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/ad_sidebar_widget.dart';

// ════════════════════════════════════════════════════════════════════════════════
// SidebarSection  — Right 30 % sticky panel of the dashboard.
//
// Contains two subsections mirroring the mockup:
//   1. "Flight Deals / عروض الطيران"
//   2. "Stay Near Your Job / اسكن بالقرب من عملك"
//
// Both take a list of [AffiliateDealModel] items injected by the parent.
// While loading, each subsection shows skeleton placeholders.
// Affiliate links open in a new browser tab.
//
// The panel is NOT in a SingleChildScrollView — the parent screen wraps
// the entire right column in one, giving independent scroll from the left grid.
// ════════════════════════════════════════════════════════════════════════════════

class SidebarSection extends StatelessWidget {
  const SidebarSection({
    super.key,
    required this.flightDeals,
    required this.hotelDeals,
    this.isLoading = false,
  });

  /// Flight deals from affiliate API. Empty until API responds.
  final List<AffiliateDealModel> flightDeals;

  /// Hotel / accommodation deals from affiliate API.
  final List<AffiliateDealModel> hotelDeals;

  /// Shows skeleton cards when true.
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundSurface,
        border: Border(
          left: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Panel header ─────────────────────────────────────────────
            _PanelHeader(),

            const SizedBox(height: 20),

            // ── Flight Deals ─────────────────────────────────────────────
            const _SubsectionTitle(
              iconData: Icons.flight_rounded,
              labelEn: 'Flight Deals',
              labelAr: 'عروض الطيران',
            ),
            const SizedBox(height: 12),
            _DealList(
              deals: flightDeals,
              isLoading: isLoading,
              skeletonCount: 2,
              emptyIcon: Icons.flight_takeoff_rounded,
              emptyLabel: 'No flight deals loaded',
            ),

            const SizedBox(height: 24),

            // ── Hotel / Accommodation ────────────────────────────────────
            const _SubsectionTitle(
              iconData: Icons.hotel_rounded,
              labelEn: 'Stay Near Your Job',
              labelAr: 'اسكن بالقرب من عملك',
            ),
            const SizedBox(height: 12),
            _DealList(
              deals: hotelDeals,
              isLoading: isLoading,
              skeletonCount: 2,
              emptyIcon: Icons.bed_rounded,
              emptyLabel: 'No accommodation deals loaded',
            ),

            const SizedBox(height: 24),

            // ── Live Monetization & Affiliate Banners ─────────────────────
            const AdSidebarWidget(),

            const SizedBox(height: 20),

            // ── Affiliate disclosure ──────────────────────────────────────
            _AffiliateDisclosure(),
          ],
        ),
      ),
    );
  }
}

// ── _PanelHeader ───────────────────────────────────────────────────────────────
class _PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Bilingual panel title
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Travel & Accommodation  ',
                style: AppTextStyles.headlineMedium,
              ),
              TextSpan(
                text: 'السفر والإقامة',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Exclusive deals for Easy Work Web users',
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
        ),
        // Partner logos strip (text-based since logo URLs come from API)
        const SizedBox(height: 10),
        const Row(
          children: [
            _PartnerChip(name: 'Booking.com'),
            SizedBox(width: 8),
            _PartnerChip(name: 'TravelPayouts'),
          ],
        ),
      ],
    );
  }
}

class _PartnerChip extends StatelessWidget {
  const _PartnerChip({required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Text(
        name,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textSecondary,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── _SubsectionTitle ───────────────────────────────────────────────────────────
class _SubsectionTitle extends StatelessWidget {
  const _SubsectionTitle({
    required this.iconData,
    required this.labelEn,
    required this.labelAr,
  });
  final IconData iconData;
  final String labelEn;
  final String labelAr;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 8,
      runSpacing: 4,
      children: [
        Icon(iconData, size: 16, color: AppColors.accentBlue),
        Text(labelEn, style: AppTextStyles.titleMedium),
        Text(
          labelAr,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ── _DealList ──────────────────────────────────────────────────────────────────
class _DealList extends StatelessWidget {
  const _DealList({
    required this.deals,
    required this.isLoading,
    required this.skeletonCount,
    required this.emptyIcon,
    required this.emptyLabel,
  });
  final List<AffiliateDealModel> deals;
  final bool isLoading;
  final int skeletonCount;
  final IconData emptyIcon;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        children: List.generate(
          skeletonCount,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _SkeletonDealCard(),
          ),
        ),
      );
    }
    if (deals.isEmpty) {
      return _DealEmptyState(icon: emptyIcon, label: emptyLabel);
    }
    return Column(
      children: deals.map((deal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AffiliateDealCard(deal: deal),
        );
      }).toList(),
    );
  }
}

// ── _DealEmptyState ────────────────────────────────────────────────────────────
class _DealEmptyState extends StatelessWidget {
  const _DealEmptyState({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Center(
        child: Column(
          children: [
            Icon(icon, color: AppColors.textDisabled, size: 28),
            const SizedBox(height: 8),
            Text(label, style: AppTextStyles.bodyMedium.copyWith(fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ── AffiliateDealCard ──────────────────────────────────────────────────────────
/// A single affiliate deal card (flight OR hotel) rendered in the sidebar.
/// Tapping the CTA opens [deal.affiliateUrl] in a new browser tab.
class AffiliateDealCard extends StatefulWidget {
  const AffiliateDealCard({super.key, required this.deal});
  final AffiliateDealModel deal;

  @override
  State<AffiliateDealCard> createState() => _AffiliateDealCardState();
}

class _AffiliateDealCardState extends State<AffiliateDealCard> {
  bool _hovered = false;

  Future<void> _openLink() async {
    final url = widget.deal.affiliateUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final deal = widget.deal;
    final isFlight = deal.type == AffiliateDealType.flight;
    final price = deal.formattedPrice();

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: _hovered ? AppColors.accentBlue.withValues(alpha: 0.5) : AppColors.borderSubtle,
          ),
          boxShadow: _hovered
              ? [
                  const BoxShadow(
                    color: AppColors.accentBlueGlow,
                    blurRadius: 12,
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image section ──────────────────────────────────────────
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(10)),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Network image or gradient placeholder
                    if (deal.imageUrl != null && deal.imageUrl!.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: deal.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                            _DealImagePlaceholder(isFlight: isFlight),
                        errorWidget: (_, __, ___) =>
                            _DealImagePlaceholder(isFlight: isFlight),
                      )
                    else
                      _DealImagePlaceholder(isFlight: isFlight),

                    // Discount badge
                    if (deal.discountPercentage != null)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: _DiscountBadge(
                            pct: deal.discountPercentage!),
                      ),

                    // Flight route pill
                    if (isFlight &&
                        deal.originCity != null &&
                        deal.destinationCity != null)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: _RouteChip(
                          origin: deal.originCity!,
                          destination: deal.destinationCity!,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ── Content ───────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  if (deal.title != null)
                    Text(
                      deal.title!,
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                  if (deal.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      deal.subtitle!,
                      style:
                          AppTextStyles.bodyMedium.copyWith(fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],

                  const SizedBox(height: 10),

                  // Price row + CTA button
                  Row(
                    children: [
                      if (price != null) ...[
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'from ',
                                  style: AppTextStyles.bodyMedium
                                      .copyWith(fontSize: 11),
                                ),
                                TextSpan(
                                  text: price,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: AppColors.accentGreen,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ] else
                        const Spacer(),
                      SizedBox(
                        height: 32,
                        child: ElevatedButton(
                          onPressed: _openLink,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            textStyle: AppTextStyles.buttonPrimary
                                .copyWith(fontSize: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            isFlight ? 'Book Now' : 'View Deal',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DealImagePlaceholder extends StatelessWidget {
  const _DealImagePlaceholder({required this.isFlight});
  final bool isFlight;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFlight
              ? [const Color(0xFF0A2540), AppColors.accentBlueMuted]
              : [const Color(0xFF1A1F2E), AppColors.backgroundElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Icon(
          isFlight ? Icons.flight_rounded : Icons.hotel_rounded,
          color: AppColors.textDisabled,
          size: 32,
        ),
      ),
    );
  }
}

class _DiscountBadge extends StatelessWidget {
  const _DiscountBadge({required this.pct});
  final int pct;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accentGreen,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'وفر $pct%',
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _RouteChip extends StatelessWidget {
  const _RouteChip({required this.origin, required this.destination});
  final String origin;
  final String destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            origin,
            style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.arrow_forward_rounded,
                size: 10, color: AppColors.textSecondary),
          ),
          Text(
            destination,
            style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ── _SkeletonDealCard ──────────────────────────────────────────────────────────
class _SkeletonDealCard extends StatefulWidget {
  @override
  State<_SkeletonDealCard> createState() => _SkeletonDealCardState();
}

class _SkeletonDealCardState extends State<_SkeletonDealCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 2.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Widget _shimmer(double width, double height) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(10)),
            child: _shimmer(double.infinity, 100),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmer(double.infinity, 13),
                const SizedBox(height: 6),
                _shimmer(120, 10),
                const SizedBox(height: 12),
                Row(children: [
                  _shimmer(80, 14),
                  const Spacer(),
                  _shimmer(72, 32),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── _AffiliateDisclosure ───────────────────────────────────────────────────────
class _AffiliateDisclosure extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      '* Affiliate links. Easy Work Web may earn a commission from bookings at no extra cost to you.',
      style: AppTextStyles.labelSmall.copyWith(
        fontSize: 10,
        color: AppColors.textDisabled,
        fontStyle: FontStyle.italic,
      ),
    );
  }
}
