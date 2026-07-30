import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/models/cv_model.dart';
import '../../../core/services/pdf_service.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvFormStep5 — Preview & Download
//
// The final step in the CV Builder. Shows:
//   • Full live Europass preview summary panel
//   • High-contrast bilingual action buttons (EN + AR)
//   • PDF generation progress indicator during download
//   • Restart / Edit from beginning option
//   • ATS readiness checklist (green ticks for filled sections)
// ════════════════════════════════════════════════════════════════════════════

class CvFormStep5 extends StatefulWidget {
  const CvFormStep5({
    super.key,
    required this.cv,
    required this.onBack,
    required this.onRestart,
  });

  final CvModel cv;
  final VoidCallback onBack;
  final VoidCallback onRestart;

  @override
  State<CvFormStep5> createState() => _CvFormStep5State();
}

class _CvFormStep5State extends State<CvFormStep5> {
  bool _isGenerating = false;
  bool _done = false;
  String? _errorMessage;

  Future<void> _downloadPdf() async {
    setState(() {
      _isGenerating = true;
      _done = false;
      _errorMessage = null;
    });
    try {
      await PdfService().downloadCvPdf(widget.cv);
      if (mounted) setState(() => _done = true);
    } catch (e) {
      if (mounted) setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cv = widget.cv;
    final checks = _buildChecklist(cv);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Step header ──────────────────────────────────────────────────────
          Text(
            'الخطوة 5: المعاينة النهائية والتحميل',
            style: AppTextStyles.headlineLarge
                .copyWith(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Step 5: Preview & Download',
            style: AppTextStyles.bodyMedium
                .copyWith(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // ── ATS readiness checklist ─────────────────────────────────────
          _AtsChecklist(checks: checks),
          const SizedBox(height: 24),

          // ── Cover Letter generator section ──────────────────────────────
          _CoverLetterCard(cv: cv),
          const SizedBox(height: 24),

          // ── CV summary card ──────────────────────────────────────────────
          _CvSummaryCard(cv: cv),
          const SizedBox(height: 28),

          // ── Download button (primary) ───────────────────────────────────
          SizedBox(
            height: 58,
            child: ElevatedButton(
              onPressed: _isGenerating ? null : _downloadPdf,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentBlue,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 4,
              ),
              child: _isGenerating
                  ? const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                AppColors.white),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text('Generating PDF…',
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      ],
                    )
                  : _done
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.check_circle_rounded, size: 20),
                            SizedBox(width: 8),
                            Text('Downloaded!  تم التنزيل',
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.download_rounded, size: 22),
                            SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Download Europass PDF',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  'تنزيل السيرة الذاتية بصيغة PDF',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ],
                        ),
            ),
          ),

          // ── Error message ───────────────────────────────────────────────
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: Colors.redAccent.withValues(alpha: 0.35)),
              ),
              child: Text(
                'Error: $_errorMessage',
                style: const TextStyle(
                    fontSize: 11, color: Colors.redAccent),
              ),
            ),
          ],

          const SizedBox(height: 16),

          // ── Secondary actions row ────────────────────────────────────────
          Row(
            children: [
              // Back button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onBack,
                  icon: const Icon(Icons.chevron_left_rounded, size: 18),
                  label: const Text('Back / رجوع'),
                ),
              ),
              const SizedBox(width: 12),
              // Start over button
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: widget.onRestart,
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Start Over / بدء من جديد'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentAmber,
                    side: BorderSide(
                        color: AppColors.accentAmber.withValues(alpha: 0.5)),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  List<_AtsCheck> _buildChecklist(CvModel cv) => [
        _AtsCheck(
          label: 'Personal Info / البيانات الشخصية',
          labelAr: '',
          done: cv.fullName.isNotEmpty &&
              (cv.email.isNotEmpty || cv.phone.isNotEmpty),
        ),
        _AtsCheck(
          label: 'Profession Selected / المهنة محددة',
          labelAr: '',
          done: cv.profession.isNotEmpty,
        ),
        _AtsCheck(
          label: 'Work Experience / الخبرة العملية',
          labelAr: '',
          done: cv.workBulletPoints.isNotEmpty,
        ),
        _AtsCheck(
          label: 'Education / التعليم',
          labelAr: '',
          done: cv.educationDegree.isNotEmpty ||
              cv.educationInstitution.isNotEmpty,
        ),
        _AtsCheck(
          label: 'Skills Added / المهارات',
          labelAr: '',
          done: cv.skills.isNotEmpty,
        ),
      ];
}

class _AtsCheck {
  final String label;
  final String labelAr;
  final bool done;
  const _AtsCheck(
      {required this.label, required this.labelAr, required this.done});
}

// ── ATS Checklist widget ──────────────────────────────────────────────────────
class _AtsChecklist extends StatelessWidget {
  const _AtsChecklist({required this.checks});
  final List<_AtsCheck> checks;

  @override
  Widget build(BuildContext context) {
    final total = checks.length;
    final done = checks.where((c) => c.done).length;
    final pct = (done / total * 100).round();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'ATS Readiness',
                style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: pct >= 80
                      ? AppColors.accentGreenMuted.withValues(alpha: 0.2)
                      : AppColors.accentAmber.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$pct% Complete',
                  style: AppTextStyles.labelSmall.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: pct >= 80
                        ? AppColors.accentGreen
                        : AppColors.accentAmber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: done / total,
              minHeight: 5,
              backgroundColor:
                  AppColors.borderSubtle,
              valueColor: AlwaysStoppedAnimation<Color>(
                pct >= 80
                    ? AppColors.accentGreen
                    : AppColors.accentAmber,
              ),
            ),
          ),
          const SizedBox(height: 14),
          ...checks.map((c) => _CheckRow(check: c)),
        ],
      ),
    );
  }
}

class _CheckRow extends StatelessWidget {
  const _CheckRow({required this.check});
  final _AtsCheck check;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            check.done
                ? Icons.check_circle_rounded
                : Icons.radio_button_unchecked_rounded,
            size: 16,
            color: check.done
                ? AppColors.accentGreen
                : AppColors.textDisabled,
          ),
          const SizedBox(width: 10),
          Text(
            check.label,
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 12,
              color: check.done
                  ? AppColors.textPrimary
                  : AppColors.textDisabled,
            ),
          ),
        ],
      ),
    );
  }
}

// ── CV Summary Card ───────────────────────────────────────────────────────────
class _CvSummaryCard extends StatelessWidget {
  const _CvSummaryCard({required this.cv});
  final CvModel cv;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: AppColors.white.withValues(alpha: 0.07)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header bar
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 11),
                decoration: BoxDecoration(
                  color:
                      AppColors.backgroundElevated.withValues(alpha: 0.6),
                  border: const Border(
                      bottom:
                          BorderSide(color: AppColors.borderSubtle)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.article_outlined,
                        size: 15, color: AppColors.accentBlue),
                    const SizedBox(width: 8),
                    Text(
                      'Europass CV Summary',
                      style: AppTextStyles.titleMedium.copyWith(
                          fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                          color: AppColors.accentGreen,
                          shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'LIVE',
                      style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 8,
                          color: AppColors.accentGreen,
                          fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + profession
                    Text(
                      cv.fullName.isNotEmpty
                          ? cv.fullName.toUpperCase()
                          : 'YOUR FULL NAME',
                      style: AppTextStyles.headlineMedium.copyWith(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5),
                    ),
                    const SizedBox(height: 3),
                    if (cv.profession.isNotEmpty)
                      Text(
                        cv.profession,
                        style: AppTextStyles.titleMedium.copyWith(
                            fontSize: 13,
                            color: AppColors.accentBlue),
                      ),
                    const SizedBox(height: 10),
                    const Divider(color: AppColors.borderSubtle),
                    const SizedBox(height: 10),

                    // Meta grid
                    Wrap(
                      spacing: 16,
                      runSpacing: 8,
                      children: [
                        if (cv.email.isNotEmpty)
                          _MetaChip(
                              icon: Icons.email_outlined, text: cv.email),
                        if (cv.phone.isNotEmpty)
                          _MetaChip(
                              icon: Icons.phone_android_rounded,
                              text: cv.phone),
                        if (cv.address.isNotEmpty)
                          _MetaChip(
                              icon: Icons.location_on_outlined,
                              text: cv.address),
                        if (cv.dateOfBirth.isNotEmpty)
                          _MetaChip(
                              icon: Icons.cake_outlined,
                              text: cv.dateOfBirth),
                        if (cv.nationality.isNotEmpty)
                          _MetaChip(
                              icon: Icons.flag_outlined,
                              text: cv.nationality),
                      ],
                    ),

                    // Education
                    if (cv.educationDegree.isNotEmpty ||
                        cv.educationInstitution.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      _SumSection(
                        icon: Icons.school_outlined,
                        title: 'Education',
                        body:
                            '${cv.educationDegree}${cv.educationInstitution.isNotEmpty ? "  ·  ${cv.educationInstitution}" : ""}',
                      ),
                    ],

                    // Skills
                    if (cv.skills.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _SumSection(
                        icon: Icons.star_outline_rounded,
                        title: 'Skills',
                        body: cv.skills.join('  |  '),
                      ),
                    ],

                    // Work bullets count
                    if (cv.workBulletPoints.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      _SumSection(
                        icon: Icons.work_outline_rounded,
                        title: 'Work Experience',
                        body:
                            '${cv.workBulletPoints.length} ATS-optimised bullet points loaded',
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(text,
            style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 11, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _SumSection extends StatelessWidget {
  const _SumSection(
      {required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: AppColors.accentBlue),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: body),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ── _CoverLetterCard ─────────────────────────────────────────────────────────
class _CoverLetterCard extends StatelessWidget {
  const _CoverLetterCard({required this.cv});
  final CvModel cv;

  @override
  Widget build(BuildContext context) {
    final letterText = cv.generatedCoverLetterText;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.description_outlined,
                  color: AppColors.accentBlue, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'European Cover Letter Generator / خطاب التغطية الأوروبي',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accentGreenMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'ATS Tailored',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.accentGreen,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Text(
              letterText,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 12,
                height: 1.6,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
