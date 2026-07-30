import re

extra = '''
  CvProfessionCategory(
    titleEn: 'Engineering & Architecture',
    titleAr: 'الهندسة والعمارة',
    emoji: '🏗️',
    professions: [
      CvProfession(titleEn: 'Civil Engineer', titleAr: 'مهندس مدني', categoryEn: 'Engineering', categoryAr: 'الهندسة', emoji: '🏗️', suggestedBullets: ['Managed construction projects from conception to completion.']),
      CvProfession(titleEn: 'Mechanical Engineer', titleAr: 'مهندس ميكانيكي', categoryEn: 'Engineering', categoryAr: 'الهندسة', emoji: '⚙️', suggestedBullets: ['Designed and optimized mechanical systems.']),
      CvProfession(titleEn: 'Electrical Engineer', titleAr: 'مهندس كهربائي', categoryEn: 'Engineering', categoryAr: 'الهندسة', emoji: '⚡', suggestedBullets: ['Developed electrical schematics and wiring plans.']),
    ],
  ),
  CvProfessionCategory(
    titleEn: 'Logistics & Transportation',
    titleAr: 'اللوجستيات والنقل',
    emoji: '🚚',
    professions: [
      CvProfession(titleEn: 'Supply Chain Manager', titleAr: 'مدير سلسلة الإمداد', categoryEn: 'Logistics', categoryAr: 'اللوجستيات', emoji: '📦', suggestedBullets: ['Optimized supply chain operations reducing costs.']),
      CvProfession(titleEn: 'Delivery Driver', titleAr: 'سائق توصيل', categoryEn: 'Logistics', categoryAr: 'اللوجستيات', emoji: '🚚', suggestedBullets: ['Ensured timely delivery of goods and packages.']),
    ],
  ),
  CvProfessionCategory(
    titleEn: 'Admin & Office Support',
    titleAr: 'الإدارة والدعم المكتبي',
    emoji: '📁',
    professions: [
      CvProfession(titleEn: 'Administrative Assistant', titleAr: 'مساعد إداري', categoryEn: 'Admin', categoryAr: 'إدارة', emoji: '📁', suggestedBullets: ['Handled scheduling, filing, and office communication.']),
      CvProfession(titleEn: 'Data Entry Clerk', titleAr: 'مدخل بيانات', categoryEn: 'Admin', categoryAr: 'إدارة', emoji: '⌨️', suggestedBullets: ['Accurately maintained large sets of company records.']),
    ],
  ),
'''

with open('lib/features/cv_builder/cv_form_data.dart', 'r', encoding='utf-8') as f:
    content = f.read()

content = content.replace('];\\n\\nconst List<String> kCountries', extra + '\\n];\\n\\nconst List<String> kCountries')

with open('lib/features/cv_builder/cv_form_data.dart', 'w', encoding='utf-8') as f:
    f.write(content)
