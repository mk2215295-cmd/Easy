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
//   • search queries (title, skill, company + location/country)
//   • category and jobType filters
//   • localeCode — 'ar' by default
//   • _cv — the live CV Builder form state
//   • _profile — UserProfileModel built dynamically from _cv + user actions
// ════════════════════════════════════════════════════════════════════════════
class JobProvider extends ChangeNotifier {
  final JobRepository _repository = JobRepository();
  final LocationService _locationService = LocationService();

  List<JobModel> _jobs = [];
  bool _isLoading = false;
  UserLocationInfo? _userLocation;

  // ── Language ──────────────────────────────────────────────────────────────
  String _localeCode = 'ar'; // Arabic on startup default
  bool _userManuallyToggledLocale = false;

  // ── Filters & Search ──────────────────────────────────────────────────────
  String _selectedJobType = 'All';
  String _selectedCategory = 'All';
  String _searchTitleQuery = '';
  String _searchLocationQuery = '';

  // ── CV Builder form state ─────────────────────────────────────────────────
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
  UserProfileModel _profile = const UserProfileModel(
    uid: 'user-77',
    fullName: 'Mahmoud',
    avatarUrl:
        'https://images.unsplash.com/photo-1534528741775-53994a69daeb'
        '?auto=format&fit=crop&q=80&w=200',
    profileCompletionPercentage: 85,
    generatedCvs: [],
    applications: [],
  );

  JobProvider() {
    _rebuildCvList();
  }

  // ── Public getters ────────────────────────────────────────────────────────
  List<JobModel> get jobs => _jobs;

  List<JobModel> get filteredJobs {
    return _jobs.where((j) {
      // 1. Job Type filter
      if (_selectedJobType != 'All' && _selectedJobType.isNotEmpty) {
        final t = (j.jobType ?? '').toLowerCase();
        final target = _selectedJobType.toLowerCase();
        if (target.contains('full') && !t.contains('full')) return false;
        if (target.contains('part') && !(t.contains('part') || t.contains('seasonal'))) return false;
        if (target.contains('volunteer') && !(t.contains('volunteer') || (j.category ?? '').toLowerCase().contains('volunteer'))) return false;
      }

      // 2. Category filter
      if (_selectedCategory != 'All' && _selectedCategory.isNotEmpty) {
        final cat = (j.category ?? '').toLowerCase();
        final title = (j.title ?? '').toLowerCase();
        final target = _selectedCategory.toLowerCase();
        if (!cat.contains(target) && !title.contains(target)) return false;
      }

      // 3. Search Title / Skill / Company
      if (_searchTitleQuery.isNotEmpty) {
        final q = _searchTitleQuery.toLowerCase();
        final title = (j.title ?? '').toLowerCase();
        final titleAr = (j.titleAr ?? '').toLowerCase();
        final company = (j.company ?? '').toLowerCase();
        final desc = (j.description ?? '').toLowerCase();
        if (!title.contains(q) && !titleAr.contains(q) && !company.contains(q) && !desc.contains(q)) {
          return false;
        }
      }

      // 4. Search Location / Country
      if (_searchLocationQuery.isNotEmpty) {
        final q = _searchLocationQuery.toLowerCase();
        final loc = (j.location ?? '').toLowerCase();
        final locAr = (j.locationAr ?? '').toLowerCase();
        final country = (j.countryCode ?? '').toLowerCase();
        if (!loc.contains(q) && !locAr.contains(q) && !country.contains(q)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  bool get isLoading => _isLoading;
  UserLocationInfo? get userLocation => _userLocation;
  String get localeCode => _localeCode;
  bool get isArabic => _localeCode == 'ar';
  String get selectedJobType => _selectedJobType;
  String get selectedCategory => _selectedCategory;
  String get searchTitleQuery => _searchTitleQuery;
  String get searchLocationQuery => _searchLocationQuery;
  CvModel get cv => _cv;
  UserProfileModel get profile => _profile;

  // ── Load jobs ─────────────────────────────────────────────────────────────
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

  // ── Filters & Search Setters ──────────────────────────────────────────────
  void setJobTypeFilter(String type) {
    _selectedJobType = type;
    notifyListeners();
  }

  void setCategoryFilter(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQueries(String title, String location) {
    _searchTitleQuery = title;
    _searchLocationQuery = location;
    notifyListeners();
  }

  void clearFilters() {
    _selectedJobType = 'All';
    _selectedCategory = 'All';
    _searchTitleQuery = '';
    _searchLocationQuery = '';
    notifyListeners();
  }

  // ── Locale ────────────────────────────────────────────────────────────────
  void setLocaleCode(String code) {
    _localeCode = code;
    _userManuallyToggledLocale = true;
    notifyListeners();
  }

  // ── CV Builder ────────────────────────────────────────────────────────────
  void updateCv(CvModel updatedCv) {
    _cv = updatedCv;
    _rebuildCvList();
    notifyListeners();
  }

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
  void applyToJob(JobModel job) {
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

  JobModel? getJobById(String id) {
    try {
      return _jobs.firstWhere((j) => j.id == id);
    } catch (_) {
      return null;
    }
  }
}
