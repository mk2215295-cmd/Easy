import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/user_profile_model.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/job_provider.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// ProfileSidebar
// Left sidebar navigation panel for the User Profile screen.
// Displays:
//   • User Profile Avatar (reads FirebaseAuth.instance.currentUser?.photoURL)
//   • Dynamic completion progress badge (e.g. "60% Profile Completion")
//   • Bilingual localized navigation menu links (لوحة التحكم، سيري الذاتية،الطلبات المقدمة، الإعدادات)
//   • Log Out CTA button at the bottom
// ════════════════════════════════════════════════════════════════════════════════
class ProfileSidebar extends StatefulWidget {
  const ProfileSidebar({
    super.key,
    required this.profile,
    required this.activeMenu,
    required this.onMenuChanged,
    required this.onLogOut,
  });

  /// The user profile data structure model.
  final UserProfileModel profile;

  /// Currently selected menu item e.g. "dashboard", "cvs", "jobs", "settings".
  final String activeMenu;

  /// Callback when a menu item is tapped.
  final ValueChanged<String> onMenuChanged;

  /// Callback when Log Out is clicked.
  final VoidCallback onLogOut;

  @override
  State<ProfileSidebar> createState() => _ProfileSidebarState();
}

class _ProfileSidebarState extends State<ProfileSidebar> {
  String? _hoveredMenu;
  bool _logOutHovered = false;

  @override
  Widget build(BuildContext context) {
    final jobProvider = context.watch<JobProvider>();
    final authProvider = context.watch<AppAuthProvider>();
    final isAr = jobProvider.isArabic;

    final user = authProvider.currentUser;
    final photoUrl = user?.photoUrl ?? widget.profile.avatarUrl;
    final initials = user?.initials ??
        (widget.profile.fullName.isNotEmpty ? widget.profile.fullName[0].toUpperCase() : 'U');

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.backgroundSurface,
        border: Border(
          right: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── App Logo / Title ──────────────────────────────────────────
          _buildLogo(),

          const SizedBox(height: 32),

          // ── User Information (Avatar + Name) ──────────────────────────
          _buildUserHeader(photoUrl, initials),

          const SizedBox(height: 20),

          // ── Profile Completion Pill ──────────────────────────────────
          _buildCompletionBadge(isAr),

          const SizedBox(height: 32),

          // ── Navigation Menu List ─────────────────────────────────────
          Expanded(
            child: Column(
              children: [
                _buildMenuItem(
                  id: 'dashboard',
                  label: isAr ? 'لوحة التحكم' : 'Dashboard',
                  icon: Icons.grid_view_rounded,
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  id: 'cvs',
                  label: isAr ? 'سيري الذاتية' : 'My CVs',
                  icon: Icons.description_rounded,
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  id: 'jobs',
                  label: isAr ? 'الطلبات المقدمة' : 'Applied Jobs',
                  icon: Icons.work_history_rounded,
                ),
                const SizedBox(height: 8),
                _buildMenuItem(
                  id: 'settings',
                  label: isAr ? 'الإعدادات' : 'Settings',
                  icon: Icons.settings_rounded,
                ),
              ],
            ),
          ),

          // ── Log Out Button ───────────────────────────────────────────
          _buildLogOutButton(isAr),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.work_rounded,
            color: AppColors.accentBlue,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Easy Work Web',
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }

  Widget _buildUserHeader(String? photoUrl, String initials) {
    return Column(
      children: [
        // Circular Avatar with fallback initials
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.accentBlueGlow,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          child: ClipOval(
            child: photoUrl != null && photoUrl.isNotEmpty
                ? CachedNetworkImage(
                    imageUrl: photoUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => _AvatarPlaceholder(initials: initials),
                    errorWidget: (_, __, ___) => _AvatarPlaceholder(initials: initials),
                  )
                : _AvatarPlaceholder(initials: initials),
          ),
        ),
        const SizedBox(height: 12),
        // Name
        Text(
          widget.profile.fullName,
          style: AppTextStyles.headlineMedium.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildCompletionBadge(bool isAr) {
    final pct = widget.profile.profileCompletionPercentage;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentBlueMuted.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.accentBlue.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: AppColors.accentBlue,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$pct%',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.accentBlue,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  isAr ? 'إكمال الملف الشخصي' : 'Profile Completion',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required String id,
    required String label,
    required IconData icon,
  }) {
    final isActive = widget.activeMenu == id;
    final isHovered = _hoveredMenu == id;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hoveredMenu = id),
      onExit: (_) => setState(() => _hoveredMenu = null),
      child: GestureDetector(
        onTap: () => widget.onMenuChanged(id),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.backgroundHover
                : isHovered
                    ? AppColors.backgroundElevated.withValues(alpha: 0.5)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive
                  ? AppColors.borderSubtle
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive
                    ? AppColors.accentBlue
                    : isHovered
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color: isActive
                      ? AppColors.textPrimary
                      : isHovered
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                ),
              ),
              if (isActive) ...[
                const Spacer(),
                Container(
                  width: 4,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.accentBlue,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogOutButton(bool isAr) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _logOutHovered = true),
      onExit: (_) => setState(() => _logOutHovered = false),
      child: GestureDetector(
        onTap: widget.onLogOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _logOutHovered
                ? AppColors.error.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.logout_rounded,
                color: _logOutHovered ? AppColors.error : AppColors.textSecondary,
                size: 18,
              ),
              const SizedBox(width: 12),
              Text(
                isAr ? 'تسجيل الخروج' : 'Log Out',
                style: AppTextStyles.titleMedium.copyWith(
                  fontSize: 13,
                  color: _logOutHovered ? AppColors.error : AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder({required this.initials});
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.accentBlue,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
      ),
    );
  }
}
