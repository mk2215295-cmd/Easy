import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/theme.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SettingsProvider>().loadPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإعدادات'),
          backgroundColor: Colors.transparent,
        ),
        body: Consumer<SettingsProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('إشعارات الوظائف'),
                  const SizedBox(height: 15),
                  _buildNotificationToggle(provider),
                  const SizedBox(height: 30),
                  if (provider.preferences.newJobsEnabled) ...[
                    _buildSectionTitle('الدول المستهدفة'),
                    const SizedBox(height: 15),
                    _buildCountriesList(provider),
                    const SizedBox(height: 30),
                    _buildSectionTitle('أنواع الوظائف'),
                    const SizedBox(height: 15),
                    _buildJobTypesList(provider),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textWhite,
      ),
    );
  }

  Widget _buildNotificationToggle(SettingsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color:
                  (provider.preferences.newJobsEnabled
                          ? AppTheme.accentCyan
                          : AppTheme.textDarkGrey)
                      .withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              provider.preferences.newJobsEnabled
                  ? Icons.notifications_active
                  : Icons.notifications_off,
              color: provider.preferences.newJobsEnabled
                  ? AppTheme.accentCyan
                  : AppTheme.textDarkGrey,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'إشعارات الوظائف الجديدة',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textWhite,
                  ),
                ),
                Text(
                  'تلقي إشعار عند إضافة وظائف جديدة',
                  style: TextStyle(fontSize: 12, color: AppTheme.textGrey),
                ),
              ],
            ),
          ),
          Switch(
            value: provider.preferences.newJobsEnabled,
            onChanged: (value) => provider.toggleNewJobs(value),
            activeColor: AppTheme.accentCyan,
          ),
        ],
      ),
    );
  }

  Widget _buildCountriesList(SettingsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: SettingsProvider.availableCountries.map((country) {
          final isSelected = provider.preferences.targetCountries.contains(
            country['key'],
          );

          return CheckboxListTile(
            value: isSelected,
            onChanged: (value) {
              provider.toggleCountry(country['key']!, value ?? false);
            },
            title: Text(
              '${country['flag']} ${country['name']}',
              style: const TextStyle(color: AppTheme.textWhite),
            ),
            activeColor: AppTheme.accentCyan,
            checkColor: AppTheme.primaryDark,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildJobTypesList(SettingsProvider provider) {
    const jobTypes = [
      {'key': 'full-time', 'name': 'دوام كامل'},
      {'key': 'part-time', 'name': 'دوام جزئي'},
      {'key': 'contract', 'name': 'عقد'},
      {'key': 'seasonal', 'name': 'موسمي'},
    ];

    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: jobTypes.map((type) {
          final isSelected = provider.preferences.jobTypes.contains(
            type['key'],
          );

          return CheckboxListTile(
            value: isSelected,
            onChanged: (value) {
              provider.toggleJobType(type['key']!, value ?? false);
            },
            title: Text(
              type['name']!,
              style: const TextStyle(color: AppTheme.textWhite),
            ),
            activeColor: AppTheme.accentPurple,
            checkColor: AppTheme.primaryDark,
            contentPadding: EdgeInsets.zero,
          );
        }).toList(),
      ),
    );
  }
}
