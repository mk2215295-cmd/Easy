import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/cv_model.dart';
import '../../../core/providers/job_provider.dart';
import '../../../theme/app_theme.dart';
import '../cv_form_data.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvFormStep2 — Work Experience
//
// Fields:
//   • Job Title (read-only mirror from Step 1 profession, editable)
//   • Company Name / اسم الشركة
//   • Work Period (date range: From → To)
//   • Work Location / موقع العمل
//   • Bullet points (auto-injected from ATS + user-editable)
//
// All changes notify via onChanged → JobProvider.updateCv() in real-time.
// ════════════════════════════════════════════════════════════════════════════
class CvFormStep2 extends StatefulWidget {
  const CvFormStep2({
    super.key,
    required this.cv,
    required this.onChanged,
    required this.onNext,
    required this.onBack,
  });

  final CvModel cv;
  final ValueChanged<CvModel> onChanged;
  final VoidCallback onNext;
  final VoidCallback onBack;

  @override
  State<CvFormStep2> createState() => _CvFormStep2State();
}

class _CvFormStep2State extends State<CvFormStep2> {
  late final TextEditingController _companyCtrl;
  late final TextEditingController _fromCtrl;
  late final TextEditingController _toCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _bulletCtrl;
  late List<String> _bullets;

  @override
  void initState() {
    super.initState();
    _companyCtrl = TextEditingController(text: widget.cv.companyName);
    _fromCtrl = TextEditingController(
        text: widget.cv.workDates.contains('–')
            ? widget.cv.workDates.split('–').first.trim()
            : widget.cv.workDates);
    _toCtrl = TextEditingController(
        text: widget.cv.workDates.contains('–')
            ? widget.cv.workDates.split('–').last.trim()
            : '');
    _locationCtrl = TextEditingController(text: widget.cv.workLocation);
    _bulletCtrl = TextEditingController();
    // Seed bullets from ATS data injected in Step 1
    _bullets = List<String>.from(widget.cv.workBulletPoints);

    _companyCtrl.addListener(_push);
    _fromCtrl.addListener(_push);
    _toCtrl.addListener(_push);
    _locationCtrl.addListener(_push);
  }

  @override
  void dispose() {
    _companyCtrl.dispose();
    _fromCtrl.dispose();
    _toCtrl.dispose();
    _locationCtrl.dispose();
    _bulletCtrl.dispose();
    super.dispose();
  }

  void _push() {
    final from = _fromCtrl.text.trim();
    final to = _toCtrl.text.trim();
    final dates = from.isEmpty && to.isEmpty
        ? ''
        : to.isEmpty
            ? from
            : '$from – $to';
    widget.onChanged(widget.cv.copyWith(
      companyName: _companyCtrl.text,
      workDates: dates,
      workLocation: _locationCtrl.text,
      workBulletPoints: _bullets,
    ));
  }

  void _addBullet() {
    final text = _bulletCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _bullets.add(text);
      _bulletCtrl.clear();
    });
    _push();
  }

  void _removeBullet(int index) {
    setState(() => _bullets.removeAt(index));
    _push();
  }

  @override
  Widget build(BuildContext context) {
    final prof = widget.cv.profession;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Step Header ──────────────────────────────────────────────
          const _StepHeader(
            en: 'Step 2: Work Experience',
            ar: 'الخطوة 2: الخبرة العملية',
          ),
          const SizedBox(height: 20),

          // ── Job Title (read from profession) ─────────────────────────
          _InfoBadge(
            icon: Icons.work_outline_rounded,
            label: 'Job Title / المسمى الوظيفي',
            value: prof.isNotEmpty ? prof : '— fill in Step 1 —',
          ),
          const SizedBox(height: 18),

          // ── Company Name ──────────────────────────────────────────────
          _LabeledField(
            labelEn: 'Company / Employer',
            labelAr: 'اسم الشركة أو صاحب العمل',
            controller: _companyCtrl,
            hint: 'e.g. TechCorp Italy',
          ),
          const SizedBox(height: 18),

          // ── Work Period ────────────────────────────────────────────────
          _label('Work Period / فترة العمل'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _fromCtrl,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'From: MM/YYYY'),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text('–',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 18)),
              ),
              Expanded(
                child: TextField(
                  controller: _toCtrl,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                      hintText: 'To: MM/YYYY or Current'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Work Location ─────────────────────────────────────────────
          _LabeledField(
            labelEn: 'Location',
            labelAr: 'موقع العمل',
            controller: _locationCtrl,
            hint: 'e.g. Berlin, Germany',
          ),
          const SizedBox(height: 18),

          // ── Experience Bullet Points ──────────────────────────────────
          _label('Experience Bullets / نقاط الخبرة'),
          const SizedBox(height: 6),
          // Display injected/entered bullets
          if (_bullets.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Column(
                children: List.generate(_bullets.length, (i) {
                  return ListTile(
                    dense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
                    leading: Container(
                      width: 6,
                      height: 6,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: const BoxDecoration(
                        color: AppColors.accentBlue,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(
                      _bullets[i],
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontSize: 12),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.close_rounded,
                          size: 15, color: AppColors.textSecondary),
                      onPressed: () => _removeBullet(i),
                    ),
                  );
                }),
              ),
            ),

          // Add bullet input row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bulletCtrl,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                    hintText: 'Type a custom bullet point and press Add / اكتب نقطة جديدة',
                  ),
                  onSubmitted: (_) => _addBullet(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _addBullet,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                ),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── 💡 Suggested Experience Bullets (Bilingual AR/EN mapping) ──────
          _SuggestedBulletsSection(
            professionTitle: prof,
            activeBullets: _bullets,
            isArabic: context.watch<JobProvider>().isArabic,
            onToggleBullet: (textEn) {
              setState(() {
                if (_bullets.contains(textEn)) {
                  _bullets.remove(textEn);
                } else {
                  _bullets.add(textEn);
                }
              });
              _push();
            },
          ),
          const SizedBox(height: 30),

          // ── Navigation Buttons ────────────────────────────────────────
          _NavRow(onBack: widget.onBack, onNext: widget.onNext,
              nextLabel: 'Next: Education / التالي: التعليم'),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Shared helpers (private to file)
// ────────────────────────────────────────────────────────────────────────────

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.en, required this.ar});
  final String en;
  final String ar;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(ar,
            style: AppTextStyles.headlineLarge
                .copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(en,
            style: AppTextStyles.bodyMedium
                .copyWith(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({
    required this.labelEn,
    required this.labelAr,
    required this.controller,
    required this.hint,
  });
  final String labelEn;
  final String labelAr;
  final TextEditingController controller;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label('$labelEn / $labelAr'),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(hintText: hint),
        ),
      ],
    );
  }
}

class _InfoBadge extends StatelessWidget {
  const _InfoBadge(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.accentBlueMuted.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(10),
        border:
            Border.all(color: AppColors.accentBlue.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.accentBlue),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 10, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(value,
                    style: AppTextStyles.titleMedium.copyWith(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget _label(String text) {
  return RichText(
    text: TextSpan(
      style: AppTextStyles.titleMedium.copyWith(fontSize: 12),
      children: [TextSpan(text: text)],
    ),
  );
}

class _NavRow extends StatelessWidget {
  const _NavRow(
      {required this.onBack,
      required this.onNext,
      required this.nextLabel});
  final VoidCallback onBack;
  final VoidCallback onNext;
  final String nextLabel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        OutlinedButton.icon(
          onPressed: onBack,
          icon: const Icon(Icons.chevron_left_rounded, size: 18),
          label: const Text('Back'),
        ),
        const Spacer(),
        ElevatedButton.icon(
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded, size: 18),
          label: Text(nextLabel,
              style: AppTextStyles.buttonPrimary.copyWith(fontSize: 13)),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        ),
      ],
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// _SuggestedBulletsSection
// Renders preset experience bullet suggestions. When [isArabic] is true,
// displays the Arabic text in the UI selection list. Tapping a bullet chip
// maps and inserts its corresponding formal English text into the CV model.
// ════════════════════════════════════════════════════════════════════════════
class _SuggestedBulletsSection extends StatelessWidget {
  const _SuggestedBulletsSection({
    required this.professionTitle,
    required this.activeBullets,
    required this.isArabic,
    required this.onToggleBullet,
  });

  final String professionTitle;
  final List<String> activeBullets;
  final bool isArabic;
  final void Function(String textEn) onToggleBullet;

  @override
  Widget build(BuildContext context) {
    final match = kProfessions
            .where((p) =>
                p.titleEn.toLowerCase() == professionTitle.toLowerCase())
            .firstOrNull ??
        kProfessions.first;

    final suggestions = match.suggestedBullets;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lightbulb_rounded,
                  color: AppColors.accentGreen, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isArabic
                      ? 'نقاط الخبرة المقترحة لمسمى: ${match.titleAr}'
                      : 'Suggested Experience Points for ${match.titleEn}',
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accentGreenMuted,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Bilingual ATS',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 9,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            isArabic
                ? 'انقر فوق أي نقطة بالأسفل لإضافتها فوراً بنصها الإنجليزي المعياري إلى سيرتك الذاتية Europass'
                : 'Tap any bullet below to insert its standardized ATS English text into your CV',
            style: AppTextStyles.bodyMedium.copyWith(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Column(
            children: suggestions.map((b) {
              final isAdded = activeBullets.contains(b.textEn);
              final displayText = isArabic ? b.textAr : b.textEn;

              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onToggleBullet(b.textEn),
                  borderRadius: BorderRadius.circular(10),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: isAdded
                          ? AppColors.accentGreenMuted.withValues(alpha: 0.25)
                          : AppColors.backgroundSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isAdded
                            ? AppColors.accentGreen
                            : AppColors.borderSubtle,
                        width: isAdded ? 1.5 : 1.0,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isAdded
                              ? Icons.check_circle_rounded
                              : Icons.add_circle_outline_rounded,
                          color: isAdded
                              ? AppColors.accentGreen
                              : AppColors.accentBlue,
                          size: 18,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayText,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontSize: 12,
                                  fontWeight: isAdded
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (isArabic) ...[
                                const SizedBox(height: 2),
                                Text(
                                  b.textEn,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    fontSize: 10,
                                    fontStyle: FontStyle.italic,
                                    color: AppColors.textSecondary
                                        .withValues(alpha: 0.8),
                                  ),
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
            }).toList(),
          ),
        ],
      ),
    );
  }
}
