import 'package:equatable/equatable.dart';

// ════════════════════════════════════════════════════════════════════════════════
// UserCvModel
// Represents a generated CV in the user's profile database.
// ════════════════════════════════════════════════════════════════════════════════
class UserCvModel extends Equatable {
  const UserCvModel({
    required this.id,
    required this.jobTitle,
    required this.fileName,
    required this.pdfUrl,
  });

  final String id;
  final String jobTitle;
  final String fileName;
  final String pdfUrl;

  @override
  List<Object?> get props => [id, jobTitle, fileName, pdfUrl];
}

// ════════════════════════════════════════════════════════════════════════════════
// AppliedApplicationModel
// Represents a single job application and its current status tracking.
// ════════════════════════════════════════════════════════════════════════════════
class AppliedApplicationModel extends Equatable {
  const AppliedApplicationModel({
    required this.id,
    required this.jobTitle,
    required this.companyName,
    required this.location,
    required this.appliedDate,
    required this.status,
    this.statusColorHex,
  });

  final String id;
  final String jobTitle;
  final String companyName;
  final String location;
  final String appliedDate;
  
  /// Status string e.g. "Reviewed", "Interview Scheduled", "Application Submitted"
  final String status;
  final String? statusColorHex;

  @override
  List<Object?> get props => [id, jobTitle, companyName, location, appliedDate, status, statusColorHex];
}

// ════════════════════════════════════════════════════════════════════════════════
// UserProfileModel
// Represents the full user account state displayed in the Profile Dashboard.
// ════════════════════════════════════════════════════════════════════════════════
class UserProfileModel extends Equatable {
  const UserProfileModel({
    required this.uid,
    required this.fullName,
    this.avatarUrl,
    required this.profileCompletionPercentage,
    required this.generatedCvs,
    required this.applications,
  });

  final String uid;
  final String fullName;
  final String? avatarUrl;
  final int profileCompletionPercentage;
  final List<UserCvModel> generatedCvs;
  final List<AppliedApplicationModel> applications;

  @override
  List<Object?> get props => [uid, fullName, avatarUrl, profileCompletionPercentage, generatedCvs, applications];
}
