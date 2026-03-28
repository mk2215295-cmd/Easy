import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class TranslationEngine {
  String get _googleTranslateApiKey =>
      dotenv.env['GOOGLE_TRANSLATE_KEY'] ?? 'YOUR_GOOGLE_TRANSLATE_KEY';
  static const String _googleTranslateUrl =
      'https://translation.googleapis.com/language/translate/v2';

  final Map<String, String> _translationsCache = {};

  Future<String> translateJob(String text, String targetLang) async {
    if (text.isEmpty) return '';

    final cacheKey = '${text.hashCode}_$targetLang';
    if (_translationsCache.containsKey(cacheKey)) {
      return _translationsCache[cacheKey]!;
    }

    try {
      final response = await http.post(
        Uri.parse('$_googleTranslateUrl?key=$_googleTranslateApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'q': text, 'target': targetLang, 'format': 'text'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final translatedText =
            data['data']['translations'][0]['translatedText'];
        _translationsCache[cacheKey] = translatedText;
        return translatedText;
      }
    } catch (e) {
      debugPrint('Translation Error: $e');
    }

    return _getMockTranslation(text, targetLang);
  }

  String _getMockTranslation(String text, String targetLang) {
    if (targetLang == 'ar') {
      switch (text.toLowerCase()) {
        case 'software engineer':
          return 'مهندس برمجيات';
        case 'chef':
          return 'طباخ';
        case 'driver':
          return 'سائق';
        case 'nurse':
          return 'ممرض';
        case 'full time':
          return 'دوام كامل';
        case 'part time':
          return 'دوام جزئي';
        case 'housing included':
          return 'السكن مشمول';
        case 'work visa sponsor':
          return 'رعاية تأشيرة عمل';
        case 'english required':
          return 'اللغة الإنجليزية مطلوبة';
        default:
          return '[AR] $text';
      }
    }

    return text;
  }

  Future<Map<String, String>> translateJobDetails({
    required String title,
    required String description,
    required String requirements,
  }) async {
    final translatedTitle = await translateJob(title, 'ar');
    final translatedDesc = await translateJob(description, 'ar');
    final translatedReq = await translateJob(requirements, 'ar');

    return {
      'title': translatedTitle,
      'description': translatedDesc,
      'requirements': translatedReq,
    };
  }

  Future<String> translateContract(String contractText) async {
    if (contractText.isEmpty) return '';

    try {
      final response = await http.post(
        Uri.parse('$_googleTranslateUrl?key=$_googleTranslateApiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'q': contractText, 'target': 'ar', 'format': 'text'}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['translations'][0]['translatedText'];
      }
    } catch (e) {
      debugPrint('Contract Translation Error: $e');
    }

    return _getContractSummary(contractText);
  }

  String _getContractSummary(String contract) {
    final summary = {
      'salary': _extractSalary(contract),
      'duration': _extractDuration(contract),
      'benefits': _extractBenefits(contract),
      'vacation': _extractVacation(contract),
    };

    return '''
📋 ملخص العقد:
━━━━━━━━━━━━━━━━━━
💰 الراتب: ${summary['salary']}
📅 المدة: ${summary['duration']}
🎁 المزايا: ${summary['benefits']}
🏖️ الإجازات: ${summary['vacation']}
''';
  }

  String _extractSalary(String contract) {
    final salaryPatterns = [
      RegExp(r'(\d+[\d,]*)\s*(EUR|USD|TRY|GBP)'),
      RegExp(r'salary[:\s]+(\d+[\d,]*)'),
      RegExp(r'الراتب[:\s]+(\d+[\d,]*(?:EUR|USD|TRY|GBP)?)'),
    ];

    for (var pattern in salaryPatterns) {
      final match = pattern.firstMatch(contract);
      if (match != null) {
        return match.group(1) ?? 'غير محدد';
      }
    }
    return 'غير محدد';
  }

  String _extractDuration(String contract) {
    if (contract.toLowerCase().contains('permanent')) {
      return 'دائم';
    }
    if (contract.toLowerCase().contains('1 year')) {
      return 'سنة واحدة';
    }
    if (contract.toLowerCase().contains('2 years')) {
      return 'سنتان';
    }
    return 'غير محدد';
  }

  String _extractBenefits(String contract) {
    final benefits = <String>[];
    if (contract.toLowerCase().contains('housing')) benefits.add('سكن');
    if (contract.toLowerCase().contains('insurance')) benefits.add('تأمين');
    if (contract.toLowerCase().contains('flight')) benefits.add('تذكرة طيران');
    if (contract.toLowerCase().contains('car')) benefits.add('سيارة');
    return benefits.isEmpty ? 'غير محددة' : benefits.join(' - ');
  }

  String _extractVacation(String contract) {
    if (contract.toLowerCase().contains('30 days')) {
      return '30 يوم';
    }
    if (contract.toLowerCase().contains('20 days')) {
      return '20 يوم';
    }
    if (contract.toLowerCase().contains('annual')) {
      return 'سنوي';
    }
    return 'غير محددة';
  }
}
