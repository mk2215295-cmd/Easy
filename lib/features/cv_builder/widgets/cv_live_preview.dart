import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/models/cv_model.dart';
import '../../../core/services/pdf_service.dart';
import '../../../theme/app_theme.dart';

// ════════════════════════════════════════════════════════════════════════════════
// CvLivePreview
// Right-side glassmorphism pane rendering a real-time live preview of the CV
// in Europass Format.
//
// Features:
//   • Frosted glass overlay (BackdropFilter blur + transparent background)
//   • Silhouette profile picture placeholder
//   • Real-time text mirrors from [cv] model
//   • Styled sections (Contact Information, Work Experience)
// ════════════════════════════════════════════════════════════════════════════════
class CvLivePreview extends StatelessWidget {
  const CvLivePreview({
    super.key,
    required this.cv,
  });

  /// The CV data state model to mirror in real-time.
  final CvModel cv;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundSurface.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.08),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
              // ── Header bar ──────────────────────────────────────────────
              _buildHeaderBar(context),

              // ── Preview content ──────────────────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bio Row (Avatar + Name & Profession)
                      _buildBioRow(),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.borderSubtle, height: 1),
                      const SizedBox(height: 20),

                      // Contact Information
                      _buildContactSection(),

                      const SizedBox(height: 24),
                      const Divider(color: AppColors.borderSubtle, height: 1),
                      const SizedBox(height: 20),

                      // Work Experience
                      _buildWorkExperienceSection(),

                      // Education & Training
                      if (cv.educationDegree.isNotEmpty ||
                          cv.educationInstitution.isNotEmpty) ...[  
                        const SizedBox(height: 24),
                        const Divider(color: AppColors.borderSubtle, height: 1),
                        const SizedBox(height: 20),
                        _buildEducationSection(),
                      ],

                      // Skills
                        if (cv.skills.isNotEmpty) ...[  
                          const SizedBox(height: 24),
                          const Divider(color: AppColors.borderSubtle, height: 1),
                          const SizedBox(height: 20),
                          _buildSkillsSection(),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundElevated.withValues(alpha: 0.5),
        border: const Border(
          bottom: BorderSide(color: AppColors.borderSubtle, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.article_rounded,
            size: 16,
            color: AppColors.accentBlue.withValues(alpha: 0.8),
          ),
          const SizedBox(width: 8),
          Text(
            'CV Live Preview - Europass Format',
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          // Download PDF Action button
          _DownloadButton(cv: cv),
          const SizedBox(width: 14),
          // Small red/dot indicator for live syncing status
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.accentGreen,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGreenGlow,
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'LIVE SYNCING',
            style: AppTextStyles.labelSmall.copyWith(
              fontSize: 8,
              color: AppColors.accentGreen,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBioRow() {
    final hasName = cv.fullName.trim().isNotEmpty;
    final nameText = hasName ? cv.fullName : 'Your Full Name';

    final hasProfession = cv.profession.trim().isNotEmpty;
    final profText = hasProfession ? cv.profession : 'Your Profession';

    final hasExp = cv.yearsOfExperience.trim().isNotEmpty;
    final expText = hasExp ? '${cv.yearsOfExperience} Years of Experience' : 'Experience Years';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Europass Style Avatar Silhouette
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.backgroundElevated,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.accentBlue.withValues(alpha: 0.3),
              width: 2,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.accentBlueGlow,
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.person_rounded,
              color: AppColors.textSecondary,
              size: 40,
            ),
          ),
        ),
        const SizedBox(width: 16),

        // Title and Info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nameText,
                style: AppTextStyles.headlineMedium.copyWith(
                  color: hasName ? AppColors.textPrimary : AppColors.textDisabled,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                profText,
                style: AppTextStyles.titleMedium.copyWith(
                  color: hasProfession ? AppColors.accentBlue : AppColors.textDisabled,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                expText,
                style: AppTextStyles.labelSmall.copyWith(
                  color: hasExp ? AppColors.textSecondary : AppColors.textDisabled,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'البيانات الشخصية / Contact Information',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.accentBlue,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        _buildContactLine(Icons.email_outlined, 'Email', cv.email),
        _buildContactLine(Icons.phone_android_rounded, 'Phone', cv.phone),
        _buildContactLine(Icons.location_on_outlined, 'Address', cv.address),
        _buildContactLine(Icons.cake_outlined, 'Date of Birth', cv.dateOfBirth),
      ],
    );
  }

  Widget _buildContactLine(IconData icon, String label, String value) {
    final hasValue = value.trim().isNotEmpty;
    if (!hasValue) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.textSecondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(fontSize: 12),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkExperienceSection() {
    final hasCompany = cv.companyName.trim().isNotEmpty;
    final hasDates = cv.workDates.trim().isNotEmpty;
    final hasProfession = cv.profession.trim().isNotEmpty;

    final parts = <String>[];
    if (hasProfession) parts.add(cv.profession);
    if (hasCompany) parts.add(cv.companyName);
    if (hasDates) parts.add(cv.workDates);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الخبرة العملية / Work Experience',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.accentBlue,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        if (parts.isNotEmpty)
          Text(
            parts.join(' - '),
            style: AppTextStyles.titleMedium.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        const SizedBox(height: 8),
        // Step 2 work bullets placeholder
        if (cv.workBulletPoints.isEmpty)
          _buildBulletItem('Experienced in residential and commercial electrical installations', false)
        else
          ...cv.workBulletPoints.map((b) => _buildBulletItem(b, true)),
      ],
    );
  }

  Widget _buildBulletItem(String text, bool isFilled) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: isFilled ? AppColors.textSecondary : AppColors.textDisabled,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 11,
                color: isFilled ? AppColors.textSecondary : AppColors.textDisabled,
                fontStyle: isFilled ? FontStyle.normal : FontStyle.italic,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Education & Training section ──────────────────────────────────────────
  Widget _buildEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'التعليم والشهادات / Education & Training',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.accentBlue,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        if (cv.educationDates.isNotEmpty)
          Text(
            cv.educationDates,
            style: AppTextStyles.labelSmall
                .copyWith(fontSize: 10, color: AppColors.textSecondary),
          ),
        const SizedBox(height: 4),
        RichText(
          text: TextSpan(
            style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
            children: [
              if (cv.educationDegree.isNotEmpty)
                TextSpan(
                  text: cv.educationDegree.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              if (cv.educationInstitution.isNotEmpty)
                TextSpan(text: '  ${cv.educationInstitution}'),
            ],
          ),
        ),
        if (cv.educationField.isNotEmpty) ...[
          const SizedBox(height: 4),
          RichText(
            text: TextSpan(
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 11),
              children: [
                const TextSpan(
                  text: 'Field of study: ',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: cv.educationField),
              ],
            ),
          ),
        ],
      ],
    );
  }

  // ── Skills section ────────────────────────────────────────────────────────
  Widget _buildSkillsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المهارات / Skills',
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.accentBlue,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: cv.skills.map((s) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.backgroundElevated,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.borderSubtle),
              ),
              child: Text(
                s,
                style: AppTextStyles.labelSmall.copyWith(
                  fontSize: 10,
                  color: AppColors.textPrimary,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ── _DownloadButton Helper ────────────────────────────────═══════════════════════
class _DownloadButton extends StatefulWidget {
  const _DownloadButton({required this.cv});
  final CvModel cv;

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _isLoading = false;

  Future<void> _triggerDownload() async {
    setState(() => _isLoading = true);
    try {
      await PdfService().downloadCvPdf(widget.cv);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _isLoading ? null : _triggerDownload,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentBlue.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: AppColors.accentBlue.withValues(alpha: 0.3)),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.accentBlue),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.download_rounded,
                      color: AppColors.accentBlue,
                      size: 14,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Download PDF',
                      style: AppTextStyles.labelSmall.copyWith(
                        fontSize: 9,
                        color: AppColors.accentBlue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
