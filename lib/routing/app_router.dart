import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/auth_provider.dart';
import '../features/applications/applications_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/cv_builder/cv_builder_screen.dart';
import '../features/job_details/job_details_screen.dart';
import '../features/jobs/jobs_screen.dart';
import '../features/landing/global_hero_screen.dart';
import '../features/profile/profile_screen.dart';
import '../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// AppRoutes — canonical route path constants
// ════════════════════════════════════════════════════════════════════════════
abstract final class AppRoutes {
  static const String login        = '/login';
  static const String dashboard    = '/';
  static const String jobs         = '/jobs';
  static const String jobDetail    = '/jobs/:jobId';
  static const String cvBuilder    = '/cv-builder';
  static const String profile      = '/profile';
  static const String applications = '/applications';
  static const String messages     = '/messages';
}

// ── Private routes that require authentication ───────────────────────────────
const _kGuardedRoutes = {
  AppRoutes.profile,
  AppRoutes.applications,
  AppRoutes.messages,
};

// ════════════════════════════════════════════════════════════════════════════
// buildAppRouter — factory that accepts AuthProvider for reactive redirects.
// ════════════════════════════════════════════════════════════════════════════
GoRouter buildAppRouter(AppAuthProvider authProvider) {
  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: AppRoutes.dashboard,

    refreshListenable: authProvider,

    // ── Auth guard ──────────────────────────────────────────────────────
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isOnLogin = loc == AppRoutes.login;

      if (authProvider.isLoading) return null;

      final isLoggedIn = authProvider.isAuthenticated;

      // Only redirect if unauthenticated user attempts to access private pages
      if (!isLoggedIn && _kGuardedRoutes.contains(loc)) {
        return AppRoutes.login;
      }

      if (isLoggedIn && isOnLogin) return AppRoutes.dashboard;

      return null;
    },

    routes: [
      // ── Public: Login ─────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),

      // ── Flagship Animated Landing Hero ────────────────────────────────
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const GlobalHeroScreen(),
        ),
      ),

      // ── Jobs List + Job Detail (Public Access) ────────────────────────
      GoRoute(
        path: AppRoutes.jobs,
        name: 'jobs',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const JobsScreen(),
        ),
        routes: [
          GoRoute(
            path: ':jobId',
            name: 'jobDetail',
            pageBuilder: (context, state) {
              final jobId = state.pathParameters['jobId'] ?? '';
              return _fadePage(
                key: state.pageKey,
                child: JobDetailsScreen(jobId: jobId),
              );
            },
          ),
        ],
      ),

      // ── CV Builder (Public Access) ────────────────────────────────────
      GoRoute(
        path: AppRoutes.cvBuilder,
        name: 'cvBuilder',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const CvBuilderScreen(),
        ),
      ),

      // ── User Profile (Guarded) ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),

      // ── Applications (Guarded) ────────────────────────────────────────
      GoRoute(
        path: AppRoutes.applications,
        name: 'applications',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const ApplicationsScreen(),
        ),
      ),

      // ── Messages ──────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.messages,
        name: 'messages',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const _PlaceholderScreen(
            label: 'Messages',
            labelAr: 'الرسائل',
            icon: Icons.chat_bubble_outline_rounded,
          ),
        ),
      ),
    ],

    errorPageBuilder: (context, state) => _fadePage(
      key: state.pageKey,
      child: _ErrorScreen(error: state.error),
    ),
  );
}

CustomTransitionPage<void> _fadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({
    required this.label,
    required this.labelAr,
    this.icon = Icons.construction_rounded,
  });
  final String label;
  final String labelAr;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accentBlueMuted, width: 2),
              ),
              child: Icon(icon, color: AppColors.accentBlue, size: 36),
            ),
            const SizedBox(height: 20),
            Text(label, style: AppTextStyles.headlineLarge),
            const SizedBox(height: 8),
            Text(
              'Coming soon',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textDisabled),
            ),
            const SizedBox(height: 28),
            TextButton.icon(
              onPressed: () => context.go(AppRoutes.dashboard),
              icon: const Icon(Icons.arrow_back_rounded, size: 16),
              label: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  const _ErrorScreen({this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppColors.error, size: 56),
            const SizedBox(height: 20),
            Text('Page Not Found', style: AppTextStyles.headlineLarge),
            const SizedBox(height: 8),
            Text(
              error?.toString() ?? 'The requested route does not exist.',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.dashboard),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
