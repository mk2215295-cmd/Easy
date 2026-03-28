import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/job_model.dart';

class ScraperService {
  String get _joobleApiKey =>
      dotenv.env['JOOBLE_API_KEY'] ?? 'YOUR_JOOBLE_API_KEY';
  static const String _joobleBaseUrl = 'https://jooble.org/api';

  Future<List<JobModel>> fetchJobsFromAllSources(String country) async {
    List<JobModel> allJobs = [];

    final joobleJobs = await _fetchFromJooble(country);
    allJobs.addAll(joobleJobs);

    final linkedInJobs = await _fetchFromLinkedIn(country);
    allJobs.addAll(linkedInJobs);

    final indeedJobs = await _fetchFromIndeed(country);
    allJobs.addAll(indeedJobs);

    return _deduplicateJobs(allJobs);
  }

  Future<List<JobModel>> _fetchFromJooble(String country) async {
    try {
      final response = await http.post(
        Uri.parse('$_joobleBaseUrl/$_joobleApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'keywords': 'work permit',
          'location': country,
          'radius': 50,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jobs = data['jobs'] as List? ?? [];

        return jobs.map((job) => _convertJoobleJob(job, country)).toList();
      }
    } catch (e) {
      debugPrint('Jooble API Error: $e');
    }
    return [];
  }

  JobModel _convertJoobleJob(Map<String, dynamic> job, String country) {
    return JobModel(
      id: 'jooble_${DateTime.now().millisecondsSinceEpoch}',
      title: job['title'] ?? '',
      company: job['company'] ?? '',
      location: job['location'] ?? '',
      country: country,
      description: job['snippet'] ?? '',
      descriptionArb: '',
      requirements: '',
      requirementsArb: '',
      salary: job['salary'] ?? '0',
      currency: _getCurrencyForCountry(country),
      workHours: '8',
      isHousingProvided: false,
      isVisaSponsor: job['workType']?.contains('permanent') ?? false,
      languageRequired: 'English',
      jobType: job['type'] ?? 'دوام كامل',
      source: 'Jooble',
      postedDate: DateTime.now(),
      isExclusive: false,
      applicationEmail: '',
      benefits: [],
    );
  }

  Future<List<JobModel>> _fetchFromLinkedIn(String country) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.linkedin.com/v2/jobSearch'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['LINKEDIN_TOKEN'] ?? ''}',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return _mockLinkedInJobs(country);
      }
    } catch (e) {
      debugPrint('LinkedIn API Error: $e');
    }
    return _mockLinkedInJobs(country);
  }

  List<JobModel> _mockLinkedInJobs(String country) {
    return _getMockJobs(country, 'LinkedIn');
  }

  Future<List<JobModel>> _fetchFromIndeed(String country) async {
    try {
      return _mockIndeedJobs(country);
    } catch (e) {
      debugPrint('Indeed API Error: $e');
      return [];
    }
  }

  List<JobModel> _mockIndeedJobs(String country) {
    return _getMockJobs(country, 'Indeed');
  }

  List<JobModel> _getMockJobs(String sourceCountry, String source) {
    final jobs = sourceCountry.toLowerCase() == 'turkey'
        ? _getTurkeyMockJobs()
        : sourceCountry.toLowerCase() == 'germany'
        ? _getGermanyMockJobs()
        : sourceCountry.toLowerCase() == 'canada'
        ? _getCanadaMockJobs()
        : _getEuropeDefaultJobs();

    return jobs
        .map(
          (job) => JobModel(
            id: '${source.toLowerCase()}_${DateTime.now().millisecondsSinceEpoch}_${jobs.indexOf(job)}',
            title: job['title']!,
            company: job['company']!,
            location: job['location']!,
            country: sourceCountry,
            description: job['description']!,
            descriptionArb: '',
            requirements: job['requirements']!,
            requirementsArb: '',
            salary: job['salary']!,
            currency: _getCurrencyForCountry(sourceCountry),
            workHours: job['workHours']!,
            isHousingProvided: job['housing'] == 'yes',
            isVisaSponsor: job['visa'] == 'yes',
            languageRequired: job['language']!,
            jobType: job['type']!,
            source: source,
            postedDate: DateTime.now().subtract(
              Duration(days: jobs.indexOf(job)),
            ),
            isExclusive: source == 'Indeed',
            applicationEmail: 'jobs@easywork-ai.com',
            benefits: (job['benefits'] ?? '').toString().split(','),
          ),
        )
        .toList();
  }

  List<Map<String, String>> _getTurkeyMockJobs() => [
    {
      'title': 'مشرف إنتاج',
      'company': 'شركة сельхоз',
      'location': 'إسطنبول',
      'description': 'مشرف خط إنتاج في مصنع تعبئة',
      'requirements': 'خبرة 3 سنوات + تأشيرة تركيا',
      'salary': '25000',
      'workHours': '8',
      'housing': 'yes',
      'visa': 'yes',
      'language': 'تركي',
      'type': 'دوام كامل',
      'benefits': 'سكن, نقل, تأمين صحي',
    },
    {
      'title': 'مهندس برمجيات',
      'company': 'Tech Istanbul',
      'location': 'أنقرة',
      'description': 'تطوير تطبيقات Flutter',
      'requirements': 'خبرة سنتين + إنجليزية',
      'salary': '35000',
      'workHours': '8',
      'housing': 'no',
      'visa': 'yes',
      'language': 'إنجليزي',
      'type': 'دوام كامل',
      'benefits': 'تأمين صحي, أسهم',
    },
    {
      'title': 'طباخ تركي',
      'company': 'فندق خمس نجوم',
      'location': 'أنطاليا',
      'description': 'طباخ تقليدي تركي',
      'requirements': 'خبرة 5 سنوات',
      'salary': '20000',
      'workHours': '10',
      'housing': 'yes',
      'visa': 'yes',
      'language': 'تركي',
      'type': 'دوام كامل',
      'benefits': 'سكن, وجبات',
    },
  ];

  List<Map<String, String>> _getGermanyMockJobs() => [
    {
      'title': 'مهندس ميكانيكا',
      'company': 'BMW',
      'location': 'ميونخ',
      'description': 'هندسة ميكانيكا السيارات',
      'requirements': 'بكالوريوس هندسة',
      'salary': '4500',
      'workHours': '40',
      'housing': 'no',
      'visa': 'yes',
      'language': 'ألماني',
      'type': 'دوام كامل',
      'benefits': 'تأمين صحي, تقاعد',
    },
    {
      'title': 'ممرض',
      'company': 'Berlin Hospital',
      'location': 'برلين',
      'description': 'تمريض في مستشفى',
      'requirements': 'Licence تمريض',
      'salary': '3800',
      'workHours': '38',
      'housing': 'yes',
      'visa': 'yes',
      'language': 'ألماني',
      'type': 'دوام كامل',
      'benefits': 'سكن, لغة',
    },
    {
      'title': 'سائق شاحنات',
      'company': 'DHL Germany',
      'location': 'هامبورغ',
      'description': 'قيادة شاحنات دولية',
      'requirements': 'رخصة سائق + خبرة',
      'salary': '3200',
      'workHours': '45',
      'housing': 'no',
      'visa': 'yes',
      'language': 'ألماني',
      'type': 'دوام كامل',
      'benefits': 'تأمين',
    },
  ];

  List<Map<String, String>> _getCanadaMockJobs() => [
    {
      'title': 'مهندس برمجيات',
      'company': 'Toronto Tech',
      'location': 'تورونتو',
      'description': 'تطوير ويب Fullstack',
      'requirements': 'خبرة 3 سنوات',
      'salary': '75000',
      'workHours': '40',
      'housing': 'no',
      'visa': 'yes',
      'language': 'إنجليزي',
      'type': 'دوام كامل',
      'benefits': 'تأمين صحي, سهم',
    },
    {
      'title': 'عامل مزرعة',
      'company': 'Ontario Farms',
      'location': 'أونتاريو',
      'description': 'عمل في مزرعة موسمية',
      'requirements': 'بدون خبرة',
      'salary': '16',
      'workHours': '40',
      'housing': 'yes',
      'visa': 'yes',
      'language': 'إنجليزي',
      'type': 'موسمي',
      'benefits': 'سكن, طعام',
    },
    {
      'title': 'مهندس كهرباء',
      'company': 'Hydro Quebec',
      'location': 'كيبك',
      'description': 'هندسة كهربائية',
      'requirements': 'بكالوريوس',
      'salary': '70000',
      'workHours': '40',
      'housing': 'no',
      'visa': 'yes',
      'language': 'فرنسي',
      'type': 'دوام كامل',
      'benefits': 'تأمين',
    },
  ];

  List<Map<String, String>> _getEuropeDefaultJobs() => [
    {
      'title': 'مطور ويب',
      'company': 'Paris Digital',
      'location': 'باريس',
      'description': 'تطوير ويب React',
      'requirements': 'خبرة سنتين',
      'salary': '4200',
      'workHours': '35',
      'housing': 'no',
      'visa': 'yes',
      'language': 'فرنسي',
      'type': 'دوام كامل',
      'benefits': 'تأمين صحي',
    },
    {
      'title': 'طباخ',
      'company': 'Rome Restaurant',
      'location': 'روما',
      'description': 'طبخ إيطالي',
      'requirements': 'خبرة 3 سنوات',
      'salary': '1800',
      'workHours': '40',
      'housing': 'yes',
      'visa': 'yes',
      'language': 'إيطالي',
      'type': 'دوام كامل',
      'benefits': 'سكن',
    },
  ];

  String _getCurrencyForCountry(String country) {
    switch (country.toLowerCase()) {
      case 'turkey':
      case 'turkiye':
        return 'TRY';
      case 'germany':
      case 'france':
      case 'italy':
      case 'spain':
      case 'netherlands':
      case 'uk':
        return 'EUR';
      case 'canada':
        return 'CAD';
      case 'australia':
        return 'AUD';
      default:
        return 'USD';
    }
  }

  List<JobModel> _deduplicateJobs(List<JobModel> jobs) {
    final Map<String, JobModel> uniqueJobs = {};
    for (var job in jobs) {
      final key = '${job.title.toLowerCase()}_${job.company.toLowerCase()}';
      if (!uniqueJobs.containsKey(key)) {
        uniqueJobs[key] = job;
      }
    }
    return uniqueJobs.values.toList();
  }
}
