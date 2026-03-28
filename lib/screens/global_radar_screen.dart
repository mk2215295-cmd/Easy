import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../config/theme.dart';
import '../services/scraper_service.dart';
import '../models/job_model.dart';
import '../services/translation_engine.dart';
import 'job_details_screen.dart';

class GlobalRadarScreen extends StatefulWidget {
  const GlobalRadarScreen({super.key});

  @override
  State<GlobalRadarScreen> createState() => _GlobalRadarScreenState();
}

class _GlobalRadarScreenState extends State<GlobalRadarScreen> {
  String _selectedCountry = 'تركيا';
  bool _isLoading = false;
  final ScraperService _scraperService = ScraperService();
  final TranslationEngine _translationEngine = TranslationEngine();
  List<JobModel>? _jobs;

  final List<Map<String, String>> _countries = [
    {'name': 'تركيا', 'flag': '🇹🇷', 'code': 'turkey'},
    {'name': 'ألمانيا', 'flag': '🇩🇪', 'code': 'germany'},
    {'name': 'كندا', 'flag': '🇨🇦', 'code': 'canada'},
    {'name': 'فرنسا', 'flag': '🇫🇷', 'code': 'france'},
    {'name': 'هولندا', 'flag': '🇳🇱', 'code': 'netherlands'},
    {'name': 'بريطانيا', 'flag': '🇬🇧', 'code': 'uk'},
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
      _jobs = null;
    });

    try {
      final jobs = await _scraperService.fetchJobsFromAllSources(
        _selectedCountry,
      );

      final translatedJobs = <JobModel>[];
      for (var job in jobs) {
        final translated = await _translationEngine.translateJobDetails(
          title: job.title,
          description: job.description,
          requirements: job.requirements,
        );

        translatedJobs.add(
          JobModel(
            id: job.id,
            title: translated['title'] ?? job.title,
            company: job.company,
            location: job.location,
            country: job.country,
            description: job.description,
            descriptionArb: translated['description'] ?? job.descriptionArb,
            requirements: job.requirements,
            requirementsArb: translated['requirements'] ?? job.requirementsArb,
            salary: job.salary,
            currency: job.currency,
            workHours: job.workHours,
            isHousingProvided: job.isHousingProvided,
            isVisaSponsor: job.isVisaSponsor,
            languageRequired: job.languageRequired,
            jobType: job.jobType,
            source: job.source,
            postedDate: job.postedDate,
            isExclusive: job.isExclusive,
            applicationEmail: job.applicationEmail,
            benefits: job.benefits,
          ),
        );
      }

      setState(() {
        _jobs = translatedJobs;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ في جلب الوظائف: $e'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('رادار الوظائف العالمي'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadJobs),
          ],
        ),
        body: Column(
          children: [
            _buildCountrySelector(),
            _buildSearchBar(),
            Expanded(
              child: _isLoading
                  ? _buildLoadingShimmer()
                  : _jobs == null || _jobs!.isEmpty
                  ? _buildEmptyState()
                  : _buildJobsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          final country = _countries[index];
          final isSelected = _selectedCountry == country['name'];

          return GestureDetector(
            onTap: () {
              setState(() => _selectedCountry = country['name']!);
              _loadJobs();
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(left: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.accentPurple : AppTheme.cardDark,
                borderRadius: BorderRadius.circular(15),
                border: isSelected
                    ? Border.all(color: AppTheme.accentCyan, width: 2)
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(country['flag']!, style: const TextStyle(fontSize: 28)),
                  const SizedBox(height: 5),
                  Text(
                    country['name']!,
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppTheme.textGrey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(15),
        ),
        child: const TextField(
          style: TextStyle(color: AppTheme.textWhite),
          decoration: InputDecoration(
            hintText: 'ابحث عن وظيفة...',
            hintStyle: TextStyle(color: AppTheme.textGrey),
            prefixIcon: Icon(Icons.search, color: AppTheme.accentPurple),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingShimmer() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: AppTheme.cardDark,
          highlightColor: AppTheme.secondaryDark,
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            height: 120,
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 80, color: AppTheme.textGrey),
          const SizedBox(height: 20),
          Text(
            'لا توجد وظائف حالياً',
            style: TextStyle(fontSize: 18, color: AppTheme.textGrey),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            onPressed: _loadJobs,
            icon: const Icon(Icons.refresh),
            label: const Text('حاول مرة أخرى'),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _jobs!.length,
      itemBuilder: (context, index) {
        final job = _jobs![index];
        return _buildJobCard(job);
      },
    );
  }

  Widget _buildJobCard(JobModel job) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    job.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textWhite,
                    ),
                  ),
                ),
                if (job.isExclusive)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.accentCyan.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'حصري',
                      style: TextStyle(
                        fontSize: 10,
                        color: AppTheme.accentCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business, size: 16, color: AppTheme.textGrey),
                const SizedBox(width: 5),
                Text(job.company, style: TextStyle(color: AppTheme.textGrey)),
              ],
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.location_on, size: 16, color: AppTheme.textGrey),
                const SizedBox(width: 5),
                Text(
                  '${job.location} ${job.countryFlag}',
                  style: TextStyle(color: AppTheme.textGrey),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${job.salary} ${job.currency}',
                    style: const TextStyle(
                      color: AppTheme.accentGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Row(
                  children: [
                    _buildSmallChip(Icons.schedule, job.workHours),
                    const SizedBox(width: 8),
                    _buildSmallChip(
                      Icons.language,
                      job.languageRequired.split(' ').first,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: AppTheme.textGrey),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 10, color: AppTheme.textGrey)),
        ],
      ),
    );
  }
}
