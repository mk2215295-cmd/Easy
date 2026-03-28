class VisaGuide {
  final Map<String, List<VisaRequirement>> laws = {
    'تركيا 🇹🇷': [
      VisaRequirement(
        title: 'إقامة سياحية',
        description: 'التقديم على إقامة سياحية فور الوصول (90 يوم)',
        requirements: ['جواز سفر ساري', 'تذكرة ذهاب وعودة', 'تأمين طبي'],
        duration: '90 يوم قابلة للتجديد',
      ),
      VisaRequirement(
        title: 'إذن عمل (Çalışma İzni)',
        description: 'يجب أن يستخرج لك صاحب العمل إذن العمل',
        requirements: ['عقد عمل', 'عرض عمل معتمد', 'تأمين طبي شامل'],
        duration: 'سنة واحدة قابلة للتجديد',
      ),
      VisaRequirement(
        title: 'تأمين طبي',
        description: 'تأمين طبي شامل يغطي الإصابات والأمراض',
        requirements: [
          'بوليصة تأمين صادرة من تركيا',
          'تغطية لا تقل عن 30,000 يورو',
        ],
        duration: 'طوال فترة الإقامة',
      ),
    ],
    'كندا 🇨🇦': [
      VisaRequirement(
        title: 'Express Entry',
        description: 'برنامج العمالة الماهرة الفيدرالي',
        requirements: ['IELTS 6.0', 'درجة CMA', 'خبرة سنتين'],
        duration: '6-8 أشهر',
      ),
      VisaRequirement(
        title: 'تصريح عمل موسمي',
        description: 'للعمل الموسمي في المزارع والمناطق السياحية',
        requirements: ['عرض عمل موسمي', 'تأمين طبي', 'جواز سفر'],
        duration: '8 أشهر',
      ),
      VisaRequirement(
        title: 'LMIA',
        description: 'تقييم تأثير سوق العمل المحلي',
        requirements: ['عرض عمل من صاحب عمل كندي', 'موافقة LMIA'],
        duration: 'متغير',
      ),
    ],
    'ألمانيا 🇩🇪': [
      VisaRequirement(
        title: 'بطاقة UE الزرقاء',
        description: 'للحصول على إقامة عمل للعمال المهرة',
        requirements: ['عقد عمل بـ 45,000€+ سنوياً', 'درجة جامعية'],
        duration: '4 سنوات',
      ),
      VisaRequirement(
        title: 'إذن عمل عادي',
        description: 'تصريح عمل عادي مع فحص سوق العمل',
        requirements: ['عرض عمل', 'الموافقة على الوظيفة من وكالة العمل'],
        duration: 'سنة قابلة للتجديد',
      ),
      VisaRequirement(
        title: 'تأشيرة البحث عن عمل',
        description: 'للبحث عن عمل في ألمانيا',
        requirements: ['كفاءة عالية', 'مؤهل جامعي', 'تأمين مالي 6,000€'],
        duration: '6 أشهر',
      ),
    ],
    'فرنسا 🇫🇷': [
      VisaRequirement(
        title: 'تأشيرة موافقة سوق العمل',
        description: 'تصريح عمل مع فحص سوق العمل',
        requirements: ['عقد عمل', 'مؤهل جامعي لا يقل عن بكالوريوس'],
        duration: 'متغير',
      ),
      VisaRequirement(
        title: 'بطاقة المهاجر الماهر',
        description: 'للحاصلين على مؤهلات عليا',
        requirements: ['مؤهل جامعي عالٍ', 'خبرة مهنية'],
        duration: '4 سنوات',
      ),
    ],
  };

  List<VisaRequirement> getLaw(String country) => laws[country] ?? [];

  String getCountryInfo(String country) {
    switch (country.toLowerCase()) {
      case 'turkey':
      case 'تركيا':
        return 'تركيا توفر دخول بدون تأشيرة لمدة 180 يوم لمعظم الدول. تصريح العمل مطلوب للتوظيف.';
      case 'canada':
      case 'كندا':
        return 'كندا تعتمد نظام النقاط. Express Entry و PNP و LMIA هي المسارات الرئيسية.';
      case 'germany':
      case 'ألمانيا':
        return 'ألمانيا لديها نظام هجرة يعتمد على المهارات. البطاقة الزرقاء للمحترفين المؤهلين.';
      case 'france':
      case 'فرنسا':
        return 'فرنسا توفر بطاقة المواهب للمحترفين والباحثين المؤهلين.';
      default:
        return 'تحقق من متطلبات التأشيرة من سفارة البلد المطلوب.';
    }
  }
}

class VisaRequirement {
  final String title;
  final String description;
  final List<String> requirements;
  final String duration;

  VisaRequirement({
    required this.title,
    required this.description,
    required this.requirements,
    required this.duration,
  });
}

class CountryInfo {
  final String name;
  final String nameArb;
  final String flag;
  final String currency;
  final String language;
  final double minSalary;
  final bool requiresWorkPermit;
  final String visaProcessingTime;

  const CountryInfo({
    required this.name,
    required this.nameArb,
    required this.flag,
    required this.currency,
    required this.language,
    required this.minSalary,
    required this.requiresWorkPermit,
    required this.visaProcessingTime,
  });

  static const List<CountryInfo> supportedCountries = [
    CountryInfo(
      name: 'Turkey',
      nameArb: 'تركيا',
      flag: '🇹🇷',
      currency: 'TRY',
      language: 'Turkish',
      minSalary: 15000,
      requiresWorkPermit: true,
      visaProcessingTime: '2-4 weeks',
    ),
    CountryInfo(
      name: 'Germany',
      nameArb: 'ألمانيا',
      flag: '🇩🇪',
      currency: 'EUR',
      language: 'German',
      minSalary: 45000,
      requiresWorkPermit: true,
      visaProcessingTime: '4-8 weeks',
    ),
    CountryInfo(
      name: 'Canada',
      nameArb: 'كندا',
      flag: '🇨🇦',
      currency: 'CAD',
      language: 'English/French',
      minSalary: 55000,
      requiresWorkPermit: true,
      visaProcessingTime: '2-6 months',
    ),
    CountryInfo(
      name: 'France',
      nameArb: 'فرنسا',
      flag: '🇫🇷',
      currency: 'EUR',
      language: 'French',
      minSalary: 40000,
      requiresWorkPermit: true,
      visaProcessingTime: '3-6 weeks',
    ),
    CountryInfo(
      name: 'UK',
      nameArb: 'المملكة المتحدة',
      flag: '🇬🇧',
      currency: 'GBP',
      language: 'English',
      minSalary: 40000,
      requiresWorkPermit: true,
      visaProcessingTime: '3-8 weeks',
    ),
    CountryInfo(
      name: 'Netherlands',
      nameArb: 'هولندا',
      flag: '🇳🇱',
      currency: 'EUR',
      language: 'Dutch',
      minSalary: 45000,
      requiresWorkPermit: true,
      visaProcessingTime: '4-6 weeks',
    ),
  ];
}
