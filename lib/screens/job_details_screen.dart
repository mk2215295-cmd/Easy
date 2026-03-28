import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../config/theme.dart';
import '../models/job_model.dart';
import '../services/email_service.dart';
import '../models/user_model.dart';
import '../providers/saved_jobs_provider.dart';

class JobDetailsScreen extends StatefulWidget {
  final JobModel job;
  const JobDetailsScreen({super.key, required this.job});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  final ScrollController _scrollController = ScrollController();
  final EmailService _emailService = EmailService();

  bool _hasScrolledToBottom = false;
  bool _isApplying = false;
  bool _agreedToTerms = false;
  final bool _showTerms = true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      if (currentScroll >= maxScroll - 50 && !_hasScrolledToBottom) {
        setState(() => _hasScrolledToBottom = true);
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفاصيل الوظيفة'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(icon: const Icon(Icons.share), onPressed: _shareJob),
            Consumer<SavedJobsProvider>(
              builder: (context, savedJobsProvider, _) {
                final isSaved = savedJobsProvider.isJobSaved(widget.job.id);
                return IconButton(
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_border,
                    color: isSaved ? AppTheme.accentCyan : null,
                  ),
                  onPressed: _saveJob,
                );
              },
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildJobHeader(),
                  const SizedBox(height: 25),
                  _buildJobDetails(),
                  const SizedBox(height: 25),
                  _buildJobRequirements(),
                  if (_showTerms) ...[
                    const SizedBox(height: 25),
                    _buildTermsAndConditions(),
                  ],
                  const SizedBox(height: 120),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildJobHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppTheme.accentPurple.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.work_outline,
                  color: AppTheme.accentPurple,
                  size: 30,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textWhite,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.job.company,
                      style: TextStyle(color: AppTheme.textGrey),
                    ),
                  ],
                ),
              ),
              if (widget.job.isExclusive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.accentCyan.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'حصري',
                    style: TextStyle(
                      color: AppTheme.accentCyan,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              _buildInfoChip(
                Icons.location_on,
                '${widget.job.location} ${widget.job.countryFlag}',
              ),
              const SizedBox(width: 10),
              _buildInfoChip(Icons.schedule, widget.job.workHours),
              const SizedBox(width: 10),
              _buildInfoChip(Icons.business_center, widget.job.jobType),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.secondaryDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppTheme.textGrey),
          const SizedBox(width: 5),
          Text(text, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildJobDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الراتب والمزايا',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textWhite,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: AppTheme.gradientHero),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الراتب الشهري',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    '${widget.job.salary} ${widget.job.currency}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white24),
              _buildBenefitRow(
                Icons.home,
                'السكن',
                widget.job.isHousingProvided ? 'متوفر' : 'غير متوفر',
              ),
              _buildBenefitRow(
                Icons.flight_takeoff,
                'تأشيرة عمل',
                widget.job.isVisaSponsor ? 'نعم' : 'تحت الدراسة',
              ),
              _buildBenefitRow(
                Icons.language,
                'اللغة المطلوبة',
                widget.job.languageRequired,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: Colors.white70)),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJobRequirements() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المتطلبات',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textWhite,
          ),
        ),
        const SizedBox(height: 15),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.job.description.isNotEmpty
                    ? widget.job.description
                    : 'وصف الوظيفة غير متوفر',
                style: const TextStyle(color: AppTheme.textWhite, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                'المتطلبات:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.job.requirements.isNotEmpty
                    ? widget.job.requirements
                    : 'لا توجد متطلبات محددة',
                style: TextStyle(color: AppTheme.textGrey, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber, color: AppTheme.accentOrange, size: 24),
              const SizedBox(width: 10),
              const Text(
                'الشروط والأحكام',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          const Text(
            '· يجب قراءة جميع تفاصيل الوظيفة قبل التقديم\n· سيتم إرسال بياناتك الشخصية للشركة\n· لا يمكن إلغاء التقديم بعد الإرسال\n· أنت توافق على إرسال سيرتك الذاتية وجواز سفرك',
            style: TextStyle(color: AppTheme.textGrey, height: 1.8),
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Checkbox(
                value: _agreedToTerms,
                onChanged: (value) {
                  if (_hasScrolledToBottom) {
                    setState(() => _agreedToTerms = value ?? false);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('الرجاء قراءة الشروط والأحكام كاملة'),
                      ),
                    );
                  }
                },
                activeColor: AppTheme.accentGreen,
              ),
              const Expanded(
                child: Text(
                  'أوافق على الشروط والأحكام وإرسال بياناتي',
                  style: TextStyle(color: AppTheme.textWhite, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.secondaryDark,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!_hasScrolledToBottom)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.accentOrange.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.swipe_down, color: AppTheme.accentOrange),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'اسحب لأسفل لقراءة الشروط قبل التقديم',
                          style: TextStyle(color: AppTheme.accentOrange),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _agreedToTerms && !_isApplying ? _applyNow : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _agreedToTerms
                        ? AppTheme.accentPurple
                        : AppTheme.textDarkGrey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: _isApplying
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send),
                            const SizedBox(width: 10),
                            const Text(
                              'تقديم الآن',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _shareJob() {
    final job = widget.job;
    final text =
        '''
${job.title}
${job.company} - ${job.location} ${job.countryFlag}

الراتب: ${job.salary} ${job.currency}
${job.isVisaSponsor ? '✅ تأشيرة عمل متوفرة' : ''}
${job.isHousingProvided ? '✅ سكن متوفر' : ''}

قدّم الآن على EASY WORK AI
''';
    SharePlus.instance.share(ShareParams(text: text));
  }

  void _saveJob() async {
    final savedJobsProvider = context.read<SavedJobsProvider>();
    final isSaved = savedJobsProvider.isJobSaved(widget.job.id);

    final success = await savedJobsProvider.toggleSaveJob(widget.job);

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isSaved ? 'تم إزالة الوظيفة من المحفوظات' : 'تم حفظ الوظيفة ✅',
          ),
          backgroundColor: isSaved
              ? AppTheme.accentOrange
              : AppTheme.accentGreen,
        ),
      );
    }
  }

  Future<void> _applyNow() async {
    setState(() => _isApplying = true);

    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يجب تسجيل الدخول أولاً'),
              backgroundColor: AppTheme.accentRed,
            ),
          );
        }
        return;
      }

      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();

      final user = doc.exists
          ? UserModel.fromJson(doc.data()!)
          : UserModel(
              id: currentUser.uid,
              name: currentUser.displayName ?? '',
              email: currentUser.email ?? '',
              phone: currentUser.phoneNumber ?? '',
              createdAt: DateTime.now(),
            );

      final success = await _emailService.sendApplicationEmail(
        job: widget.job,
        user: user,
        cvUrl: user.profile?.cvUrl ?? '',
        passportUrl: user.passportUrl ?? '',
      );

      if (mounted) {
        if (success) {
          _showSuccessDialog();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('فشل التقديم، يرجى المحاولة مرة أخرى'),
              backgroundColor: AppTheme.accentRed,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('خطأ: $e'),
            backgroundColor: AppTheme.accentRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isApplying = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardDark,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: AppTheme.accentGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 50),
            ),
            const SizedBox(height: 20),
            const Text(
              'تم التقديم بنجاح!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textWhite,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'سيتم التواصل معك قريباً من شركة ${widget.job.company}',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textGrey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
