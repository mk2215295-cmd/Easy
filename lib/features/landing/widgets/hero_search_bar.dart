import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// HeroSearchBar & Category Pills
// Glowing glassmorphic dual-input search console and quick category selector
// matching the user's reference image.
// ════════════════════════════════════════════════════════════════════════════
class HeroSearchBar extends StatefulWidget {
  const HeroSearchBar({
    super.key,
    required this.onSearch,
    required this.onCategorySelected,
    this.selectedCategory = 'All',
    this.isArabic = false,
  });

  final void Function(String titleQuery, String locationQuery) onSearch;
  final void Function(String category) onCategorySelected;
  final String selectedCategory;
  final bool isArabic;

  @override
  State<HeroSearchBar> createState() => _HeroSearchBarState();
}

class _HeroSearchBarState extends State<HeroSearchBar> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isSearchHovered = false;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    widget.onSearch(_titleController.text.trim(), _locationController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 800;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Main Glassmorphic Search Bar ────────────────────────────────────
        Container(
          constraints: const BoxConstraints(maxWidth: 860),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1E38).withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFF00F0FF).withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F0FF).withValues(alpha: 0.12),
                blurRadius: 30,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: isDesktop ? _buildDesktopInputs() : _buildMobileInputs(),
        ),

        const SizedBox(height: 24),

        // ── Category Pills Row ──────────────────────────────────────────────
        _buildCategoryPills(isDesktop),
      ],
    );
  }

  Widget _buildDesktopInputs() {
    return Row(
      children: [
        // Input 1: Job Title, Skill, or Company
        Expanded(
          flex: 5,
          child: _buildInputField(
            controller: _titleController,
            icon: Icons.search_rounded,
            label: widget.isArabic ? 'المسمى الوظيفي، المهارة، أو الشركة' : 'Job Title, Skill, or Company',
            hint: widget.isArabic ? 'مثال: مهندس، فني، Google...' : 'e.g. Software Engineer, Welder...',
          ),
        ),

        // Vertical divider line
        Container(
          width: 1,
          height: 42,
          margin: const EdgeInsets.symmetric(horizontal: 8),
          color: Colors.white.withValues(alpha: 0.15),
        ),

        // Input 2: Location (City or Country)
        Expanded(
          flex: 4,
          child: _buildInputField(
            controller: _locationController,
            icon: Icons.location_on_outlined,
            label: widget.isArabic ? 'الموقع (المدينة أو الدولة)' : 'Location (City or Country)',
            hint: widget.isArabic ? 'برلين، فرنسا، عن بُعد...' : 'Berlin, Germany, Remote...',
          ),
        ),

        const SizedBox(width: 8),

        // Search Button (Glowing Neon Teal)
        _buildSearchButton(),
      ],
    );
  }

  Widget _buildMobileInputs() {
    return Column(
      children: [
        _buildInputField(
          controller: _titleController,
          icon: Icons.search_rounded,
          label: widget.isArabic ? 'المسمى الوظيفي أو الشركة' : 'Job Title or Company',
          hint: widget.isArabic ? 'مهندس برمجيات...' : 'Software Engineer...',
        ),
        const SizedBox(height: 8),
        _buildInputField(
          controller: _locationController,
          icon: Icons.location_on_outlined,
          label: widget.isArabic ? 'الموقع (الدولة أو المدينة)' : 'Location (City/Country)',
          hint: widget.isArabic ? 'ألمانيا، باريس...' : 'Germany, Paris...',
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: _buildSearchButton(),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required IconData icon,
    required String label,
    required String hint,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF070F1E).withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B949E),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Icon(icon, color: const Color(0xFF00F0FF), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller,
                  onSubmitted: (_) => _triggerSearch(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      color: Colors.white.withValues(alpha: 0.35),
                      fontSize: 13,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isSearchHovered = true),
      onExit: (_) => setState(() => _isSearchHovered = false),
      child: GestureDetector(
        onTap: _triggerSearch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 28),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isSearchHovered
                  ? [const Color(0xFF00F0FF), const Color(0xFF10B981)]
                  : [const Color(0xFF00C9FF), const Color(0xFF0072FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00F0FF).withValues(alpha: _isSearchHovered ? 0.6 : 0.35),
                blurRadius: _isSearchHovered ? 20 : 12,
                spreadRadius: _isSearchHovered ? 2 : 0,
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.isArabic ? 'بحث' : 'SEARCH',
                  style: const TextStyle(
                    color: Color(0xFF030712),
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.search_rounded,
                  color: Color(0xFF030712),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryPills(bool isDesktop) {
    final categories = [
      {'id': 'Tech', 'nameEn': 'Tech & AI', 'nameAr': 'التقنية والبرمجيات', 'jobs': '4.2k+ jobs', 'icon': Icons.computer_rounded},
      {'id': 'Finance', 'nameEn': 'Finance & Business', 'nameAr': 'المالية والأعمال', 'jobs': '3.1k+ jobs', 'icon': Icons.account_balance_wallet_outlined},
      {'id': 'Creative', 'nameEn': 'Creative & Media', 'nameAr': 'التصميم والإعلام', 'jobs': '2.8k+ jobs', 'icon': Icons.palette_outlined},
      {'id': 'Remote', 'nameEn': 'Remote Global', 'nameAr': 'عن بُعد حول العالم', 'jobs': '5.5k+ jobs', 'icon': Icons.public_rounded},
      {'id': 'Industrial', 'nameEn': 'Vocational & Trades', 'nameAr': 'المهن الفنية والصناعية', 'jobs': '3.8k+ jobs', 'icon': Icons.handyman_outlined},
      {'id': 'Healthcare', 'nameEn': 'Healthcare & Care', 'nameAr': 'الرعاية والطب', 'jobs': '2.4k+ jobs', 'icon': Icons.medical_services_outlined},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((cat) {
          final isSelected = widget.selectedCategory.toLowerCase() == (cat['id'] as String).toLowerCase();
          return _CategoryPillItem(
            id: cat['id'] as String,
            name: widget.isArabic ? (cat['nameAr'] as String) : (cat['nameEn'] as String),
            jobCount: cat['jobs'] as String,
            icon: cat['icon'] as IconData,
            isSelected: isSelected,
            onTap: () => widget.onCategorySelected(cat['id'] as String),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryPillItem extends StatefulWidget {
  const _CategoryPillItem({
    required this.id,
    required this.name,
    required this.jobCount,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  final String id;
  final String name;
  final String jobCount;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_CategoryPillItem> createState() => _CategoryPillItemState();
}

class _CategoryPillItemState extends State<_CategoryPillItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final active = widget.isSelected || _isHovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF00F0FF).withValues(alpha: 0.12)
                : const Color(0xFF0F1E38).withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: active
                  ? const Color(0xFF00F0FF).withValues(alpha: 0.6)
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.2,
            ),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: const Color(0xFF00F0FF).withValues(alpha: 0.2),
                      blurRadius: 16,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active
                      ? const Color(0xFF00F0FF).withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.06),
                ),
                child: Icon(
                  widget.icon,
                  size: 16,
                  color: active ? const Color(0xFF00F0FF) : Colors.white70,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: active ? Colors.white : Colors.white70,
                    ),
                  ),
                  Text(
                    widget.jobCount,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: active ? const Color(0xFF00F0FF) : const Color(0xFF8B949E),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: active ? const Color(0xFF00F0FF) : const Color(0xFF8B949E),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
