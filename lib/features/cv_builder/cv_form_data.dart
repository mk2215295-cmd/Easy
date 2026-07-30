// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
// CvFormData
//
// Categorized taxonomy of White-Collar & Blue-Collar professions with
// bilingual labels (English & Arabic) and a comprehensive pool of 8-10
// bilingual suggested experience bullet points per profession.
//
// Bilingual Mapping:
//   â€¢ [textAr] is shown in the UI selection list when language is Arabic.
//   â€¢ [textEn] is the formal ATS English text inserted into the PDF/CV.
// â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•

class CvExperienceBullet {
  const CvExperienceBullet({
    required this.textEn,
    required this.textAr,
  });

  /// Formal ATS English text inserted into the Europass PDF/CV model
  final String textEn;

  /// Arabic localized text shown in the UI preset suggestion list
  final String textAr;
}

class CvProfession {
  const CvProfession({
    required this.titleEn,
    required this.titleAr,
    required this.categoryEn,
    required this.categoryAr,
    required this.emoji,
    required this.suggestedBullets,
  });

  /// ATS-friendly English job title embedded in the PDF.
  final String titleEn;

  /// Arabic label shown inside the UI dropdown/modal.
  final String titleAr;

  /// Category name in English (e.g. "Vocational & Technical Trades")
  final String categoryEn;

  /// Category name in Arabic (e.g. "Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©")
  final String categoryAr;

  /// Emoji indicator for visual clarity
  final String emoji;

  /// Comprehensive list of 8-10 bilingual ATS suggested bullet points.
  final List<CvExperienceBullet> suggestedBullets;

  /// Legacy helper getter returning English bullet point strings.
  List<String> get atsBullets => suggestedBullets.map((b) => b.textEn).toList();
}

class CvProfessionCategory {
  const CvProfessionCategory({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.emoji,
    required this.professions,
  });

  final String id;
  final String titleEn;
  final String titleAr;
  final String emoji;
  final List<CvProfession> professions;
}

// â”€â”€ Categorized Professions Database â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
const List<CvProfession> kProfessions = [
  // 1. ðŸ› ï¸ Vocational & Technical Trades
  CvProfession(
    titleEn: 'Electrician',
    titleAr: 'ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠ',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©',
    emoji: 'ðŸ› ï¸',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Installed, maintained and repaired electrical wiring, equipment and fixtures in compliance with national safety codes.',
        textAr: 'ØªØ±ÙƒÙŠØ¨ ÙˆØµÙŠØ§Ù†Ø© ÙˆØ¥ØµÙ„Ø§Ø­ Ø§Ù„ØªÙ…Ø¯ÙŠØ¯Ø§Øª ÙˆØ§Ù„Ù…Ø¹Ø¯Ø§Øª ÙˆØ§Ù„ØªØ±ÙƒÙŠØ¨Ø§Øª Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙˆÙÙ‚Ø§Ù‹ Ù„Ù…Ø¹Ø§ÙŠÙŠØ± Ø§Ù„Ø³Ù„Ø§Ù…Ø© Ø§Ù„ÙˆØ·Ù†ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Read and interpreted blueprints, wiring diagrams and engineering drawings to carry out installation tasks.',
        textAr: 'Ù‚Ø±Ø§Ø¡Ø© ÙˆØªÙØ³ÙŠØ± Ø§Ù„Ù…Ø®Ø·Ø·Ø§Øª Ø§Ù„Ù‡Ù†Ø¯Ø³ÙŠØ© ÙˆØ±Ø³ÙˆÙ…Ø§Øª Ø§Ù„ØªÙ…Ø¯ÙŠØ¯Ø§Øª Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© Ù„ØªÙ†ÙÙŠØ° Ø§Ù„Ù…Ù‡Ø§Ù… Ø¨Ø¯Ù‚Ø©.',
      ),
      CvExperienceBullet(
        textEn: 'Performed preventive maintenance on industrial electrical systems, reducing unplanned downtime by 25%.',
        textAr: 'ØªÙ†ÙÙŠØ° Ø§Ù„ØµÙŠØ§Ù†Ø© Ø§Ù„ÙˆÙ‚Ø§Ø¦ÙŠØ© Ù„Ù„Ø£Ù†Ø¸Ù…Ø© Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© Ø§Ù„ØµÙ†Ø§Ø¹ÙŠØ©ØŒ Ù…Ù…Ø§ Ù‚Ù„Ù„ Ù…Ù† Ø§Ù„ØªÙˆÙ‚Ù ØºÙŠØ± Ø§Ù„Ù…Ø®Ø·Ø· Ù„Ù‡ Ø¨Ù†Ø³Ø¨Ø© 25%.',
      ),
      CvExperienceBullet(
        textEn: 'Diagnosed and repaired electrical faults in high-voltage transformers, switchgears, and control panels.',
        textAr: 'ØªØ´Ø®ÙŠØµ ÙˆØ¥ØµÙ„Ø§Ø­ Ø§Ù„Ø£Ø¹Ø·Ø§Ù„ Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙÙŠ Ù…Ø­ÙˆÙ„Ø§Øª Ø§Ù„Ø¶ØºØ· Ø§Ù„Ø¹Ø§Ù„ÙŠ ÙˆÙ„ÙˆØ­Ø§Øª Ø§Ù„ØªØ­ÙƒÙ… ÙˆØ§Ù„Ù‚Ø·Ø¹.',
      ),
      CvExperienceBullet(
        textEn: 'Tested electrical systems and continuity using multimeters, megohmmeters, and insulation testers.',
        textAr: 'Ø§Ø®ØªØ¨Ø§Ø± Ø§Ù„Ø£Ù†Ø¸Ù…Ø© Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙˆØ§Ù„Ø§Ø³ØªÙ…Ø±Ø§Ø±ÙŠØ© Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø£Ø¬Ù‡Ø²Ø© Ø§Ù„ÙÙˆÙ„ØªÙ…ÙŠØªØ± ÙˆØ§Ù„Ù…ÙŠØ¬ÙˆÙ…ÙŠØªØ± ÙˆÙØ­Øµ Ø§Ù„Ø¹Ø²Ù„.',
      ),
      CvExperienceBullet(
        textEn: 'Installed cable trays, conduit systems, and junction boxes for commercial facilities.',
        textAr: 'ØªØ±ÙƒÙŠØ¨ Ù…Ø³Ø§Ø±Ø§Øª Ø§Ù„ÙƒØ§Ø¨Ù„Ø§Øª ÙˆØ£Ù†Ø¸Ù…Ø© Ø§Ù„Ø£Ù†Ø§Ø¨ÙŠØ¨ ÙˆØµÙ†Ø§Ø¯ÙŠÙ‚ Ø§Ù„ØªØ¬Ù…ÙŠØ¹ ÙÙŠ Ø§Ù„Ù…Ù†Ø´Ø¢Øª Ø§Ù„ØªØ¬Ø§Ø±ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Collaborated with project managers and site engineers to deliver electrical works on schedule.',
        textAr: 'Ø§Ù„ØªØ¹Ø§ÙˆÙ† Ù…Ø¹ Ù…Ø¯ÙŠØ±ÙŠ Ø§Ù„Ù…Ø´Ø§Ø±ÙŠØ¹ ÙˆÙ…Ù‡Ù†Ø¯Ø³ÙŠ Ø§Ù„Ù…ÙˆÙ‚Ø¹ Ù„ØªØ³Ù„ÙŠÙ… Ø§Ù„Ø£Ø¹Ù…Ø§Ù„ Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙÙŠ Ø§Ù„Ù…ÙˆØ§Ø¹ÙŠØ¯ Ø§Ù„Ù…Ø­ØªØ³Ø¨Ø©.',
      ),
      CvExperienceBullet(
        textEn: 'Enforced zero-incident OSHA & CE safety protocols across all live wire installation sites.',
        textAr: 'ØªØ·Ø¨ÙŠÙ‚ Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø§Ù„Ø³Ù„Ø§Ù…Ø© Ø§Ù„Ù…Ù‡Ù†ÙŠØ© ÙˆØªØ¬Ù†Ø¨ Ø§Ù„Ø­ÙˆØ§Ø¯Ø« ÙÙŠ Ø¬Ù…ÙŠØ¹ Ù…ÙˆØ§Ù‚Ø¹ Ø§Ù„Ø¹Ù…Ù„ Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© Ø§Ù„Ø­ÙŠØ©.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Welder & Fabricator',
    titleAr: 'Ù„Ø­Ø§Ù… ÙˆÙ…Ø´ÙƒÙ‘Ù„ Ù…Ø¹Ø§Ø¯Ù†',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©',
    emoji: 'ðŸ› ï¸',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Performed MIG, TIG and arc welding on structural steel and stainless steel components in manufacturing environments.',
        textAr: 'ØªÙ†ÙÙŠØ° Ø¹Ù…Ù„ÙŠØ§Øª Ø§Ù„Ù„Ø­Ø§Ù… Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… MIG ÙˆTIG ÙˆØ§Ù„Ù„Ø­Ø§Ù… Ø§Ù„Ù‚ÙˆØ³ÙŠ Ø¹Ù„Ù‰ Ø§Ù„Ù‡ÙŠØ§ÙƒÙ„ Ø§Ù„ÙÙˆÙ„Ø§Ø°ÙŠØ© ÙˆØ§Ù„Ù…Ø¹Ø§Ø¯Ù†.',
      ),
      CvExperienceBullet(
        textEn: 'Interpreted engineering drawings and welding symbols to produce precision welds meeting ISO 9001 quality standards.',
        textAr: 'Ù‚Ø±Ø§Ø¡Ø© ÙˆØ±Ø³Ù… Ø±Ù…ÙˆØ² Ø§Ù„Ù„Ø­Ø§Ù… ÙˆØ§Ù„Ù…Ø®Ø·Ø·Ø§Øª Ø§Ù„Ù‡Ù†Ø¯Ø³ÙŠØ© Ù„Ø¥Ù†ØªØ§Ø¬ Ù„Ø­Ø§Ù…Ø§Øª Ø¯Ù‚ÙŠÙ‚Ø© ØªØ·Ø§Ø¨Ù‚ Ù…Ø¹Ø§ÙŠÙŠØ± ISO 9001.',
      ),
      CvExperienceBullet(
        textEn: 'Inspected completed welds using visual and non-destructive testing (NDT) methods to ensure structural integrity.',
        textAr: 'ÙØ­Øµ Ø§Ù„Ù„Ø­Ø§Ù…Ø§Øª Ø§Ù„Ù…ÙƒØªÙ…Ù„Ø© Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„ÙØ­Øµ Ø§Ù„Ø¨ØµØ±ÙŠ ÙˆØ§Ø§Ø®ØªØ¨Ø§Ø±Ø§Øª NDT ØºÙŠØ± Ø§Ù„Ù…Ø¯Ù…Ø±Ø© Ù„Ø¶Ù…Ø§Ù† Ù…ØªØ§Ù†Ø© Ø§Ù„Ù‡ÙŠÙƒÙ„.',
      ),
      CvExperienceBullet(
        textEn: 'Operated angle grinders, cutting torches, plasma cutters, and fabrication tools with 100% precision.',
        textAr: 'ØªØ´ØºÙŠÙ„ Ø£Ø¯ÙˆØ§Øª Ø§Ù„Ù‚Ø·Ø¹ Ø¨Ø§Ù„Ø¨Ù„Ø§Ø²Ù…Ø§ ÙˆØ§Ù„Ù…Ø¬Ø§Ù„Ø® ÙˆÙ…Ø¹Ø¯Ø§Øª Ø§Ù„ØªØ´ÙƒÙŠÙ„ Ø¨Ø¯Ù‚Ø© Ø¹Ø§Ù„ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Fabricated heavy structural frames, tanks, and pressure piping to design specification.',
        textAr: 'ØªØµÙ†ÙŠØ¹ ÙˆØªØ´ÙƒÙŠÙ„ Ø§Ù„Ù‡ÙŠØ§ÙƒÙ„ Ø§Ù„Ù…Ø¹Ø¯Ù†ÙŠØ© Ø§Ù„Ø«Ù‚ÙŠÙ„Ø© ÙˆØ§Ù„Ø®Ø²Ø§Ù†Ø§Øª ÙˆØ£Ù†Ø§Ø¨ÙŠØ¨ Ø§Ù„Ø¶ØºØ· ÙˆÙÙ‚Ø§Ù‹ Ù„Ù„Ù…ÙˆØ§ØµÙØ§Øª.',
      ),
      CvExperienceBullet(
        textEn: 'Set up welding parameters, shielding gas flow rates, and voltage according to metallurgy specs.',
        textAr: 'Ø¶Ø¨Ø· Ù…Ø¹Ø¯Ù„Ø§Øª ØªØ¯ÙÙ‚ Ø§Ù„ØºØ§Ø² ÙˆÙ…Ø³ØªÙˆÙŠØ§Øª Ø§Ù„Ø¬Ù‡Ø¯ Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠ ÙˆÙÙ‚Ø§Ù‹ Ù„Ù…ÙˆØ§ØµÙØ§Øª Ø§Ù„Ù…Ø¹Ø§Ø¯Ù† Ø§Ù„Ù…Ø¹Ø§Ù„Ø¬Ø©.',
      ),
      CvExperienceBullet(
        textEn: 'Prepared metal surfaces by cleaning, beveling, and clamping parts prior to assembly.',
        textAr: 'ØªØ¬Ù‡ÙŠØ² Ø£Ø³Ø·Ø­ Ø§Ù„Ù…Ø¹Ø§Ø¯Ù† Ø¨Ø§Ù„ØªÙ†Ø¸ÙŠÙ ÙˆØ§Ù„Ø´Ø·Ù ÙˆØ§Ù„ØªØ«Ø¨ÙŠØª Ù‚Ø¨Ù„ Ø¨Ø¯Ø¡ Ø¹Ù…Ù„ÙŠØ© Ø§Ù„ØªØ¬Ù…ÙŠØ¹.',
      ),
      CvExperienceBullet(
        textEn: 'Strictly adhered to PPE, eye protection, and ventilation safety protocols on fabrication floors.',
        textAr: 'Ø§Ù„Ø§Ù„ØªØ²Ø§Ù… Ø§Ù„ØµØ§Ø±Ù… Ø¨Ù…Ø¹Ø¯Ø§Øª Ø§Ù„Ø­Ù…Ø§ÙŠØ© Ø§Ù„Ø´Ø®ØµÙŠØ© ÙˆØ³Ù„Ø§Ù…Ø© Ø§Ù„ØªÙ‡ÙˆÙŠØ© Ø¯Ø§Ø®Ù„ ÙˆØ±Ø´ Ø§Ù„ØªØµÙ†ÙŠØ¹.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Plumber & Pipefitter',
    titleAr: 'Ø³Ø¨Ø§Ùƒ ÙˆÙÙ†ÙŠ ØªÙ…Ø¯ÙŠØ¯Ø§Øª ØµØ­ÙŠØ©',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©',
    emoji: 'ðŸ› ï¸',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Installed, inspected and repaired commercial and residential piping systems, water heaters and drainage infrastructure.',
        textAr: 'ØªØ±ÙƒÙŠØ¨ ÙˆÙØ­Øµ ÙˆØ¥ØµÙ„Ø§Ø­ Ø´Ø¨ÙƒØ§Øª Ø§Ù„Ø£Ù†Ø§Ø¨ÙŠØ¨ Ø§Ù„ØªØ¬Ø§Ø±ÙŠØ© ÙˆØ§Ù„Ø³ÙƒÙ†ÙŠØ© ÙˆØ³Ø®Ø§Ù†Ø§Øª Ø§Ù„Ù…ÙŠØ§Ù‡ ÙˆØ§Ù„Ø¨Ù†ÙŠØ© Ø§Ù„ØªØ­ØªÙŠØ© Ù„Ù„ØµØ±Ù.',
      ),
      CvExperienceBullet(
        textEn: 'Used pressure testing gauges to detect pipe leaks and ensured all installations met building regulatory standards.',
        textAr: 'Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø£Ø¬Ù‡Ø²Ø© Ù‚ÙŠØ§Ø³ Ø§Ù„Ø¶ØºØ· Ù„Ø§ÙƒØªØ´Ø§Ù Ø§Ù„ØªØ³Ø±ÙŠØ¨Ø§Øª ÙˆØ¶Ù…Ø§Ù† Ù…Ø·Ø§Ø¨Ù‚Ø© Ø§Ù„ØªÙ…Ø¯ÙŠØ¯Ø§Øª Ù„Ù„ÙˆØ§Ø¦Ø­ Ø§Ù„Ø¨Ù†Ø§Ø¡.',
      ),
      CvExperienceBullet(
        textEn: 'Replaced damaged valves, fittings and pumps in high-demand plumbing systems with zero unplanned shutdowns.',
        textAr: 'Ø§Ø³ØªØ¨Ø¯Ø§Ù„ Ø§Ù„ØµÙ…Ø§Ù…Ø§Øª ÙˆØ§Ù„Ù…Ø¶Ø®Ø§Øª Ø§Ù„ØªØ§Ù„ÙØ© ÙÙŠ Ø´Ø¨ÙƒØ§Øª Ø§Ù„Ù…ÙŠØ§Ù‡ Ø¯ÙˆÙ† ØªØ¹Ø·ÙŠÙ„ Ø®Ø·ÙˆØ· Ø§Ù„Ø¥Ù…Ø¯Ø§Ø¯.',
      ),
      CvExperienceBullet(
        textEn: 'Coordinated with site managers to plan pipe routing, trenching, and material estimation for major renovations.',
        textAr: 'Ø§Ù„ØªÙ†Ø³ÙŠÙ‚ Ù…Ø¹ Ù…Ø¯ÙŠØ±ÙŠ Ø§Ù„Ù…ÙˆÙ‚Ø¹ Ù„ØªØ®Ø·ÙŠØ· Ù…Ø³Ø§Ø±Ø§Øª Ø§Ù„Ø£Ù†Ø§Ø¨ÙŠØ¨ ÙˆØ­ÙØ± Ø§Ù„Ø®Ù†Ø§Ø¯Ù‚ ÙˆØ­Ø³Ø§Ø¨ ÙƒÙ…ÙŠØ§Øª Ø§Ù„Ù…ÙˆØ§Ø¯.',
      ),
      CvExperienceBullet(
        textEn: 'Soldered, brazed, and threaded copper, PVC, PEX, and cast iron piping for water supply.',
        textAr: 'Ù„Ø­Ø§Ù… ÙˆØªÙ„Ø­ÙŠÙ… ÙˆØªØ«Ø¨ÙŠØª Ø£Ù†Ø§Ø¨ÙŠØ¨ Ø§Ù„Ù†Ø­Ø§Ø³ ÙˆØ§Ù„Ù€ PVC ÙˆØ§Ù„Ø­Ø¯ÙŠØ¯ Ù„Ø´Ø¨ÙƒØ§Øª Ø§Ù„ØªØºØ°ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Cleared complex blockages in main sewer lines using hydro-jetters and motor drain augers.',
        textAr: 'ØªØ³Ù„ÙŠÙƒ ÙˆØªØ·Ù‡ÙŠØ± Ø§Ù„Ø§Ù†Ø³Ø¯Ø§Ø¯Ø§Øª Ø§Ù„Ù…Ø¹Ù‚Ø¯Ø© ÙÙŠ Ø®Ø·ÙˆØ· Ø§Ù„Ù…Ø¬Ø§Ø±ÙŠ Ø§Ù„Ø±Ø¦ÙŠØ³ÙŠØ© Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„Ø¶ØºØ· Ø§Ù„Ø¹Ø§Ù„ÙŠ ÙˆØ§Ù„ØªØ¬Ù‡ÙŠØ²Ø§Øª Ø§Ù„Ø¢Ù„ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Installed sanitary fixtures, pumps, backflow preventers, and water filtration equipment.',
        textAr: 'ØªØ±ÙƒÙŠØ¨ Ø§Ù„Ø£Ø¯ÙˆØ§Øª Ø§Ù„ØµØ­ÙŠØ© ÙˆØ§Ù„Ù…Ø¶Ø®Ø§Øª ÙˆÙ…Ø¹Ø¯Ø§Øª Ø§Ù„ÙÙ„ØªØ±Ø© ÙˆØ£Ø¬Ù‡Ø²Ø© Ù…Ù†Ø¹ Ø§Ù„ØªØ¯ÙÙ‚ Ø§Ù„Ø¹ÙƒØ³ÙŠ.',
      ),
      CvExperienceBullet(
        textEn: 'Maintained detailed work orders, material logs, and safety inspection documentation.',
        textAr: 'ØªÙˆØ«ÙŠÙ‚ Ø£Ø°ÙˆÙ†Ø§Øª Ø§Ù„Ø¹Ù…Ù„ ÙˆØ³Ø¬Ù„Ø§Øª Ø§Ù„Ù…ÙˆØ§Ø¯ ÙˆÙØ­ÙˆØµØ§Øª Ø§Ù„Ø³Ù„Ø§Ù…Ø© Ø¨Ø´ÙƒÙ„ Ù…Ù†ØªØ¸Ù….',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'HVAC Technician',
    titleAr: 'ÙÙ†ÙŠ ØªÙƒÙŠÙŠÙ ÙˆØªØ¨Ø±ÙŠØ¯',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©',
    emoji: 'ðŸ› ï¸',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Installed, serviced and repaired central heating, ventilation and air conditioning (HVAC) systems in commercial buildings.',
        textAr: 'ØªØ±ÙƒÙŠØ¨ ÙˆØµÙŠØ§Ù†Ø© ÙˆØ¥ØµÙ„Ø§Ø­ Ø£Ù†Ø¸Ù…Ø© Ø§Ù„ØªÙƒÙŠÙŠÙ ÙˆØ§Ù„ØªØ¨Ø±ÙŠØ¯ Ø§Ù„Ù…Ø±ÙƒØ²ÙŠØ© ÙˆØ§Ù„ØªÙ‡ÙˆÙŠØ© ÙÙŠ Ø§Ù„Ù…Ø¨Ø§Ù†ÙŠ Ø§Ù„ØªØ¬Ø§Ø±ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Recovered refrigerants and recharged systems according to F-Gas environmental regulations and safety standards.',
        textAr: 'Ø§Ø³ØªØ±Ø¬Ø§Ø¹ ÙˆØ³Ø§Ø¦Ø· Ø§Ù„ØªØ¨Ø±ÙŠØ¯ ÙˆØ¥Ø¹Ø§Ø¯Ø© Ø´Ø­Ù† Ø§Ù„Ø£Ù†Ø¸Ù…Ø© ÙˆÙÙ‚Ø§Ù‹ Ù„Ù„ÙˆØ§Ø¦Ø­ Ø§Ù„Ø¨ÙŠØ¦ÙŠØ© ÙˆØ§Ù„Ø³Ù„Ø§Ù…Ø© Ø§Ù„Ù…Ø¹ØªÙ…Ø¯Ø©.',
      ),
      CvExperienceBullet(
        textEn: 'Diagnosed electrical and mechanical faults in chillers, air handling units (AHUs) and compressors.',
        textAr: 'ØªØ´Ø®ÙŠØµ Ø§Ù„Ø£Ø¹Ø·Ø§Ù„ Ø§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙˆØ§Ù„Ù…ÙŠÙƒØ§Ù†ÙŠÙƒÙŠØ© ÙÙŠ Ø§Ù„Ù…Ø¨Ø±Ø¯Ø§Øª (Chillers) ÙˆÙˆØ­Ø¯Ø§Øª Ù…Ù†Ø§ÙˆÙ„Ø© Ø§Ù„Ù‡ÙˆØ§Ø¡ ÙˆØ§Ù„Ø¶ÙˆØ§ØºØ·.',
      ),
      CvExperienceBullet(
        textEn: 'Executed scheduled preventive maintenance contracts, improving system energy efficiency by 18%.',
        textAr: 'ØªÙ†ÙÙŠØ° Ø¹Ù‚ÙˆØ¯ Ø§Ù„ØµÙŠØ§Ù†Ø© Ø§Ù„ÙˆÙ‚Ø§Ø¦ÙŠØ© Ø§Ù„Ø¯ÙˆØ±ÙŠØ© Ù…Ù…Ø§ Ø³Ø§Ù‡Ù… ÙÙŠ ØªØ­Ø³ÙŠÙ† ÙƒÙØ§Ø¡Ø© Ø§Ø³ØªÙ‡Ù„Ø§Ùƒ Ø§Ù„Ø·Ø§Ù‚Ø© Ø¨Ù†Ø³Ø¨Ø© 18%.',
      ),
      CvExperienceBullet(
        textEn: 'Replaced failed fan motors, expansion valves, thermostats, and circuit boards.',
        textAr: 'Ø§Ø³ØªØ¨Ø¯Ø§Ù„ Ù…Ø­Ø±ÙƒØ§Øª Ø§Ù„Ù…Ø±ÙˆØ­ÙŠØ§Øª ÙˆØµÙ…Ø§Ù…Ø§Øª Ø§Ù„ØªÙ…Ø¯Ø¯ ÙˆØ«Ø±Ù…ÙˆØ³ØªØ§Øª ÙˆÙ„ÙˆØ­Ø§Øª Ø§Ù„ØªØ­ÙƒÙ… Ø§Ù„ØªØ§Ù„ÙØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Inspected and cleaned ductwork, air filters, and evaporator coils to optimize indoor air quality.',
        textAr: 'ØªÙ†Ø¸ÙŠÙ ÙˆÙØ­Øµ Ù…Ø¬Ø§Ø±ÙŠ Ø§Ù„Ù‡ÙˆØ§Ø¡ ÙˆØ§Ù„ÙÙ„Ø§ØªØ± ÙˆÙ…Ø¨Ø®Ø±Ø§Øª Ø§Ù„ØªØ¨Ø±ÙŠØ¯ Ù„Ø¶Ù…Ø§Ù† Ø¬ÙˆØ¯Ø© Ø§Ù„Ù‡ÙˆØ§Ø¡ Ø§Ù„Ø¯Ø§Ø®Ù„ÙŠ.',
      ),
      CvExperienceBullet(
        textEn: 'Programmed digital building management thermostats and automated HVAC controllers.',
        textAr: 'Ø¨Ø±Ù…Ø¬Ø© Ø£Ù†Ø¸Ù…Ø© Ø§Ù„ØªØ­ÙƒÙ… Ø§Ù„Ø±Ù‚Ù…ÙŠ ÙˆØ§Ù„Ù€ Thermostat Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠ Ù„Ø¥Ù†Ø¹Ø§Ø´ ÙƒÙØ§Ø¡Ø© Ø§Ù„ØªØ¨Ø±ÙŠØ¯.',
      ),
      CvExperienceBullet(
        textEn: 'Completed emergency field service calls with a 95% first-visit resolution rate.',
        textAr: 'Ø§Ù„Ø§Ø³ØªØ¬Ø§Ø¨Ø© Ù„Ù†Ø¯Ø§Ø¡Ø§Øª Ø§Ù„ØµÙŠØ§Ù†Ø© Ø§Ù„Ø·Ø§Ø±Ø¦Ø© ÙˆØ¥ØµÙ„Ø§Ø­ Ø§Ù„Ù…Ø´Ø§ÙƒÙ„ Ù…Ù† Ø§Ù„Ø²ÙŠØ§Ø±Ø© Ø§Ù„Ø£ÙˆÙ„Ù‰ Ø¨Ù†Ø³Ø¨Ø© 95%.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Automotive Mechanic',
    titleAr: 'Ù…ÙŠÙƒØ§Ù†ÙŠÙƒÙŠ Ø³ÙŠØ§Ø±Ø§Øª ÙˆØ¢Ù„Ø§Øª',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©',
    emoji: 'ðŸ› ï¸',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Diagnosed engine, transmission, brake and electrical faults using OBD-II computer diagnostic tools.',
        textAr: 'ØªØ´Ø®ÙŠØµ Ø£Ø¹Ø·Ø§Ù„ Ø§Ù„Ù…Ø­Ø±ÙƒØ§Øª ÙˆØ¹Ù„Ø¨ Ø§Ù„ØªØ±ÙˆØ³ ÙˆØ§Ù„Ù…ÙƒØ§Ø¨Ø­ Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø£Ø¬Ù‡Ø²Ø© Ø§Ù„ÙØ­Øµ Ø§Ù„ÙƒÙ…Ø¨ÙŠÙˆØªØ±ÙŠ OBD-II.',
      ),
      CvExperienceBullet(
        textEn: 'Performed complete vehicle overhauls, timing belt replacements and suspension tuning on diverse vehicle fleets.',
        textAr: 'Ø¥Ø¬Ø±Ø§Ø¡ Ø§Ù„Ø¹Ù…Ø±Ø§Øª Ø§Ù„ÙƒØ§Ù…Ù„Ø© Ù„Ù„Ù…Ø­Ø±ÙƒØ§Øª ÙˆØªØºÙŠÙŠØ± Ø³ÙŠÙˆØ± Ø§Ù„ØªÙˆÙ‚ÙŠØª ÙˆØªØ¹Ø¯ÙŠÙ„ Ø£Ù†Ø¸Ù…Ø© Ø§Ù„ØªØ¹Ù„ÙŠÙ‚ Ù„Ø£Ø³Ø·ÙˆÙ„ Ø§Ù„Ø³ÙŠØ§Ø±Ø§Øª.',
      ),
      CvExperienceBullet(
        textEn: 'Maintained daily service logs, estimated repair costs and communicated technical solutions clearly to clients.',
        textAr: 'Ø§Ù„Ø§Ø­ØªÙØ§Ø¸ Ø¨Ø³Ø¬Ù„Ø§Øª Ø§Ù„Ø®Ø¯Ù…Ø© Ø§Ù„ÙŠÙˆÙ…ÙŠØ© ÙˆØªÙ‚Ø¯ÙŠØ± ØªÙƒØ§Ù„ÙŠÙ Ø§Ù„Ø¥ØµÙ„Ø§Ø­ ÙˆØ´Ø±Ø­ Ø§Ù„Ø­Ù„ÙˆÙ„ Ø§Ù„ØªÙ‚Ù†ÙŠØ© Ù„Ù„Ø¹Ù…Ù„Ø§Ø¡.',
      ),
      CvExperienceBullet(
        textEn: 'Replaced worn brake pads, rotors, shocks, struts, and steering linkages.',
        textAr: 'Ø§Ø³ØªØ¨Ø¯Ø§Ù„ ÙØ­Ù…Ø§Øª Ø§Ù„Ù…ÙƒØ§Ø¨Ø­ ÙˆØ§Ù„Ø£Ù‚Ø±Ø§Øµ ÙˆØ§Ù„Ù…Ø³Ø§Ø¹Ø¯ÙŠÙ† ÙˆØ£Ù†Ø¸Ù…Ø© Ø§Ù„ØªÙˆØ¬ÙŠÙ‡ Ø§Ù„ØªØ§Ù„ÙØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Flushed and refilled transmission fluids, engine oils, coolants, and brake hydraulic lines.',
        textAr: 'ØªØºÙŠÙŠØ± ÙˆØºØ³ÙŠÙ„ Ø²ÙŠÙˆØª Ø§Ù„Ù…Ø­Ø±Ùƒ ÙˆØ³ÙˆØ§Ø¦Ù„ Ø§Ù„ØªØ¨Ø±ÙŠØ¯ ÙˆØ²ÙŠÙˆØª Ø§Ù„ÙØ±Ø§Ù…Ù„ ÙˆØ§Ù„Ù‡ÙŠØ¯Ø±ÙˆÙ„ÙŠÙƒ.',
      ),
      CvExperienceBullet(
        textEn: 'Balanced wheels, performed 4-wheel alignment, and mounted commercial tires.',
        textAr: 'Ø¶Ø¨Ø· Ø²ÙˆØ§ÙŠØ§ Ø§Ù„Ø¹Ø¬Ù„Ø§Øª Ø§Ù„Ø£Ø±Ø¨Ø¹ ÙˆØªØ±ØµÙŠØµ Ø§Ù„Ø¥Ø·Ø§Ø±Ø§Øª ÙˆØµÙŠØ§Ù†ØªÙ‡Ø§.',
      ),
      CvExperienceBullet(
        textEn: 'Enforced shop safety standards and proper disposal of hazardous automotive fluids and batteries.',
        textAr: 'ØªØ·Ø¨ÙŠÙ‚ Ù…Ø¹Ø§ÙŠÙŠØ± Ø§Ù„Ø³Ù„Ø§Ù…Ø© Ø¯Ø§Ø®Ù„ Ø§Ù„ÙˆØ±Ø´Ø© ÙˆØ§Ù„ØªØ®Ù„Øµ Ø§Ù„Ø¢Ù…Ù† Ù…Ù† Ø¨Ø·Ø§Ø±ÙŠØ§Øª ÙˆØ²ÙŠÙˆØª Ø§Ù„Ø³ÙŠØ§Ø±Ø§Øª.',
      ),
      CvExperienceBullet(
        textEn: 'Conducted pre-purchase and pre-inspection safety testing for passenger and commercial vehicles.',
        textAr: 'Ø¥Ø¬Ø±Ø§Ø¡ ÙØ­ÙˆØµØ§Øª Ø§Ù„Ø´Ø§Ù…Ù„Ø© ÙˆØ§Ù„Ø³Ù„Ø§Ù…Ø© Ø§Ù„ÙÙ†ÙŠØ© Ù„Ù„Ø³ÙŠØ§Ø±Ø§Øª Ù‚Ø¨Ù„ Ø§Ù„ÙØ­Øµ Ø§Ù„Ø¯ÙˆØ±ÙŠ.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Factory Operator & Technician',
    titleAr: 'Ù…Ø´ØºÙ„ ÙˆÙÙ†ÙŠ Ù…ØµÙ†Ø¹',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©',
    emoji: 'ðŸ› ï¸',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Operated and maintained automated production line machinery, ensuring continuous output at target efficiency rates.',
        textAr: 'ØªØ´ØºÙŠÙ„ ÙˆØµÙŠØ§Ù†Ø© Ø®Ø·ÙˆØ· Ø§Ù„Ø¥Ù†ØªØ§Ø¬ Ø§Ù„Ø¢Ù„ÙŠØ© ÙˆØ¶Ù…Ø§Ù† Ø§Ø³ØªÙ…Ø±Ø§Ø±ÙŠØ© Ø§Ù„ØªØ´ØºÙŠÙ„ Ø¨Ù…Ø¹Ø¯Ù„Ø§Øª Ø§Ù„ÙƒÙØ§Ø¡Ø© Ø§Ù„Ù…Ø³ØªÙ‡Ø¯ÙØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Conducted routine inspections and preventive maintenance on CNC machines, conveyors and hydraulic equipment.',
        textAr: 'Ø¥Ø¬Ø±Ø§Ø¡ Ø§Ù„ÙØ­ÙˆØµØ§Øª Ø§Ù„Ø¯ÙˆØ±ÙŠØ© ÙˆØ§Ù„ØµÙŠØ§Ù†Ø© Ø§Ù„ÙˆÙ‚Ø§Ø¦ÙŠØ© Ù„Ø¢Ù„Ø§Øª CNC ÙˆØ§Ù„Ø³ÙŠÙˆØ± Ø§Ù„Ù†Ø§Ù‚Ù„Ø© ÙˆØ§Ù„Ø£Ù†Ø¸Ù…Ø© Ø§Ù„Ù‡ÙŠØ¯Ø±ÙˆÙ„ÙŠÙƒÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Diagnosed mechanical and electrical faults, reducing average repair downtime from 4 hours to under 90 minutes.',
        textAr: 'ØªØ´Ø®ÙŠØµ Ø§Ù„Ø£Ø¹Ø·Ø§Ù„ Ø§Ù„Ù…ÙŠÙƒØ§Ù†ÙŠÙƒÙŠØ© ÙˆØ§Ù„ÙƒÙ‡Ø±Ø¨Ø§Ø¦ÙŠØ© ÙˆØªÙ‚Ù„ÙŠÙ„ Ø²Ù…Ù† Ø§Ù„ØªÙˆÙ‚Ù Ù…Ù† 4 Ø³Ø§Ø¹Ø§Øª Ø¥Ù„Ù‰ Ø£Ù‚Ù„ Ù…Ù† 90 Ø¯Ù‚ÙŠÙ‚Ø©.',
      ),
      CvExperienceBullet(
        textEn: 'Adhered to ISO quality control procedures and logged all maintenance activities in the CMMS system.',
        textAr: 'Ø§Ù„Ø§Ù„ØªØ²Ø§Ù… Ø¨Ù…Ø¹Ø§ÙŠÙŠØ± Ø¬ÙˆØ¯Ø© ISO ÙˆØªØ³Ø¬ÙŠÙ„ Ø¬Ù…ÙŠØ¹ Ø£Ù†Ø´Ø·Ø© Ø§Ù„ØµÙŠØ§Ù†Ø© ÙÙŠ Ù†Ø¸Ø§Ù… CMMS.',
      ),
      CvExperienceBullet(
        textEn: 'Adjusted machine calibration parameters and tooling setups according to production batch specifications.',
        textAr: 'Ø¶Ø¨Ø· Ø¥Ø¹Ø¯Ø§Ø¯Ø§Øª ÙƒØ§Ù„ÙŠØ¨Ø±Ø§ØªÙˆØ± Ø§Ù„Ø¢Ù„Ø§Øª ÙˆØ§Ù„Ù‚ÙˆØ§Ù„Ø¨ ÙˆÙÙ‚Ø§Ù‹ Ù„Ù…ÙˆØ§ØµÙØ§Øª Ø¯ÙØ¹Ø© Ø§Ù„Ø¥Ù†ØªØ§Ø¬.',
      ),
      CvExperienceBullet(
        textEn: 'Monitored raw material feed lines to prevent blockages and line starvation.',
        textAr: 'Ù…Ø±Ø§Ù‚Ø¨Ø© Ø®Ø·ÙˆØ· ØªØºØ°ÙŠØ© Ø§Ù„Ù…ÙˆØ§Ø¯ Ø§Ù„Ø®Ø§Ù… Ù„Ù…Ù†Ø¹ Ø§Ù„Ø§Ù†Ø­Ø´Ø§Ø± Ø£Ùˆ ØªÙˆÙ‚Ù Ø§Ù„ØªØ¯ÙÙ‚.',
      ),
      CvExperienceBullet(
        textEn: 'Enforced strict 5S shop-floor organization and machine safety guards compliance.',
        textAr: 'ØªØ·Ø¨ÙŠÙ‚ Ù…Ù†Ù‡Ø¬ÙŠØ© 5S Ù„ØªØ±ØªÙŠØ¨ Ø¨ÙŠØ¦Ø© Ø§Ù„Ø¹Ù…Ù„ ÙˆØ§Ù„Ø§Ù„ØªØ²Ø§Ù… Ø¨Ø­ÙˆØ§Ø¬Ø² Ø§Ù„Ø­Ù…Ø§ÙŠØ© Ø§Ù„ØªÙ„Ù‚Ø§Ø¦ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Trained junior machine operators on emergency shut-off protocols and shift handovers.',
        textAr: 'ØªØ¯Ø±ÙŠØ¨ Ø§Ù„Ù…Ø´ØºÙ„ÙŠÙ† Ø§Ù„Ø¬Ø¯Ø¯ Ø¹Ù„Ù‰ Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø§Ù„Ø¥ÙŠÙ‚Ø§Ù Ø§Ù„Ø·Ø§Ø±Ø¦ ÙˆØªØ³Ù„ÙŠÙ… Ø§Ù„ÙˆØ±Ø¯ÙŠØ§Øª.',
      ),
    ],
  ),

  // 2. ðŸ’» Tech & Engineering
  CvProfession(
    titleEn: 'Software Engineer',
    titleAr: 'Ù…Ù‡Ù†Ø¯Ø³ Ø¨Ø±Ù…Ø¬ÙŠØ§Øª',
    categoryEn: 'Tech, Engineering & Business',
    categoryAr: 'Ø§Ù„ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ§ ÙˆØ§Ù„Ù‡Ù†Ø¯Ø³Ø© ÙˆØ§Ù„Ø£Ø¹Ù…Ø§Ù„',
    emoji: 'ðŸ’»',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Architected and deployed scalable RESTful microservices and backend web applications using modern cloud frameworks.',
        textAr: 'ØªØµÙ…ÙŠÙ… ÙˆØªØ·ÙˆÙŠØ± Ø§Ù„Ø®Ø¯Ù…Ø§Øª Ø§Ù„Ù…ØµØºØ±Ø© ÙˆØ§Ù„ØªØ·Ø¨ÙŠÙ‚Ø§Øª Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠØ© Ø§Ù„Ù‚Ø§Ø¨Ù„Ø© Ù„Ù„ØªÙˆØ³Ø¹.',
      ),
      CvExperienceBullet(
        textEn: 'Wrote clean, testable codebase backed by CI/CD pipelines, unit testing and automated integration tests.',
        textAr: 'ÙƒØªØ§Ø¨Ø© ÙƒÙˆØ¯ Ø¨Ø±Ù…Ø¬ÙŠ Ù†Ø¸ÙŠÙ Ù…Ø¯Ø¹ÙˆÙ… Ø¨Ø§Ø®ØªØ¨Ø§Ø±Ø§Øª Ø§Ù„ÙˆØ­Ø¯Ø© ÙˆØ§Ù„ØªÙƒØ§Ù…Ù„ ÙˆØ£Ù†Ø§Ø¨ÙŠØ¨ Ø§Ù„ØªØ¬Ù…ÙŠØ¹ Ø§Ù„Ø¢Ù„ÙŠ CI/CD.',
      ),
      CvExperienceBullet(
        textEn: 'Collaborated in Agile/Scrum sprint teams to ship enterprise features on time with zero high-severity production bugs.',
        textAr: 'Ø§Ù„Ø¹Ù…Ù„ Ø¶Ù…Ù† ÙØ±Ù‚ Agile/Scrum Ù„ØªØ³Ù„ÙŠÙ… Ø§Ù„Ù…ÙŠØ²Ø§Øª Ø§Ù„Ø¨Ø±Ù…Ø¬ÙŠØ© ÙÙŠ Ù…ÙˆØ§Ø¹ÙŠØ¯Ù‡Ø§ Ø¨Ø¯ÙˆÙ† Ø£Ø®Ø·Ø§Ø¡.',
      ),
      CvExperienceBullet(
        textEn: 'Optimized database queries and API response latencies by 35% across high-traffic platforms.',
        textAr: 'ØªØ­Ø³ÙŠÙ† Ø§Ø³ØªØ¹Ù„Ø§Ù…Ø§Øª Ù‚ÙˆØ§Ø¹Ø¯ Ø§Ù„Ø¨ÙŠØ§Ù†Ø§Øª ÙˆØ§Ø³ØªØ¬Ø§Ø¨Ø© Ø§Ù„Ù€ API Ø¨Ù†Ø³Ø¨Ø© 35% Ø¹Ù„Ù‰ Ø§Ù„Ù…Ù†ØµØ§Øª Ø¹Ø§Ù„ÙŠØ© Ø§Ù„Ø²ÙŠØ§Ø±Ø§Øª.',
      ),
      CvExperienceBullet(
        textEn: 'Integrated OAuth2, JWT, and third-party RESTful APIs with strict security protocols.',
        textAr: 'Ø¯Ù…Ø¬ Ø¨Ø±ÙˆØªÙˆÙƒÙˆÙ„Ø§Øª Ø§Ù„Ø£Ù…Ø§Ù† OAuth2 Ùˆ JWT ÙˆØ§Ù„ÙˆØ§Ø¬Ù‡Ø§Øª Ø§Ù„Ø¨Ø±Ù…Ø¬ÙŠØ© Ø§Ù„Ø®Ø§Ø±Ø¬ÙŠØ© Ø¨Ø£Ø¹Ù„Ù‰ Ù…Ø¹Ø§ÙŠÙŠØ± Ø§Ù„Ø­Ù…Ø§ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Monitored system health using Prometheus, Grafana, and cloud logging dashboards.',
        textAr: 'Ù…Ø±Ø§Ù‚Ø¨Ø© Ø£Ø¯Ø§Ø¡ Ø§Ù„Ø®ÙˆØ§Ø¯Ù… ÙˆØ§Ø³ØªÙ‚Ø±Ø§Ø± Ø§Ù„Ù†Ø¸Ø§Ù… Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø£Ø¯ÙˆØ§Øª Ø§Ù„Ù…Ø±Ø§Ù‚Ø¨Ø© ÙˆØ§Ù„Ø³Ø¬Ù„Ø§Øª Ø§Ù„Ø³Ø­Ø§Ø¨ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Conducted peer code reviews to enforce software architecture patterns and coding guidelines.',
        textAr: 'Ù…Ø±Ø§Ø¬Ø¹Ø© Ø§Ù„ÙƒÙˆØ¯ Ø§Ù„Ø¨Ø±Ù…Ø¬ÙŠ Ù„Ù„Ø£Ù‚Ø±Ø§Ù† Ù„Ø¶Ù…Ø§Ù† Ø§Ù„Ø§Ù„ØªØ²Ø§Ù… Ø¨Ø£Ù†Ù…Ø§Ø· Ø§Ù„Ù…Ø¹Ù…Ø§Ø±ÙŠØ© ÙˆØ§Ù„Ù…Ø¹Ø§ÙŠÙŠØ± Ø§Ù„Ù‚ÙŠØ§Ø³ÙŠØ©.',
      ),
      CvExperienceBullet(
        textEn: 'Refactored legacy monolithic services into modular maintainable components.',
        textAr: 'Ø¥Ø¹Ø§Ø¯Ø© Ù‡ÙŠÙƒÙ„Ø© Ø§Ù„Ø¨Ø±Ø§Ù…Ø¬ Ø§Ù„Ù‚Ø¯ÙŠÙ…Ø© Ø¥Ù„Ù‰ Ù…ÙƒÙˆÙ†Ø§Øª Ø¨Ø±Ù…Ø¬ÙŠØ© Ø­Ø¯ÙŠØ«Ø© ÙˆØ³Ù‡ÙˆÙ„Ø© Ø§Ù„ØµÙŠØ§Ù†Ø©.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Flutter & Mobile Developer',
    titleAr: 'Ù…Ø·ÙˆØ± ØªØ·Ø¨ÙŠÙ‚Ø§Øª ÙÙ„Ø§ØªØ± ÙˆØ¬ÙˆØ§Ù„',
    categoryEn: 'Tech, Engineering & Business',
    categoryAr: 'Ø§Ù„ØªÙƒÙ†ÙˆÙ„ÙˆØ¬ÙŠØ§ ÙˆØ§Ù„Ù‡Ù†Ø¯Ø³Ø© ÙˆØ§Ù„Ø£Ø¹Ù…Ø§Ù„',
    emoji: 'ðŸ’»',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Built cross-platform iOS & Android mobile applications using Flutter & Dart with clean architecture and Provider/Bloc.',
        textAr: 'ØªØ·ÙˆÙŠØ± ØªØ·Ø¨ÙŠÙ‚Ø§Øª Ø¬ÙˆØ§Ù„ ØªØ¹Ù…Ù„ Ø¹Ù„Ù‰ iOS Ùˆ Android Ø¨Ø§Ø³ØªØ®Ø¯Ø§Ù… Flutter Ùˆ Dart ÙˆØ¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø­Ø§Ù„Ø©.',
      ),
      CvExperienceBullet(
        textEn: 'Integrated Firebase Auth, Cloud Firestore, REST APIs and OAuth providers for seamless user authentication.',
        textAr: 'Ø¯Ù…Ø¬ Ø®Ø¯Ù…Ø§Øª Ø§Ù„Ù…ØµØ§Ø¯Ù‚Ø© Ù…Ù† Firebase Ùˆ Firestore ÙˆØ§Ù„ÙˆØ§Ø¬Ù‡Ø§Øª Ø§Ù„Ø¨Ø±Ù…Ø¬ÙŠØ© Ù„Ø±Ø¨Ø· Ø§Ù„Ù…Ø³ØªØ®Ø¯Ù…ÙŠÙ†.',
      ),
      CvExperienceBullet(
        textEn: 'Implemented responsive pixel-perfect UI layouts and custom smooth micro-animations.',
        textAr: 'Ø¨Ù†Ø§Ø¡ ÙˆØ§Ø¬Ù‡Ø§Øª Ù…Ø³ØªØ®Ø¯Ù… Ù…ØªØ¬Ø§ÙˆØ¨Ø© Ø¹Ø§Ù„ÙŠØ© Ø§Ù„Ø¯Ù‚Ø© Ù…Ø¹ Ø­Ø±ÙƒØ§Øª ÙˆØªØ£Ø«ÙŠØ±Ø§Øª ØªÙØ§Ø¹Ù„ÙŠØ© Ø³Ù„Ø³Ø©.',
      ),
      CvExperienceBullet(
        textEn: 'Published and maintained applications on Apple App Store & Google Play Store.',
        textAr: 'Ø±ÙØ¹ ÙˆÙ†Ø´Ø± ÙˆØµÙŠØ§Ù†Ø© Ø§Ù„ØªØ·Ø¨ÙŠÙ‚Ø§Øª Ø¹Ù„Ù‰ Ù…ØªØ¬Ø±ÙŠ App Store Ùˆ Google Play.',
      ),
      CvExperienceBullet(
        textEn: 'Implemented offline data caching using Hive, SQLite, and Shared Preferences.',
        textAr: 'ØªÙØ¹ÙŠÙ„ Ø§Ù„ØªØ®Ø²ÙŠÙ† Ø§Ù„Ù…Ø­Ù„ÙŠ Ø§Ù„Ù…Ø¤Ù‚Øª Ù„Ù„Ø¨ÙŠØ§Ù†Ø§Øª Ù„Ø¶Ù…Ø§Ù† Ø¹Ù…Ù„ Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ Ø¨Ø¯ÙˆÙ† Ø§ØªØµØ§Ù„ Ø¨Ø§Ù„Ø¥Ù†ØªØ±Ù†Øª.',
      ),
      CvExperienceBullet(
        textEn: 'Integrated push notifications, deep linking, and in-app analytics tracking.',
        textAr: 'Ø¯Ù…Ø¬ Ø§Ù„ØªÙ†Ø¨ÙŠÙ‡Ø§Øª Ø§Ù„ÙÙˆØ±ÙŠØ© ÙˆØ§Ù„Ø±ÙˆØ§Ø¨Ø· Ø§Ù„Ø¹Ù…ÙŠÙ‚Ø© ÙˆØ£Ø¯ÙˆØ§Øª ØªØ­Ù„ÙŠÙ„Ø§Øª Ø§Ø³ØªØ®Ø¯Ø§Ù… Ø§Ù„ØªØ·Ø¨ÙŠÙ‚.',
      ),
      CvExperienceBullet(
        textEn: 'Reduced mobile app bundle size by 30% through asset optimization and tree-shaking.',
        textAr: 'ØªÙ‚Ù„ÙŠÙ„ Ø­Ø¬Ù… Ù…Ù„Ù Ø§Ù„ØªØ·Ø¨ÙŠÙ‚ Ø¨Ù†Ø³Ø¨Ø© 30% Ø¹Ø¨Ø± ØªØ­Ø³ÙŠÙ† Ø§Ù„ÙˆØ³Ø§Ø¦Ø· ÙˆØ¶ØºØ· Ø§Ù„Ø¹Ù†Ø§ØµØ±.',
      ),
      CvExperienceBullet(
        textEn: 'Handled app localization (RTL & LTR) for multi-language global deployment.',
        textAr: 'Ø¯Ø¹Ù… Ø§Ù„ØªÙˆØ·ÙŠÙ† ÙˆØ§Ù„Ù„ØºØ§Øª Ù…ØªØ¹Ø¯Ø¯Ø© Ø§Ù„Ø§ØªØ¬Ø§Ù‡Ø§Øª (RTL/LTR) Ù„Ù„Ù†Ø´Ø± Ø§Ù„Ø¹Ø§Ù„Ù…ÙŠ.',
      ),
    ],
  ),
  
  // 3. ðŸ—ï¸ Construction & Logistics
  CvProfession(
    titleEn: 'Construction Worker',
    titleAr: 'Ø¹Ø§Ù…Ù„ Ø¨Ù†Ø§Ø¡',
    categoryEn: 'Construction & Logistics',
    categoryAr: 'Ø§Ù„Ø¨Ù†Ø§Ø¡ ÙˆØ§Ù„Ù„ÙˆØ¬Ø³ØªÙŠØ§Øª',
    emoji: 'ðŸ—ï¸',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Assisted in the erection of scaffolding and operation of heavy construction equipment.',
        textAr: 'Ø§Ù„Ù…Ø³Ø§Ø¹Ø¯Ø© ÙÙŠ Ù†ØµØ¨ Ø§Ù„Ø³Ù‚Ø§Ù„Ø§Øª ÙˆØªØ´ØºÙŠÙ„ Ù…Ø¹Ø¯Ø§Øª Ø§Ù„Ø¨Ù†Ø§Ø¡ Ø§Ù„Ø«Ù‚ÙŠÙ„Ø©.',
      ),
    ],
  ),
  
  // 4. ðŸ¨ Hospitality, Services & Agriculture
  CvProfession(
    titleEn: 'Customer Service Representative',
    titleAr: 'Ù…Ù…Ø«Ù„ Ø®Ø¯Ù…Ø© Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡',
    categoryEn: 'Hospitality, Services & Agriculture',
    categoryAr: 'Ø§Ù„Ø¶ÙŠØ§ÙØ© ÙˆØ§Ù„Ø®Ø¯Ù…Ø§Øª ÙˆØ§Ù„Ø²Ø±Ø§Ø¹Ø©',
    emoji: 'ðŸ¨',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Resolved customer inquiries and maintained high satisfaction ratings.',
        textAr: 'Ø­Ù„ Ø§Ø³ØªÙØ³Ø§Ø±Ø§Øª Ø§Ù„Ø¹Ù…Ù„Ø§Ø¡ ÙˆØ§Ù„Ø­ÙØ§Ø¸ Ø¹Ù„Ù‰ Ù…Ø¹Ø¯Ù„Ø§Øª Ø±Ø¶Ø§ Ø¹Ø§Ù„ÙŠØ©.',
      ),
    ],
  ),
  
  // 5. ðŸ¥ Healthcare & Science
  CvProfession(
    titleEn: 'Registered Nurse',
    titleAr: 'Ù…Ù…Ø±Ø¶ Ù…Ø³Ø¬Ù„',
    categoryEn: 'Healthcare & Science',
    categoryAr: 'Ø§Ù„Ø±Ø¹Ø§ÙŠØ© Ø§Ù„ØµØ­ÙŠØ© ÙˆØ§Ù„Ø¹Ù„ÙˆÙ…',
    emoji: 'ðŸ¥',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Provided exceptional patient care and assisted in clinical procedures.',
        textAr: 'ØªÙ‚Ø¯ÙŠÙ… Ø±Ø¹Ø§ÙŠØ© Ù…ØªÙ…ÙŠØ²Ø© Ù„Ù„Ù…Ø±Ø¶Ù‰ ÙˆØ§Ù„Ù…Ø³Ø§Ø¹Ø¯Ø© ÙÙŠ Ø§Ù„Ø¥Ø¬Ø±Ø§Ø¡Ø§Øª Ø§Ù„Ø³Ø±ÙŠØ±ÙŠØ©.',
      ),
    ],
  ),
  
  // 6. ðŸ“Š Business, Sales & Admin
  CvProfession(
    titleEn: 'Sales Manager',
    titleAr: 'Ù…Ø¯ÙŠØ± Ù…Ø¨ÙŠØ¹Ø§Øª',
    categoryEn: 'Business, Sales & Admin',
    categoryAr: 'Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø£Ø¹Ù…Ø§Ù„ ÙˆØ§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª',
    emoji: 'ðŸ“Š',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Developed sales strategies and led a high-performing sales team.',
        textAr: 'ØªØ·ÙˆÙŠØ± Ø§Ø³ØªØ±Ø§ØªÙŠØ¬ÙŠØ§Øª Ø§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª ÙˆÙ‚ÙŠØ§Ø¯Ø© ÙØ±ÙŠÙ‚ Ù…Ø¨ÙŠØ¹Ø§Øª Ø¹Ø§Ù„ÙŠ Ø§Ù„Ø£Ø¯Ø§Ø¡.',
      ),
  ),
  CvProfessionCategory(
    titleEn: 'Engineering & Architecture',
    titleAr: 'الهندسة والعمارة',
    emoji: '🏗️',
    professions: [
      CvProfession(titleEn: 'Civil Engineer', titleAr: 'مهندس مدني', categoryEn: 'Engineering', categoryAr: 'الهندسة', emoji: '🏗️', suggestedBullets: ['Managed construction projects from conception to completion.', 'Ensured compliance with safety and building regulations.']),
      CvProfession(titleEn: 'Mechanical Engineer', titleAr: 'مهندس ميكانيكي', categoryEn: 'Engineering', categoryAr: 'الهندسة', emoji: '⚙️', suggestedBullets: ['Designed and optimized mechanical systems.', 'Conducted thermal and stress analysis on components.']),
      CvProfession(titleEn: 'Electrical Engineer', titleAr: 'مهندس كهربائي', categoryEn: 'Engineering', categoryAr: 'الهندسة', emoji: '⚡', suggestedBullets: ['Developed electrical schematics and wiring plans.', 'Tested and troubleshoot complex circuitry.']),
      CvProfession(titleEn: 'Architect', titleAr: 'مهندس معماري', categoryEn: 'Engineering', categoryAr: 'الهندسة', emoji: '🏢', suggestedBullets: ['Designed aesthetically pleasing and functional structures.', 'Drafted blueprints using CAD software.']),
    ],
  ),
  CvProfessionCategory(
    titleEn: 'Logistics & Transportation',
    titleAr: 'اللوجستيات والنقل',
    emoji: '🚚',
    professions: [
      CvProfession(titleEn: 'Supply Chain Manager', titleAr: 'مدير سلسلة الإمداد', categoryEn: 'Logistics', categoryAr: 'اللوجستيات', emoji: '📦', suggestedBullets: ['Optimized supply chain operations reducing costs.', 'Negotiated contracts with vendors and suppliers.']),
      CvProfession(titleEn: 'Delivery Driver', titleAr: 'سائق توصيل', categoryEn: 'Logistics', categoryAr: 'اللوجستيات', emoji: '🚚', suggestedBullets: ['Ensured timely delivery of goods and packages.', 'Maintained vehicle logs and maintenance schedules.']),
      CvProfession(titleEn: 'Logistics Coordinator', titleAr: 'منسق لوجستيات', categoryEn: 'Logistics', categoryAr: 'اللوجستيات', emoji: '📋', suggestedBullets: ['Coordinated dispatch and tracked incoming shipments.']),
    ],
  ),
  CvProfessionCategory(
    titleEn: 'Admin & Office Support',
    titleAr: 'الإدارة والدعم المكتبي',
    emoji: '📁',
    professions: [
      CvProfession(titleEn: 'Administrative Assistant', titleAr: 'مساعد إداري', categoryEn: 'Admin', categoryAr: 'إدارة', emoji: '📁', suggestedBullets: ['Handled scheduling, filing, and office communication.', 'Organized meetings and maintained executives calendars.']),
      CvProfession(titleEn: 'Data Entry Clerk', titleAr: 'مدخل بيانات', categoryEn: 'Admin', categoryAr: 'إدارة', emoji: '⌨️', suggestedBullets: ['Accurately maintained large sets of company records.', 'Performed regular database cleanups and audits.']),
      CvProfession(titleEn: 'HR Manager', titleAr: 'مدير موارد بشرية', categoryEn: 'Admin', categoryAr: 'إدارة', emoji: '👥', suggestedBullets: ['Managed recruitment, onboarding, and employee relations.', 'Implemented company-wide HR policies.']),
    ],
  ),
];

// â”€â”€ Categorized list generator â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
final List<CvProfessionCategory> kProfessionCategories = [
  CvProfessionCategory(
    id: 'trades',
    titleEn: 'Vocational & Technical Trades',
    titleAr: 'ðŸ› ï¸ Ø§Ù„Ø­Ø±Ù Ø§Ù„ÙÙ†ÙŠØ© ÙˆØ§Ù„ØªÙ‚Ù†ÙŠØ©',
    emoji: 'ðŸ› ï¸',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('Ø§Ù„Ø­Ø±Ù') || p.categoryEn.contains('Trades'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'construction',
    titleEn: 'Construction & Logistics',
    titleAr: 'ðŸ—ï¸ Ø§Ù„Ø¨Ù†Ø§Ø¡ ÙˆØ§Ù„Ù„ÙˆØ¬Ø³ØªÙŠØ§Øª',
    emoji: 'ðŸ—ï¸',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('Ø§Ù„Ø¨Ù†Ø§Ø¡') ||
            p.categoryEn.contains('Construction'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'hospitality',
    titleEn: 'Hospitality, Services & Agriculture',
    titleAr: 'ðŸ¨ Ø§Ù„Ø¶ÙŠØ§ÙØ© ÙˆØ§Ù„Ø®Ø¯Ù…Ø§Øª ÙˆØ§Ù„Ø²Ø±Ø§Ø¹Ø©',
    emoji: 'ðŸ¨',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('Ø§Ù„Ø¶ÙŠØ§ÙØ©') ||
            p.categoryEn.contains('Hospitality'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'tech',
    titleEn: 'Tech, Engineering & Business',
    titleAr: 'ðŸ’» Ø§Ù„ØªÙ‚Ù†ÙŠØ© ÙˆØ§Ù„Ù‡Ù†Ø¯Ø³Ø© ÙˆØ§Ù„Ø£Ø¹Ù…Ø§Ù„',
    emoji: 'ðŸ’»',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('Ø§Ù„ØªÙ‚Ù†ÙŠØ©') ||
            p.categoryEn.contains('Tech'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'healthcare',
    titleEn: 'Healthcare & Science',
    titleAr: 'ðŸ¥ Ø§Ù„Ø±Ø¹Ø§ÙŠØ© Ø§Ù„ØµØ­ÙŠØ© ÙˆØ§Ù„Ø¹Ù„ÙˆÙ…',
    emoji: 'ðŸ¥',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('Ø§Ù„Ø±Ø¹Ø§ÙŠØ©') ||
            p.categoryEn.contains('Healthcare'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'business',
    titleEn: 'Business, Sales & Admin',
    titleAr: 'ðŸ“Š Ø¥Ø¯Ø§Ø±Ø© Ø§Ù„Ø£Ø¹Ù…Ø§Ù„ ÙˆØ§Ù„Ù…Ø¨ÙŠØ¹Ø§Øª',
    emoji: 'ðŸ“Š',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('Ø¥Ø¯Ø§Ø±Ø©') ||
            p.categoryEn.contains('Business'))
        .toList(),
  ),
];

const List<String> kCountries = [
  'Afghanistan / أفغانستان', 'Albania / ألبانيا', 'Algeria / الجزائر', 'Andorra / أندورا', 'Angola / أنغولا', 
  'Argentina / الأرجنتين', 'Armenia / أرمينيا', 'Australia / أستراليا', 'Austria / النمسا', 'Azerbaijan / أذربيجان',
  'Bahrain / البحرين', 'Bangladesh / بنغلاديش', 'Belarus / بيلاروس', 'Belgium / بلجيكا', 'Bolivia / بوليفيا',
  'Brazil / البرازيل', 'Bulgaria / بلغاريا', 'Cameroon / الكاميرون', 'Canada / كندا', 'Chile / تشيلي',
  'China / الصين', 'Colombia / كولومبيا', 'Costa Rica / كوستاريكا', 'Croatia / كرواتيا', 'Cuba / كوبا',
  'Cyprus / قبرص', 'Czech Republic / التشيك', 'Denmark / الدنمارك', 'Egypt / مصر', 'Estonia / إستونيا',
  'Ethiopia / إثيوبيا', 'Finland / فنلندا', 'France / فرنسا', 'Georgia / جورجيا', 'Germany / ألمانيا',
  'Ghana / غانا', 'Greece / اليونان', 'Hungary / المجر', 'Iceland / آيسلندا', 'India / الهند',
  'Indonesia / إندونيسيا', 'Iran / إيران', 'Iraq / العراق', 'Ireland / أيرلندا', 'Israel / إسرائيل',
  'Italy / إيطاليا', 'Japan / اليابان', 'Jordan / الأردن', 'Kazakhstan / كازاخستان', 'Kenya / كينيا',
  'Kuwait / الكويت', 'Latvia / لاتفيا', 'Lebanon / لبنان', 'Libya / ليبيا', 'Lithuania / ليتوانيا',
  'Luxembourg / لوكسمبورغ', 'Malaysia / ماليزيا', 'Malta / مالطا', 'Mexico / المكسيك', 'Morocco / المغرب',
  'Netherlands / هولندا', 'New Zealand / نيوزيلندا', 'Nigeria / نيجيريا', 'Norway / النرويج', 'Oman / عمان',
  'Pakistan / باكستان', 'Palestine / فلسطين', 'Peru / بيرو', 'Philippines / الفلبين', 'Poland / بولندا',
  'Portugal / البرتغال', 'Qatar / قطر', 'Romania / رومانيا', 'Russia / روسيا', 'Saudi Arabia / السعودية',
  'Senegal / السنغال', 'Serbia / صربيا', 'Singapore / سنغافورة', 'Slovakia / سلوفاكيا', 'Slovenia / سلوفينيا',
  'South Africa / جنوب أفريقيا', 'South Korea / كوريا الجنوبية', 'Spain / إسبانيا', 'Sudan / السودان',
  'Sweden / السويد', 'Switzerland / سويسرا', 'Syria / سوريا', 'Taiwan / تايوان', 'Thailand / تايلاند',
  'Tunisia / تونس', 'Turkey / تركيا', 'Uganda / أوغندا', 'Ukraine / أوكرانيا', 'United Arab Emirates / الإمارات',
  'United Kingdom / المملكة المتحدة', 'United States / الولايات المتحدة', 'Uruguay / أوروغواي',
  'Uzbekistan / أوزبكستان', 'Venezuela / فنزويلا', 'Vietnam / فيتنام', 'Yemen / اليمن', 'Zambia / زامبيا'
];

const Map<String, List<String>> kCountryCityMap = {
  'Ø§Ù„Ø³Ø¹ÙˆØ¯ÙŠØ©': ['Ø§Ù„Ø±ÙŠØ§Ø¶', 'Ø¬Ø¯Ø©', 'Ø§Ù„Ø¯Ù…Ø§Ù…', 'Ù…ÙƒØ©', 'Ø§Ù„Ù…Ø¯ÙŠÙ†Ø© Ø§Ù„Ù…Ù†ÙˆØ±Ø©'],
  'Ø§Ù„Ø¥Ù…Ø§Ø±Ø§Øª': ['Ø¯Ø¨ÙŠ', 'Ø£Ø¨Ùˆ Ø¸Ø¨ÙŠ', 'Ø§Ù„Ø´Ø§Ø±Ù‚Ø©', 'Ø§Ù„Ø¹ÙŠÙ†'],
  'Ù…ØµØ±': ['Ø§Ù„Ù‚Ø§Ù‡Ø±Ø©', 'Ø§Ù„Ø¥Ø³ÙƒÙ†Ø¯Ø±ÙŠØ©', 'Ø§Ù„Ø¬ÙŠØ²Ø©', 'Ø´Ø±Ù… Ø§Ù„Ø´ÙŠØ®'],
  'Ø§Ù„ÙƒÙˆÙŠØª': ['Ù…Ø¯ÙŠÙ†Ø© Ø§Ù„ÙƒÙˆÙŠØª', 'Ø§Ù„Ø£Ø­Ù…Ø¯ÙŠ', 'Ø­ÙˆÙ„ÙŠ', 'Ø§Ù„Ø³Ø§Ù„Ù…ÙŠØ©'],
  'Ù‚Ø·Ø±': ['Ø§Ù„Ø¯ÙˆØ­Ø©', 'Ø§Ù„Ø±ÙŠØ§Ù†', 'Ø§Ù„ÙˆÙƒØ±Ø©'],
  'Ø§Ù„Ø¨Ø­Ø±ÙŠÙ†': ['Ø§Ù„Ù…Ù†Ø§Ù…Ø©', 'Ø§Ù„Ù…Ø­Ø±Ù‚', 'Ø§Ù„Ø±ÙØ§Ø¹'],
  'Ø¹Ù…Ø§Ù†': ['Ù…Ø³Ù‚Ø·', 'ØµÙ„Ø§Ù„Ø©', 'ØµØ­Ø§Ø±'],
  'Ø§Ù„Ø£Ø±Ø¯Ù†': ['Ø¹Ù…Ø§Ù†', 'Ø¥Ø±Ø¨Ø¯', 'Ø§Ù„Ø²Ø±Ù‚Ø§Ø¡', 'Ø§Ù„Ø¹Ù‚Ø¨Ø©'],
  'Ù„Ø¨Ù†Ø§Ù†': ['Ø¨ÙŠØ±ÙˆØª', 'Ø·Ø±Ø§Ø¨Ù„Ø³', 'ØµÙŠØ¯Ø§'],
  'Ø§Ù„Ø¬Ø²Ø§Ø¦Ø±': ['Ø§Ù„Ø¬Ø²Ø§Ø¦Ø± Ø§Ù„Ø¹Ø§ØµÙ…Ø©', 'ÙˆÙ‡Ø±Ø§Ù†', 'Ù‚Ø³Ù†Ø·ÙŠÙ†Ø©'],
  'Ø§Ù„Ù…ØºØ±Ø¨': ['Ø§Ù„Ø¯Ø§Ø± Ø§Ù„Ø¨ÙŠØ¶Ø§Ø¡', 'Ø§Ù„Ø±Ø¨Ø§Ø·', 'Ù…Ø±Ø§ÙƒØ´', 'Ø·Ù†Ø¬Ø©'],
  'ØªÙˆÙ†Ø³': ['ØªÙˆÙ†Ø³ Ø§Ù„Ø¹Ø§ØµÙ…Ø©', 'ØµÙØ§Ù‚Ø³', 'Ø³ÙˆØ³Ø©'],
  'Ø£Ù„Ù…Ø§Ù†ÙŠØ§': ['Ø¨Ø±Ù„ÙŠÙ†', 'Ù…ÙŠÙˆÙ†Ø®', 'ÙØ±Ø§Ù†ÙƒÙÙˆØ±Øª', 'Ù‡Ø§Ù…Ø¨ÙˆØ±Øº', 'ÙƒÙˆÙ„ÙˆÙ†ÙŠØ§'],
  'ÙØ±Ù†Ø³Ø§': ['Ø¨Ø§Ø±ÙŠØ³', 'Ù„ÙŠÙˆÙ†', 'Ù…Ø§Ø±Ø³ÙŠÙ„ÙŠØ§', 'ØªÙˆÙ„ÙˆØ²'],
  'Ø¥ÙŠØ·Ø§Ù„ÙŠØ§': ['Ø±ÙˆÙ…Ø§', 'Ù…ÙŠÙ„Ø§Ù†Ùˆ', 'Ù†Ø§Ø¨ÙˆÙ„ÙŠ', 'ØªÙˆØ±ÙŠÙ†Ùˆ'],
  'Ø¥Ø³Ø¨Ø§Ù†ÙŠØ§': ['Ù…Ø¯Ø±ÙŠØ¯', 'Ø¨Ø±Ø´Ù„ÙˆÙ†Ø©', 'ÙØ§Ù„Ù†Ø³ÙŠØ§', 'Ø¥Ø´Ø¨ÙŠÙ„ÙŠØ©'],
  'Ù‡ÙˆÙ„Ù†Ø¯Ø§': ['Ø£Ù…Ø³ØªØ±Ø¯Ø§Ù…', 'Ø±ÙˆØªØ±Ø¯Ø§Ù…', 'Ù„Ø§Ù‡Ø§ÙŠ', 'Ø£ÙˆØªØ±ÙŠØ®Øª'],
  'Ø§Ù„Ù†Ù…Ø³Ø§': ['ÙÙŠÙŠÙ†Ø§', 'Ø³Ø§Ù„Ø²Ø¨ÙˆØ±Øº', 'ØºØ±Ø§ØªØ³'],
  'Ø¨Ù„Ø¬ÙŠÙƒØ§': ['Ø¨Ø±ÙˆÙƒØ³Ù„', 'Ø£Ù†ØªÙˆÙŠØ±Ø¨', 'ØºÙ†Øª'],
  'Ø§Ù„ÙŠÙˆÙ†Ø§Ù†': ['Ø£Ø«ÙŠÙ†Ø§', 'Ø³Ø§Ù„ÙˆÙ†ÙŠÙƒ', 'Ø¨Ø§ØªØ±Ø§Ø³'],
  'Ø§Ù„Ø³ÙˆÙŠØ¯': ['Ø³ØªÙˆÙƒÙ‡ÙˆÙ„Ù…', 'ØºÙˆØªÙ†Ø¨Ø±Øº', 'Ù…Ø§Ù„Ù…Ùˆ'],
  'Ø£ÙŠØ±Ù„Ù†Ø¯Ø§': ['Ø¯Ø¨Ù„Ù†', 'ÙƒÙˆØ±Ùƒ', 'ØºØ§Ù„ÙˆØ§ÙŠ'],
  'Ø§Ù„Ø¯Ù†Ù…Ø§Ø±Ùƒ': ['ÙƒÙˆØ¨Ù†Ù‡Ø§ØºÙ†', 'Ø¢Ø±Ù‡ÙˆØ³'],
  'Ø§Ù„Ù†Ø±ÙˆÙŠØ¬': ['Ø£ÙˆØ³Ù„Ùˆ', 'Ø¨ÙŠØ±ØºÙ†'],
  'Ø§Ù„Ø¨Ø±ØªØºØ§Ù„': ['Ù„Ø´Ø¨ÙˆÙ†Ø©', 'Ø¨ÙˆØ±ØªÙˆ'],
  'Ø§Ù„Ù…Ù…Ù„ÙƒØ© Ø§Ù„Ù…ØªØ­Ø¯Ø©': ['Ù„Ù†Ø¯Ù†', 'Ù…Ø§Ù†Ø´Ø³ØªØ±', 'Ø¨Ø±Ù…Ù†ØºÙ‡Ø§Ù…', 'ØºÙ„Ø§Ø³ÙƒÙˆ'],
  'Ø§Ù„ÙˆÙ„Ø§ÙŠØ§Øª Ø§Ù„Ù…ØªØ­Ø¯Ø©': ['Ù†ÙŠÙˆÙŠÙˆØ±Ùƒ', 'Ù„ÙˆØ³ Ø£Ù†Ø¬Ù„ÙˆØ³', 'Ø´ÙŠÙƒØ§ØºÙˆ', 'Ù‡ÙŠÙˆØ³ØªÙ†'],
  'ÙƒÙ†Ø¯Ø§': ['ØªÙˆØ±ÙˆÙ†ØªÙˆ', 'ÙØ§Ù†ÙƒÙˆÙØ±', 'Ù…ÙˆÙ†ØªØ±ÙŠØ§Ù„', 'ÙƒØ§Ù„Ø¬Ø§Ø±ÙŠ'],
  'Ø£Ø³ØªØ±Ø§Ù„ÙŠØ§': ['Ø³ÙŠØ¯Ù†ÙŠ', 'Ù…Ù„Ø¨ÙˆØ±Ù†', 'Ø¨Ø±ÙŠØ²Ø¨Ø§Ù†', 'Ø¨ÙŠØ±Ø«'],
};

