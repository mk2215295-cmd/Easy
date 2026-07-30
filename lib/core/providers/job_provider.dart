import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/models/cv_model.dart';
import '../../core/models/job_model.dart';
import '../../core/models/user_profile_model.dart';
import '../repositories/job_repository.dart';
import '../services/location_service.dart';

// ════════════════════════════════════════════════════════════════════════════
// JobProvider — Single Source of Truth
//
// Owns:
//   • jobs list (fetched from repository, geo-filtered)
//   • localeCode — 'ar' by default (Egypt / outside-EU detected)
//   • _cv — the live CV Builder form state
//   • _profile — UserProfileModel built dynamically from _cv + user actions
//
// Key design decisions:
//   • _profile.generatedCvs starts EMPTY. The list is built purely from
//     `_cv` whenever updateCv() is called. No hardcoded placeholder CVs.
//   • _profile.applications starts EMPTY. Rows are added only when the user
//     taps "Apply Now" from a JobDetailsScreen, via applyToJob().
//   • The profile fullName tracks _cv.fullName in real-time.
// ════════════════════════════════════════════════════════════════════════════
class JobProvider extends ChangeNotifier {
  final JobRepository _repository = JobRepository();
  final LocationService _locationService = LocationService();

  List<JobModel> _jobs = [];
  bool _isLoading = false;
  UserLocationInfo? _userLocation;

  // ── Language ──────────────────────────────────────────────────────────────
  String _localeCode = 'ar'; // Arabic on startup (Egypt / outside-EU default)
  bool _userManuallyToggledLocale = false;

  // ── CV Builder form state ─────────────────────────────────────────────────
  // Pre-populated with the user's name so the Profile page shows 'Mahmoud'
  // immediately. All other fields start blank — the form drives them.
  CvModel _cv = const CvModel(
    fullName: 'Mahmoud',
    profession: '',
    yearsOfExperience: '',
    passport: '',
    dateOfBirth: '',
    nationality: 'Egyptian',
    gender: 'Male',
    phone: '',
    email: '',
    country: 'Egypt',
    city: 'Cairo',
    aboutMe: '',
    companyName: '',
    workDates: '',
    workLocation: '',
    workBulletPoints: [],
    educationDegree: '',
    educationInstitution: '',
    educationDates: '',
    educationLocation: '',
    educationField: '',
    motherTongue: 'Arabic',
    otherLanguage: 'English',
    cefrListening: 'B1',
    cefrReading: 'B1',
    cefrSpokenProduction: 'B1',
    cefrSpokenInteraction: 'B1',
    cefrWriting: 'B1',
    skills: [],
  );

  // ── User Profile state ─────────────────────────────────────────────────────
  // NO hardcoded CVs or applications — every item is injected dynamically.
  UserProfileModel _profile = const UserProfileModel(
    uid: 'user-77',
    fullName: 'Mahmoud',
    avatarUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb'
        '?auto=format&fit=crop&q=80&w=200',
    profileCompletionPercentage: 85,
    generatedCvs: [],    // populated by updateCv()
    applications: [],    // populated by applyToJob()
  );

  JobProvider() {
    // Build the initial CV card from the pre-filled name + empty profession
    _rebuildCvList();
  }

  String _selectedJobType = 'All';

  // ── Public getters ────────────────────────────────────────────────────────
  List<JobModel> get jobs => _jobs;
  List<JobModel> get filteredJobs {
    if (_selectedJobType == 'All' || _selectedJobType.isEmpty) return _jobs;
    return _jobs.where((j) {
      final t = (j.jobType ?? '').toLowerCase();
      final cat = (j.category ?? '').toLowerCase();
      final target = _selectedJobType.toLowerCase();
      if (target.contains('full')) return t.contains('full');
      if (target.contains('part')) return t.contains('part') || t.contains('seasonal');
      if (target.contains('volunteer')) return t.contains('volunteer') || cat.contains('volunteer');
      return true;
    }).toList();
  }

  bool get isLoading => _isLoading;
  UserLocationInfo? get userLocation => _userLocation;
  String get localeCode => _localeCode;
  bool get isArabic => _localeCode == 'ar';
  String get selectedJobType => _selectedJobType;
  CvModel get cv => _cv;
  UserProfileModel get profile => _profile;

  // ── Load jobs (geo-aware) ─────────────────────────────────────────────────
  Future<void> loadJobs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final locationInfo = await _locationService.detectUserLocation();
      _userLocation = locationInfo;

      if (locationInfo.inEu && !_userManuallyToggledLocale) {
        _localeCode = 'en';
      } else if (!locationInfo.inEu && !_userManuallyToggledLocale) {
        _localeCode = 'ar';
      }

      _jobs = await _repository.fetchJobs();
    } catch (_) {
      _jobs = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ── Filters ───────────────────────────────────────────────────────────────
  void setJobTypeFilter(String type) {
    _selectedJobType = type;
    notifyListeners();
  }

  // ── Locale ────────────────────────────────────────────────────────────────
  void setLocaleCode(String code) {
    _localeCode = code;
    _userManuallyToggledLocale = true;
    notifyListeners();
  }

  // ── CV Builder ────────────────────────────────────────────────────────────
  /// Called by every form field listener in CvFormStep1 (and future steps).
  /// Updates the live model AND rebuilds the generated CV card on the
  /// Profile Dashboard in real-time.
  void updateCv(CvModel updatedCv) {
    _cv = updatedCv;
    _rebuildCvList();
    notifyListeners();
  }

  /// Computes dynamic profile completion based on real user data:
  ///   • 20% baseline (registration)
  ///   • +20% for completed CV profession
  ///   • +20% for contact details (phone, country, city)
  ///   • +20% for skills / work experience
  ///   • +20% for submitted applications
  int _calculateProfileCompletion() {
    int pct = 20;
    if (_cv.profession.trim().isNotEmpty) pct += 20;
    if (_cv.phone.trim().isNotEmpty ||
        _cv.country.trim().isNotEmpty ||
        _cv.city.trim().isNotEmpty) {
      pct += 20;
    }
    if (_cv.skills.isNotEmpty || _cv.companyName.trim().isNotEmpty) pct += 20;
    if (_profile.applications.isNotEmpty) pct += 20;
    return pct.clamp(20, 100);
  }

  /// Rebuilds _profile.generatedCvs from the current _cv state.
  /// Produces exactly ONE card whose title = profession and whose filename
  /// encodes the user's name + profession. If the profession field is still
  /// empty the list stays empty (no phantom placeholder card).
  void _rebuildCvList() {
    final name = _cv.fullName.trim().isEmpty ? 'User' : _cv.fullName.trim();
    final profession = _cv.profession.trim();

    final List<UserCvModel> cvList = [];

    if (profession.isNotEmpty) {
      final cleanProf = profession.replaceAll(RegExp(r'\s+'), '');
      cvList.add(UserCvModel(
        id: 'cv-active',
        jobTitle: profession,
        fileName: 'CV_${name}_$cleanProf.pdf',
        pdfUrl: '',
      ));
    }

    _profile = UserProfileModel(
      uid: _profile.uid,
      fullName: name,
      avatarUrl: _profile.avatarUrl,
      profileCompletionPercentage: _calculateProfileCompletion(),
      generatedCvs: cvList,
      applications: _profile.applications,
    );
  }

  // ── Apply to a job ────────────────────────────────────────────────────────
  /// Adds a new application row to the Profile Dashboard table.
  /// Called by the "Apply Now" button on JobDetailsScreen.
  /// Deduplicates by job ID so hammering the button adds only one row.
  void applyToJob(JobModel job) {
    // Prevent duplicate entries
    final alreadyApplied =
        _profile.applications.any((a) => a.id == 'app-${job.id}');
    if (alreadyApplied) return;

    final today = DateFormat('MMM d, yyyy').format(DateTime.now());
    final isAr = isArabic;

    final newApp = AppliedApplicationModel(
      id: 'app-${job.id}',
      jobTitle: isAr
          ? (job.titleAr ?? job.title ?? '')
          : (job.title ?? job.titleAr ?? ''),
      companyName: job.company ?? '—',
      location: isAr
          ? (job.locationAr ?? job.location ?? '')
          : (job.location ?? job.locationAr ?? ''),
      appliedDate: today,
      status: 'Application Submitted',
    );

    final updatedApps = [..._profile.applications, newApp];

    _profile = UserProfileModel(
      uid: _profile.uid,
      fullName: _profile.fullName,
      avatarUrl: _profile.avatarUrl,
      profileCompletionPercentage: _calculateProfileCompletionWithApps(updatedApps),
      generatedCvs: _profile.generatedCvs,
      applications: updatedApps,
    );

    notifyListeners();
  }

  int _calculateProfileCompletionWithApps(List<AppliedApplicationModel> apps) {
    int pct = 20;
    if (_cv.profession.trim().isNotEmpty) pct += 20;
    if (_cv.phone.trim().isNotEmpty ||
        _cv.country.trim().isNotEmpty ||
        _cv.city.trim().isNotEmpty) {
      pct += 20;
    }
    if (_cv.skills.isNotEmpty || _cv.companyName.trim().isNotEmpty) pct += 20;
    if (apps.isNotEmpty) pct += 20;
    return pct.clamp(20, 100);
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  JobModel? getJobById(String id) {
    try {
      return _jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }
}
