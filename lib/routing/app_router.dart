import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/auth_provider.dart';
import '../features/applications/applications_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/cv_builder/cv_builder_screen.dart';
import '../features/dashboard/dashboard_screen.dart';
import '../features/job_details/job_details_screen.dart';
import '../features/jobs/jobs_screen.dart';
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

// ── Routes that require authentication ───────────────────────────────────────
const _kGuardedRoutes = {
  AppRoutes.dashboard,
  AppRoutes.jobs,
  AppRoutes.cvBuilder,
  AppRoutes.profile,
  AppRoutes.applications,
  AppRoutes.messages,
};

// ════════════════════════════════════════════════════════════════════════════
// buildAppRouter — factory that accepts the AuthProvider so the router's
// redirect callback and refreshListenable are fully reactive.
// ════════════════════════════════════════════════════════════════════════════
GoRouter buildAppRouter(AppAuthProvider authProvider) {
  return GoRouter(
    debugLogDiagnostics: false,
    initialLocation: AppRoutes.dashboard,

    // Re-evaluate redirect every time auth state changes
    refreshListenable: authProvider,

    // ── Auth guard ──────────────────────────────────────────────────────
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final isOnLogin = loc == AppRoutes.login;

      // While Firebase is still resolving the session — show nothing
      if (authProvider.isLoading) return null;

      final isLoggedIn = authProvider.isAuthenticated;

      // Unauthenticated user hitting a guarded route → send to login
      if (!isLoggedIn && _kGuardedRoutes.any((r) => loc == r || loc.startsWith('/jobs/'))) {
        return AppRoutes.login;
      }

      // Authenticated user landing on /login → send to dashboard
      if (isLoggedIn && isOnLogin) return AppRoutes.dashboard;

      return null; // no redirect needed
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

      // ── Dashboard ─────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const DashboardScreen(),
        ),
      ),

      // ── Jobs List + Job Detail ─────────────────────────────────────────
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

      // ── CV Builder ────────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.cvBuilder,
        name: 'cvBuilder',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const CvBuilderScreen(),
        ),
      ),

      // ── User Profile ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),

      // ── Applications ──────────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.applications,
        name: 'applications',
        pageBuilder: (context, state) => _fadePage(
          key: state.pageKey,
          child: const ApplicationsScreen(),
        ),
      ),

      // ── Messages (placeholder) ────────────────────────────────────────
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

// ── Shared fade transition ────────────────────────────────────────────────────
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

// ════════════════════════════════════════════════════════════════════════════
// _PlaceholderScreen — only for routes not yet implemented (Messages)
// ════════════════════════════════════════════════════════════════════════════
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
              label: const Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _ErrorScreen — 404 / routing error fallback
// ════════════════════════════════════════════════════════════════════════════
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
              child: const Text('Go to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
