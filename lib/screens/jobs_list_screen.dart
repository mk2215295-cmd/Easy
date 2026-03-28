import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/theme.dart';
import '../models/job_model.dart';
import 'job_details_screen.dart';

class JobsListScreen extends StatefulWidget {
  const JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<JobModel> _jobs = [];
  bool _isLoading = true;
  String _selectedCountry = 'all';
  String _selectedFilter = 'الكل';

  final List<String> _filters = [
    'الكل',
    'دوام كامل',
    'دوام جزئي',
    'عقد',
    'موسمي',
  ];

  final List<Map<String, String>> _countries = [
    {'key': 'all', 'name': 'الكل', 'flag': '🌍'},
    {'key': 'germany', 'name': 'ألمانيا', 'flag': '🇩🇪'},
    {'key': 'france', 'name': 'فرنسا', 'flag': '🇫🇷'},
    {'key': 'netherlands', 'name': 'هولندا', 'flag': '🇳🇱'},
    {'key': 'italy', 'name': 'إيطاليا', 'flag': '🇮🇹'},
    {'key': 'spain', 'name': 'إسبانيا', 'flag': '🇪🇸'},
    {'key': 'sweden', 'name': 'السويد', 'flag': '🇸🇪'},
    {'key': 'austria', 'name': 'النمسا', 'flag': '🇦🇹'},
    {'key': 'turkey', 'name': 'تركيا', 'flag': '🇹🇷'},
    {'key': 'canada', 'name': 'كندا', 'flag': '🇨🇦'},
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  Future<void> _loadJobs() async {
    setState(() => _isLoading = true);
    try {
      Query query = _firestore
          .collection('jobs')
          .where('isActive', isEqualTo: true)
          .orderBy('postedDate', descending: true)
          .limit(100);

      if (_selectedCountry != 'all') {
        query = query.where('country', isEqualTo: _selectedCountry);
      }

      final snapshot = await query.get();
      final jobs = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return JobModel.fromJson(data);
      }).toList();

      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading jobs: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الوظائف المتاحة'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadJobs),
          ],
        ),
        body: Column(
          children: [
            _buildCountryChips(),
            _buildFilterChips(),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _jobs.isEmpty
                  ? _buildEmptyState()
                  : _buildJobsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountryChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _countries.length,
        itemBuilder: (context, index) {
          final country = _countries[index];
          final isSelected = _selectedCountry == country['key'];
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text('${country['flag']} ${country['name']}'),
              selected: isSelected,
              onSelected: (s) {
                setState(() => _selectedCountry = country['key']!);
                _loadJobs();
              },
              selectedColor: AppTheme.accentCyan,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textGrey,
                fontSize: 12,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(left: 8),
            child: ChoiceChip(
              label: Text(filter),
              selected: isSelected,
              onSelected: (s) => setState(() => _selectedFilter = filter),
              selectedColor: AppTheme.accentPurple,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : AppTheme.textGrey,
              ),
            ),
          );
        },
      ),
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
            style: TextStyle(color: AppTheme.textGrey),
          ),
        ],
      ),
    );
  }

  Widget _buildJobsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(15),
      itemCount: _jobs.length,
      itemBuilder: (context, index) {
        final job = _jobs[index];
        return GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => JobDetailsScreen(job: job)),
          ),
          child: Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(16),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.textWhite,
                        ),
                      ),
                    ),
                    Text(
                      job.salaryFormatted,
                      style: const TextStyle(
                        color: AppTheme.accentGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.business, size: 14, color: AppTheme.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      job.company,
                      style: TextStyle(color: AppTheme.textGrey),
                    ),
                    const SizedBox(width: 15),
                    Icon(Icons.location_on, size: 14, color: AppTheme.textGrey),
                    const SizedBox(width: 4),
                    Text(
                      '${job.location} ${job.countryFlag}',
                      style: TextStyle(color: AppTheme.textGrey),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: [
                    _buildChip(job.jobType, AppTheme.accentCyan),
                    _buildChip(job.languageRequired, AppTheme.accentPurple),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildChip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: TextStyle(fontSize: 11, color: color)),
    );
  }

  void _showFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تصفية الوظائف',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 8,
              children: _filters
                  .map(
                    (f) => ChoiceChip(
                      label: Text(f),
                      selected: _selectedFilter == f,
                      onSelected: (s) {
                        setState(() => _selectedFilter = f);
                        Navigator.pop(context);
                      },
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
