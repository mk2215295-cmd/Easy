import 'package:equatable/equatable.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JobRequirementModel
// A single requirement item shown in the 2-column checkmark grid on the
// Job Details screen (المتطلبات section).
// All text fields are nullable — UI must handle null gracefully.
// ════════════════════════════════════════════════════════════════════════════════
class JobRequirementModel extends Equatable {
  const JobRequirementModel({
    required this.id,
    this.textAr,
    this.textEn,
  });

  /// Unique requirement identifier (from API)
  final String id;

  /// Requirement text in Arabic (primary display language)
  final String? textAr;

  /// Requirement text in English (secondary / translation)
  final String? textEn;

  factory JobRequirementModel.fromJson(Map<String, dynamic> json) {
    return JobRequirementModel(
      id: json['id']?.toString() ?? '',
      textAr: json['text_ar'] as String?,
      textEn: json['text_en'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'text_ar': textAr,
        'text_en': textEn,
      };

  @override
  List<Object?> get props => [id, textAr, textEn];
}
