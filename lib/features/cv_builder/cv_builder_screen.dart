import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/providers/job_provider.dart';
import '../../core/models/cv_model.dart';
import '../../routing/app_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/app_header.dart';
import 'widgets/cv_form_step1.dart';
import 'widgets/cv_form_step2.dart';
import 'widgets/cv_form_step3.dart';
import 'widgets/cv_form_step4.dart';
import 'widgets/cv_form_step5.dart';
import 'widgets/cv_live_preview.dart';
import 'widgets/cv_step_indicator.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvBuilderScreen — Full 5-Step Europass CV Builder
//
// Step routing:
//   1 → Personal Information (profession dropdown, cascading country/city,
//       DOB mask, ATS bullet auto-inject)
//   2 → Work Experience (company, period, location, bullet list)
//   3 → Education & Training (degree dropdown, institution, years, field)
//   4 → Skills & Languages (chip tags, CEFR level selectors)
//   5 → Preview & Download (ATS checklist, summary card, PDF download)
//
// Split layout:
//   Desktop (≥ 960 px): Left form (60%) + Right live preview (40%)
//   Mobile   (< 960 px): Stacked (form → preview)
//
// All form data flows through JobProvider.updateCv() so the live preview
// always mirrors the latest state. No hardcoded placeholder data.
// ════════════════════════════════════════════════════════════════════════════

class CvBuilderScreen extends StatefulWidget {
  const CvBuilderScreen({super.key});

  @override
  State<CvBuilderScreen> createState() => _CvBuilderScreenState();
}

class _CvBuilderScreenState extends State<CvBuilderScreen> {
  int _currentStep = 1;
  static const int _totalSteps = 5;

  void _goNext() =>
      setState(() => _currentStep = (_currentStep + 1).clamp(1, _totalSteps));

  void _goBack() =>
      setState(() => _currentStep = (_currentStep - 1).clamp(1, _totalSteps));

  void _restart() => setState(() => _currentStep = 1);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth >= 960;

    final jobProvider = context.watch<JobProvider>();
    final isArabic = jobProvider.isArabic;
    final cvData = jobProvider.cv;

    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      drawer: AppDrawer(
        activeRoute: AppRoutes.cvBuilder,
        isArabic: isArabic,
        onLanguageToggle: (v) =>
            jobProvider.setLocaleCode(v ? 'ar' : 'en'),
      ),
      body: Column(
        children: [
          // ── Pinned universal header ────────────────────────────────────
          AppHeader(
            activeRoute: AppRoutes.cvBuilder,
            isArabic: isArabic,
            onLanguageToggle: (v) =>
                jobProvider.setLocaleCode(v ? 'ar' : 'en'),
          ),

          // ── Progress indicator bar ─────────────────────────────────────
          CvStepIndicator(currentStep: _currentStep),

          // ── Split / stacked layout ─────────────────────────────────────
          Expanded(
            child: isDesktop
                ? _buildDesktopLayout(cvData)
                : _buildMobileLayout(cvData),
          ),
        ],
      ),
    );
  }

  // ── Desktop: left form (60%) | right live preview (40%) ───────────────────
  Widget _buildDesktopLayout(CvModel cvData) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 0, 32, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Left — form pane
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundSurface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildStepForm(cvData),
              ),
            ),
          ),

          const SizedBox(width: 32),

          // Right — live preview (hidden on step 5 where the summary is in-form)
          Expanded(
            flex: 4,
            child: CvLivePreview(cv: cvData),
          ),
        ],
      ),
    );
  }

  // ── Mobile: stacked (form → preview) ─────────────────────────────────────
  Widget _buildMobileLayout(CvModel cvData) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: SizedBox(
              height: 600,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: _buildStepForm(cvData),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 480,
            child: CvLivePreview(cv: cvData),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Central step router ────────────────────────────────────────────────────
  Widget _buildStepForm(CvModel cvData) {
    final jobProvider = context.read<JobProvider>();

    void onChanged(CvModel updated) => jobProvider.updateCv(updated);

    switch (_currentStep) {
      case 1:
        return CvFormStep1(
          cv: cvData,
          onChanged: onChanged,
          onNext: _goNext,
        );
      case 2:
        return CvFormStep2(
          cv: cvData,
          onChanged: onChanged,
          onNext: _goNext,
          onBack: _goBack,
        );
      case 3:
        return CvFormStep3(
          cv: cvData,
          onChanged: onChanged,
          onNext: _goNext,
          onBack: _goBack,
        );
      case 4:
        return CvFormStep4(
          cv: cvData,
          onChanged: onChanged,
          onNext: _goNext,
          onBack: _goBack,
        );
      case 5:
        return CvFormStep5(
          cv: cvData,
          onBack: _goBack,
          onRestart: _restart,
        );
      default:
        return CvFormStep1(
          cv: cvData,
          onChanged: onChanged,
          onNext: _goNext,
        );
    }
  }
}
