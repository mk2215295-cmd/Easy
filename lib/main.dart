import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/providers/auth_provider.dart';
import 'core/providers/job_provider.dart';
import 'firebase_options.dart';
import 'routing/app_router.dart';
import 'theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// Entry Point
// ════════════════════════════════════════════════════════════════════════════
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase before anything else
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  GoogleFonts.config.allowRuntimeFetching = true;

  // Create AuthProvider once — shared with both the Provider tree and
  // the GoRouter instance (as refreshListenable).
  final authProvider = AppAuthProvider();

  runApp(
    MultiProvider(
      providers: [
        // Auth must be first so GoRouter's redirect can read it
        ChangeNotifierProvider<AppAuthProvider>.value(value: authProvider),
        ChangeNotifierProvider<JobProvider>(
          create: (_) => JobProvider()..loadJobs(),
        ),
      ],
      child: EasyWorkApp(authProvider: authProvider),
    ),
  );
}

// ════════════════════════════════════════════════════════════════════════════
// EasyWorkApp — Root Widget
// ════════════════════════════════════════════════════════════════════════════
class EasyWorkApp extends StatefulWidget {
  const EasyWorkApp({super.key, required this.authProvider});
  final AppAuthProvider authProvider;

  @override
  State<EasyWorkApp> createState() => _EasyWorkAppState();
}

class _EasyWorkAppState extends State<EasyWorkApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = buildAppRouter(widget.authProvider);
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeCode =
        context.select<JobProvider, String>((p) => p.localeCode);

    return MaterialApp.router(
      title: 'Easy Work Web',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,

      routerConfig: _router,

      // ── Localisation ────────────────────────────────────────────────
      locale: Locale(localeCode),
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
        Locale('de'),
        Locale('fr'),
        Locale('it'),
        Locale('pl'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
    );
  }
}
