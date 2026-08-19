import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// HeroSearchBar & Category Pills
// Exact 1-to-1 visual recreation of the image search console and category cards.
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
  final TextEditingController _titleController = TextEditingController(text: 'Software Engineer');
  final TextEditingController _locationController = TextEditingController(text: 'Berlin, Germany');
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
    final isDesktop = screenWidth >= 850;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Main Glassmorphic Search Bar Console ────────────────────────────
        Container(
          constraints: const BoxConstraints(maxWidth: 920),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF1B263B).withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFF5A7290).withValues(alpha: 0.4),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
              BoxShadow(
                color: const Color(0xFF00C2E8).withValues(alpha: 0.1),
                blurRadius: 30,
              ),
            ],
          ),
          child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
        ),

        const SizedBox(height: 24),

        // ── 4 Category Pills with exact colors from image ───────────────────
        _buildExactCategoryRow(isDesktop),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // 1. Job Title, Skill, or Company
        Expanded(
          flex: 42,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 4),
                child: Text(
                  widget.isArabic ? 'المسمى الوظيفي، المهارة، أو الشركة' : 'Job Title, Skill, or Company',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9FB2C8),
                  ),
                ),
              ),
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _titleController,
                        onSubmitted: (_) => _triggerSearch(),
                        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13.5, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: widget.isArabic ? 'مثال: Software Engineer' : 'e.g. Software Engineer',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        // 2. Location (City or Country)
        Expanded(
          flex: 38,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 6, bottom: 4),
                child: Text(
                  widget.isArabic ? 'الموقع (المدينة أو الدولة)' : 'Location (City or Country)',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF9FB2C8),
                  ),
                ),
              ),
              Container(
                height: 42,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        onSubmitted: (_) => _triggerSearch(),
                        style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13.5, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                          hintText: widget.isArabic ? 'مثال: Berlin, Germany' : 'e.g. Berlin, Germany',
                          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(width: 14),

        // 3. Glowing SEARCH Button
        Padding(
          padding: const EdgeInsets.only(top: 18),
          child: _buildSearchButton(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isArabic ? 'المسمى الوظيفي، المهارة، أو الشركة' : 'Job Title, Skill, or Company',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9FB2C8)),
        ),
        const SizedBox(height: 4),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _titleController,
                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Text(
          widget.isArabic ? 'الموقع (المدينة أو الدولة)' : 'Location (City or Country)',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF9FB2C8)),
        ),
        const SizedBox(height: 4),
        Container(
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFF64748B), size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _locationController,
                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13),
                  decoration: const InputDecoration(isDense: true, contentPadding: EdgeInsets.zero, border: InputBorder.none),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(width: double.infinity, child: _buildSearchButton()),
      ],
    );
  }

  Widget _buildSearchButton() {
    return MouseRegion(
      onEnter: (_) => setState(() => _isSearchHovered = true),
      onExit: (_) => setState(() => _isSearchHovered = false),
      child: GestureDetector(
        onTap: _triggerSearch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 42,
          padding: const EdgeInsets.symmetric(horizontal: 22),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _isSearchHovered
                  ? [const Color(0xFF00E5FF), const Color(0xFF00B0FF)]
                  : [const Color(0xFF00C2E8), const Color(0xFF0098B8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00C2E8).withValues(alpha: _isSearchHovered ? 0.65 : 0.35),
                blurRadius: 16,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.isArabic ? 'SEARCH' : 'SEARCH',
                style: const TextStyle(
                  color: Color(0xFF07121E),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(
                Icons.search_rounded,
                color: Color(0xFF07121E),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExactCategoryRow(bool isDesktop) {
    final categories = [
      {
        'id': 'Tech',
        'title': 'Tech',
        'jobs': '4.2k+ jobs',
        'icon': Icons.computer_rounded,
        'bg': const Color(0xFF142944),
        'border': const Color(0xFF2C5688),
        'iconBg': const Color(0xFF1B3D6B),
      },
      {
        'id': 'Finance',
        'title': 'Finance',
        'jobs': '3.1k+ jobs',
        'icon': Icons.account_balance_wallet_outlined,
        'bg': const Color(0xFF103534),
        'border': const Color(0xFF206965),
        'iconBg': const Color(0xFF184E4C),
      },
      {
        'id': 'Creative',
        'title': 'Creative',
        'jobs': '2.8k+ jobs',
        'icon': Icons.palette_outlined,
        'bg': const Color(0xFF3A231C),
        'border': const Color(0xFF6B4135),
        'iconBg': const Color(0xFF533127),
      },
      {
        'id': 'Remote',
        'title': 'Remote',
        'jobs': '5.5k+ jobs',
        'icon': Icons.sports_esports_outlined,
        'bg': const Color(0xFF342817),
        'border': const Color(0xFF69512F),
        'iconBg': const Color(0xFF503D23),
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((cat) {
          final isSelected = widget.selectedCategory.toLowerCase() == (cat['id'] as String).toLowerCase();
          return _ExactCategoryCard(
            title: cat['title'] as String,
            jobs: cat['jobs'] as String,
            icon: cat['icon'] as IconData,
            bgColor: cat['bg'] as Color,
            borderColor: cat['border'] as Color,
            iconBg: cat['iconBg'] as Color,
            isSelected: isSelected,
            onTap: () => widget.onCategorySelected(cat['id'] as String),
          );
        }).toList(),
      ),
    );
  }
}

class _ExactCategoryCard extends StatefulWidget {
  const _ExactCategoryCard({
    required this.title,
    required this.jobs,
    required this.icon,
    required this.bgColor,
    required this.borderColor,
    required this.iconBg,
    required this.isSelected,
    required this.onTap,
  });

  final String title;
  final String jobs;
  final IconData icon;
  final Color bgColor;
  final Color borderColor;
  final Color iconBg;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<_ExactCategoryCard> createState() => _ExactCategoryCardState();
}

class _ExactCategoryCardState extends State<_ExactCategoryCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 175,
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _isHovered ? widget.bgColor.withValues(alpha: 0.95) : widget.bgColor.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isHovered ? Colors.white.withValues(alpha: 0.6) : widget.borderColor,
              width: 1.2,
            ),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: widget.borderColor.withValues(alpha: 0.4),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              // Icon in circular badge
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.iconBg,
                ),
                child: Icon(widget.icon, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              // Title & Job Count
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.jobs,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF94A3B8),
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
