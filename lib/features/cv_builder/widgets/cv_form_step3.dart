import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/models/cv_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvFormStep3 — Education & Training
//
// Fields:
//   • Degree / الشهادة أو المؤهل  (dropdown from kDegrees)
//   • Institution / المدرسة أو الجامعة
//   • Graduation Year / سنة التخرج  (4-digit mask)
//   • Start Year / سنة الالتحاق
//   • Field of Study / مجال الدراسة
//   • Location / موقع المؤسسة
//
// All changes propagate live to the preview via onChanged.
// ════════════════════════════════════════════════════════════════════════════

const List<String> _kDegrees = [
  'High School Diploma',
  'Vocational Training Certificate',
  'Technical Diploma (2-Year)',
  'Associate Degree',
  "Bachelor's Degree",
  "Master's Degree",
  'PhD / Doctorate',
  'Professional Certification',
  'Trade / Craft Certificate',
];

class CvFormStep3 extends StatefulWidget {
  const CvFormStep3({
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
  State<CvFormStep3> createState() => _CvFormStep3State();
}

class _CvFormStep3State extends State<CvFormStep3> {
  late final TextEditingController _institutionCtrl;
  late final TextEditingController _startYearCtrl;
  late final TextEditingController _endYearCtrl;
  late final TextEditingController _fieldCtrl;
  late final TextEditingController _locationCtrl;
  String? _selectedDegree;

  @override
  void initState() {
    super.initState();
    _selectedDegree = widget.cv.educationDegree.isNotEmpty
        ? (_kDegrees.contains(widget.cv.educationDegree)
            ? widget.cv.educationDegree
            : null)
        : null;
    _institutionCtrl =
        TextEditingController(text: widget.cv.educationInstitution);
    // Parse dates from 'YYYY – YYYY' format
    final dates = widget.cv.educationDates;
    _startYearCtrl = TextEditingController(
        text: dates.contains('–') ? dates.split('–').first.trim() : '');
    _endYearCtrl = TextEditingController(
        text: dates.contains('–') ? dates.split('–').last.trim() : dates);
    _fieldCtrl = TextEditingController(text: widget.cv.educationField);
    _locationCtrl =
        TextEditingController(text: widget.cv.educationLocation);

    _institutionCtrl.addListener(_push);
    _startYearCtrl.addListener(_push);
    _endYearCtrl.addListener(_push);
    _fieldCtrl.addListener(_push);
    _locationCtrl.addListener(_push);
  }

  @override
  void dispose() {
    _institutionCtrl.dispose();
    _startYearCtrl.dispose();
    _endYearCtrl.dispose();
    _fieldCtrl.dispose();
    _locationCtrl.dispose();
    super.dispose();
  }

  void _push() {
    final s = _startYearCtrl.text.trim();
    final e = _endYearCtrl.text.trim();
    final dates = s.isNotEmpty && e.isNotEmpty
        ? '$s – $e'
        : e.isNotEmpty
            ? e
            : s;
    widget.onChanged(widget.cv.copyWith(
      educationDegree: _selectedDegree ?? '',
      educationInstitution: _institutionCtrl.text,
      educationDates: dates,
      educationField: _fieldCtrl.text,
      educationLocation: _locationCtrl.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ───────────────────────────────────────────────────
          const _StepHeader(
              en: 'Step 3: Education & Training',
              ar: 'الخطوة 3: التعليم والتدريب'),
          const SizedBox(height: 20),

          // ── Degree Dropdown ──────────────────────────────────────────
          _label('Degree / الشهادة أو المؤهل'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedDegree,
            dropdownColor: AppColors.backgroundElevated,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Select your qualification / اختر مؤهلك',
            ),
            items: _kDegrees
                .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                .toList(),
            onChanged: (val) {
              setState(() => _selectedDegree = val);
              _push();
            },
          ),
          const SizedBox(height: 18),

          // ── Institution ──────────────────────────────────────────────
          _LabeledField(
            labelEn: 'School / University',
            labelAr: 'المدرسة أو الجامعة',
            controller: _institutionCtrl,
            hint: 'e.g. Technical Institute of Alexandria',
          ),
          const SizedBox(height: 18),

          // ── Study Years ──────────────────────────────────────────────
          _label('Study Period / فترة الدراسة'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _startYearCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(hintText: 'Start: YYYY'),
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
                  controller: _endYearCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration:
                      const InputDecoration(hintText: 'End: YYYY'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // ── Field of Study ────────────────────────────────────────────
          _LabeledField(
            labelEn: 'Field of Study',
            labelAr: 'مجال الدراسة',
            controller: _fieldCtrl,
            hint: 'e.g. Modern Electrical Machines',
          ),
          const SizedBox(height: 18),

          // ── Location ─────────────────────────────────────────────────
          _LabeledField(
            labelEn: 'Institution Location',
            labelAr: 'موقع المؤسسة',
            controller: _locationCtrl,
            hint: 'e.g. Alexandria, Egypt',
          ),
          const SizedBox(height: 30),

          // ── Navigation ───────────────────────────────────────────────
          _NavRow(
            onBack: widget.onBack,
            onNext: widget.onNext,
            nextLabel: 'Next: Skills / التالي: المهارات',
          ),
        ],
      ),
    );
  }
}

// ── Shared helpers ────────────────────────────────────────────────────────────
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
