import 'package:flutter/foundation.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../models/cv_model.dart';
import '../models/user_profile_model.dart';

// ════════════════════════════════════════════════════════════════════════════
// PdfService — Official Europass CV Layout Engine
//
// Reproduces the exact visual structure shown in the master Europass template:
//
//  ┌─────────────────────────────────────────────────── [europass logo] ──┐
//  │  FULL NAME IN BOLD UPPERCASE                                         │
//  │  Passport: xxx | Date of birth: xx | Nationality | Gender | Phone    │
//  │  (Mobile) xxx  | Email address: xxx@xxx                              │
//  │  Address: City, Country                                              │
//  ├──────────────────────────────────────────────────────────────────────┤
//  │  • ABOUT ME ─────────────────────────────────────────────────────    │
//  │    [summary paragraph]                                               │
//  │  • WORK EXPERIENCE ──────────────────────────────────────────────    │
//  │    JOB TITLE – DATES – LOCATION                                      │
//  │    • bullet  • bullet  • bullet                                      │
//  │  • EDUCATION AND TRAINING ───────────────────────────────────────    │
//  │    dates  location                                                   │
//  │    DEGREE NAME  Institution                                          │
//  │    Field of study: xxx                                               │
//  │  • LANGUAGE SKILLS ──────────────────────────────────────────────    │
//  │    Mother tongue(s): ARABIC                                          │
//  │    [CEFR table]                                                      │
//  │  • SKILLS ───────────────────────────────────────────────────────    │
//  │    Skill1 | Skill2 | Skill3                                          │
//  └─── 1/1 ──────────────────────────────────────────────────────────────┘
//
// Translation: all user-entered strings are sanitised through a two-layer
// Arabic→English translation engine before being embedded in the PDF.
// ════════════════════════════════════════════════════════════════════════════

class PdfService {
  // ── Colour palette (matches Europass spec) ───────────────────────────────
  static const PdfColor _kBlue = PdfColor.fromInt(0xFF003399);     // EU Blue
  static const PdfColor _kTextDark = PdfColor.fromInt(0xFF1A1A1A);
  static const PdfColor _kTextLight = PdfColor.fromInt(0xFF888888);
  static const PdfColor _kRuleGrey = PdfColor.fromInt(0xFFBBBBBB);
  static const PdfColor _kCellBg = PdfColor.fromInt(0xFFF2F2F2);
  static const PdfColor _kHeaderBg = PdfColor.fromInt(0xFFE8E8E8);

  // ── Typography helpers ───────────────────────────────────────────────────
  static pw.TextStyle _ts({
    double size = 9,
    bool bold = false,
    bool italic = false,
    PdfColor? color,
  }) =>
      pw.TextStyle(
        fontSize: size,
        fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        fontStyle: italic ? pw.FontStyle.italic : pw.FontStyle.normal,
        color: color ?? _kTextDark,
      );

  // ══════════════════════════════════════════════════════════════════════════
  // PUBLIC API
  // ══════════════════════════════════════════════════════════════════════════

  /// Generates a Europass-styled A4 PDF from [cv].
  /// All Arabic input is translated to English before embedding.
  Future<Uint8List> generateCvPdf(CvModel cv) async {
    final s = _sanitiseCv(cv); // translate Arabic → English
    final doc = pw.Document(
      title: 'Europass CV – ${s.fullName}',
      author: 'Easy Work PDF Engine',
    );

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        // Europass uses tight margins to fit all content
        margin: const pw.EdgeInsets.fromLTRB(36, 32, 36, 36),
        build: (ctx) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // 1. Header block
            _buildHeader(s),
            pw.SizedBox(height: 14),

            // 2. About Me
            if (s.aboutMe.isNotEmpty) ...[
              _buildSectionTitle('ABOUT ME'),
              pw.SizedBox(height: 5),
              pw.Text(s.aboutMe, style: _ts(size: 8.5)),
              pw.SizedBox(height: 10),
            ],

            // 3. Work Experience
            _buildSectionTitle('WORK EXPERIENCE'),
            pw.SizedBox(height: 5),
            _buildWorkExperience(s),
            pw.SizedBox(height: 10),

            // 4. Education & Training
            _buildSectionTitle('EDUCATION AND TRAINING'),
            pw.SizedBox(height: 5),
            _buildEducation(s),
            pw.SizedBox(height: 10),

            // 5. Language Skills
            _buildSectionTitle('LANGUAGE SKILLS'),
            pw.SizedBox(height: 5),
            _buildLanguageSkills(s),
            pw.SizedBox(height: 10),

            // 6. Skills
            _buildSectionTitle('SKILLS'),
            pw.SizedBox(height: 5),
            _buildSkills(s),

            // 7. Footer
            pw.Expanded(child: pw.SizedBox()),
            _buildFooter(),
          ],
        ),
      ),
    );

    return doc.save();
  }

  /// Triggers native web browser PDF download dialog.
  Future<void> downloadCvPdf(CvModel cv) async {
    final bytes = await generateCvPdf(cv);
    final name = cv.fullName
        .trim()
        .replaceAll(RegExp(r'\s+'), '_')
        .replaceAll(RegExp(r'[^\w_]'), '');
    final filename =
        '${name.isNotEmpty ? name : 'CV'}_Europass.pdf';
    await Printing.sharePdf(bytes: bytes, filename: filename);
  }

  /// Generates + downloads a PDF from a Profile Dashboard UserCvModel card.
  Future<void> downloadUserCvPdf(
      String userName, UserCvModel userCv) async {
    await downloadCvPdf(CvModel(
      fullName: userName,
      profession: userCv.jobTitle,
    ));
  }

  // ══════════════════════════════════════════════════════════════════════════
  // SECTION BUILDERS
  // ══════════════════════════════════════════════════════════════════════════

  // ── 1. Header ──────────────────────────────────────────────────────────────
  pw.Widget _buildHeader(CvModel cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Row: Name (left) + europass logo (right)
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Full name — large bold uppercase
            pw.Expanded(
              child: pw.Text(
                cv.fullName.isNotEmpty
                    ? cv.fullName.toUpperCase()
                    : 'YOUR FULL NAME',
                style: _ts(size: 16, bold: true, color: _kTextDark),
              ),
            ),
            pw.SizedBox(width: 12),
            // europass branding block
            _buildEuropassLogo(),
          ],
        ),

        pw.SizedBox(height: 6),
        pw.Divider(color: _kRuleGrey, thickness: 0.8),
        pw.SizedBox(height: 4),

        // Metadata row 1: Passport | DOB | Nationality | Gender | Phone
        _buildMetaRow1(cv),
        pw.SizedBox(height: 2),

        // Metadata row 2: (Mobile) phone | Email address
        _buildMetaRow2(cv),
        pw.SizedBox(height: 2),

        // Address line
        if (cv.address.isNotEmpty)
          pw.RichText(
            text: pw.TextSpan(
              style: _ts(size: 8),
              children: [
                pw.TextSpan(
                    text: 'Address: ',
                    style: _ts(size: 8, bold: true)),
                pw.TextSpan(
                    text: '${cv.address} (Home)',
                    style: _ts(size: 8)),
              ],
            ),
          ),
      ],
    );
  }

  pw.Widget _buildEuropassLogo() {
    // Recreate the EU flag + "europass" wordmark using pure PDF primitives.
    return pw.Row(
      mainAxisSize: pw.MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        // EU flag: blue square with yellow stars hint (simplified)
        pw.Container(
          width: 26,
          height: 18,
          decoration: pw.BoxDecoration(
            color: _kBlue,
            borderRadius: pw.BorderRadius.circular(2),
          ),
          child: pw.Center(
            child: pw.Text(
              '★',
              style: const pw.TextStyle(
                fontSize: 10,
                color: PdfColors.yellow,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
        ),
        pw.SizedBox(width: 5),
        pw.Text(
          'europass',
          style: _ts(size: 14, bold: true, color: _kBlue),
        ),
      ],
    );
  }

  pw.Widget _buildMetaRow1(CvModel cv) {
    final parts = <String>[];
    if (cv.passport.isNotEmpty) {
      parts.add('Passport: ${cv.passport}');
    }
    if (cv.dateOfBirth.isNotEmpty) {
      parts.add('Date of birth: ${cv.dateOfBirth}');
    }
    if (cv.nationality.isNotEmpty) {
      parts.add('Nationality: ${cv.nationality}');
    }
    if (cv.gender.isNotEmpty) {
      parts.add('Gender: ${cv.gender}');
    }
    if (cv.phone.isNotEmpty) {
      parts.add('Phone number: ${cv.phone}');
    }

    if (parts.isEmpty) return pw.SizedBox.shrink();

    return pw.Text(
      parts.join('  |  '),
      style: _ts(size: 8, bold: true),
    );
  }

  pw.Widget _buildMetaRow2(CvModel cv) {
    final parts = <String>[];
    if (cv.phone.isNotEmpty) {
      parts.add('${cv.phone} (Mobile)');
    }
    if (cv.email.isNotEmpty) {
      parts.add('Email address: ${cv.email}');
    }

    if (parts.isEmpty) return pw.SizedBox.shrink();

    return pw.RichText(
      text: pw.TextSpan(
        style: _ts(size: 8),
        children: parts.map((p) {
          final isEmail = p.startsWith('Email');
          return pw.TextSpan(
            text: p == parts.last ? p : '$p  |  ',
            style: isEmail
                ? _ts(size: 8, color: _kBlue)
                : _ts(size: 8),
          );
        }).toList(),
      ),
    );
  }

  // ── Section title helper (• TITLE + horizontal rule) ─────────────────────
  pw.Widget _buildSectionTitle(String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          children: [
            // Bullet square (matches Europass hollow-square bullet)
            pw.Container(
              width: 6,
              height: 6,
              margin: const pw.EdgeInsets.only(right: 5, top: 1),
              decoration: const pw.BoxDecoration(
                border: pw.Border.fromBorderSide(pw.BorderSide(color: _kTextDark, width: 1)),
              ),
            ),
            pw.Text(
              title,
              style: _ts(size: 9, bold: true, color: _kTextDark),
            ),
          ],
        ),
        pw.SizedBox(height: 3),
        pw.Divider(color: _kRuleGrey, thickness: 0.6),
      ],
    );
  }

  // ── 3. Work Experience ─────────────────────────────────────────────────────
  pw.Widget _buildWorkExperience(CvModel cv) {
    final hasContent = cv.companyName.isNotEmpty ||
        cv.workDates.isNotEmpty ||
        cv.workBulletPoints.isNotEmpty;

    if (!hasContent) {
      return pw.Text('[No work experience added]',
          style: _ts(size: 8.5, italic: true, color: _kTextLight));
    }

    // Build the title line: JOB TITLE – DATES – LOCATION
    final titleParts = <String>[];
    if (cv.profession.isNotEmpty) titleParts.add(cv.profession.toUpperCase());
    if (cv.workDates.isNotEmpty) titleParts.add(cv.workDates);
    if (cv.workLocation.isNotEmpty) titleParts.add(cv.workLocation.toUpperCase());
    if (cv.companyName.isNotEmpty) titleParts.add(cv.companyName.toUpperCase());

    final bullets = cv.workBulletPoints.isNotEmpty
        ? cv.workBulletPoints
        : <String>[
            'Carried out all assigned tasks efficiently and to the highest professional standards.',
            'Followed all relevant health and safety regulations on site.',
          ];

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (titleParts.isNotEmpty)
          pw.Text(
            titleParts.join('  –  '),
            style: _ts(size: 8.5, bold: true),
          ),
        pw.SizedBox(height: 4),
        ...bullets.map((b) => _buildBulletItem(b)),
      ],
    );
  }

  pw.Widget _buildBulletItem(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('• ', style: _ts(size: 8.5)),
          pw.Expanded(
            child: pw.Text(text, style: _ts(size: 8.5)),
          ),
        ],
      ),
    );
  }

  // ── 4. Education & Training ───────────────────────────────────────────────
  pw.Widget _buildEducation(CvModel cv) {
    final hasContent = cv.educationDegree.isNotEmpty ||
        cv.educationInstitution.isNotEmpty ||
        cv.educationDates.isNotEmpty;

    if (!hasContent) {
      return pw.Text('[No education added]',
          style: _ts(size: 8.5, italic: true, color: _kTextLight));
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Date + location line (small grey)
        if (cv.educationDates.isNotEmpty || cv.educationLocation.isNotEmpty)
          pw.Text(
            [cv.educationDates, cv.educationLocation]
                .where((s) => s.isNotEmpty)
                .join('  '),
            style: _ts(size: 8, color: _kTextLight),
          ),
        pw.SizedBox(height: 3),

        // Degree name (bold) + institution
        pw.RichText(
          text: pw.TextSpan(
            style: _ts(size: 8.5),
            children: [
              if (cv.educationDegree.isNotEmpty)
                pw.TextSpan(
                  text: cv.educationDegree.toUpperCase(),
                  style: _ts(size: 8.5, bold: true),
                ),
              if (cv.educationInstitution.isNotEmpty)
                pw.TextSpan(
                  text: '  ${cv.educationInstitution}',
                  style: _ts(size: 8.5),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 3),

        // Field of study
        if (cv.educationField.isNotEmpty)
          pw.RichText(
            text: pw.TextSpan(
              style: _ts(size: 8.5),
              children: [
                pw.TextSpan(
                    text: 'Field of study: ',
                    style: _ts(size: 8.5, bold: true)),
                pw.TextSpan(text: cv.educationField),
              ],
            ),
          ),
      ],
    );
  }

  // ── 5. Language Skills with CEFR table ───────────────────────────────────
  pw.Widget _buildLanguageSkills(CvModel cv) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Mother tongue
        pw.RichText(
          text: pw.TextSpan(
            style: _ts(size: 8.5),
            children: [
              pw.TextSpan(
                  text: 'Mother tongue(s):  ',
                  style: _ts(size: 8.5)),
              pw.TextSpan(
                  text: cv.motherTongue.toUpperCase(),
                  style: _ts(size: 8.5, bold: true)),
            ],
          ),
        ),
        pw.SizedBox(height: 4),

        pw.Text('Other language(s):', style: _ts(size: 8.5)),
        pw.SizedBox(height: 6),

        // CEFR table
        _buildCefrTable(cv),
        pw.SizedBox(height: 4),

        // CEFR legend
        pw.Text(
          'Levels: A1 and A2: Basic user; B1 and B2: Independent user; C1 and C2: Proficient user',
          style: _ts(size: 7, italic: true, color: _kTextLight),
        ),
      ],
    );
  }

  pw.Widget _buildCefrTable(CvModel cv) {
    // Column widths (proportional to A4 content width ≈ 523 pt)
    const double langCol = 72;
    const double skillCol = 72;

    // ── Group header row: UNDERSTANDING | SPEAKING | WRITING ─────────────
    final groupHeaderRow = pw.TableRow(
      children: [
        _cefrCell('', bold: false, bg: PdfColors.white, width: langCol),
        _cefrGroupHeader('UNDERSTANDING', span: 2),
        _cefrGroupHeader('SPEAKING', span: 2),
        _cefrCell('WRITING', bold: true, bg: _kHeaderBg, width: skillCol,
            align: pw.Alignment.center),
      ],
    );

    // ── Sub-header row: Listening | Reading | Spoken prod | Spoken int ────
    final subHeaderRow = pw.TableRow(
      children: [
        _cefrCell('', bold: false, bg: PdfColors.white, width: langCol),
        _cefrCell('Listening', bold: false, bg: _kHeaderBg, width: skillCol,
            size: 7.5, align: pw.Alignment.center),
        _cefrCell('Reading', bold: false, bg: _kHeaderBg, width: skillCol,
            size: 7.5, align: pw.Alignment.center),
        _cefrCell('Spoken\nproduction', bold: false, bg: _kHeaderBg,
            width: skillCol, size: 7.5, align: pw.Alignment.center),
        _cefrCell('Spoken\ninteraction', bold: false, bg: _kHeaderBg,
            width: skillCol, size: 7.5, align: pw.Alignment.center),
        _cefrCell('', bold: false, bg: _kHeaderBg, width: skillCol),
      ],
    );

    // ── Language data row ─────────────────────────────────────────────────
    final langRow = pw.TableRow(
      decoration: const pw.BoxDecoration(color: _kCellBg),
      children: [
        _cefrCell(cv.otherLanguage.toUpperCase(),
            bold: true, bg: _kCellBg, width: langCol),
        _cefrCell(cv.cefrListening,
            bold: false, bg: _kCellBg, width: skillCol,
            align: pw.Alignment.center),
        _cefrCell(cv.cefrReading,
            bold: false, bg: _kCellBg, width: skillCol,
            align: pw.Alignment.center),
        _cefrCell(cv.cefrSpokenProduction,
            bold: false, bg: _kCellBg, width: skillCol,
            align: pw.Alignment.center),
        _cefrCell(cv.cefrSpokenInteraction,
            bold: false, bg: _kCellBg, width: skillCol,
            align: pw.Alignment.center),
        _cefrCell(cv.cefrWriting,
            bold: false, bg: _kCellBg, width: skillCol,
            align: pw.Alignment.center),
      ],
    );

    return pw.Table(
      border: pw.TableBorder.all(
        color: _kRuleGrey,
        width: 0.5,
      ),
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      columnWidths: {
        0: const pw.FixedColumnWidth(langCol),
        1: const pw.FlexColumnWidth(),
        2: const pw.FlexColumnWidth(),
        3: const pw.FlexColumnWidth(),
        4: const pw.FlexColumnWidth(),
        5: const pw.FlexColumnWidth(),
      },
      children: [groupHeaderRow, subHeaderRow, langRow],
    );
  }

  pw.Widget _cefrGroupHeader(String text, {required int span}) {
    // Simulate column spanning by using a fixed-width container.
    return pw.Container(
      color: _kHeaderBg,
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
      child: pw.Text(
        text,
        style: _ts(size: 8, bold: true),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.Widget _cefrCell(
    String text, {
    required bool bold,
    required PdfColor bg,
    required double width,
    double size = 8.5,
    pw.Alignment align = pw.Alignment.centerLeft,
  }) {
    return pw.Container(
      color: bg,
      alignment: align,
      padding: const pw.EdgeInsets.symmetric(vertical: 5, horizontal: 6),
      child: pw.Text(
        text,
        style: _ts(size: size, bold: bold),
        textAlign:
            align == pw.Alignment.center ? pw.TextAlign.center : pw.TextAlign.left,
      ),
    );
  }

  // ── 6. Skills ─────────────────────────────────────────────────────────────
  pw.Widget _buildSkills(CvModel cv) {
    final list = cv.skills.where((s) => s.isNotEmpty).toList();
    if (list.isEmpty) {
      return pw.Text('[No skills added]',
          style: _ts(size: 8.5, italic: true, color: _kTextLight));
    }
    return pw.Text(
      list.join('  |  '),
      style: _ts(size: 8.5),
    );
  }

  // ── 7. Footer ─────────────────────────────────────────────────────────────
  pw.Widget _buildFooter() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.end,
      children: [
        pw.Text('1 / 1', style: _ts(size: 8, color: _kTextLight)),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════════════════
  // ARABIC → ENGLISH TRANSLATION LAYER
  // ══════════════════════════════════════════════════════════════════════════

  CvModel _sanitiseCv(CvModel cv) {
    return CvModel(
      fullName: _s(cv.fullName),
      profession: _s(cv.profession),
      yearsOfExperience: cv.yearsOfExperience,
      passport: cv.passport,           // keep as-is (alphanumeric)
      dateOfBirth: cv.dateOfBirth,     // keep as-is (DD/MM/YYYY)
      nationality: _s(cv.nationality),
      gender: _s(cv.gender),
      phone: cv.phone,
      email: cv.email,
      country: _s(cv.country),
      city: _s(cv.city),
      aboutMe: _s(cv.aboutMe),
      companyName: _s(cv.companyName),
      workDates: cv.workDates,
      workLocation: _s(cv.workLocation),
      workBulletPoints: cv.workBulletPoints.map(_s).toList(),
      educationDegree: _s(cv.educationDegree),
      educationInstitution: _s(cv.educationInstitution),
      educationDates: cv.educationDates,
      educationLocation: _s(cv.educationLocation),
      educationField: _s(cv.educationField),
      motherTongue: _s(cv.motherTongue),
      otherLanguage: _s(cv.otherLanguage),
      cefrListening: cv.cefrListening,
      cefrReading: cv.cefrReading,
      cefrSpokenProduction: cv.cefrSpokenProduction,
      cefrSpokenInteraction: cv.cefrSpokenInteraction,
      cefrWriting: cv.cefrWriting,
      skills: cv.skills.map(_s).toList(),
    );
  }

  /// Sanitises a single string: phrase-map first, then char transliteration.
  String _s(String input) {
    if (input.isEmpty) return input;
    final t = input.trim();
    if (!_hasArabic(t)) return t;
    return _kPhraseMap[t] ?? _transliterate(t);
  }

  bool _hasArabic(String s) =>
      s.runes.any((r) => r >= 0x0600 && r <= 0x06FF);

  String _transliterate(String arabic) {
    final sb = StringBuffer();
    for (final ch in arabic.split('')) {
      sb.write(_kCharMap[ch] ?? ch);
    }
    return sb.toString().replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}

// ════════════════════════════════════════════════════════════════════════════
// Translation data tables
// ════════════════════════════════════════════════════════════════════════════

const Map<String, String> _kPhraseMap = {
  // Professions
  'كهربائي': 'Electrician',
  'مشرف مزرعة': 'Farm Supervisor',
  'لحام': 'Welder',
  'فني مصنع': 'Factory Technician',
  'عامل تنظيف فندق': 'Hotel Housekeeper',
  'مشغل مستودع': 'Warehouse Operator',
  'عامل بناء': 'Construction Worker',
  'سائق شاحنة': 'Truck Driver',
  'سباك': 'Plumber',
  'عامل إنتاج غذائي': 'Food Production Operative',
  'مهندس برمجيات': 'Software Engineer',
  'مدير مشروع': 'Project Manager',
  'محلل بيانات': 'Data Analyst',
  'محاسب': 'Accountant',
  'ممرض': 'Nurse',
  'طبيب': 'Doctor',
  'مدرس': 'Teacher',
  'عامل': 'Worker',
  'فني': 'Technician',
  // Nationalities
  'مصري': 'Egyptian',
  'مصرية': 'Egyptian',
  'عربي': 'Arab',
  'سوري': 'Syrian',
  'مغربي': 'Moroccan',
  'جزائري': 'Algerian',
  // Genders
  'ذكر': 'Male',
  'أنثى': 'Female',
  'رجل': 'Male',
  'امرأة': 'Female',
  // Languages
  'العربية': 'Arabic',
  'انجليزي': 'English',
  'الإنجليزية': 'English',
  'ألماني': 'German',
  'فرنسي': 'French',
  // Countries
  'مصر': 'Egypt',
  'ألمانيا': 'Germany',
  'إيطاليا': 'Italy',
  'فرنسا': 'France',
  'بولندا': 'Poland',
  'هولندا': 'Netherlands',
  'إسبانيا': 'Spain',
  'بلجيكا': 'Belgium',
  'السويد': 'Sweden',
  'النمسا': 'Austria',
  'المملكة المتحدة': 'United Kingdom',
  'إيرلندا': 'Ireland',
  // Egyptian cities
  'القاهرة': 'Cairo',
  'الإسكندرية': 'Alexandria',
  'الجيزة': 'Giza',
  'المنصورة': 'Mansoura',
  'طنطا': 'Tanta',
  'أسيوط': 'Assiut',
  'الأقصر': 'Luxor',
  'السويس': 'Suez',
  // European cities
  'برلين': 'Berlin',
  'ميونيخ': 'Munich',
  'هامبورغ': 'Hamburg',
  'باريس': 'Paris',
  'روما': 'Rome',
  'ميلان': 'Milan',
  'وارسو': 'Warsaw',
  'أمستردام': 'Amsterdam',
  'مدريد': 'Madrid',
  'برشلونة': 'Barcelona',
  // Common Arabic first names
  'محمود': 'Mahmoud',
  'أحمد': 'Ahmed',
  'محمد': 'Mohammed',
  'علي': 'Ali',
  'خالد': 'Khaled',
  'عمر': 'Omar',
  'يوسف': 'Youssef',
  'إبراهيم': 'Ibrahim',
  'حسن': 'Hassan',
  'مصطفى': 'Mustafa',
  'عبدالله': 'Abdullah',
  'عبدالرحمن': 'Abdel Rahman',
  'رمضان': 'Ramadan',
  'حسين': 'Hussein',
  'سامي': 'Sami',
};

const Map<String, String> _kCharMap = {
  'ا': 'a', 'أ': 'a', 'إ': 'i', 'آ': 'aa',
  'ب': 'b', 'ت': 't', 'ث': 'th',
  'ج': 'j', 'ح': 'h', 'خ': 'kh',
  'د': 'd', 'ذ': 'dh', 'ر': 'r', 'ز': 'z',
  'س': 's', 'ش': 'sh', 'ص': 's', 'ض': 'd',
  'ط': 't', 'ظ': 'z', 'ع': "'", 'غ': 'gh',
  'ف': 'f', 'ق': 'q', 'ك': 'k', 'ل': 'l',
  'م': 'm', 'ن': 'n', 'ه': 'h', 'و': 'w',
  'ي': 'y', 'ى': 'a', 'ة': 'a', 'ء': "'",
  'ئ': 'y', 'ؤ': 'w',
  // Diacritics — strip
  '\u064b': '', '\u064c': '', '\u064d': '',
  '\u064e': '', '\u064f': '', '\u0650': '',
  '\u0651': '', '\u0652': '',
  ' ': ' ', '-': '-', '.': '.', ',': ',',
};
