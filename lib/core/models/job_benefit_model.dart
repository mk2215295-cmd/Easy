import 'package:equatable/equatable.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JobBenefitModel
// A single benefit chip shown under the salary range on the Job Details screen
// (e.g. accommodation ✓, health insurance ✓, annual flight ticket ✓).
// The [type] field maps to a predefined icon in the UI layer — no IconData
// is stored in the model to keep it framework-agnostic.
// ════════════════════════════════════════════════════════════════════════════════

/// String constants for [JobBenefitModel.type] — avoids stringly-typed bugs.
abstract final class BenefitType {
  static const String accommodation   = 'accommodation';    // توفير السكن
  static const String healthInsurance = 'health_insurance'; // تأمين صحي شامل
  static const String flightTicket    = 'flight_ticket';    // تذكرة طيران سنوية
  static const String transportation  = 'transportation';   // مواصلات
  static const String bonus           = 'bonus';            // مكافأة
  static const String visa            = 'visa';             // تأشيرة
  static const String other           = 'other';
}

class JobBenefitModel extends Equatable {
  const JobBenefitModel({
    required this.id,
    this.type = BenefitType.other,
    this.labelAr,
    this.labelEn,
  });

  /// Unique benefit identifier (from API)
  final String id;

  /// Benefit category — matches one of the [BenefitType] constants.
  /// Used by the UI to select the correct icon.
  final String type;

  /// Benefit label in Arabic (e.g. 'توفير السكن')
  final String? labelAr;

  /// Benefit label in English (e.g. 'Accommodation Provided')
  final String? labelEn;

  factory JobBenefitModel.fromJson(Map<String, dynamic> json) {
    return JobBenefitModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? BenefitType.other,
      labelAr: json['label_ar'] as String?,
      labelEn: json['label_en'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'label_ar': labelAr,
        'label_en': labelEn,
      };

  @override
  List<Object?> get props => [id, type, labelAr, labelEn];
}
