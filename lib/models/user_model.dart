class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? photoUrl;
  final String? passportUrl;
  final bool isPassportVerified;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final String role;
  final UserProfile? profile;
  final NotificationPreferences? notificationPreferences;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
    this.passportUrl,
    this.isPassportVerified = false,
    required this.createdAt,
    this.lastLoginAt,
    this.role = 'user',
    this.profile,
    this.notificationPreferences,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      photoUrl: json['photoUrl'],
      passportUrl: json['passportUrl'],
      isPassportVerified: json['isPassportVerified'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'])
          : null,
      role: json['role'] ?? 'user',
      profile: json['profile'] != null
          ? UserProfile.fromJson(json['profile'])
          : null,
      notificationPreferences: json['notificationPreferences'] != null
          ? NotificationPreferences.fromJson(json['notificationPreferences'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'photoUrl': photoUrl,
      'passportUrl': passportUrl,
      'isPassportVerified': isPassportVerified,
      'createdAt': createdAt.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
      'role': role,
      'profile': profile?.toJson(),
      'notificationPreferences': notificationPreferences?.toJson(),
    };
  }

  bool get isComplete => profile != null && profile!.isComplete;
  bool get isAdmin => role == 'admin';
}

class UserProfile {
  final String title;
  final String summary;
  final List<String> skills;
  final List<WorkExperience> experiences;
  final List<Education> education;
  final List<String> languages;
  final String? cvUrl;
  final DateTime? lastUpdated;

  UserProfile({
    required this.title,
    required this.summary,
    required this.skills,
    required this.experiences,
    required this.education,
    required this.languages,
    this.cvUrl,
    this.lastUpdated,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      experiences: (json['experiences'] as List? ?? [])
          .map((e) => WorkExperience.fromJson(e))
          .toList(),
      education: (json['education'] as List? ?? [])
          .map((e) => Education.fromJson(e))
          .toList(),
      languages: List<String>.from(json['languages'] ?? []),
      cvUrl: json['cvUrl'],
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'summary': summary,
      'skills': skills,
      'experiences': experiences.map((e) => e.toJson()).toList(),
      'education': education.map((e) => e.toJson()).toList(),
      'languages': languages,
      'cvUrl': cvUrl,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  bool get isComplete {
    return title.isNotEmpty && summary.isNotEmpty && skills.isNotEmpty;
  }

  int get completionPercentage {
    int score = 0;
    if (title.isNotEmpty) score += 20;
    if (summary.isNotEmpty) score += 20;
    if (skills.isNotEmpty) score += 20;
    if (experiences.isNotEmpty) score += 15;
    if (education.isNotEmpty) score += 15;
    if (cvUrl != null) score += 10;
    return score;
  }
}

class WorkExperience {
  final String company;
  final String position;
  final DateTime startDate;
  final DateTime? endDate;
  final String description;
  final bool isCurrent;

  WorkExperience({
    required this.company,
    required this.position,
    required this.startDate,
    this.endDate,
    required this.description,
    this.isCurrent = false,
  });

  factory WorkExperience.fromJson(Map<String, dynamic> json) {
    return WorkExperience(
      company: json['company'] ?? '',
      position: json['position'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      description: json['description'] ?? '',
      isCurrent: json['isCurrent'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'company': company,
      'position': position,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'description': description,
      'isCurrent': isCurrent,
    };
  }
}

class Education {
  final String school;
  final String degree;
  final String field;
  final DateTime startDate;
  final DateTime? endDate;
  final double? gpa;

  Education({
    required this.school,
    required this.degree,
    required this.field,
    required this.startDate,
    this.endDate,
    this.gpa,
  });

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      school: json['school'] ?? '',
      degree: json['degree'] ?? '',
      field: json['field'] ?? '',
      startDate: json['startDate'] != null
          ? DateTime.parse(json['startDate'])
          : DateTime.now(),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      gpa: json['gpa']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'school': school,
      'degree': degree,
      'field': field,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'gpa': gpa,
    };
  }
}

class NotificationPreferences {
  final bool newJobsEnabled;
  final List<String> targetCountries;
  final List<String> jobTypes;

  NotificationPreferences({
    this.newJobsEnabled = true,
    this.targetCountries = const ['germany', 'france', 'netherlands'],
    this.jobTypes = const ['full-time', 'part-time'],
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      newJobsEnabled: json['newJobsEnabled'] ?? true,
      targetCountries: List<String>.from(
        json['targetCountries'] ?? ['germany', 'france', 'netherlands'],
      ),
      jobTypes: List<String>.from(
        json['jobTypes'] ?? ['full-time', 'part-time'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'newJobsEnabled': newJobsEnabled,
      'targetCountries': targetCountries,
      'jobTypes': jobTypes,
    };
  }

  NotificationPreferences copyWith({
    bool? newJobsEnabled,
    List<String>? targetCountries,
    List<String>? jobTypes,
  }) {
    return NotificationPreferences(
      newJobsEnabled: newJobsEnabled ?? this.newJobsEnabled,
      targetCountries: targetCountries ?? this.targetCountries,
      jobTypes: jobTypes ?? this.jobTypes,
    );
  }
}
