import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_assets.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/providers/job_provider.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// AppHeader  — Universal sticky navigation header used on EVERY screen.
// ════════════════════════════════════════════════════════════════════════════════

class AppHeader extends StatefulWidget {
  const AppHeader({
    super.key,
    this.activeRoute,
    this.onLanguageToggle,
    this.isArabic = false,
  });

  final String? activeRoute;
  final ValueChanged<bool>? onLanguageToggle;
  final bool isArabic;

  static const double barHeight = 64.0;

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  static const List<_NavItem> _navItems = [
    _NavItem(
      labelEn: 'Dashboard',
      labelAr: 'الرئيسية',
      route: AppRoutes.dashboard,
      icon: Icons.grid_view_rounded,
    ),
    _NavItem(
      labelEn: 'Jobs',
      labelAr: 'الوظائف',
      route: AppRoutes.jobs,
      icon: Icons.work_outline_rounded,
    ),
    _NavItem(
      labelEn: 'Applications',
      labelAr: 'طلباتي',
      route: AppRoutes.applications,
      icon: Icons.description_outlined,
    ),
    _NavItem(
      labelEn: 'Messages',
      labelAr: 'الرسائل',
      route: AppRoutes.messages,
      icon: Icons.chat_bubble_outline_rounded,
    ),
    _NavItem(
      labelEn: 'Profile',
      labelAr: 'ملفي',
      route: AppRoutes.profile,
      icon: Icons.person_outline_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 1080;
    final isTablet = screenWidth >= 640 && screenWidth < 1080;

    final jobProvider = context.watch<JobProvider>();
    final isArabic = jobProvider.isArabic;

    return Container(
      height: AppHeader.barHeight,
      decoration: const BoxDecoration(
        color: AppColors.backgroundSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 32.0 : (isTablet ? 20.0 : 16.0),
        ),
        child: Row(
          children: [
            // ── Logo ────────────────────────────────────────────────────
            const _LogoSection(),

            const SizedBox(width: 32),

            // ── Navigation ──────────────────────────────────────────────
            if (isDesktop) ...[
              Expanded(
                child: _DesktopNav(
                  items: _navItems,
                  activeRoute: widget.activeRoute,
                  isArabic: isArabic,
                ),
              ),
            ] else if (isTablet) ...[
              Expanded(
                child: _TabletNav(
                  items: _navItems,
                  activeRoute: widget.activeRoute,
                ),
              ),
            ] else ...[
              const Spacer(),
            ],

            // ── Right-side Actions ───────────────────────────────────────
            _ActionsBar(
              isArabic: isArabic,
              onLanguageToggle: (v) => jobProvider.setLocaleCode(v ? 'ar' : 'en'),
              showHamburger: !isDesktop && !isTablet,
              navItems: _navItems,
              activeRoute: widget.activeRoute,
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _LogoSection
// Displays the official scaled-down Easy Work logo in the top nav & drawer.
// ════════════════════════════════════════════════════════════════════════════════
class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(AppRoutes.dashboard),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x1A007FFF),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Image.asset(
            AppAssets.logo,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Image.asset(
              AppAssets.logoImage14,
              height: 32,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _DesktopNav  — Full text tabs with animated underline indicator
// ════════════════════════════════════════════════════════════════════════════════
class _DesktopNav extends StatelessWidget {
  const _DesktopNav({
    required this.items,
    required this.activeRoute,
    required this.isArabic,
  });

  final List<_NavItem> items;
  final String? activeRoute;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        final isActive = activeRoute == item.route ||
            (item.route != AppRoutes.dashboard &&
                (activeRoute?.startsWith(item.route) ?? false));
        return _DesktopNavTab(
          item: item,
          isActive: isActive,
          isArabic: isArabic,
        );
      }).toList(),
    );
  }
}

class _DesktopNavTab extends StatefulWidget {
  const _DesktopNavTab({
    required this.item,
    required this.isActive,
    required this.isArabic,
  });

  final _NavItem item;
  final bool isActive;
  final bool isArabic;

  @override
  State<_DesktopNavTab> createState() => _DesktopNavTabState();
}

class _DesktopNavTabState extends State<_DesktopNavTab> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.isArabic ? widget.item.labelAr : widget.item.labelEn;
    final textColor = widget.isActive
        ? AppColors.accentBlue
        : _hovered
            ? AppColors.textPrimary
            : AppColors.textSecondary;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: AppHeader.barHeight,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isActive
                    ? AppColors.accentBlue
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.item.icon,
                size: 16,
                color: textColor,
              ),
              const SizedBox(width: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: (widget.isActive
                        ? AppTextStyles.navActive
                        : AppTextStyles.navInactive)
                    .copyWith(color: textColor),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _TabletNav  — Icon-only nav with tooltips
// ════════════════════════════════════════════════════════════════════════════════
class _TabletNav extends StatelessWidget {
  const _TabletNav({required this.items, required this.activeRoute});

  final List<_NavItem> items;
  final String? activeRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: items.map((item) {
        final isActive = activeRoute == item.route ||
            (item.route != AppRoutes.dashboard &&
                (activeRoute?.startsWith(item.route) ?? false));
        return Tooltip(
          message: item.labelEn,
          child: _IconNavBtn(item: item, isActive: isActive),
        );
      }).toList(),
    );
  }
}

class _IconNavBtn extends StatefulWidget {
  const _IconNavBtn({required this.item, required this.isActive});
  final _NavItem item;
  final bool isActive;

  @override
  State<_IconNavBtn> createState() => _IconNavBtnState();
}

class _IconNavBtnState extends State<_IconNavBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => context.go(widget.item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 44,
          height: AppHeader.barHeight,
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: widget.isActive
                    ? AppColors.accentBlue
                    : Colors.transparent,
                width: 2,
              ),
            ),
          ),
          child: Icon(
            widget.item.icon,
            size: 20,
            color: widget.isActive
                ? AppColors.accentBlue
                : _hovered
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _ActionsBar  — Right cluster: language toggle, notifications, avatar,
//                and (on mobile) hamburger for the drawer.
// ════════════════════════════════════════════════════════════════════════════════
class _ActionsBar extends StatelessWidget {
  const _ActionsBar({
    required this.isArabic,
    required this.onLanguageToggle,
    required this.showHamburger,
    required this.navItems,
    required this.activeRoute,
  });

  final bool isArabic;
  final ValueChanged<bool>? onLanguageToggle;
  final bool showHamburger;
  final List<_NavItem> navItems;
  final String? activeRoute;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Language Toggle (Picker) ─────────────────────────────────────
        const _LanguagePicker(),

        SizedBox(width: showHamburger ? 4 : 8),

        // ── Notification Bell (desktop/tablet only) ──────────────────────
        if (!showHamburger) ...[
          _NotificationBell(),
          const SizedBox(width: 8),
        ],

        // ── User Avatar ───────────────────────────────────────────────────
        _UserAvatarButton(),

        // ── Mobile Hamburger ──────────────────────────────────────────────
        if (showHamburger) ...[
          const SizedBox(width: 4),
          _HamburgerButton(
            navItems: navItems,
            activeRoute: activeRoute,
            isArabic: isArabic,
          ),
        ],
      ],
    );
  }
}

// ── Language Picker Dropdown ──────────────────────────────────────────────────
class _LanguagePicker extends StatelessWidget {
  const _LanguagePicker();

  static const Map<String, String> _languages = {
    'en': '🇺🇸  EN',
    'ar': '🇪🇬  AR',
    'de': '🇩🇪  DE',
    'fr': '🇫🇷  FR',
    'it': '🇮🇹  IT',
    'pl': '🇵🇱  PL',
  };

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final activeLocale = jobProvider.localeCode;

    return PopupMenuButton<String>(
      tooltip: 'Select Language / اختر اللغة',
      onSelected: (code) => jobProvider.setLocaleCode(code),
      color: AppColors.backgroundSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      child: Container(
        height: 32,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.borderSubtle),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              activeLocale.toUpperCase(),
              style: AppTextStyles.labelSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down_rounded, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
      itemBuilder: (context) {
        return _languages.entries.map((entry) {
          final isSelected = entry.key == activeLocale;
          return PopupMenuItem<String>(
            value: entry.key,
            child: Row(
              children: [
                Text(
                  entry.value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected ? AppColors.accentBlue : AppColors.textPrimary,
                  ),
                ),
                if (isSelected) ...[
                  const Spacer(),
                  const Icon(Icons.check_rounded, size: 14, color: AppColors.accentBlue),
                ],
              ],
            ),
          );
        }).toList();
      },
    );
  }
}

// ── Notification Bell ─────────────────────────────────────────────────────────
class _NotificationBell extends StatefulWidget {
  @override
  State<_NotificationBell> createState() => _NotificationBellState();
}

class _NotificationBellState extends State<_NotificationBell> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () {/* TODO: open notifications panel */},
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.backgroundHover
                : AppColors.backgroundElevated,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                size: 20,
                color:
                    _hovered ? AppColors.textPrimary : AppColors.textSecondary,
              ),
              // Notification dot — driven by API unread count in Phase 3
              Positioned(
                top: 7,
                right: 7,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accentBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── User Avatar Button ────────────────────────────────────────────────────────
class _UserAvatarButton extends StatefulWidget {
  @override
  State<_UserAvatarButton> createState() => _UserAvatarButtonState();
}

class _UserAvatarButtonState extends State<_UserAvatarButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AppAuthProvider>();
    final user = auth.currentUser;

    final photoUrl = user?.photoUrl;
    final initials = user?.initials ?? '?';
    final displayName = user?.displayName ?? 'User';
    final email = user?.email ?? '';

    final avatar = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: _hovered ? AppColors.accentBlue : AppColors.borderSubtle,
            width: 2,
          ),
          boxShadow: _hovered
              ? const [
                  BoxShadow(
                    color: AppColors.accentBlueGlow,
                    blurRadius: 10,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: ClipOval(
          child: photoUrl != null && photoUrl.isNotEmpty
              ? CachedNetworkImage(
                  imageUrl: photoUrl,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => _InitialsCircle(initials: initials),
                  errorWidget: (_, __, ___) =>
                      _InitialsCircle(initials: initials),
                )
              : _InitialsCircle(initials: initials),
        ),
      ),
    );

    // Not logged in — navigate to profile on tap
    if (user == null) {
      return GestureDetector(
        onTap: () => context.go(AppRoutes.profile),
        child: avatar,
      );
    }

    // Logged in — show popup menu
    return PopupMenuButton<String>(
      tooltip: '',
      color: AppColors.backgroundElevated,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.borderSubtle),
      ),
      offset: const Offset(0, 48),
      onSelected: (val) async {
        if (val == 'signout') {
          await auth.signOut();
          if (context.mounted) context.go(AppRoutes.login);
        } else if (val == 'profile') {
          context.go(AppRoutes.profile);
        }
      },
      itemBuilder: (_) => [
        // User info header (non-selectable)
        PopupMenuItem<String>(
          enabled: false,
          height: 64,
          child: Row(
            children: [
              SizedBox(
                width: 36,
                height: 36,
                child: ClipOval(
                  child: photoUrl != null && photoUrl.isNotEmpty
                      ? CachedNetworkImage(
                          imageUrl: photoUrl,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) =>
                              _InitialsCircle(initials: initials),
                        )
                      : _InitialsCircle(initials: initials),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      displayName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      email,
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const PopupMenuDivider(),
        // Profile
        PopupMenuItem<String>(
          value: 'profile',
          child: Row(
            children: [
              const Icon(Icons.person_outline_rounded,
                  size: 15, color: AppColors.textSecondary),
              const SizedBox(width: 10),
              Text('My Profile',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontSize: 13, color: AppColors.textPrimary)),
            ],
          ),
        ),
        // Sign out
        PopupMenuItem<String>(
          value: 'signout',
          child: Row(
            children: [
              const Icon(Icons.logout_rounded,
                  size: 15, color: AppColors.error),
              const SizedBox(width: 10),
              Text(
                'Sign Out / تسجيل الخروج',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: 13,
                  color: AppColors.error,
                ),
              ),
            ],
          ),
        ),
      ],
      child: avatar,
    );
  }
}

// ── Initials fallback circle ──────────────────────────────────────────────────
class _InitialsCircle extends StatelessWidget {
  const _InitialsCircle({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 38,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.accentBlueMuted, AppColors.backgroundElevated],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTextStyles.titleMedium.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.accentBlue,
          ),
        ),
      ),
    );
  }
}

// ── Mobile Hamburger → Drawer ─────────────────────────────────────────────────
class _HamburgerButton extends StatelessWidget {
  const _HamburgerButton({
    required this.navItems,
    required this.activeRoute,
    required this.isArabic,
  });
  final List<_NavItem> navItems;
  final String? activeRoute;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.menu_rounded),
      color: AppColors.textSecondary,
      onPressed: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// AppDrawer — mobile side-drawer nav (used by Scaffold.drawer)
// ════════════════════════════════════════════════════════════════════════════════
class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.activeRoute,
    required this.isArabic,
    this.onLanguageToggle,
  });

  final String? activeRoute;
  final bool isArabic;
  final ValueChanged<bool>? onLanguageToggle;

  static const List<_NavItem> _items = [
    _NavItem(
        labelEn: 'Dashboard',
        labelAr: 'الرئيسية',
        route: AppRoutes.dashboard,
        icon: Icons.grid_view_rounded),
    _NavItem(
        labelEn: 'Jobs',
        labelAr: 'الوظائف',
        route: AppRoutes.jobs,
        icon: Icons.work_outline_rounded),
    _NavItem(
        labelEn: 'Applications',
        labelAr: 'طلباتي',
        route: AppRoutes.applications,
        icon: Icons.description_outlined),
    _NavItem(
        labelEn: 'Messages',
        labelAr: 'الرسائل',
        route: AppRoutes.messages,
        icon: Icons.chat_bubble_outline_rounded),
    _NavItem(
        labelEn: 'Profile',
        labelAr: 'ملفي',
        route: AppRoutes.profile,
        icon: Icons.person_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundSurface,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo in drawer header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: _LogoSection(),
            ),
            const Divider(color: AppColors.borderSubtle, height: 1),
            const SizedBox(height: 12),
            // Nav items
            ...(_items.map((item) {
              final isActive = activeRoute == item.route;
              return ListTile(
                leading: Icon(
                  item.icon,
                  color: isActive
                      ? AppColors.accentBlue
                      : AppColors.textSecondary,
                  size: 20,
                ),
                title: Text(
                  isArabic ? item.labelAr : item.labelEn,
                  style: isActive
                      ? AppTextStyles.navActive
                      : AppTextStyles.navInactive,
                ),
                selected: isActive,
                selectedTileColor: AppColors.accentBlueMuted,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                onTap: () {
                  Navigator.of(context).pop(); // close drawer
                  context.go(item.route);
                },
              );
            })),
            const Spacer(),
            // Language picker at bottom
            const Padding(
              padding: EdgeInsets.all(20),
              child: _LanguagePicker(),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// _NavItem — immutable nav route descriptor
// ════════════════════════════════════════════════════════════════════════════════
class _NavItem {
  const _NavItem({
    required this.labelEn,
    required this.labelAr,
    required this.route,
    required this.icon,
  });
  final String labelEn;
  final String labelAr;
  final String route;
  final IconData icon;
}
