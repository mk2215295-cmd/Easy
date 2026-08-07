import 'cv_model.dart';

class CvExperienceBullet {
  const CvExperienceBullet({
    required this.textEn,
    required this.textAr,
  });

  final String textEn;
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

  final String titleEn;
  final String titleAr;
  final String categoryEn;
  final String categoryAr;
  final String emoji;
  final List<CvExperienceBullet> suggestedBullets;

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

const List<CvProfession> kProfessions = [
  CvProfession(
    titleEn: 'Electrician',
    titleAr: 'كهربائي',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'الحرف الفنية والتقنية',
    emoji: '🛠️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Installed, maintained and repaired electrical wiring, equipment and fixtures in compliance with national safety codes.',
        textAr: 'تركيب وصيانة وإصلاح التمديدات والمعدات والتركيبات الكهربائية وفقاً لمعايير السلامة الوطنية.',
      ),
      CvExperienceBullet(
        textEn: 'Read and interpreted blueprints, wiring diagrams and engineering drawings to carry out installation tasks.',
        textAr: 'قراءة وتفسير المخططات الهندسة ورسومات التمديدات الكهربائية لتقييم وتطبيق المهام بدقة.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Mechanical Engineer',
    titleAr: 'مهندس ميكانيكي',
    categoryEn: 'Engineering',
    categoryAr: 'الهندسة',
    emoji: '⚙️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Designed and optimized mechanical components and systems.',
        textAr: 'تصميم وتحسين الأنظمة والمكونات الميكانيكية.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Software Engineer',
    titleAr: 'مهندس برمجيات',
    categoryEn: 'IT & Software',
    categoryAr: 'تكنولوجيا المعلومات والبرمجيات',
    emoji: '💻',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Developed scalable web and mobile applications using modern frameworks.',
        textAr: 'تطوير تطبيقات الويب والجوال باستخدام أحدث التقنيات.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Sales Manager',
    titleAr: 'مدير مبيعات',
    categoryEn: 'Business, Sales & Admin',
    categoryAr: 'إدارة الأعمال والمبيعات',
    emoji: '📊',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Developed sales strategies and led a high-performing sales team.',
        textAr: 'تطوير استراتيجيات المبيعات وقيادة فريق مبيعات عالي الأداء.',
      ),
    ],
  ),
];

final List<CvProfessionCategory> kProfessionCategories = [
  CvProfessionCategory(
    id: 'trades',
    titleEn: 'Vocational & Technical Trades',
    titleAr: 'الحرف الفنية والتقنية',
    emoji: '🛠️',
    professions: kProfessions,
  ),
  CvProfessionCategory(
    id: 'engineering',
    titleEn: 'Engineering & Architecture',
    titleAr: 'الهندسة والعمارة',
    emoji: '🏗️',
    professions: kProfessions,
  ),
  CvProfessionCategory(
    id: 'it',
    titleEn: 'IT & Software Development',
    titleAr: 'تكنولوجيا المعلومات والبرمجيات',
    emoji: '💻',
    professions: kProfessions,
  ),
  CvProfessionCategory(
    id: 'business',
    titleEn: 'Business, Sales & Admin',
    titleAr: 'إدارة الأعمال والمبيعات',
    emoji: '📊',
    professions: kProfessions,
  ),
];

const List<String> kCountries = [
  'Egypt', 'Saudi Arabia', 'United Arab Emirates', 'Qatar', 'Kuwait',
  'Bahrain', 'Oman', 'Jordan', 'Lebanon', 'Germany', 'France',
  'Italy', 'Spain', 'Netherlands', 'Poland', 'United Kingdom',
  'United States', 'Canada', 'Australia'
];
