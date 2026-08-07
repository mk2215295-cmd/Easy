import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/models/cv_model.dart';
import '../../../core/services/location_service.dart';
import '../../../theme/app_theme.dart';
import '../cv_form_data.dart';

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
  String? _selectedProfessionTitle;
  String? _selectedCountry;
  String? _selectedCity;

  final LocationService _locationService = LocationService();
  List<String> _countries = [];
  List<String> _cities = [];
  bool _isLoadingCountries = true;
  bool _isLoadingCities = false;

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
          break;
        }
      }
    }

    _nameCtrl.addListener(_pushUpdate);
    _emailCtrl.addListener(_pushUpdate);
    _dobCtrl.addListener(_pushUpdate);

    _loadCountries();
  }

  Future<void> _loadCountries() async {
    final list = await _locationService.fetchCountries();
    if (mounted) {
      setState(() {
        _countries = list.isNotEmpty ? list : kCountries;
        _isLoadingCountries = false;
      });
      if (_selectedCountry != null && _selectedCountry!.isNotEmpty) {
        _loadCities(_selectedCountry!);
      }
    }
  }

  Future<void> _loadCities(String country) async {
    setState(() {
      _isLoadingCities = true;
      _cities = [];
    });
    final list = await _locationService.fetchCities(country);
    if (mounted) {
      setState(() {
        _cities = list.isNotEmpty ? list : (kCountryCityMap[country] ?? []);
        _isLoadingCities = false;
      });
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

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
      _selectedProfessionTitle = null;
    });
    _pushUpdate();
  }

  void _onProfessionChanged(String profTitle) {
    setState(() {
      _selectedProfessionTitle = profTitle;
    });
    final match = kProfessions.firstWhere(
      (p) =>
          p.titleEn.toLowerCase() == profTitle.toLowerCase() ||
          p.titleAr == profTitle,
      orElse: () => CvProfession(
        titleEn: profTitle,
        titleAr: profTitle,
        categoryEn: '',
        categoryAr: '',
        emoji: '💼',
        suggestedBullets: [],
      ),
    );
    _pushUpdate(bullets: match.atsBullets);
  }

  void _onCountrySelected(String country) {
    setState(() {
      _selectedCountry = country;
      _selectedCity = null;
    });
    _pushUpdate();
    _loadCities(country);
  }

  void _onCitySelected(String city) {
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
      '1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '10+'
    ];

    final availableProfessions =
        _selectedCategory?.professions ?? kProfessions;
    final professionStrings = availableProfessions
        .map((p) => "\ / \")
        .toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _StepHeader(),
          const SizedBox(height: 24),

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
                      'يرجى كتابة الاسم ثلاثي أو رباعي على الأقل',
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

          _CustomAutocomplete(
            labelEn: '2. Job Title / المسمى الوظيفي',
            labelAr: 'اختر من القائمة أو اكتب مسمى وظيفي جديد',
            hint: 'e.g. Software Engineer / مهندس برمجيات',
            initialValue: _selectedProfessionTitle ?? '',
            options: professionStrings,
            onSelected: (val) {
              final clean = val.split(' / ').first;
              _onProfessionChanged(clean);
            },
            onChanged: (val) => _onProfessionChanged(val),
          ),
          if (_selectedProfessionTitle != null) ...[
            const SizedBox(height: 8),
            _AtsInjectedBadge(profession: _selectedProfessionTitle!),
          ],
          const SizedBox(height: 18),

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

          _InputField(
            controller: _emailCtrl,
            labelEn: 'Contact Information',
            labelAr: 'معلومات الاتصال البريدية',
            hint: 'e.g. email@domain.com',
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),

          _CustomAutocomplete(
            labelEn: 'Country / الدولة',
            labelAr: 'اختر دولة الإقامة الحالية',
            hint: 'Select country / اختر الدولة',
            initialValue: _selectedCountry ?? '',
            options: _countries,
            isLoading: _isLoadingCountries,
            onSelected: _onCountrySelected,
            onChanged: _onCountrySelected,
          ),
          const SizedBox(height: 18),

          _CustomAutocomplete(
            labelEn: 'City / المدينة',
            labelAr: 'اختر المدينة',
            hint: 'Select city / اختر المدينة',
            initialValue: _selectedCity ?? '',
            options: _cities,
            isLoading: _isLoadingCities,
            onSelected: _onCitySelected,
            onChanged: _onCitySelected,
          ),
          const SizedBox(height: 18),

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

class _CustomAutocomplete extends StatefulWidget {
  const _CustomAutocomplete({
    required this.labelEn,
    required this.labelAr,
    required this.hint,
    required this.options,
    required this.initialValue,
    required this.onSelected,
    required this.onChanged,
    this.isLoading = false,
  });

  final String labelEn;
  final String labelAr;
  final String hint;
  final List<String> options;
  final String initialValue;
  final ValueChanged<String> onSelected;
  final ValueChanged<String> onChanged;
  final bool isLoading;

  @override
  State<_CustomAutocomplete> createState() => _CustomAutocompleteState();
}

class _CustomAutocompleteState extends State<_CustomAutocomplete> {
  late TextEditingController _textCtrl;

  @override
  void initState() {
    super.initState();
    _textCtrl = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_CustomAutocomplete oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync controller when parent changes the value (e.g. after category change)
    if (oldWidget.initialValue != widget.initialValue &&
        _textCtrl.text != widget.initialValue) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _textCtrl.text = widget.initialValue;
          _textCtrl.selection = TextSelection.collapsed(offset: widget.initialValue.length);
        }
      });
    }
  }

  @override
  void dispose() {
    _textCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            style: AppTextStyles.titleMedium.copyWith(fontSize: 12),
            children: [
              TextSpan(text: widget.labelEn),
              const TextSpan(text: ' / '),
              TextSpan(
                text: widget.labelAr,
                style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Autocomplete<String>(
          initialValue: TextEditingValue(text: widget.initialValue),
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return widget.options.take(50);
            }
            return widget.options.where((String option) {
              return option
                  .toLowerCase()
                  .contains(textEditingValue.text.toLowerCase());
            });
          },
          onSelected: widget.onSelected,
          fieldViewBuilder: (BuildContext context,
              TextEditingController textEditingController,
              FocusNode focusNode,
              VoidCallback onFieldSubmitted) {
            return TextField(
              controller: textEditingController,
              focusNode: focusNode,
              onChanged: widget.onChanged,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: widget.hint,
                suffixIcon: widget.isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : const Icon(Icons.arrow_drop_down,
                        color: AppColors.textSecondary),
              ),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                color: AppColors.backgroundElevated,
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxHeight: 200, maxWidth: 350),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (BuildContext context, int index) {
                      final String option = options.elementAt(index);
                      return InkWell(
                        onTap: () => onSelected(option),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child:
                              Text(option, style: AppTextStyles.bodyMedium),
                        ),
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}


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
              'تم إدراج المهام الوظيفية المعتمدة لـ "\"',
              style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.accentGreen, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }
}

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
