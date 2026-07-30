import 'package:equatable/equatable.dart';

// ════════════════════════════════════════════════════════════════════════════
// CvModel  — Extended Europass-compatible CV data structure.
//
// Fields map 1-to-1 to the Europass PDF sections:
//   Personal Info  → fullName, profession, passport, dateOfBirth,
//                    nationality, gender, phone, email, country, city
//   About Me       → aboutMe
//   Work Exp       → companyName, workDates, workLocation, workBulletPoints
//   Education      → educationDegree, educationInstitution,
//                    educationDates, educationLocation, educationField
//   Language       → motherTongue, otherLanguage,
//                    cefrListening, cefrReading,
//                    cefrSpokenProduction, cefrSpokenInteraction, cefrWriting
//   Skills         → skills (pipe-separated in PDF)
// ════════════════════════════════════════════════════════════════════════════
class CvModel extends Equatable {
  const CvModel({
    // ── Personal Information ─────────────────────────────────────────────
    this.fullName = '',
    this.profession = '',
    this.yearsOfExperience = '',
    this.passport = '',
    this.dateOfBirth = '',
    this.nationality = '',
    this.gender = '',
    this.phone = '',
    this.email = '',
    this.country = '',
    this.city = '',
    // ── About Me ─────────────────────────────────────────────────────────
    this.aboutMe = '',
    // ── Work Experience ──────────────────────────────────────────────────
    this.companyName = '',
    this.workDates = '',
    this.workLocation = '',
    this.workBulletPoints = const [],
    // ── Education & Training ─────────────────────────────────────────────
    this.educationDegree = '',
    this.educationInstitution = '',
    this.educationDates = '',
    this.educationLocation = '',
    this.educationField = '',
    // ── Language Skills ───────────────────────────────────────────────────
    this.motherTongue = 'Arabic',
    this.otherLanguage = 'English',
    this.cefrListening = 'B1',
    this.cefrReading = 'B1',
    this.cefrSpokenProduction = 'B1',
    this.cefrSpokenInteraction = 'B1',
    this.cefrWriting = 'B1',
    // ── Digital & Other Skills ────────────────────────────────────────────
    this.skills = const [],
    // ── Cover Letter ──────────────────────────────────────────────────────
    this.coverLetter = '',
  });

  // Personal
  final String fullName;
  final String profession;
  final String yearsOfExperience;
  final String passport;
  final String dateOfBirth;
  final String nationality;
  final String gender;
  final String phone;
  final String email;
  final String country;
  final String city;

  // About Me
  final String aboutMe;

  // Work Experience
  final String companyName;
  final String workDates;
  final String workLocation;
  final List<String> workBulletPoints;

  // Education
  final String educationDegree;
  final String educationInstitution;
  final String educationDates;
  final String educationLocation;
  final String educationField;

  // Languages
  final String motherTongue;
  final String otherLanguage;
  final String cefrListening;
  final String cefrReading;
  final String cefrSpokenProduction;
  final String cefrSpokenInteraction;
  final String cefrWriting;

  // Skills
  final List<String> skills;

  // Cover Letter
  final String coverLetter;

  /// Combined address for PDF/display output.
  String get address =>
      [city, country].where((s) => s.isNotEmpty).join(', ');

  /// Automatically generates a high-converting, ATS-friendly European Cover Letter
  /// matching the user's selected Profession and experience.
  String get generatedCoverLetterText {
    if (coverLetter.trim().isNotEmpty) return coverLetter;
    final name = fullName.trim().isEmpty ? 'Applicant' : fullName.trim();
    final jobTitle = profession.trim().isEmpty ? 'Professional' : profession.trim();
    final exp = yearsOfExperience.trim().isEmpty ? 'proven' : '$yearsOfExperience+ years of';
    final userCountry = country.trim().isEmpty ? 'Europe' : country.trim();
    final skillList = skills.isNotEmpty ? skills.take(3).join(', ') : 'technical skills, quality standards, and safety protocols';

    return '''
Dear Hiring Manager,

I am writing to express my strong interest in joining your team as a $jobTitle. With $exp practical experience based in $userCountry, I have built a solid track record of delivering quality work, maintaining strict safety compliance, and collaborating efficiently in fast-paced environments.

My expertise includes $skillList. I am highly adaptable, eager to relocate or contribute immediately, and committed to upholding high European operational standards.

I look forward to discussing how my background and hands-on skills align with your organization's goals.

Sincerely,
$name
''';
  }

  CvModel copyWith({
    String? fullName,
    String? profession,
    String? yearsOfExperience,
    String? passport,
    String? dateOfBirth,
    String? nationality,
    String? gender,
    String? phone,
    String? email,
    String? country,
    String? city,
    String? aboutMe,
    String? companyName,
    String? workDates,
    String? workLocation,
    List<String>? workBulletPoints,
    String? educationDegree,
    String? educationInstitution,
    String? educationDates,
    String? educationLocation,
    String? educationField,
    String? motherTongue,
    String? otherLanguage,
    String? cefrListening,
    String? cefrReading,
    String? cefrSpokenProduction,
    String? cefrSpokenInteraction,
    String? cefrWriting,
    List<String>? skills,
    String? coverLetter,
  }) {
    return CvModel(
      fullName: fullName ?? this.fullName,
      profession: profession ?? this.profession,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      passport: passport ?? this.passport,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      nationality: nationality ?? this.nationality,
      gender: gender ?? this.gender,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      country: country ?? this.country,
      city: city ?? this.city,
      aboutMe: aboutMe ?? this.aboutMe,
      companyName: companyName ?? this.companyName,
      workDates: workDates ?? this.workDates,
      workLocation: workLocation ?? this.workLocation,
      workBulletPoints: workBulletPoints ?? this.workBulletPoints,
      educationDegree: educationDegree ?? this.educationDegree,
      educationInstitution: educationInstitution ?? this.educationInstitution,
      educationDates: educationDates ?? this.educationDates,
      educationLocation: educationLocation ?? this.educationLocation,
      educationField: educationField ?? this.educationField,
      motherTongue: motherTongue ?? this.motherTongue,
      otherLanguage: otherLanguage ?? this.otherLanguage,
      cefrListening: cefrListening ?? this.cefrListening,
      cefrReading: cefrReading ?? this.cefrReading,
      cefrSpokenProduction: cefrSpokenProduction ?? this.cefrSpokenProduction,
      cefrSpokenInteraction:
          cefrSpokenInteraction ?? this.cefrSpokenInteraction,
      cefrWriting: cefrWriting ?? this.cefrWriting,
      skills: skills ?? this.skills,
      coverLetter: coverLetter ?? this.coverLetter,
    );
  }

  @override
  List<Object?> get props => [
        fullName, profession, yearsOfExperience, passport,
        dateOfBirth, nationality, gender, phone, email,
        country, city, aboutMe, companyName, workDates,
        workLocation, workBulletPoints, educationDegree,
        educationInstitution, educationDates, educationLocation,
        educationField, motherTongue, otherLanguage,
        cefrListening, cefrReading, cefrSpokenProduction,
        cefrSpokenInteraction, cefrWriting, skills, coverLetter,
      ];
}
