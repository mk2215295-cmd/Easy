import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/affiliate_deal_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JdSidebar  — Right 30% sticky panel on the Job Details screen.
//
// Unlike the Dashboard's SidebarSection (which shows generic deals),
// this panel is contextually aware of the job's destination country.
// Key differences from Dashboard sidebar:
//   • Custom [titleAr] / [titleEn] header: "عروض حصرية في فرنسا"
//   • Booking.com + TravelPayouts logos strip
//   • Partner logos rendered at top
//   • Scroll up/down navigation arrows (for short viewport heights)
//   • Deals list is a combined flight + hotel list passed from parent
//
// Data comes from [JobModel.contextualDeals] once the API is wired in Phase 4.
// ════════════════════════════════════════════════════════════════════════════════

class JdSidebar extends StatefulWidget {
  const JdSidebar({
    super.key,
    required this.deals,
    this.isLoading = false,
    this.titleAr,
    this.titleEn,
  });

  final List<AffiliateDealModel> deals;
  final bool isLoading;

  /// Context-aware heading in Arabic. e.g. "عروض حصرية في فرنسا"
  final String? titleAr;

  /// Context-aware heading in English. e.g. "Exclusive deals in France"
  final String? titleEn;

  @override
  State<JdSidebar> createState() => _JdSidebarState();
}

class _JdSidebarState extends State<JdSidebar> {
  final ScrollController _scrollCtrl = ScrollController();

  void _scrollUp() {
    _scrollCtrl.animateTo(
      (_scrollCtrl.offset - 200).clamp(0, _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollDown() {
    _scrollCtrl.animateTo(
      (_scrollCtrl.offset + 200).clamp(0, _scrollCtrl.position.maxScrollExtent),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    _scrollCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundSurface,
        border: Border(
          left: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: Column(
        children: [
          // ── Up arrow ────────────────────────────────────────────────
          _ScrollArrow(onTap: _scrollUp, icon: Icons.keyboard_arrow_up_rounded),

          // ── Scrollable deals ─────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Partner logos strip
                  _PartnerLogosStrip(),

                  const SizedBox(height: 14),

                  // Context-aware heading
                  _ContextHeading(
                    titleAr: widget.titleAr,
                    titleEn: widget.titleEn,
                  ),

                  const SizedBox(height: 16),

                  // Deals list
                  if (widget.isLoading || widget.deals.isEmpty)
                    _SkeletonDeals()
                  else
                    _DealsList(deals: widget.deals),

                  const SizedBox(height: 12),

                  // Affiliate disclosure
                  Text(
                    '* Affiliate links — no extra cost to you.',
                    style: AppTextStyles.labelSmall.copyWith(
                      fontSize: 10,
                      color: AppColors.textDisabled,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Down arrow ───────────────────────────────────────────────
          _ScrollArrow(
              onTap: _scrollDown,
              icon: Icons.keyboard_arrow_down_rounded),
        ],
      ),
    );
  }
}

// ── _ScrollArrow ───────────────────────────────────────────────────────────────
class _ScrollArrow extends StatefulWidget {
  const _ScrollArrow({required this.onTap, required this.icon});
  final VoidCallback onTap;
  final IconData icon;

  @override
  State<_ScrollArrow> createState() => _ScrollArrowState();
}

class _ScrollArrowState extends State<_ScrollArrow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: double.infinity,
          height: 36,
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accentBlueMuted
                : AppColors.backgroundElevated,
            border: const Border(
              bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
              top: BorderSide(color: AppColors.borderSubtle, width: 1),
            ),
          ),
          child: Icon(
            widget.icon,
            color: _hovered ? AppColors.accentBlue : AppColors.textDisabled,
            size: 20,
          ),
        ),
      ),
    );
  }
}

// ── _PartnerLogosStrip ──────────────────────────────────────────────────────────
class _PartnerLogosStrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        _PartnerBadge(label: 'Booking.com', color: Color(0xFF003580)),
        SizedBox(width: 8),
        _PartnerBadge(label: '✈ travelpayouts', color: Color(0xFF1A3A5C)),
      ],
    );
  }
}

class _PartnerBadge extends StatelessWidget {
  const _PartnerBadge({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.white,
          fontWeight: FontWeight.w700,
          fontSize: 10,
        ),
      ),
    );
  }
}

// ── _ContextHeading ─────────────────────────────────────────────────────────────
class _ContextHeading extends StatelessWidget {
  const _ContextHeading({this.titleAr, this.titleEn});
  final String? titleAr;
  final String? titleEn;

  @override
  Widget build(BuildContext context) {
    final text = titleAr ?? titleEn ?? 'عروض حصرية';
    return Text(
      text,
      textAlign: TextAlign.right,
      style: AppTextStyles.headlineMedium.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16,
      ),
    );
  }
}

// ── _DealsList ─────────────────────────────────────────────────────────────────
class _DealsList extends StatelessWidget {
  const _DealsList({required this.deals});
  final List<AffiliateDealModel> deals;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: deals.map((deal) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: _JdDealCard(deal: deal),
        );
      }).toList(),
    );
  }
}

// ── _JdDealCard ─────────────────────────────────────────────────────────────────
class _JdDealCard extends StatefulWidget {
  const _JdDealCard({required this.deal});
  final AffiliateDealModel deal;

  @override
  State<_JdDealCard> createState() => _JdDealCardState();
}

class _JdDealCardState extends State<_JdDealCard> {
  bool _hovered = false;

  Future<void> _open() async {
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
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _hovered
                ? AppColors.accentBlue.withValues(alpha: 0.5)
                : AppColors.borderSubtle,
          ),
          boxShadow: _hovered
              ? [
                  const BoxShadow(
                    color: AppColors.accentBlueGlow,
                    blurRadius: 14,
                    spreadRadius: 0,
                  )
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: SizedBox(
                height: 110,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (deal.imageUrl != null && deal.imageUrl!.isNotEmpty)
                      CachedNetworkImage(
                        imageUrl: deal.imageUrl!,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => _placeholder(isFlight),
                        errorWidget: (_, __, ___) => _placeholder(isFlight),
                      )
                    else
                      _placeholder(isFlight),

                    // Discount badge
                    if (deal.discountPercentage != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: _DiscountBadge(pct: deal.discountPercentage!),
                      ),

                    // Flight icon overlay
                    if (isFlight)
                      const Positioned(
                        top: 8,
                        right: 8,
                        child: Icon(
                          Icons.flight_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (deal.title != null)
                    Text(
                      deal.title!,
                      textAlign: TextAlign.right,
                      style: AppTextStyles.titleMedium.copyWith(fontSize: 13),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // CTA button
                      SizedBox(
                        height: 34,
                        child: ElevatedButton(
                          onPressed: _open,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            textStyle: AppTextStyles.buttonPrimary
                                .copyWith(fontSize: 11),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          child: Text(isFlight ? 'استعرض العروض' : 'احجز الآن'),
                        ),
                      ),

                      const Spacer(),

                      // Price
                      if (price != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'من $price',
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.accentGreen,
                                fontSize: 13,
                              ),
                            ),
                            if (!isFlight)
                              Text(
                                'ليلة',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                          ],
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

  Widget _placeholder(bool isFlight) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isFlight
              ? [const Color(0xFF0A2540), AppColors.accentBlueMuted]
              : [const Color(0xFF1A2030), AppColors.backgroundElevated],
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

// ── _SkeletonDeals ──────────────────────────────────────────────────────────────
class _SkeletonDeals extends StatefulWidget {
  @override
  State<_SkeletonDeals> createState() => _SkeletonDealsState();
}

class _SkeletonDealsState extends State<_SkeletonDeals>
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

  Widget _shimmer(double h) => AnimatedBuilder(
        animation: _anim,
        builder: (_, __) => Container(
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
    return Column(
      children: [
        _shimmer(110),
        const SizedBox(height: 8),
        _shimmer(13),
        const SizedBox(height: 6),
        _shimmer(34),
        const SizedBox(height: 16),
        _shimmer(110),
        const SizedBox(height: 8),
        _shimmer(13),
        const SizedBox(height: 6),
        _shimmer(34),
      ],
    );
  }
}
