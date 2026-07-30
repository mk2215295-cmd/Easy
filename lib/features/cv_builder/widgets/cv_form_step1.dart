import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/cv_model.dart';
import '../../../theme/app_theme.dart';
import '../cv_form_data.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvFormStep1 — Personal Information & Cascading Sector/Profession Selectors
//
// Features & Strict Validations:
//   1. Full Name Validation: Enforces at least 3 to 4 words (minimum 2 spaces)
//      before enabling progression. Displays Arabic warning banner.
//   2. Cascading Two-Level Selectors:
//      - Selector 1: Sector Category (القطاع المهني / e.g. الحرف, البرمجة, البناء)
//      - Selector 2: Job Title (المسمى الوظيفي), dynamically filtered by Sector.
//   3. Cascading Country + City Selectors.
//   4. Date of Birth DD/MM/YYYY Mask.
//   5. Sequential Next Button Locking: Locked until required fields are valid.
// ════════════════════════════════════════════════════════════════════════════
class CvFormStep1 extends StatefulWidget {
  const CvFormStep1({
    super.key,
    required this.cv,
    required this.onChanged,
    required this.onNext,
  });

  final CvModel cv;
  final ValueChanged<CvModel> onChanged;
  final VoidCallback onNext;

  @override
  State<CvFormStep1> createState() => _CvFormStep1State();
}

class _CvFormStep1State extends State<CvFormStep1> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _dobCtrl;

  CvProfessionCategory? _selectedCategory;
  CvProfession? _selectedProfessionObj;
  String? _selectedProfessionTitle;
  String? _selectedCountry;
  String? _selectedCity;

  @override
  void initState() {
    super.initState();

    _nameCtrl = TextEditingController(text: widget.cv.fullName);
    _emailCtrl = TextEditingController(text: widget.cv.email);
    _dobCtrl = TextEditingController(text: widget.cv.dateOfBirth);

    _selectedProfessionTitle =
        widget.cv.profession.isNotEmpty ? widget.cv.profession : null;
    _selectedCountry =
        widget.cv.country.isNotEmpty ? widget.cv.country : null;
    _selectedCity = widget.cv.city.isNotEmpty ? widget.cv.city : null;

    // Restore selected category & profession object if existing
    if (_selectedProfessionTitle != null) {
      for (final cat in kProfessionCategories) {
        final match = cat.professions.firstWhere(
          (p) =>
              p.titleEn.toLowerCase() ==
                  _selectedProfessionTitle!.toLowerCase() ||
              p.titleAr == _selectedProfessionTitle,
          orElse: () => const CvProfession(
            titleEn: '',
            titleAr: '',
            categoryEn: '',
            categoryAr: '',
            emoji: '',
            suggestedBullets: [],
          ),
        );
        if (match.titleEn.isNotEmpty) {
          _selectedCategory = cat;
          _selectedProfessionObj = match;
          break;
        }
      }
    }

    _nameCtrl.addListener(_pushUpdate);
    _emailCtrl.addListener(_pushUpdate);
    _dobCtrl.addListener(_pushUpdate);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  // Full Name validation helper (requires 3 to 4 words minimum)
  bool _isFullNameValid(String name) {
    final words =
        name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    return words.length >= 3;
  }

  void _pushUpdate({List<String>? bullets}) {
    widget.onChanged(widget.cv.copyWith(
      fullName: _nameCtrl.text,
      profession: _selectedProfessionTitle ?? '',
      email: _emailCtrl.text,
      country: _selectedCountry ?? '',
      city: _selectedCity ?? '',
      dateOfBirth: _dobCtrl.text,
      workBulletPoints: bullets ?? widget.cv.workBulletPoints,
    ));
  }

  void _onCategoryChanged(CvProfessionCategory? cat) {
    setState(() {
      _selectedCategory = cat;
      _selectedProfessionObj = null;
      _selectedProfessionTitle = null;
    });
    _pushUpdate();
  }

  void _onProfessionChanged(CvProfession? prof) {
    if (prof == null) return;
    setState(() {
      _selectedProfessionObj = prof;
      _selectedProfessionTitle = prof.titleEn;
    });
    _pushUpdate(bullets: prof.atsBullets);
  }

  void _onCountrySelected(String? country) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = null;
    });
    _pushUpdate();
  }

  void _onCitySelected(String? city) {
    setState(() => _selectedCity = city);
    _pushUpdate();
  }

  @override
  Widget build(BuildContext context) {
    final nameText = _nameCtrl.text;
    final isNameValid = _isFullNameValid(nameText);
    final isNameTouched = nameText.trim().isNotEmpty;
    final isProfessionValid = _selectedProfessionTitle != null &&
        _selectedProfessionTitle!.isNotEmpty;

    final isStepValid = isNameValid && isProfessionValid;

    final List<String> expOptions = [
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
      '10+'
    ];

    final List<String> cities = _selectedCountry != null
        ? (kCountryCityMap[_selectedCountry] ?? [])
        : [];

    final availableProfessions =
        _selectedCategory?.professions ?? kProfessions;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepHeader(),
          const SizedBox(height: 24),

          // ── 1. Full Name (3 to 4 Words Enforced) ──────────────────────
          _InputField(
            controller: _nameCtrl,
            labelEn: 'Full Name (3-4 words required)',
            labelAr: 'الاسم الكامل (ثلاثي أو رباعي)',
            hint: 'مثال: محمود أحمد علي السيد',
            suffixIcon: isNameValid
                ? const Icon(Icons.check_circle_rounded,
                    color: AppColors.accentGreen, size: 20)
                : (isNameTouched
                    ? const Icon(Icons.error_outline_rounded,
                        color: Color(0xFFEF4444), size: 20)
                    : null),
          ),
          if (isNameTouched && !isNameValid) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF2F2),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline_rounded,
                      color: Color(0xFFB91C1C), size: 14),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'يرجى كتابة الاسم ثلاثي أو رباعي على الأقل (مثال: محمود أحمد علي)',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: const Color(0xFFB91C1C),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 18),

          // ── 2. Cascading Selector 1: Sector Category (القطاع المهني) ───
          _buildLabel('1. Sector Category / القطاع المهني',
              'اختر قطاع العمل الرئيسي أولاً'),
          const SizedBox(height: 8),
          DropdownButtonFormField<CvProfessionCategory>(
            initialValue: _selectedCategory,
            dropdownColor: AppColors.backgroundElevated,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'اختر القطاع المهني / Select Sector',
            ),
            items: kProfessionCategories
                .map((cat) => DropdownMenuItem(
                      value: cat,
                      child: Row(
                        children: [
                          Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              cat.titleAr,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: _onCategoryChanged,
          ),
          const SizedBox(height: 18),

          // ── 3. Cascading Selector 2: Job Title (المسمى الوظيفي) ────────
          _buildLabel('2. Job Title / المسمى الوظيفي',
              'تتغير المسميات المتاحة بحسب القطاع المختار'),
          const SizedBox(height: 8),
          DropdownButtonFormField<CvProfession>(
            initialValue: _selectedProfessionObj,
            dropdownColor: AppColors.backgroundElevated,
            isExpanded: true,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: _selectedCategory == null
                  ? 'اختر القطاع أولاً / Select sector first'
                  : 'اختر المسمى الوظيفي / Select Job Title',
            ),
            disabledHint: Text(
              'اختر القطاع أولاً / Select sector first',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textDisabled),
            ),
            items: availableProfessions
                .map((prof) => DropdownMenuItem(
                      value: prof,
                      child: Row(
                        children: [
                          Text(prof.emoji,
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '${prof.titleAr} (${prof.titleEn})',
                              style: const TextStyle(fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: availableProfessions.isEmpty
                ? null
                : _onProfessionChanged,
          ),
          if (_selectedProfessionTitle != null) ...[
            const SizedBox(height: 8),
            _AtsInjectedBadge(profession: _selectedProfessionTitle!),
          ],
          const SizedBox(height: 18),

          // ── 4. Years of Experience Dropdown ──────────────────────────
          _buildLabel('Years of Experience / سنوات الخبرة', 'اختر سنوات الخبرة'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: widget.cv.yearsOfExperience.isEmpty
                ? null
                : widget.cv.yearsOfExperience,
            dropdownColor: AppColors.backgroundElevated,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            decoration:
                const InputDecoration(hintText: 'Select years / اختر'),
            items: expOptions
                .map((v) => DropdownMenuItem(value: v, child: Text(v)))
                .toList(),
            onChanged: (val) {
              if (val != null) {
                widget.onChanged(
                    widget.cv.copyWith(yearsOfExperience: val));
              }
            },
          ),
          const SizedBox(height: 18),

          // ── 5. Email / Contact ────────────────────────────────────────
          _InputField(
            controller: _emailCtrl,
            labelEn: 'Contact Information',
            labelAr: 'معلومات الاتصال البريدية',
            hint: 'e.g. email@domain.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),

          // ── 6. Country Dropdown ───────────────────────────────────────
          _buildLabel('Country / الدولة', 'اختر دولة الإقامة الحالية'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCountry,
            dropdownColor: AppColors.backgroundElevated,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            decoration:
                const InputDecoration(hintText: 'Select country / اختر الدولة'),
            items: kCountries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: _onCountrySelected,
          ),
          const SizedBox(height: 18),

          // ── 7. City Dropdown (filters on country) ─────────────────────
          _buildLabel('City / المدينة', 'اختر المدينة'),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedCity,
            dropdownColor: AppColors.backgroundElevated,
            icon: const Icon(Icons.keyboard_arrow_down_rounded,
                color: AppColors.textSecondary),
            style: AppTextStyles.bodyMedium
                .copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              hintText: _selectedCountry == null
                  ? 'Select a country first / اختر الدولة أولاً'
                  : 'Select city / اختر المدينة',
            ),
            disabledHint: Text(
              'Select a country first',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textDisabled),
            ),
            items: cities.isEmpty
                ? null
                : cities
                    .map((c) =>
                        DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
            onChanged: cities.isEmpty ? null : _onCitySelected,
          ),
          const SizedBox(height: 18),

          // ── 8. Date of Birth with DD/MM/YYYY mask ─────────────────────
          _InputField(
            controller: _dobCtrl,
            labelEn: 'Date of Birth',
            labelAr: 'تاريخ الميلاد',
            hint: 'DD/MM/YYYY',
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _DateMaskFormatter(),
            ],
          ),
          const SizedBox(height: 32),

          // ── Sequential Locked Next Button ─────────────────────────────
          _NextButton(
            onNext: widget.onNext,
            isEnabled: isStepValid,
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String en, String ar) {
    return RichText(
      text: TextSpan(
        style: AppTextStyles.titleMedium.copyWith(fontSize: 12),
        children: [
          TextSpan(text: en),
          const TextSpan(text: ' / '),
          TextSpan(
            text: ar,
            style: const TextStyle(
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ── _StepHeader ───────────────────────────────────────────────────────────────
class _StepHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الخطوة 1: البيانات الشخصية وتحديد المسمى الوظيفي',
          style: AppTextStyles.headlineLarge.copyWith(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Step 1: Personal Information',
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

// ── _InputField ───────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.labelEn,
    required this.labelAr,
    required this.hint,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatters,
  });

  final TextEditingController controller;
  final String labelEn;
  final String labelAr;
  final String hint;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.titleMedium.copyWith(fontSize: 12),
            children: [
              TextSpan(text: labelEn),
              const TextSpan(text: ' / '),
              TextSpan(
                text: labelAr,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: AppTextStyles.bodyMedium
              .copyWith(color: AppColors.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

// ── _AtsInjectedBadge ─────────────────────────────────────────────────────────
class _AtsInjectedBadge extends StatelessWidget {
  const _AtsInjectedBadge({required this.profession});
  final String profession;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.accentGreenMuted.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.accentGreen.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.auto_awesome_rounded,
            color: AppColors.accentGreen,
            size: 16,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'تم إدراج المهام الوظيفية المعتمدة تلقائياً لـ "$profession"',
              style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.accentGreen, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

// ── _NextButton (Locked until valid) ──────────────────────────────────────────
class _NextButton extends StatelessWidget {
  const _NextButton({required this.onNext, required this.isEnabled});
  final VoidCallback onNext;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: ElevatedButton(
        onPressed: isEnabled ? onNext : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isEnabled ? AppColors.accentBlue : AppColors.backgroundElevated,
          disabledBackgroundColor: AppColors.backgroundElevated,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isEnabled) ...[
              const Icon(Icons.lock_outline_rounded,
                  size: 16, color: AppColors.textDisabled),
              const SizedBox(width: 8),
            ],
            Text(
              'Next: Work Experience',
              style: AppTextStyles.buttonPrimary.copyWith(
                fontSize: 14,
                color: isEnabled ? AppColors.white : AppColors.textDisabled,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '/ التالي: الخبرة العملية',
              style: AppTextStyles.buttonPrimary.copyWith(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: isEnabled
                    ? AppColors.white.withValues(alpha: 0.7)
                    : AppColors.textDisabled,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: isEnabled ? AppColors.white : AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Date Mask Formatter (DD/MM/YYYY) ─────────────────────────────────────────
class _DateMaskFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    if (text.length <= oldValue.text.length) {
      return newValue;
    }

    final digits = text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) buffer.write('/');
      buffer.write(digits[i]);
    }

    final result = buffer.toString();

    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: result.length),
    );
  }
}
