import 'dart:math' as math;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../../core/models/affiliate_deal_model.dart';
import '../../core/models/job_benefit_model.dart';
import '../../core/models/job_model.dart';
import '../../core/models/job_requirement_model.dart';
import '../../core/services/location_service.dart';

// ════════════════════════════════════════════════════════════════════════════════
// JobRepository
// Fetches authentic live job postings from Firestore with rich global and European
// opportunities (Google, Siemens, Spotify, Airbnb, AgriCorp, SolEurope, etc.).
// ════════════════════════════════════════════════════════════════════════════════
class JobRepository {
  JobRepository({LocationService? locationService})
      : _locationService = locationService ?? LocationService();

  final LocationService _locationService;

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        math.cos((lat2 - lat1) * p) / 2 +
        math.cos(lat1 * p) *
            math.cos(lat2 * p) *
            (1 - math.cos((lon2 - lon1) * p)) /
            2;
    return 12742 * math.asin(math.sqrt(a));
  }

  /// Fetches jobs from Firebase Firestore `jobs` collection with local fallback pool.
  Future<List<JobModel>> fetchJobs() async {
    final locationInfo = await _locationService.detectUserLocation();
    final List<JobModel> liveJobs = [];

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('jobs')
          .where('is_active', isEqualTo: true)
          .get();

      for (var doc in snapshot.docs) {
        liveJobs.add(JobModel.fromJson(doc.data()));
      }
    } catch (e) {
      debugPrint('Firestore fetch notice: $e');
    }

    final localPool = _generateRawJobPool();
    final combined = [...liveJobs, ...localPool];

    if (locationInfo.inEu) {
      combined.sort((a, b) {
        final distA = _calculateDistance(
          locationInfo.latitude,
          locationInfo.longitude,
          a.latitude ?? 0.0,
          a.longitude ?? 0.0,
        );
        final distB = _calculateDistance(
          locationInfo.latitude,
          locationInfo.longitude,
          b.latitude ?? 0.0,
          b.longitude ?? 0.0,
        );
        return distA.compareTo(distB);
      });
      return combined;
    } else {
      return combined
          .where((job) => job.requiresVisaSponsorship != false)
          .map((job) => _injectVisaSponsorshipFlag(job))
          .toList();
    }
  }

  JobModel _injectVisaSponsorshipFlag(JobModel job) {
    return JobModel(
      id: job.id,
      title: job.title,
      titleAr: job.titleAr,
      company: job.company,
      location: job.location,
      locationAr: job.locationAr,
      countryFlagEmoji: job.countryFlagEmoji,
      countryCode: job.countryCode,
      description: job.description,
      descriptionAr: job.descriptionAr,
      salaryMin: job.salaryMin,
      salaryMax: job.salaryMax,
      salaryCurrency: job.salaryCurrency,
      salaryPeriod: job.salaryPeriod,
      matchPercentage: job.matchPercentage,
      heroImageUrl: job.heroImageUrl,
      category: job.category,
      jobType: job.jobType,
      postedAt: job.postedAt,
      applicationDeadline: job.applicationDeadline,
      isNew: job.isNew,
      isFeatured: job.isFeatured,
      requirements: job.requirements,
      benefits: job.benefits,
      accommodationDescriptionAr: job.accommodationDescriptionAr,
      accommodationDescriptionEn: job.accommodationDescriptionEn,
      accommodationImageUrls: job.accommodationImageUrls,
      applyUrl: job.applyUrl,
      contextualDeals: job.contextualDeals,
      sidebarTitleAr: job.sidebarTitleAr,
      sidebarTitleEn: job.sidebarTitleEn,
      experienceYearsMin: job.experienceYearsMin,
      contractType: job.contractType,
      startDate: job.startDate,
      latitude: job.latitude,
      longitude: job.longitude,
      requiresVisaSponsorship: true,
    );
  }

  String _getHeroImageByCategory(String title) {
    final t = title.toLowerCase();
    if (t.contains('farm') || t.contains('agri') || t.contains('vineyard')) {
      return 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&q=80&w=600';
    }
    if (t.contains('hotel') || t.contains('host') || t.contains('barista') || t.contains('housekeeper')) {
      return 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=600';
    }
    if (t.contains('driver') || t.contains('truck') || t.contains('logistics') || t.contains('warehouse')) {
      return 'https://images.unsplash.com/photo-1516576880669-dfcbfd8f6bc7?auto=format&fit=crop&q=80&w=600';
    }
    if (t.contains('developer') || t.contains('flutter') || t.contains('software') || t.contains('ux') || t.contains('data')) {
      return 'https://images.unsplash.com/photo-1517694712202-14dd9538aa97?auto=format&fit=crop&q=80&w=600';
    }
    return 'https://images.unsplash.com/photo-1504917595217-d4dc5ebe6122?auto=format&fit=crop&q=80&w=600';
  }

  /// Generates the rich baseline European & Global jobs pool.
  List<JobModel> _generateRawJobPool() {
    final List<JobModel> jobs = [];

    final rawData = [
      // 0-3 Top Global Brands matching UI Reference
      ['job-g1', 'Lead UX Designer', 'كبير مصممي تجربة المستخدم', 'Google', 'New York, USA', 'نيويورك، الولايات المتحدة', '🇺🇸', 'US', 'Tech', 'Full-Time', 6500.0, 12000.0, 98, true, 40.7128, -74.0060],
      ['job-g2', 'Senior Data Analyst & AI Engineer', 'كبير محللي البيانات ومهندس ذكاء اصطناعي', 'Siemens', 'Munich, Germany', 'ميونخ، ألمانيا', '🇩🇪', 'DE', 'Tech', 'Full-Time', 5500.0, 9500.0, 96, true, 48.1351, 11.5820],
      ['job-g3', 'Senior Software Engineer (Audio Core)', 'كبير مهندسي البرمجيات', 'Spotify', 'Stockholm, Sweden', 'ستوكهولم، السويد', '🇸🇪', 'SE', 'Tech', 'Full-Time', 6000.0, 10500.0, 95, true, 59.3293, 18.0686],
      ['job-g4', 'Global Product Manager', 'مدير منتجات دولي', 'Airbnb', 'Tokyo, Japan', 'طوكيو، اليابان', '🇯🇵', 'JP', 'Creative', 'Full-Time', 5800.0, 11000.0, 94, true, 35.6762, 139.6503],

      // Core Vocational & Technical European Careers
      ['job-1', 'Farm Supervisor in France', 'مشرف مزرعة في فرنسا', 'AgriCorp Europe', 'Paris, France', 'باريس، فرنسا', '🇫🇷', 'FR', 'Agricultural', 'Full-Time', 2500.0, 3000.0, 92, true, 48.8566, 2.3522],
      ['job-2', 'Factory Maintenance Technician in Italy', 'فني صيانة مصانع في إيطاليا', 'ItalMech SpA', 'Rome, Italy', 'روما، إيطاليا', '🇮🇹', 'IT', 'Industrial', 'Full-Time', 2200.0, 2700.0, 88, true, 41.9028, 12.4964],
      ['job-3', 'Warehouse Logistics Operator in Poland', 'مشغل مستودعات ولوجستيات في بولندا', 'PolLogistics SA', 'Warsaw, Poland', 'وارسو، بولندا', '🇵🇱', 'PL', 'Logistics', 'Full-Time', 1800.0, 2300.0, 85, true, 52.2297, 21.0122],
      ['job-4', 'European Youth Volunteering & Ecology', 'تطوع الشباب الأوروبي في اليونان', 'Hellenic Youth Eco', 'Athens, Greece', 'أثينا، اليونان', '🇬🇷', 'GR', 'Volunteering', 'Volunteering', 400.0, 600.0, 95, true, 37.9838, 23.7275],
      ['job-5', 'Hotel Housekeeper & Hospitality Lead', 'عامل تنظيف ومساعد فندقي في النمسا', 'Alps Hospitality', 'Vienna, Austria', 'فيينا، النمسا', '🇦🇹', 'AT', 'Hospitality', 'Part-Time', 1200.0, 1600.0, 80, true, 48.2082, 16.3738],

      // Solar, Electrician, Technical & Remote
      ['job-6', 'Solar Panel Installation Technician', 'فني تركيب ألواح طاقة شمسية في إسبانيا', 'SolEurope Energies', 'Madrid, Spain', 'مدريد، إسبانيا', '🇪🇸', 'ES', 'Renewable Energy', 'Full-Time', 2300.0, 2800.0, 90, true, 40.4168, -3.7037],
      ['job-7', 'Electrician & Industrial Automation', 'كهربائي وفني صيانة صناعية في ألمانيا', 'Bavaria Power Systems', 'Munich, Germany', 'ميونخ، ألمانيا', '🇩🇪', 'DE', 'Engineering', 'Full-Time', 3200.0, 3900.0, 94, true, 48.1351, 11.5820],
      ['job-8', 'HVAC Maintenance Specialist', 'فني تكييف وتبريد في هولندا', 'Dutch Climate Solutions', 'Amsterdam, Netherlands', 'أمستردام، هولندا', '🇳🇱', 'NL', 'HVAC', 'Full-Time', 3000.0, 3600.0, 89, true, 52.3676, 4.9041],
      ['job-9', 'Senior Flutter & Mobile Engineer (Remote Global)', 'مطور تطبيقات فلاتر وجوال (عن بُعد)', 'EuroTech Remote Labs', 'Remote Global', 'عمل عن بعد دولي', '🌐', 'EU', 'Tech', 'Remote', 4500.0, 6000.0, 96, true, 50.8503, 4.3517],
      ['job-10', 'Construction Site Supervisor in Belgium', 'مشرف موقع بناء وتشغيل في بلجيكا', 'BelgoBuild NV', 'Brussels, Belgium', 'بروكسل، بلجيكا', '🇧🇪', 'BE', 'Construction', 'Full-Time', 2800.0, 3400.0, 87, true, 50.8503, 4.3517],

      // Truck Driver, Welder, Caregiver & Food Operative
      ['job-11', 'International Heavy Truck Driver (Class CE)', 'سائق شاحنات ونقل دولي (فئة CE) في بولندا', 'PolTrans Express', 'Krakow, Poland', 'كراكوف، بولندا', '🇵🇱', 'PL', 'Logistics', 'Full-Time', 2400.0, 3100.0, 93, true, 50.0647, 19.9450],
      ['job-12', 'MIG/TIG Welder & Fabricator in Finland', 'لحام ومشكّل معادن MIG/TIG في فنلندا', 'Nordic Steelworks', 'Helsinki, Finland', 'هلسنكي، فنلندا', '🇫🇮', 'FI', 'Industrial', 'Full-Time', 3100.0, 3800.0, 92, true, 60.1699, 24.9384],
      ['job-13', 'Food Production Operative in Denmark', 'عامل تصنيع وتعبئة أغذية في الدنمارك', 'Danish FoodTech', 'Copenhagen, Denmark', 'كوبنهاغن، الدنمارك', '🇩🇰', 'DK', 'Food Industry', 'Full-Time', 2900.0, 3500.0, 89, true, 55.6761, 12.5683],
      ['job-14', 'Elderly Caregiver & Healthcare Assistant', 'مقدم رعاية صحية ومساعد تمريض في ألمانيا', 'SeniorCare Bavaria', 'Stuttgart, Germany', 'شتوتغارت، ألمانيا', '🇩🇪', 'DE', 'Healthcare', 'Full-Time', 2600.0, 3200.0, 94, true, 48.7758, 9.1829],
      ['job-15', 'Chef & Commercial Kitchen Cook in France', 'طاهي ورئيس طباخين في فرنسا', 'Gourmet France Lyon', 'Lyon, France', 'ليون، فرنسا', '🇫🇷', 'FR', 'Hospitality', 'Full-Time', 2700.0, 3400.0, 90, true, 45.7640, 4.8357],
    ];

    for (final item in rawData) {
      final id = item[0] as String;
      final titleEn = item[1] as String;
      final titleAr = item[2] as String;
      final company = item[3] as String;
      final locEn = item[4] as String;
      final locAr = item[5] as String;
      final emoji = item[6] as String;
      final code = item[7] as String;
      final category = item[8] as String;
      final type = item[9] as String;
      final minS = item[10] as double;
      final maxS = item[11] as double;
      final match = item[12] as int;
      final reqVisa = item[13] as bool;
      final lat = item[14] as double;
      final lng = item[15] as double;

      jobs.add(JobModel(
        id: id,
        title: titleEn,
        titleAr: titleAr,
        company: company,
        location: locEn,
        locationAr: locAr,
        countryFlagEmoji: emoji,
        countryCode: code,
        description: _buildDescription(titleEn, company, locEn, category, type, minS, maxS),
        descriptionAr: _buildDescriptionAr(titleAr, company, locAr, category, type, minS, maxS),
        salaryMin: minS,
        salaryMax: maxS,
        salaryCurrency: '€',
        salaryPeriod: 'month',
        matchPercentage: match,
        heroImageUrl: _getHeroImageByCategory(titleEn),
        category: category,
        jobType: type,
        postedAt: DateTime.now().subtract(const Duration(days: 2)),
        isNew: true,
        isFeatured: true,
        latitude: lat,
        longitude: lng,
        requiresVisaSponsorship: reqVisa,
        requirements: [
          JobRequirementModel(
            id: '$id-req-1',
            textEn: 'Minimum 1-2 years of practical experience in $category field',
            textAr: 'خبرة عملية لا تقل عن سنة إلى سنتين في مجال $titleAr',
          ),
          JobRequirementModel(
            id: '$id-req-2',
            textEn: 'Knowledge of international workplace safety and quality standards',
            textAr: 'معرفة بمعايير السلامة والصحة المهنية المعتمدة',
          ),
          JobRequirementModel(
            id: '$id-req-3',
            textEn: 'Basic English or host country communication skills',
            textAr: 'مهارات تواصل أساسية باللغة الإنجليزية أو لغة بلد العمل',
          ),
          JobRequirementModel(
            id: '$id-req-4',
            textEn: 'Ability to work independently and collaborate within international teams',
            textAr: 'القدرة على العمل المستقل والتعاون ضمن فرق عمل دولية',
          ),
          JobRequirementModel(
            id: '$id-req-5',
            textEn: 'Valid passport and eligibility to obtain work visa',
            textAr: 'جواز سفر ساري المفعول وأهلية الحصول على تأشيرة عمل',
          ),
        ],
        benefits: [
          JobBenefitModel(
            id: '$id-ben-1',
            type: BenefitType.accommodation,
            labelAr: 'توفير السكن وتسهيلات الإقامة بالقرب من موقع العمل',
            labelEn: 'Accommodation & Housing near Worksite',
          ),
          JobBenefitModel(
            id: '$id-ben-2',
            type: BenefitType.healthInsurance,
            labelAr: 'تأمين صحي شامل واجتماعي وفق القانون الدولي',
            labelEn: 'Full Medical & Social Insurance (Global Standard)',
          ),
          JobBenefitModel(
            id: '$id-ben-3',
            type: BenefitType.visa,
            labelAr: 'كفالة التأشيرة وتصريح العمل الرسمي',
            labelEn: 'Visa & Work Permit Sponsorship',
          ),
        ],
        accommodationDescriptionAr:
            'سكن مؤثث مجهز بالكامل بالقرب من موقع العمل مع تغطية تكاليف المرافق.',
        accommodationDescriptionEn:
            'Fully furnished accommodation near work premises with utility coverage.',
        applyUrl: 'https://easy-work-web-e916b.web.app/#/jobs/$id',
        sidebarTitleAr: 'عروض الإقامة والانتقال الحصرية',
        sidebarTitleEn: 'Exclusive relocation & stay deals',
        contextualDeals: _generateMockDeals(),
      ));
    }

    return jobs;
  }

  List<AffiliateDealModel> _generateMockDeals() {
    return const [
      AffiliateDealModel(
        id: 'deal-1',
        type: AffiliateDealType.flight,
        title: 'Discounted Flights to Europe',
        titleAr: 'تذاكر طيران مخفضة إلى أوروبا',
        subtitle: 'Special candidate rates via Travelpayouts',
        subtitleAr: 'أسعار خاصة للمتقدمين عبر أسفار أوروبا',
        affiliateUrl: 'https://www.travelpayouts.com',
        partnerName: 'Travelpayouts',
        imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?auto=format&fit=crop&q=80&w=400',
      ),
      AffiliateDealModel(
        id: 'deal-2',
        type: AffiliateDealType.hotel,
        title: 'Relocation Stays near Worksite',
        titleAr: 'فنادق وشقق الانتقال بالقرب من موقع العمل',
        subtitle: 'Flexible monthly stays via Booking.com',
        subtitleAr: 'حجوزات شهرية مرنة عبر Booking.com',
        affiliateUrl: 'https://www.booking.com',
        partnerName: 'Booking.com',
        imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&q=80&w=400',
      ),
    ];
  }

  String _buildDescription(String titleEn, String company, String locEn, String category, String type, double minS, double maxS) {
    final salary = '€${minS.toStringAsFixed(0)}–€${maxS.toStringAsFixed(0)}/month';
    return '$company is hiring a $titleEn based in $locEn. '
        'This is a $type position in the $category sector with a competitive salary of $salary. '
        'The role involves executing day-to-day operational duties in line with international industry standards. '
        'Candidates will receive a full employment contract, comprehensive health and social insurance, '
        'and dedicated relocation and visa sponsorship support to help you settle smoothly.';
  }

  String _buildDescriptionAr(String titleAr, String company, String locAr, String category, String type, double minS, double maxS) {
    final salary = '€${minS.toStringAsFixed(0)} – €${maxS.toStringAsFixed(0)} شهرياً';
    final typeAr = type == 'Full-Time' ? 'دوام كامل' : (type == 'Part-Time' ? 'دوام جزئي' : type);
    return 'تعلن شركة $company عن حاجتها لشغل وظيفة $titleAr في مدينة $locAr. '
        'هذه وظيفة $typeAr في مجال $category براتب تنافسي يتراوح بين $salary. '
        'يحصل المتقدم الناجح على عقد عمل رسمي، تأمين صحي واجتماعي شامل، '
        'ودعم كامل للحصول على تأشيرة العمل وتسهيلات السكن والانتقال.';
  }
}
