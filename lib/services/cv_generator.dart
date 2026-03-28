import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/user_model.dart';

class CVGenerator {
  Future<Uint8List> generateEuropassCV(
    UserProfile profile,
    UserModel user,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => [
          _buildHeader(user.name, profile.title),
          pw.SizedBox(height: 20),
          _buildSummary(profile.summary),
          pw.SizedBox(height: 20),
          _buildSkills(profile.skills),
          pw.SizedBox(height: 20),
          _buildExperience(profile.experiences),
          pw.SizedBox(height: 20),
          _buildEducation(profile.education),
          pw.SizedBox(height: 20),
          _buildLanguages(profile.languages),
        ],
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildHeader(String name, String title) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(15),
          decoration: pw.BoxDecoration(
            color: PdfColors.indigo900,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    name,
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 5),
                  pw.Text(
                    title,
                    style: const pw.TextStyle(
                      fontSize: 18,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
              pw.Text(
                'Europass',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildSummary(String summary) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('ملخص المهني'),
        pw.Text(summary, style: const pw.TextStyle(fontSize: 12)),
      ],
    );
  }

  pw.Widget _buildSkills(List<String> skills) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('المهارات'),
        pw.Wrap(
          spacing: 10,
          runSpacing: 5,
          children: skills
              .map(
                (skill) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.indigo100,
                    borderRadius: pw.BorderRadius.circular(15),
                  ),
                  child: pw.Text(
                    skill,
                    style: const pw.TextStyle(fontSize: 11),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  pw.Widget _buildExperience(List<WorkExperience> experiences) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('الخبرة العملية'),
        ...experiences.map(
          (exp) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  exp.position,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  exp.company,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.Text(
                  '${exp.startDate.year} - ${exp.isCurrent ? 'حتى الآن' : exp.endDate?.year ?? ''}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Text(
                  exp.description,
                  style: const pw.TextStyle(fontSize: 11),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildEducation(List<Education> education) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('التعليم'),
        ...education.map(
          (edu) => pw.Container(
            margin: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  edu.degree,
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.Text(
                  edu.school,
                  style: const pw.TextStyle(
                    fontSize: 12,
                    color: PdfColors.grey700,
                  ),
                ),
                pw.Text(
                  '${edu.startDate.year} - ${edu.endDate?.year ?? 'حتى الآن'}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _buildLanguages(List<String> languages) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('اللغات'),
        pw.Wrap(
          spacing: 10,
          children: languages
              .map(
                (lang) => pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 5,
                  ),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.indigo900),
                    borderRadius: pw.BorderRadius.circular(15),
                  ),
                  child: pw.Text(lang, style: const pw.TextStyle(fontSize: 11)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  pw.Widget _buildSectionTitle(String title) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.only(bottom: 5),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(color: PdfColors.indigo900)),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 16,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.indigo900,
        ),
      ),
    );
  }

  Future<void> printCV(UserProfile profile, UserModel user) async {
    final pdfData = await generateEuropassCV(profile, user);
    await Printing.layoutPdf(onLayout: (format) async => pdfData);
  }

  Future<void> shareCV(UserProfile profile, UserModel user) async {
    final pdfData = await generateEuropassCV(profile, user);
    await Printing.sharePdf(bytes: pdfData, filename: 'CV_${user.name}.pdf');
  }
}
