class JobModel {
  final String id;
  final String title;
  final String company;
  final String location;
  final String country;
  final String description;
  final String descriptionArb;
  final String requirements;
  final String requirementsArb;
  final String salary;
  final String currency;
  final String workHours;
  final bool isHousingProvided;
  final bool isVisaSponsor;
  final String languageRequired;
  final String jobType;
  final String source;
  final DateTime postedDate;
  final bool isExclusive;
  final String applicationEmail;
  final List<String> benefits;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.country,
    required this.description,
    required this.descriptionArb,
    required this.requirements,
    required this.requirementsArb,
    required this.salary,
    required this.currency,
    required this.workHours,
    required this.isHousingProvided,
    required this.isVisaSponsor,
    required this.languageRequired,
    required this.jobType,
    required this.source,
    required this.postedDate,
    required this.isExclusive,
    required this.applicationEmail,
    required this.benefits,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      company: json['company'] ?? '',
      location: json['location'] ?? '',
      country: json['country'] ?? '',
      description: json['description'] ?? '',
      descriptionArb: json['descriptionArb'] ?? json['description'] ?? '',
      requirements: json['requirements'] ?? '',
      requirementsArb: json['requirementsArb'] ?? json['requirements'] ?? '',
      salary: json['salary'] ?? '0',
      currency: json['currency'] ?? 'EUR',
      workHours: json['workHours'] ?? '8',
      isHousingProvided: json['isHousingProvided'] ?? false,
      isVisaSponsor: json['isVisaSponsor'] ?? false,
      languageRequired: json['languageRequired'] ?? 'English',
      jobType: json['jobType'] ?? 'دوام كامل',
      source: json['source'] ?? 'Indeed',
      postedDate: json['postedDate'] != null
          ? DateTime.parse(json['postedDate'])
          : DateTime.now(),
      isExclusive: json['isExclusive'] ?? false,
      applicationEmail: json['applicationEmail'] ?? '',
      benefits: List<String>.from(json['benefits'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'location': location,
      'country': country,
      'description': description,
      'descriptionArb': descriptionArb,
      'requirements': requirements,
      'requirementsArb': requirementsArb,
      'salary': salary,
      'currency': currency,
      'workHours': workHours,
      'isHousingProvided': isHousingProvided,
      'isVisaSponsor': isVisaSponsor,
      'languageRequired': languageRequired,
      'jobType': jobType,
      'source': source,
      'postedDate': postedDate.toIso8601String(),
      'isExclusive': isExclusive,
      'applicationEmail': applicationEmail,
      'benefits': benefits,
    };
  }

  String get salaryFormatted => '$salary $currency';

  String get countryFlag {
    switch (country.toLowerCase()) {
      case 'turkey':
      case 'turkiye':
        return '🇹🇷';
      case 'germany':
      case 'deutschland':
        return '🇩🇪';
      case 'canada':
        return '🇨🇦';
      case 'france':
        return '🇫🇷';
      case 'uk':
      case 'united kingdom':
        return '🇬🇧';
      case 'italy':
        return '🇮🇹';
      case 'spain':
        return '🇪🇸';
      case 'netherlands':
        return '🇳🇱';
      case 'australia':
        return '🇦🇺';
      default:
        return '🌍';
    }
  }
}

class JobApplication {
  final String id;
  final String jobId;
  final String userId;
  final DateTime appliedAt;
  final String status;
  final String cvUrl;
  final String passportUrl;
  final bool isReviewed;
  final String companyNotes;

  JobApplication({
    required this.id,
    required this.jobId,
    required this.userId,
    required this.appliedAt,
    required this.status,
    required this.cvUrl,
    required this.passportUrl,
    required this.isReviewed,
    required this.companyNotes,
  });

  factory JobApplication.fromJson(Map<String, dynamic> json) {
    return JobApplication(
      id: json['id'] ?? '',
      jobId: json['jobId'] ?? '',
      userId: json['userId'] ?? '',
      appliedAt: json['appliedAt'] != null
          ? DateTime.parse(json['appliedAt'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
      cvUrl: json['cvUrl'] ?? '',
      passportUrl: json['passportUrl'] ?? '',
      isReviewed: json['isReviewed'] ?? false,
      companyNotes: json['companyNotes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'jobId': jobId,
      'userId': userId,
      'appliedAt': appliedAt.toIso8601String(),
      'status': status,
      'cvUrl': cvUrl,
      'passportUrl': passportUrl,
      'isReviewed': isReviewed,
      'companyNotes': companyNotes,
    };
  }

  String get statusArb {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'reviewed':
        return 'تمت المراجعة';
      case 'interview':
        return 'مقابلة';
      case 'accepted':
        return 'تم القبول';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }
}
