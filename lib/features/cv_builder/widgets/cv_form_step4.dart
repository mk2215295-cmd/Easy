import 'package:flutter/material.dart';
import '../../../core/models/cv_model.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvFormStep4 — Skills & Languages
//
// Features:
//   • Quick-add chip panel: tap a suggestion to add it instantly.
//   • Free-text input with Enter/Add button for custom skills.
//   • Removable chip tags rendered in a Wrap layout.
//   • CEFR language level selectors (5 dropdowns for the language table).
//
// Live-syncs to CvModel.skills and all cefrXxx fields on every change.
// ════════════════════════════════════════════════════════════════════════════

const List<String> _kSuggestions = [
  'Electrical Installations', 'PLC Programming', 'Welding (MIG/TIG)',
  'Forklift Operation', 'HACCP', 'MS Word', 'MS Excel', 'Power Point',
  'AutoCAD', 'Heavy Equipment', 'Teamwork', 'Decision-making',
  'Safety Compliance', 'Inventory Management', 'Customer Service',
];

const List<String> _kCefrLevels = [
  'A1', 'A2', 'B1', 'B2', 'C1', 'C2',
];

class CvFormStep4 extends StatefulWidget {
  const CvFormStep4({
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
  State<CvFormStep4> createState() => _CvFormStep4State();
}

class _CvFormStep4State extends State<CvFormStep4> {
  late List<String> _skills;
  late final TextEditingController _customCtrl;

  // CEFR levels
  late String _listening;
  late String _reading;
  late String _spokenProd;
  late String _spokenInt;
  late String _writing;

  @override
  void initState() {
    super.initState();
    _skills = List<String>.from(widget.cv.skills);
    _customCtrl = TextEditingController();
    _listening = widget.cv.cefrListening.isNotEmpty
        ? widget.cv.cefrListening
        : 'B1';
    _reading = widget.cv.cefrReading.isNotEmpty
        ? widget.cv.cefrReading
        : 'B1';
    _spokenProd = widget.cv.cefrSpokenProduction.isNotEmpty
        ? widget.cv.cefrSpokenProduction
        : 'B1';
    _spokenInt = widget.cv.cefrSpokenInteraction.isNotEmpty
        ? widget.cv.cefrSpokenInteraction
        : 'B1';
    _writing = widget.cv.cefrWriting.isNotEmpty
        ? widget.cv.cefrWriting
        : 'B1';
  }

  @override
  void dispose() {
    _customCtrl.dispose();
    super.dispose();
  }

  void _push() {
    widget.onChanged(widget.cv.copyWith(
      skills: _skills,
      cefrListening: _listening,
      cefrReading: _reading,
      cefrSpokenProduction: _spokenProd,
      cefrSpokenInteraction: _spokenInt,
      cefrWriting: _writing,
    ));
  }

  void _addSkill(String skill) {
    final s = skill.trim();
    if (s.isEmpty || _skills.contains(s)) return;
    setState(() => _skills.add(s));
    _push();
  }

  void _removeSkill(String skill) {
    setState(() => _skills.remove(skill));
    _push();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          const _StepHeader(
              en: 'Step 4: Skills & Languages',
              ar: 'الخطوة 4: المهارات واللغات'),
          const SizedBox(height: 20),

          // ── Quick-add suggestion chips ──────────────────────────────────
          _sectionLabel('Quick Add / إضافة سريعة'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _kSuggestions.map((s) {
              final alreadyAdded = _skills.contains(s);
              return FilterChip(
                label: Text(s,
                    style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 11,
                        color: alreadyAdded
                            ? AppColors.accentGreen
                            : AppColors.textSecondary)),
                selected: alreadyAdded,
                onSelected: (_) => alreadyAdded
                    ? _removeSkill(s)
                    : _addSkill(s),
                checkmarkColor: AppColors.accentGreen,
                selectedColor:
                    AppColors.accentGreenMuted.withValues(alpha: 0.2),
                backgroundColor: AppColors.backgroundElevated,
                side: BorderSide(
                  color: alreadyAdded
                      ? AppColors.accentGreen.withValues(alpha: 0.5)
                      : AppColors.borderSubtle,
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

          // ── Custom skill input ──────────────────────────────────────────
          _sectionLabel('Custom Skill / مهارة مخصصة'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _customCtrl,
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: AppColors.textPrimary),
                  decoration: const InputDecoration(
                      hintText: 'Type a skill and press Add'),
                  onSubmitted: (v) {
                    _addSkill(v);
                    _customCtrl.clear();
                  },
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  _addSkill(_customCtrl.text);
                  _customCtrl.clear();
                },
                style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 12)),
                child: const Text('Add'),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // ── Active skill chips ──────────────────────────────────────────
          if (_skills.isNotEmpty) ...[
            _sectionLabel('Your Skills / مهاراتك'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills.map((s) {
                return Chip(
                  label: Text(s,
                      style: AppTextStyles.labelSmall.copyWith(
                          fontSize: 11, color: AppColors.textPrimary)),
                  deleteIcon: const Icon(Icons.close_rounded, size: 13),
                  onDeleted: () => _removeSkill(s),
                  backgroundColor: AppColors.backgroundElevated,
                  side: const BorderSide(color: AppColors.borderSubtle),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
          ],

          // ── CEFR Language Levels ────────────────────────────────────────
          _sectionLabel('Language CEFR Levels / مستوى اللغة'),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.backgroundElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle),
            ),
            child: Column(
              children: [
                _CefrRow(
                  label: 'Listening / الاستماع',
                  value: _listening,
                  onChanged: (v) {
                    if (v != null) setState(() => _listening = v);
                    _push();
                  },
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _CefrRow(
                  label: 'Reading / القراءة',
                  value: _reading,
                  onChanged: (v) {
                    if (v != null) setState(() => _reading = v);
                    _push();
                  },
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _CefrRow(
                  label: 'Spoken Production / الإنتاج الشفهي',
                  value: _spokenProd,
                  onChanged: (v) {
                    if (v != null) setState(() => _spokenProd = v);
                    _push();
                  },
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _CefrRow(
                  label: 'Spoken Interaction / التفاعل الشفهي',
                  value: _spokenInt,
                  onChanged: (v) {
                    if (v != null) setState(() => _spokenInt = v);
                    _push();
                  },
                ),
                const Divider(height: 20, color: AppColors.borderSubtle),
                _CefrRow(
                  label: 'Writing / الكتابة',
                  value: _writing,
                  onChanged: (v) {
                    if (v != null) setState(() => _writing = v);
                    _push();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // ── Navigation ──────────────────────────────────────────────────
          _NavRow(
            onBack: widget.onBack,
            onNext: widget.onNext,
            nextLabel: 'Preview & Download / معاينة وتنزيل',
          ),
        ],
      ),
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

Widget _sectionLabel(String text) {
  return Text(
    text,
    style: AppTextStyles.titleMedium.copyWith(
        fontSize: 12, fontWeight: FontWeight.w600),
  );
}

class _CefrRow extends StatelessWidget {
  const _CefrRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });
  final String label;
  final String value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(label,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
        ),
        DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.backgroundElevated,
          underline: const SizedBox.shrink(),
          style: AppTextStyles.titleMedium
              .copyWith(color: AppColors.accentBlue),
          items: _kCefrLevels
              .map((l) => DropdownMenuItem(value: l, child: Text(l)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

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
          icon: const Icon(Icons.file_download_outlined, size: 18),
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
