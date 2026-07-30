import 'package:equatable/equatable.dart';

import 'affiliate_deal_model.dart';
import 'job_benefit_model.dart';
import 'job_requirement_model.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JobModel  — Extended production domain model for a single job listing.
//
// Phase 3 additions (driven by Job Details screen mockup):
//   • [requirements]              — 2-column checkmark list (المتطلبات)
//   • [benefits]                  — benefit chips (السكن / الصحة / الطيران)
//   • [accommodationDescriptionAr/En] — text block under تفاصيل السكن
//   • [accommodationImageUrls]    — thumbnail gallery
//   • [applyUrl]                  — external application URL
//   • [contextualDeals]           — affiliate deals pre-filtered for this job's country
//   • [sidebarTitleAr/En]         — "Exclusive deals in [City]" header
//   • [experienceYearsMin]        — minimum years of experience
//   • [contractType]              — e.g. 'seasonal', 'full_time'
//   • [startDate]                 — ISO 8601 expected start date
//
// ⚠ No hardcoded display values — every field is nullable.
//   The UI renders skeleton placeholders when a field is null.
// ════════════════════════════════════════════════════════════════════════════════
class JobModel extends Equatable {
  const JobModel({
    required this.id,
    // ── Card fields (Phase 2) ──────────────────────────────────────────────
    this.title,
    this.titleAr,
    this.company,
    this.location,
    this.locationAr,
    this.countryFlagEmoji,
    this.countryCode,
    this.description,
    this.descriptionAr,
    this.salaryMin,
    this.salaryMax,
    this.salaryCurrency,
    this.salaryPeriod,
    this.matchPercentage,
    this.heroImageUrl,
    this.category,
    this.jobType,
    this.postedAt,
    this.applicationDeadline,
    this.isNew,
    this.isFeatured,
    // ── Detail-screen fields (Phase 3) ────────────────────────────────────
    this.requirements = const [],
    this.benefits = const [],
    this.accommodationDescriptionAr,
    this.accommodationDescriptionEn,
    this.accommodationImageUrls = const [],
    this.applyUrl,
    this.contextualDeals = const [],
    this.sidebarTitleAr,
    this.sidebarTitleEn,
    this.experienceYearsMin,
    this.contractType,
    this.startDate,
    this.latitude,
    this.longitude,
    this.requiresVisaSponsorship,
    this.recruiterEmail,
  });

  final String? recruiterEmail;

  // ── Identity ──────────────────────────────────────────────────────────────
  final String id;

  // ── Card-level display fields ─────────────────────────────────────────────
  final String? title;
  final String? titleAr;
  final String? company;
  final String? location;
  final String? locationAr;
  final String? countryFlagEmoji;
  final String? countryCode;
  final String? description;
  final String? descriptionAr;
  final double? salaryMin;
  final double? salaryMax;
  final String? salaryCurrency;
  final String? salaryPeriod;
  final int? matchPercentage;
  final String? heroImageUrl;
  final String? category;
  final String? jobType;
  final DateTime? postedAt;
  final DateTime? applicationDeadline;
  final bool? isNew;
  final bool? isFeatured;

  // ── Detail-screen fields ──────────────────────────────────────────────────

  /// Ordered list of requirements shown in the 2-column checkmark grid.
  final List<JobRequirementModel> requirements;

  /// Benefit chips shown under the salary range.
  final List<JobBenefitModel> benefits;

  /// Long-form accommodation description in Arabic (تفاصيل السكن body text).
  final String? accommodationDescriptionAr;

  /// Long-form accommodation description in English.
  final String? accommodationDescriptionEn;

  /// CDN URLs of accommodation photo thumbnails (max 4 shown in UI).
  final List<String> accommodationImageUrls;

  /// External deep-link URL for submitting an application.
  final String? applyUrl;

  /// Pre-filtered affiliate deals contextual to this job's destination country.
  final List<AffiliateDealModel> contextualDeals;

  /// Sidebar heading in Arabic, e.g. "عروض حصرية في فرنسا"
  final String? sidebarTitleAr;

  /// Sidebar heading in English, e.g. "Exclusive deals in France"
  final String? sidebarTitleEn;

  /// Minimum years of experience required (numeric from API).
  final int? experienceYearsMin;

  /// Employment contract type string from API (e.g. 'seasonal', 'full_time').
  final String? contractType;

  /// Expected job start date (ISO 8601).
  final DateTime? startDate;

  /// Job location latitude coordinates for sorting.
  final double? latitude;

  /// Job location longitude coordinates for sorting.
  final double? longitude;

  /// Visa sponsorship requirement flag for non-EU applicants.
  final bool? requiresVisaSponsorship;

  // ── Helpers ───────────────────────────────────────────────────────────────

  /// Formatted salary string, e.g. "€2,500 – €3,000 / month".
  /// Returns null when salary data is incomplete.
  String? formattedSalary({
    String fallbackCurrency = '€',
    String fallbackPeriod = 'month',
  }) {
    if (salaryMin == null && salaryMax == null) return null;
    final curr = salaryCurrency ?? fallbackCurrency;
    final period = salaryPeriod ?? fallbackPeriod;
    final min = salaryMin != null ? '$curr${_fmt(salaryMin!)}' : null;
    final max = salaryMax != null ? '$curr${_fmt(salaryMax!)}' : null;
    if (min != null && max != null) return '$min – $max / $period';
    return '${min ?? max} / $period';
  }

  String _fmt(double v) =>
      v.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          );

  /// Resolved recruiter email for mailto: Gmail application integration.
  String get recruiterEmailAddress {
    if (recruiterEmail != null && recruiterEmail!.isNotEmpty) {
      return recruiterEmail!;
    }
    final cleanCompany =
        (company ?? 'careers').replaceAll(RegExp(r'[^a-zA-Z0-9]'), '').toLowerCase();
    return 'recruitment@$cleanCompany.eu';
  }

  // ── Deserialisation ───────────────────────────────────────────────────────
  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String?,
      titleAr: json['title_ar'] as String?,
      company: json['company'] as String?,
      location: json['location'] as String?,
      locationAr: json['location_ar'] as String?,
      countryFlagEmoji: json['country_flag_emoji'] as String?,
      countryCode: json['country_code'] as String?,
      description: json['description'] as String?,
      descriptionAr: json['description_ar'] as String?,
      salaryMin: (json['salary_min'] as num?)?.toDouble(),
      salaryMax: (json['salary_max'] as num?)?.toDouble(),
      salaryCurrency: json['salary_currency'] as String?,
      salaryPeriod: json['salary_period'] as String?,
      matchPercentage: json['match_percentage'] as int?,
      heroImageUrl: json['hero_image_url'] as String?,
      category: json['category'] as String?,
      jobType: json['job_type'] as String?,
      postedAt: json['posted_at'] != null
          ? DateTime.tryParse(json['posted_at'] as String)
          : null,
      applicationDeadline: json['application_deadline'] != null
          ? DateTime.tryParse(json['application_deadline'] as String)
          : null,
      isNew: json['is_new'] as bool?,
      isFeatured: json['is_featured'] as bool?,
      requirements: (json['requirements'] as List<dynamic>? ?? [])
          .map((e) =>
              JobRequirementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      benefits: (json['benefits'] as List<dynamic>? ?? [])
          .map((e) =>
              JobBenefitModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      accommodationDescriptionAr:
          json['accommodation_description_ar'] as String?,
      accommodationDescriptionEn:
          json['accommodation_description_en'] as String?,
      accommodationImageUrls:
          (json['accommodation_image_urls'] as List<dynamic>? ?? [])
              .map((e) => e as String)
              .toList(),
      applyUrl: json['apply_url'] as String?,
      contextualDeals:
          (json['contextual_deals'] as List<dynamic>? ?? [])
              .map((e) =>
                  AffiliateDealModel.fromJson(e as Map<String, dynamic>))
              .toList(),
      sidebarTitleAr: json['sidebar_title_ar'] as String?,
      sidebarTitleEn: json['sidebar_title_en'] as String?,
      experienceYearsMin: json['experience_years_min'] as int?,
      contractType: json['contract_type'] as String?,
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'] as String)
          : null,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      requiresVisaSponsorship: json['requires_visa_sponsorship'] as bool?,
    );
  }

  // ── Serialisation ─────────────────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'title_ar': titleAr,
        'company': company,
        'location': location,
        'location_ar': locationAr,
        'country_flag_emoji': countryFlagEmoji,
        'country_code': countryCode,
        'description': description,
        'description_ar': descriptionAr,
        'salary_min': salaryMin,
        'salary_max': salaryMax,
        'salary_currency': salaryCurrency,
        'salary_period': salaryPeriod,
        'match_percentage': matchPercentage,
        'hero_image_url': heroImageUrl,
        'category': category,
        'job_type': jobType,
        'posted_at': postedAt?.toIso8601String(),
        'application_deadline': applicationDeadline?.toIso8601String(),
        'is_new': isNew,
        'is_featured': isFeatured,
        'requirements': requirements.map((r) => r.toJson()).toList(),
        'benefits': benefits.map((b) => b.toJson()).toList(),
        'accommodation_description_ar': accommodationDescriptionAr,
        'accommodation_description_en': accommodationDescriptionEn,
        'accommodation_image_urls': accommodationImageUrls,
        'apply_url': applyUrl,
        'contextual_deals':
            contextualDeals.map((d) => d.toJson()).toList(),
        'sidebar_title_ar': sidebarTitleAr,
        'sidebar_title_en': sidebarTitleEn,
        'experience_years_min': experienceYearsMin,
        'contract_type': contractType,
        'start_date': startDate?.toIso8601String(),
        'latitude': latitude,
        'longitude': longitude,
        'requires_visa_sponsorship': requiresVisaSponsorship,
      };

  @override
  List<Object?> get props => [
        id, title, titleAr, company, location, locationAr,
        countryFlagEmoji, countryCode, description, descriptionAr,
        salaryMin, salaryMax, salaryCurrency, salaryPeriod,
        matchPercentage, heroImageUrl, category, jobType,
        postedAt, applicationDeadline, isNew, isFeatured,
        requirements, benefits,
        accommodationDescriptionAr, accommodationDescriptionEn,
        accommodationImageUrls, applyUrl, contextualDeals,
        sidebarTitleAr, sidebarTitleEn,
        experienceYearsMin, contractType, startDate,
        latitude, longitude, requiresVisaSponsorship,
      ];
}
