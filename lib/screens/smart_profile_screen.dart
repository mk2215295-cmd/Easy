import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../config/theme.dart';
import '../models/user_model.dart';
import '../services/cv_generator.dart';

class SmartProfileScreen extends StatefulWidget {
  const SmartProfileScreen({super.key});

  @override
  State<SmartProfileScreen> createState() => _SmartProfileScreenState();
}

class _SmartProfileScreenState extends State<SmartProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CVGenerator _cvGenerator = CVGenerator();

  UserModel? _user;
  UserProfile? _profile;
  bool _isLoading = true;
  bool _isEditing = false;

  final _nameController = TextEditingController();
  final _titleController = TextEditingController();
  final _summaryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadUserData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _titleController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final doc = await _db.collection('users').doc(userId).get();
        if (doc.exists) {
          final user = UserModel.fromJson(doc.data()!);
          setState(() {
            _user = user;
            _profile = user.profile;
            _nameController.text = user.name;
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final newProfile = UserProfile(
          title: _titleController.text,
          summary: _summaryController.text,
          skills: _profile?.skills ?? [],
          experiences: _profile?.experiences ?? [],
          education: _profile?.education ?? [],
          languages: _profile?.languages ?? [],
          cvUrl: _profile?.cvUrl,
          lastUpdated: DateTime.now(),
        );

        await _db.collection('users').doc(userId).update({
          'profile': newProfile.toJson(),
        });

        setState(() {
          _profile = newProfile;
          _isEditing = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم حفظ الملف الشخصي ✅'),
              backgroundColor: AppTheme.accentGreen,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error saving profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الملف الذكي'),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(_isEditing ? Icons.check : Icons.edit),
              onPressed: () {
                if (_isEditing) {
                  _saveProfile();
                } else {
                  setState(() => _isEditing = true);
                }
              },
            ),
          ],
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildProfileHeader(),
                  _buildProgressCard(),
                  _buildTabBar(),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildInfoTab(),
                        _buildSkillsTab(),
                        _buildExperienceTab(),
                        _buildCVTab(),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.secondaryDark, AppTheme.primaryDark],
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: AppTheme.gradientPrimary),
                  border: Border.all(color: AppTheme.accentCyan, width: 3),
                ),
                child: const Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _user?.name ?? 'اسم المستخدم',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textWhite,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentGreen.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _profile?.isComplete == true ? 'مكتمل' : 'غير مكتمل',
                        style: const TextStyle(
                          color: AppTheme.accentGreen,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    final percentage = _profile?.completionPercentage ?? 0;
    return Container(
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'اكتمال الملف',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: percentage >= 80
                      ? AppTheme.accentGreen
                      : AppTheme.accentOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: AppTheme.secondaryDark,
              valueColor: AlwaysStoppedAnimation<Color>(
                percentage >= 80 ? AppTheme.accentGreen : AppTheme.accentOrange,
              ),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppTheme.accentCyan,
        unselectedLabelColor: AppTheme.textGrey,
        indicatorColor: AppTheme.accentCyan,
        tabs: const [
          Tab(text: 'المعلومات'),
          Tab(text: 'المهارات'),
          Tab(text: 'الخبرة'),
          Tab(text: 'السيرة'),
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: [
          _buildSectionCard(
            'المسمى الوظيفي',
            Icons.work_outline,
            _isEditing
                ? TextFormField(
                    controller: _titleController,
                    style: const TextStyle(color: AppTheme.textWhite),
                    decoration: const InputDecoration(
                      hintText: 'أدخل المسمى الوظيفي',
                    ),
                  )
                : Text(
                    _profile?.title ?? 'لم يُحدد',
                    style: const TextStyle(color: AppTheme.textWhite),
                  ),
          ),
          const SizedBox(height: 15),
          _buildSectionCard(
            'ملخص المهني',
            Icons.description_outlined,
            _isEditing
                ? TextFormField(
                    controller: _summaryController,
                    style: const TextStyle(color: AppTheme.textWhite),
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'أدخل ملخصك المهني',
                    ),
                  )
                : Text(
                    _profile?.summary ?? 'لم يُحدد',
                    style: const TextStyle(color: AppTheme.textWhite),
                  ),
          ),
          const SizedBox(height: 15),
          _buildSectionCard(
            'اللغات',
            Icons.language,
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (_profile?.languages ?? ['لم تُحدد'])
                  .map(
                    (lang) => Chip(
                      label: Text(lang),
                      backgroundColor: AppTheme.accentPurple.withValues(
                        alpha: 0.2,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsTab() {
    final skills = _profile?.skills ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المهارات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              if (_isEditing)
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppTheme.accentCyan,
                  ),
                  onPressed: _addSkill,
                ),
            ],
          ),
          const SizedBox(height: 15),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: skills.isEmpty
                ? [
                    const Text(
                      'أضف مهاراتك',
                      style: TextStyle(color: AppTheme.textGrey),
                    ),
                  ]
                : skills
                      .map(
                        (skill) => Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.accentPurple.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppTheme.accentPurple.withValues(
                                alpha: 0.3,
                              ),
                            ),
                          ),
                          child: Text(
                            skill,
                            style: const TextStyle(
                              color: AppTheme.accentPurple,
                            ),
                          ),
                        ),
                      )
                      .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceTab() {
    final exp = _profile?.experiences ?? [];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'الخبرة العملية',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
              if (_isEditing)
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppTheme.accentCyan,
                  ),
                  onPressed: _addExperience,
                ),
            ],
          ),
          const SizedBox(height: 15),
          if (exp.isEmpty)
            const Center(
              child: Text(
                'أضف خبراتك العملية',
                style: TextStyle(color: AppTheme.textGrey),
              ),
            )
          else
            ...exp.map((e) => _buildExperienceCard(e)),
        ],
      ),
    );
  }

  Widget _buildExperienceCard(WorkExperience exp) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exp.position,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.textWhite,
            ),
          ),
          Text(exp.company, style: TextStyle(color: AppTheme.textGrey)),
          const SizedBox(height: 5),
          Text(
            '${exp.startDate.year} - ${exp.isCurrent ? 'حتى الآن' : exp.endDate?.year ?? ''}',
            style: TextStyle(color: AppTheme.textGrey, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildCVTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.picture_as_pdf, size: 80, color: AppTheme.textGrey),
          const SizedBox(height: 20),
          const Text(
            'السيرة الذاتية',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textWhite,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _profile?.cvUrl != null ? 'تم إنشاء السيرة' : 'لم تُنشأ السيرة بعد',
            style: TextStyle(color: AppTheme.textGrey),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: _generateCV,
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(
              _profile?.cvUrl != null ? 'تحديث السيرة' : 'إنشاء السيرة',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, IconData icon, Widget content) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.accentPurple, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textWhite,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          content,
        ],
      ),
    );
  }

  void _addSkill() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: AppTheme.cardDark,
          title: const Text(
            'إضافة مهارة',
            style: TextStyle(color: AppTheme.textWhite),
          ),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: AppTheme.textWhite),
            decoration: const InputDecoration(hintText: 'اسم المهارة'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  setState(() {
                    _profile = UserProfile(
                      title: _profile?.title ?? '',
                      summary: _profile?.summary ?? '',
                      skills: [...(_profile?.skills ?? []), controller.text],
                      experiences: _profile?.experiences ?? [],
                      education: _profile?.education ?? [],
                      languages: _profile?.languages ?? [],
                    );
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('إضافة'),
            ),
          ],
        );
      },
    );
  }

  void _addExperience() {
    final companyController = TextEditingController();
    final positionController = TextEditingController();
    final descriptionController = TextEditingController();
    bool isCurrent = false;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: AppTheme.cardDark,
              title: const Text(
                'إضافة خبرة عملية',
                style: TextStyle(color: AppTheme.textWhite),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: companyController,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        labelText: 'اسم الشركة',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: positionController,
                      style: const TextStyle(color: AppTheme.textWhite),
                      decoration: const InputDecoration(
                        labelText: 'المسمى الوظيفي',
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      style: const TextStyle(color: AppTheme.textWhite),
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'وصف العمل'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: isCurrent,
                          activeColor: AppTheme.accentCyan,
                          onChanged: (val) {
                            setDialogState(() => isCurrent = val ?? false);
                          },
                        ),
                        const Text(
                          'لا أزال أعمل هنا',
                          style: TextStyle(color: AppTheme.textWhite),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (companyController.text.isNotEmpty &&
                        positionController.text.isNotEmpty) {
                      setState(() {
                        _profile = UserProfile(
                          title: _profile?.title ?? '',
                          summary: _profile?.summary ?? '',
                          skills: _profile?.skills ?? [],
                          experiences: [
                            ...(_profile?.experiences ?? []),
                            WorkExperience(
                              company: companyController.text.trim(),
                              position: positionController.text.trim(),
                              startDate: DateTime.now(),
                              description: descriptionController.text.trim(),
                              isCurrent: isCurrent,
                            ),
                          ],
                          education: _profile?.education ?? [],
                          languages: _profile?.languages ?? [],
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('إضافة'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _generateCV() async {
    if (_user != null && _profile != null) {
      try {
        await _cvGenerator.shareCV(_profile!, _user!);
      } catch (e) {
        debugPrint('Error generating CV: $e');
      }
    }
  }
}
