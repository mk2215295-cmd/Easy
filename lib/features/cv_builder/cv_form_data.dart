// ════════════════════════════════════════════════════════════════════════════
// CvFormData
//
// Categorized taxonomy of White-Collar & Blue-Collar professions with
// bilingual labels (English & Arabic) and a comprehensive pool of 8-10
// bilingual suggested experience bullet points per profession.
//
// Bilingual Mapping:
//   • [textAr] is shown in the UI selection list when language is Arabic.
//   • [textEn] is the formal ATS English text inserted into the PDF/CV.
// ════════════════════════════════════════════════════════════════════════════

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

  /// Category name in Arabic (e.g. "الحرف الفنية والتقنية")
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

// ── Categorized Professions Database ──────────────────────────────────────────
const List<CvProfession> kProfessions = [
  // 1. 🛠️ Vocational & Technical Trades
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
        textAr: 'قراءة وتفسير المخططات الهندسية ورسومات التمديدات الكهربائية لتنفيذ المهام بدقة.',
      ),
      CvExperienceBullet(
        textEn: 'Performed preventive maintenance on industrial electrical systems, reducing unplanned downtime by 25%.',
        textAr: 'تنفيذ الصيانة الوقائية للأنظمة الكهربائية الصناعية، مما قلل من التوقف غير المخطط له بنسبة 25%.',
      ),
      CvExperienceBullet(
        textEn: 'Diagnosed and repaired electrical faults in high-voltage transformers, switchgears, and control panels.',
        textAr: 'تشخيص وإصلاح الأعطال الكهربائية في محولات الضغط العالي ولوحات التحكم والقطع.',
      ),
      CvExperienceBullet(
        textEn: 'Tested electrical systems and continuity using multimeters, megohmmeters, and insulation testers.',
        textAr: 'اختبار الأنظمة الكهربائية والاستمرارية باستخدام أجهزة الفولتميتر والميجوميتر وفحص العزل.',
      ),
      CvExperienceBullet(
        textEn: 'Installed cable trays, conduit systems, and junction boxes for commercial facilities.',
        textAr: 'تركيب مسارات الكابلات وأنظمة الأنابيب وصناديق التجميع في المنشآت التجارية.',
      ),
      CvExperienceBullet(
        textEn: 'Collaborated with project managers and site engineers to deliver electrical works on schedule.',
        textAr: 'التعاون مع مديري المشاريع ومهندسي الموقع لتسليم الأعمال الكهربائية في المواعيد المحتسبة.',
      ),
      CvExperienceBullet(
        textEn: 'Enforced zero-incident OSHA & CE safety protocols across all live wire installation sites.',
        textAr: 'تطبيق إجراءات السلامة المهنية وتجنب الحوادث في جميع مواقع العمل الكهربائية الحية.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Welder & Fabricator',
    titleAr: 'لحام ومشكّل معادن',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'الحرف الفنية والتقنية',
    emoji: '🛠️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Performed MIG, TIG and arc welding on structural steel and stainless steel components in manufacturing environments.',
        textAr: 'تنفيذ عمليات اللحام باستخدام MIG وTIG واللحام القوسي على الهياكل الفولاذية والمعادن.',
      ),
      CvExperienceBullet(
        textEn: 'Interpreted engineering drawings and welding symbols to produce precision welds meeting ISO 9001 quality standards.',
        textAr: 'قراءة ورسم رموز اللحام والمخططات الهندسية لإنتاج لحامات دقيقة تطابق معايير ISO 9001.',
      ),
      CvExperienceBullet(
        textEn: 'Inspected completed welds using visual and non-destructive testing (NDT) methods to ensure structural integrity.',
        textAr: 'فحص اللحامات المكتملة باستخدام الفحص البصري وااختبارات NDT غير المدمرة لضمان متانة الهيكل.',
      ),
      CvExperienceBullet(
        textEn: 'Operated angle grinders, cutting torches, plasma cutters, and fabrication tools with 100% precision.',
        textAr: 'تشغيل أدوات القطع بالبلازما والمجالخ ومعدات التشكيل بدقة عالية.',
      ),
      CvExperienceBullet(
        textEn: 'Fabricated heavy structural frames, tanks, and pressure piping to design specification.',
        textAr: 'تصنيع وتشكيل الهياكل المعدنية الثقيلة والخزانات وأنابيب الضغط وفقاً للمواصفات.',
      ),
      CvExperienceBullet(
        textEn: 'Set up welding parameters, shielding gas flow rates, and voltage according to metallurgy specs.',
        textAr: 'ضبط معدلات تدفق الغاز ومستويات الجهد الكهربائي وفقاً لمواصفات المعادن المعالجة.',
      ),
      CvExperienceBullet(
        textEn: 'Prepared metal surfaces by cleaning, beveling, and clamping parts prior to assembly.',
        textAr: 'تجهيز أسطح المعادن بالتنظيف والشطف والتثبيت قبل بدء عملية التجميع.',
      ),
      CvExperienceBullet(
        textEn: 'Strictly adhered to PPE, eye protection, and ventilation safety protocols on fabrication floors.',
        textAr: 'الالتزام الصارم بمعدات الحماية الشخصية وسلامة التهوية داخل ورش التصنيع.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Plumber & Pipefitter',
    titleAr: 'سباك وفني تمديدات صحية',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'الحرف الفنية والتقنية',
    emoji: '🛠️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Installed, inspected and repaired commercial and residential piping systems, water heaters and drainage infrastructure.',
        textAr: 'تركيب وفحص وإصلاح شبكات الأنابيب التجارية والسكنية وسخانات المياه والبنية التحتية للصرف.',
      ),
      CvExperienceBullet(
        textEn: 'Used pressure testing gauges to detect pipe leaks and ensured all installations met building regulatory standards.',
        textAr: 'استخدام أجهزة قياس الضغط لاكتشاف التسريبات وضمان مطابقة التمديدات للوائح البناء.',
      ),
      CvExperienceBullet(
        textEn: 'Replaced damaged valves, fittings and pumps in high-demand plumbing systems with zero unplanned shutdowns.',
        textAr: 'استبدال الصمامات والمضخات التالفة في شبكات المياه دون تعطيل خطوط الإمداد.',
      ),
      CvExperienceBullet(
        textEn: 'Coordinated with site managers to plan pipe routing, trenching, and material estimation for major renovations.',
        textAr: 'التنسيق مع مديري الموقع لتخطيط مسارات الأنابيب وحفر الخنادق وحساب كميات المواد.',
      ),
      CvExperienceBullet(
        textEn: 'Soldered, brazed, and threaded copper, PVC, PEX, and cast iron piping for water supply.',
        textAr: 'لحام وتلحيم وتثبيت أنابيب النحاس والـ PVC والحديد لشبكات التغذية.',
      ),
      CvExperienceBullet(
        textEn: 'Cleared complex blockages in main sewer lines using hydro-jetters and motor drain augers.',
        textAr: 'تسليك وتطهير الانسدادات المعقدة في خطوط المجاري الرئيسية باستخدام الضغط العالي والتجهيزات الآلية.',
      ),
      CvExperienceBullet(
        textEn: 'Installed sanitary fixtures, pumps, backflow preventers, and water filtration equipment.',
        textAr: 'تركيب الأدوات الصحية والمضخات ومعدات الفلترة وأجهزة منع التدفق العكسي.',
      ),
      CvExperienceBullet(
        textEn: 'Maintained detailed work orders, material logs, and safety inspection documentation.',
        textAr: 'توثيق أذونات العمل وسجلات المواد وفحوصات السلامة بشكل منتظم.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'HVAC Technician',
    titleAr: 'فني تكييف وتبريد',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'الحرف الفنية والتقنية',
    emoji: '🛠️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Installed, serviced and repaired central heating, ventilation and air conditioning (HVAC) systems in commercial buildings.',
        textAr: 'تركيب وصيانة وإصلاح أنظمة التكييف والتبريد المركزية والتهوية في المباني التجارية.',
      ),
      CvExperienceBullet(
        textEn: 'Recovered refrigerants and recharged systems according to F-Gas environmental regulations and safety standards.',
        textAr: 'استرجاع وسائط التبريد وإعادة شحن الأنظمة وفقاً للوائح البيئية والسلامة المعتمدة.',
      ),
      CvExperienceBullet(
        textEn: 'Diagnosed electrical and mechanical faults in chillers, air handling units (AHUs) and compressors.',
        textAr: 'تشخيص الأعطال الكهربائية والميكانيكية في المبردات (Chillers) ووحدات مناولة الهواء والضواغط.',
      ),
      CvExperienceBullet(
        textEn: 'Executed scheduled preventive maintenance contracts, improving system energy efficiency by 18%.',
        textAr: 'تنفيذ عقود الصيانة الوقائية الدورية مما ساهم في تحسين كفاءة استهلاك الطاقة بنسبة 18%.',
      ),
      CvExperienceBullet(
        textEn: 'Replaced failed fan motors, expansion valves, thermostats, and circuit boards.',
        textAr: 'استبدال محركات المروحيات وصمامات التمدد وثرموستات ولوحات التحكم التالفة.',
      ),
      CvExperienceBullet(
        textEn: 'Inspected and cleaned ductwork, air filters, and evaporator coils to optimize indoor air quality.',
        textAr: 'تنظيف وفحص مجاري الهواء والفلاتر ومبخرات التبريد لضمان جودة الهواء الداخلي.',
      ),
      CvExperienceBullet(
        textEn: 'Programmed digital building management thermostats and automated HVAC controllers.',
        textAr: 'برمجة أنظمة التحكم الرقمي والـ Thermostat التلقائي لإنعاش كفاءة التبريد.',
      ),
      CvExperienceBullet(
        textEn: 'Completed emergency field service calls with a 95% first-visit resolution rate.',
        textAr: 'الاستجابة لنداءات الصيانة الطارئة وإصلاح المشاكل من الزيارة الأولى بنسبة 95%.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Automotive Mechanic',
    titleAr: 'ميكانيكي سيارات وآلات',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'الحرف الفنية والتقنية',
    emoji: '🛠️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Diagnosed engine, transmission, brake and electrical faults using OBD-II computer diagnostic tools.',
        textAr: 'تشخيص أعطال المحركات وعلب التروس والمكابح باستخدام أجهزة الفحص الكمبيوتري OBD-II.',
      ),
      CvExperienceBullet(
        textEn: 'Performed complete vehicle overhauls, timing belt replacements and suspension tuning on diverse vehicle fleets.',
        textAr: 'إجراء العمرات الكاملة للمحركات وتغيير سيور التوقيت وتعديل أنظمة التعليق لأسطول السيارات.',
      ),
      CvExperienceBullet(
        textEn: 'Maintained daily service logs, estimated repair costs and communicated technical solutions clearly to clients.',
        textAr: 'الاحتفاظ بسجلات الخدمة اليومية وتقدير تكاليف الإصلاح وشرح الحلول التقنية للعملاء.',
      ),
      CvExperienceBullet(
        textEn: 'Replaced worn brake pads, rotors, shocks, struts, and steering linkages.',
        textAr: 'استبدال فحمات المكابح والأقراص والمساعدين وأنظمة التوجيه التالفة.',
      ),
      CvExperienceBullet(
        textEn: 'Flushed and refilled transmission fluids, engine oils, coolants, and brake hydraulic lines.',
        textAr: 'تغيير وغسيل زيوت المحرك وسوائل التبريد وزيوت الفرامل والهيدروليك.',
      ),
      CvExperienceBullet(
        textEn: 'Balanced wheels, performed 4-wheel alignment, and mounted commercial tires.',
        textAr: 'ضبط زوايا العجلات الأربع وترصيص الإطارات وصيانتها.',
      ),
      CvExperienceBullet(
        textEn: 'Enforced shop safety standards and proper disposal of hazardous automotive fluids and batteries.',
        textAr: 'تطبيق معايير السلامة داخل الورشة والتخلص الآمن من بطاريات وزيوت السيارات.',
      ),
      CvExperienceBullet(
        textEn: 'Conducted pre-purchase and pre-inspection safety testing for passenger and commercial vehicles.',
        textAr: 'إجراء فحوصات الشاملة والسلامة الفنية للسيارات قبل الفحص الدوري.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Factory Operator & Technician',
    titleAr: 'مشغل وفني مصنع',
    categoryEn: 'Vocational & Technical Trades',
    categoryAr: 'الحرف الفنية والتقنية',
    emoji: '🛠️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Operated and maintained automated production line machinery, ensuring continuous output at target efficiency rates.',
        textAr: 'تشغيل وصيانة خطوط الإنتاج الآلية وضمان استمرارية التشغيل بمعدلات الكفاءة المستهدفة.',
      ),
      CvExperienceBullet(
        textEn: 'Conducted routine inspections and preventive maintenance on CNC machines, conveyors and hydraulic equipment.',
        textAr: 'إجراء الفحوصات الدورية والصيانة الوقائية لآلات CNC والسيور الناقلة والأنظمة الهيدروليكية.',
      ),
      CvExperienceBullet(
        textEn: 'Diagnosed mechanical and electrical faults, reducing average repair downtime from 4 hours to under 90 minutes.',
        textAr: 'تشخيص الأعطال الميكانيكية والكهربائية وتقليل زمن التوقف من 4 ساعات إلى أقل من 90 دقيقة.',
      ),
      CvExperienceBullet(
        textEn: 'Adhered to ISO quality control procedures and logged all maintenance activities in the CMMS system.',
        textAr: 'الالتزام بمعايير جودة ISO وتسجيل جميع أنشطة الصيانة في نظام CMMS.',
      ),
      CvExperienceBullet(
        textEn: 'Adjusted machine calibration parameters and tooling setups according to production batch specifications.',
        textAr: 'ضبط إعدادات كاليبراتور الآلات والقوالب وفقاً لمواصفات دفعة الإنتاج.',
      ),
      CvExperienceBullet(
        textEn: 'Monitored raw material feed lines to prevent blockages and line starvation.',
        textAr: 'مراقبة خطوط تغذية المواد الخام لمنع الانحشار أو توقف التدفق.',
      ),
      CvExperienceBullet(
        textEn: 'Enforced strict 5S shop-floor organization and machine safety guards compliance.',
        textAr: 'تطبيق منهجية 5S لترتيب بيئة العمل والالتزام بحواجز الحماية التلقائية.',
      ),
      CvExperienceBullet(
        textEn: 'Trained junior machine operators on emergency shut-off protocols and shift handovers.',
        textAr: 'تدريب المشغلين الجدد على إجراءات الإيقاف الطارئ وتسليم الورديات.',
      ),
    ],
  ),

  // 2. 💻 Tech & Engineering
  CvProfession(
    titleEn: 'Software Engineer',
    titleAr: 'مهندس برمجيات',
    categoryEn: 'Tech, Engineering & Business',
    categoryAr: 'التكنولوجيا والهندسة والأعمال',
    emoji: '💻',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Architected and deployed scalable RESTful microservices and backend web applications using modern cloud frameworks.',
        textAr: 'تصميم وتطوير الخدمات المصغرة والتطبيقات السحابية القابلة للتوسع.',
      ),
      CvExperienceBullet(
        textEn: 'Wrote clean, testable codebase backed by CI/CD pipelines, unit testing and automated integration tests.',
        textAr: 'كتابة كود برمجي نظيف مدعوم باختبارات الوحدة والتكامل وأنابيب التجميع الآلي CI/CD.',
      ),
      CvExperienceBullet(
        textEn: 'Collaborated in Agile/Scrum sprint teams to ship enterprise features on time with zero high-severity production bugs.',
        textAr: 'العمل ضمن فرق Agile/Scrum لتسليم الميزات البرمجية في مواعيدها بدون أخطاء.',
      ),
      CvExperienceBullet(
        textEn: 'Optimized database queries and API response latencies by 35% across high-traffic platforms.',
        textAr: 'تحسين استعلامات قواعد البيانات واستجابة الـ API بنسبة 35% على المنصات عالية الزيارات.',
      ),
      CvExperienceBullet(
        textEn: 'Integrated OAuth2, JWT, and third-party RESTful APIs with strict security protocols.',
        textAr: 'دمج بروتوكولات الأمان OAuth2 و JWT والواجهات البرمجية الخارجية بأعلى معايير الحماية.',
      ),
      CvExperienceBullet(
        textEn: 'Monitored system health using Prometheus, Grafana, and cloud logging dashboards.',
        textAr: 'مراقبة أداء الخوادم واستقرار النظام باستخدام أدوات المراقبة والسجلات السحابية.',
      ),
      CvExperienceBullet(
        textEn: 'Conducted peer code reviews to enforce software architecture patterns and coding guidelines.',
        textAr: 'مراجعة الكود البرمجي للأقران لضمان الالتزام بأنماط المعمارية والمعايير القياسية.',
      ),
      CvExperienceBullet(
        textEn: 'Refactored legacy monolithic services into modular maintainable components.',
        textAr: 'إعادة هيكلة البرامج القديمة إلى مكونات برمجية حديثة وسهولة الصيانة.',
      ),
    ],
  ),
  CvProfession(
    titleEn: 'Flutter & Mobile Developer',
    titleAr: 'مطور تطبيقات فلاتر وجوال',
    categoryEn: 'Tech, Engineering & Business',
    categoryAr: 'التكنولوجيا والهندسة والأعمال',
    emoji: '💻',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Built cross-platform iOS & Android mobile applications using Flutter & Dart with clean architecture and Provider/Bloc.',
        textAr: 'تطوير تطبيقات جوال تعمل على iOS و Android باستخدام Flutter و Dart وإدارة الحالة.',
      ),
      CvExperienceBullet(
        textEn: 'Integrated Firebase Auth, Cloud Firestore, REST APIs and OAuth providers for seamless user authentication.',
        textAr: 'دمج خدمات المصادقة من Firebase و Firestore والواجهات البرمجية لربط المستخدمين.',
      ),
      CvExperienceBullet(
        textEn: 'Implemented responsive pixel-perfect UI layouts and custom smooth micro-animations.',
        textAr: 'بناء واجهات مستخدم متجاوبة عالية الدقة مع حركات وتأثيرات تفاعلية سلسة.',
      ),
      CvExperienceBullet(
        textEn: 'Published and maintained applications on Apple App Store & Google Play Store.',
        textAr: 'رفع ونشر وصيانة التطبيقات على متجري App Store و Google Play.',
      ),
      CvExperienceBullet(
        textEn: 'Implemented offline data caching using Hive, SQLite, and Shared Preferences.',
        textAr: 'تفعيل التخزين المحلي المؤقت للبيانات لضمان عمل التطبيق بدون اتصال بالإنترنت.',
      ),
      CvExperienceBullet(
        textEn: 'Integrated push notifications, deep linking, and in-app analytics tracking.',
        textAr: 'دمج التنبيهات الفورية والروابط العميقة وأدوات تحليلات استخدام التطبيق.',
      ),
      CvExperienceBullet(
        textEn: 'Reduced mobile app bundle size by 30% through asset optimization and tree-shaking.',
        textAr: 'تقليل حجم ملف التطبيق بنسبة 30% عبر تحسين الوسائط وضغط العناصر.',
      ),
      CvExperienceBullet(
        textEn: 'Handled app localization (RTL & LTR) for multi-language global deployment.',
        textAr: 'دعم التوطين واللغات متعددة الاتجاهات (RTL/LTR) للنشر العالمي.',
      ),
    ],
  ),
  
  // 3. 🏗️ Construction & Logistics
  CvProfession(
    titleEn: 'Construction Worker',
    titleAr: 'عامل بناء',
    categoryEn: 'Construction & Logistics',
    categoryAr: 'البناء واللوجستيات',
    emoji: '🏗️',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Assisted in the erection of scaffolding and operation of heavy construction equipment.',
        textAr: 'المساعدة في نصب السقالات وتشغيل معدات البناء الثقيلة.',
      ),
    ],
  ),
  
  // 4. 🏨 Hospitality, Services & Agriculture
  CvProfession(
    titleEn: 'Customer Service Representative',
    titleAr: 'ممثل خدمة العملاء',
    categoryEn: 'Hospitality, Services & Agriculture',
    categoryAr: 'الضيافة والخدمات والزراعة',
    emoji: '🏨',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Resolved customer inquiries and maintained high satisfaction ratings.',
        textAr: 'حل استفسارات العملاء والحفاظ على معدلات رضا عالية.',
      ),
    ],
  ),
  
  // 5. 🏥 Healthcare & Science
  CvProfession(
    titleEn: 'Registered Nurse',
    titleAr: 'ممرض مسجل',
    categoryEn: 'Healthcare & Science',
    categoryAr: 'الرعاية الصحية والعلوم',
    emoji: '🏥',
    suggestedBullets: [
      CvExperienceBullet(
        textEn: 'Provided exceptional patient care and assisted in clinical procedures.',
        textAr: 'تقديم رعاية متميزة للمرضى والمساعدة في الإجراءات السريرية.',
      ),
    ],
  ),
  
  // 6. 📊 Business, Sales & Admin
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

// ── Categorized list generator ────────────────────────────────────────────────
final List<CvProfessionCategory> kProfessionCategories = [
  CvProfessionCategory(
    id: 'trades',
    titleEn: 'Vocational & Technical Trades',
    titleAr: '🛠️ الحرف الفنية والتقنية',
    emoji: '🛠️',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('الحرف') || p.categoryEn.contains('Trades'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'construction',
    titleEn: 'Construction & Logistics',
    titleAr: '🏗️ البناء واللوجستيات',
    emoji: '🏗️',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('البناء') ||
            p.categoryEn.contains('Construction'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'hospitality',
    titleEn: 'Hospitality, Services & Agriculture',
    titleAr: '🏨 الضيافة والخدمات والزراعة',
    emoji: '🏨',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('الضيافة') ||
            p.categoryEn.contains('Hospitality'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'tech',
    titleEn: 'Tech, Engineering & Business',
    titleAr: '💻 التقنية والهندسة والأعمال',
    emoji: '💻',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('التقنية') ||
            p.categoryEn.contains('Tech'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'healthcare',
    titleEn: 'Healthcare & Science',
    titleAr: '🏥 الرعاية الصحية والعلوم',
    emoji: '🏥',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('الرعاية') ||
            p.categoryEn.contains('Healthcare'))
        .toList(),
  ),
  CvProfessionCategory(
    id: 'business',
    titleEn: 'Business, Sales & Admin',
    titleAr: '📊 إدارة الأعمال والمبيعات',
    emoji: '📊',
    professions: kProfessions
        .where((p) =>
            p.categoryAr.contains('إدارة') ||
            p.categoryEn.contains('Business'))
        .toList(),
  ),
];

const List<String> kCountries = [
  'السعودية',
  'الإمارات',
  'مصر',
  'الكويت',
  'قطر',
  'البحرين',
  'عمان',
  'الأردن',
  'لبنان',
  'الجزائر',
  'المغرب',
  'تونس',
  'ألمانيا',
  'فرنسا',
  'إيطاليا',
  'إسبانيا',
  'هولندا',
  'النمسا',
  'بلجيكا',
  'اليونان',
  'السويد',
  'أيرلندا',
  'الدنمارك',
  'النرويج',
  'البرتغال',
  'المملكة المتحدة',
  'الولايات المتحدة',
  'كندا',
  'أستراليا',
];

const Map<String, List<String>> kCountryCityMap = {
  'السعودية': ['الرياض', 'جدة', 'الدمام', 'مكة', 'المدينة المنورة'],
  'الإمارات': ['دبي', 'أبو ظبي', 'الشارقة', 'العين'],
  'مصر': ['القاهرة', 'الإسكندرية', 'الجيزة', 'شرم الشيخ'],
  'الكويت': ['مدينة الكويت', 'الأحمدي', 'حولي', 'السالمية'],
  'قطر': ['الدوحة', 'الريان', 'الوكرة'],
  'البحرين': ['المنامة', 'المحرق', 'الرفاع'],
  'عمان': ['مسقط', 'صلالة', 'صحار'],
  'الأردن': ['عمان', 'إربد', 'الزرقاء', 'العقبة'],
  'لبنان': ['بيروت', 'طرابلس', 'صيدا'],
  'الجزائر': ['الجزائر العاصمة', 'وهران', 'قسنطينة'],
  'المغرب': ['الدار البيضاء', 'الرباط', 'مراكش', 'طنجة'],
  'تونس': ['تونس العاصمة', 'صفاقس', 'سوسة'],
  'ألمانيا': ['برلين', 'ميونخ', 'فرانكفورت', 'هامبورغ', 'كولونيا'],
  'فرنسا': ['باريس', 'ليون', 'مارسيليا', 'تولوز'],
  'إيطاليا': ['روما', 'ميلانو', 'نابولي', 'تورينو'],
  'إسبانيا': ['مدريد', 'برشلونة', 'فالنسيا', 'إشبيلية'],
  'هولندا': ['أمستردام', 'روتردام', 'لاهاي', 'أوتريخت'],
  'النمسا': ['فيينا', 'سالزبورغ', 'غراتس'],
  'بلجيكا': ['بروكسل', 'أنتويرب', 'غنت'],
  'اليونان': ['أثينا', 'سالونيك', 'باتراس'],
  'السويد': ['ستوكهولم', 'غوتنبرغ', 'مالمو'],
  'أيرلندا': ['دبلن', 'كورك', 'غالواي'],
  'الدنمارك': ['كوبنهاغن', 'آرهوس'],
  'النرويج': ['أوسلو', 'بيرغن'],
  'البرتغال': ['لشبونة', 'بورتو'],
  'المملكة المتحدة': ['لندن', 'مانشستر', 'برمنغهام', 'غلاسكو'],
  'الولايات المتحدة': ['نيويورك', 'لوس أنجلوس', 'شيكاغو', 'هيوستن'],
  'كندا': ['تورونتو', 'فانكوفر', 'مونتريال', 'كالجاري'],
  'أستراليا': ['سيدني', 'ملبورن', 'بريزبان', 'بيرث'],
};
